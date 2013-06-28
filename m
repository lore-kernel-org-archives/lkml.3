Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3F1PFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:05:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3F1PFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:05:23 -0400
Date: Fri, 28 Jun 2013 17:05:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Mike Galbraith <bitbucket@online.de>, Tim Hockin <thockin@hockin.org>,
        Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130628150513.GD5125@dhcp22.suse.cz>
References: <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628050138.GD2500@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-06-13 22:01:38, Tejun Heo wrote:
> Hello, Mike.
> 
> On Fri, Jun 28, 2013 at 06:49:10AM +0200, Mike Galbraith wrote:
> > I always thought that was a very cool feature, mkdir+echo, poof done.
> > Now maybe that interface is suboptimal for serious usage, but it makes
> > the things usable via dirt simple scripts, very flexible, nice.
> 
> Oh, that in itself is not bad.  I mean, if you're root, it's pretty
> easy to play with and that part is fine.  But combined with the
> hierarchical nature of cgroup and file permissions, it encourages
> people to "deligate" subdirectories to less previledged domains,

OK, this really depends on what you expose to non-root users. I have
seen use cases where admin prepares top-level which is root-only but
it allows creating sub-groups which are under _full_ control of the
subdomain. This worked nicely for memcg for example because hard limit,
oom handling and other knobs are hierarchical so the subdomain cannot
overwrite what admin has said.

> which
> in turn leads to normal binaries to manipulate them directly, which is
> where the horror begins.  We end up exposing control knobs which are
> tightly coupled to kernel implementation details right into lay
> binaries and scripts directly used by end users.
>
> I think this is the first time this happened, which is probably why
> nobody really noticed the mess earlier.
> 
> Anyways, if you're root, you can keep doing whatever you want.

OK, so libcgroup's rules daemon will still work and place my tasks in
appropriate cgroups?

This is not quite in par with "libcgroup is dead and others have to
migrate to systemd as well" statements from the link posted earlier.
I really do not think that _any_ central agent will understand my
requirements and needs so I need a way to talk to cgroupfs somehow - I
have used libcgroups so far but touching cgroupfs is quite convinient
as well.

And the systemd, with its history of eating projects and not caring much
about their previous users who are not willing to jump in to the systemd
car, doesn't sound like a good place where to place the new interface to
me.

[...]
-- 
Michal Hocko
SUSE Labs
