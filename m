Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3F0RtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:49:00 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:52745 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3F0Rs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:48:58 -0400
Date: Thu, 27 Jun 2013 10:48:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Mike Galbraith <bitbucket@online.de>, Tim Hockin <thockin@hockin.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130627174850.GC5599@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627132206.GE4003@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627132206.GE4003@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Serge.

On Thu, Jun 27, 2013 at 08:22:06AM -0500, Serge Hallyn wrote:
> At some point (probably soon) we might want to talk about a standard API
> for these things.  However I think it will have to come in the form of
> a standard library, which knows to either send requests over dbus to
> systemd, or over /dev/cgroup sock to the manager.

Yeah, eventually, I think we'll have a standardized way to configure
resource distribution in the system.  Maybe we'll agree on a
standardized dbus protocol or there will be library, I don't know;
however, whatever form it may be in, it abstraction level should be
way higher than that of direct cgroupfs access.  It's way too low
level and very easy to end up in a complete nonsense configuration.

e.g. enabling "cpu" on a cgroup whlie leaving other cgroups alone
wouldn't enable fair scheduling on that cgroup but drastically reduce
the amount of cpu share it gets as it now gets treated as single
entity competing with all tasks at the parent level.

At the moment, I'm not sure what the eventual abstraction would look
like.  systemd is extending its basic constructs by adding slices and
scopes and it does make sense to integrate the general organization of
the system (services, user sessions, VMs and so on) with resource
management.  Given some time, I'm hoping we'll be able to come up with
and agree on some common constructs so that each workload can indicate
its resource requirements in a unified way.

That said, I really think we should experiment for a while before
trying to settle down on things.  We've now just started exploring how
system-wide resource managment can be made widely available to systems
without requiring extremely specialized hand-crafted configurations
and I'm pretty sure we're getting and gonna get quite a few details
wrong, so I don't think it'd be a good idea to try to agree on things
right now.  As far as such integration goes, I think it's time to play
with things and observe the results.

Thanks.

-- 
tejun
