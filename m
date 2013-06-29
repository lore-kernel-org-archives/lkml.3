Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3F2Bsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 21:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab3F2Bsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 21:48:38 -0400
Message-ID: <51CE3CE0.9010506@redhat.com>
Date: Sat, 29 Jun 2013 03:48:16 +0200
From: Lennart Poettering <lpoetter@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tim Hockin <thockin@hockin.org>
CC: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        Mike Galbraith <bitbucket@online.de>, Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
References: <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com> <20130625000118.GT1918@mtj.dyndns.org> <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com> <20130626212047.GB4536@htj.dyndns.org> <1372311907.5871.78.camel@marge.simpson.net> <20130627180143.GD5599@mtj.dyndns.org> <1372391198.5989.110.camel@marge.simpson.net> <20130628040930.GC2500@htj.dyndns.org> <1372394950.5989.128.camel@marge.simpson.net> <20130628050138.GD2500@htj.dyndns.org> <20130628150513.GD5125@dhcp22.suse.cz> <CAAAKZwtqYe-c0bfkgHFbzsOKVHifjTwkqcpci=uS1JwqS9TJHQ@mail.gmail.com>
In-Reply-To: <CAAAKZwtqYe-c0bfkgHFbzsOKVHifjTwkqcpci=uS1JwqS9TJHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.06.2013 20:53, Tim Hockin wrote:

> a single-agent, we should make a kick-ass implementation that is
> flexible and scalable, and full-featured enough to not require
> divergence at the lowest layer of the stack.  Then build systemd on
> top of that. Let systemd offer more features and policies and
> "semantic" APIs.

Well, what if systemd is already kick-ass? I mean, if you have a problem 
with systemd, then that's your own problem, but I really don't think why 
I should bother?

I for sure am not going to make the PID 1 a client of another daemon. 
That's just wrong. If you have a daemon that is both conceptually the 
manager of another service and the client of that other service, then 
that's bad design and you will easily run into deadlocks and such. Just 
think about it: if you have some external daemon for managing cgroups, 
and you need cgroups for running external daemons, how are you going to 
start the external daemon for managing cgroups? Sure, you can hack 
around this, make that daemon special, and magic, and stuff -- or you 
can just not do such nonsense. There's no reason to repeat the fuckup 
that cgroup became in kernelspace a second time, but this time in 
userspace, with multiple manager daemons all with different and slightly 
incompatible definitions what a unit to manage actualy is...

We want to run fewer, simpler things on our systems, we want to reuse as 
much of the code as we can. You don't achieve that by running yet 
another daemon that does worse what systemd can anyway do simpler, 
easier and better.

The least you could grant us is to have a look at the final APIs we will 
have to offer before you already imply that systemd cannot be a valid 
implementation of any API people could ever agree on.

Lennart
