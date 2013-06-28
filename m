Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3F1Sxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:53:42 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:42867 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3F1Sxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130628150513.GD5125@dhcp22.suse.cz>
References: <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org> <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org> <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org> <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org> <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org> <20130628150513.GD5125@dhcp22.suse.cz>
From: Tim Hockin <thockin@hockin.org>
Date: Fri, 28 Jun 2013 11:53:13 -0700
X-Google-Sender-Auth: hcoIu4W60t-mUnu0qJXEwjFlO_s
Message-ID: <CAAAKZwtqYe-c0bfkgHFbzsOKVHifjTwkqcpci=uS1JwqS9TJHQ@mail.gmail.com>
Subject: Re: cgroup: status-quo and userland efforts
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <bitbucket@online.de>,
        Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 8:05 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Thu 27-06-13 22:01:38, Tejun Heo wrote:

>> Oh, that in itself is not bad.  I mean, if you're root, it's pretty
>> easy to play with and that part is fine.  But combined with the
>> hierarchical nature of cgroup and file permissions, it encourages
>> people to "deligate" subdirectories to less previledged domains,
>
> OK, this really depends on what you expose to non-root users. I have
> seen use cases where admin prepares top-level which is root-only but
> it allows creating sub-groups which are under _full_ control of the
> subdomain. This worked nicely for memcg for example because hard limit,
> oom handling and other knobs are hierarchical so the subdomain cannot
> overwrite what admin has said.

bingo

> And the systemd, with its history of eating projects and not caring much
> about their previous users who are not willing to jump in to the systemd
> car, doesn't sound like a good place where to place the new interface to
> me.

+1

If systemd is the only upstream implementation of this single-agent
idea, we will have to invent our own, and continue to diverge rather
than converge.  I think that, if we are going to pursue this model of
a single-agent, we should make a kick-ass implementation that is
flexible and scalable, and full-featured enough to not require
divergence at the lowest layer of the stack.  Then build systemd on
top of that. Let systemd offer more features and policies and
"semantic" APIs.

We will build our own semantic APIs that are, necessarily, different
from systemd.  But we can all use the same low-level mechanism.

Tim
