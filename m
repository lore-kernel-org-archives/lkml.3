Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3F1TSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:18:44 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41245 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3F1TSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:18:42 -0400
Message-ID: <51CDE18E.8080009@amacapital.net>
Date: Fri, 28 Jun 2013 12:18:38 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mike Galbraith <bitbucket@online.de>, thockin@hockin.org,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
References: <20130406012159.GA17159@mtj.dyndns.org> <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com> <20130422214159.GG12543@htj.dyndns.org> <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com> <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com> <20130625000118.GT1918@mtj.dyndns.org> <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com> <20130626212047.GB4536@htj.dyndns.org> <1372311907.5871.78.camel@marge.simpson.net> <20130627180143.GD5599@mtj.dyndns.org>
In-Reply-To: <20130627180143.GD5599@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 11:01 AM, Tejun Heo wrote:
> AFAICS, having a userland agent which has overall knowledge of the
> hierarchy and enforcesf structure and limiations is a requirement to
> make cgroup generally useable and useful.  For systemd based systems,
> systemd serving that role isn't too crazy.  It's sure gonna have
> teeting issues at the beginning but it has all the necessary
> information to manage workloads on the system.
> 
> A valid issue is interoperability between systemd and non-systemd
> systems.  I don't have an immediately good answer for that.  I wrote
> in another reply but making cgroup generally available is a pretty new
> effort and we're still in the process of figuring out what the right
> constructs and abstractions are.  Hopefully, we'll be able to reach a
> common set of abstractions to base things on top in itme.
> 

The systemd stuff will break my code, too (although the single hierarchy
by itself won't, I think).  I think that the kernel should make whatever
simple changes are needed so that systemd can function without using
cgroups at all.  That way users of a different cgroup scheme can turn
off systemd's.

Here was my proposal, which hasn't gotten a clear reply:

http://article.gmane.org/gmane.comp.sysutils.systemd.devel/11424

I've already sent a patch to make /proc/<pid>/task/<tid>/children
available regardless of configuration.

--Andy


