Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3F0UwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:52:24 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:32851 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3F0UwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:52:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130627181457.GB26334@sergelap>
References: <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org> <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org> <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org> <1372311907.5871.78.camel@marge.simpson.net>
 <20130627132206.GE4003@sergelap> <20130627174850.GC5599@mtj.dyndns.org> <20130627181457.GB26334@sergelap>
From: Tim Hockin <thockin@hockin.org>
Date: Thu, 27 Jun 2013 13:52:01 -0700
X-Google-Sender-Auth: Othl8L_GH4yR-ZeDwDS-Ky0u5qQ
Message-ID: <CAAAKZwuzBbORHBWtCbXixuSM+CjfHGXvGmEdD32Z7Qf54W04Nw@mail.gmail.com>
Subject: Re: cgroup: status-quo and userland efforts
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <bitbucket@online.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:14 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Tejun Heo (tj@kernel.org):
>> Hello, Serge.
>>
>> On Thu, Jun 27, 2013 at 08:22:06AM -0500, Serge Hallyn wrote:
>> > At some point (probably soon) we might want to talk about a standard API
>> > for these things.  However I think it will have to come in the form of
>> > a standard library, which knows to either send requests over dbus to
>> > systemd, or over /dev/cgroup sock to the manager.
>>
>> Yeah, eventually, I think we'll have a standardized way to configure
>> resource distribution in the system.  Maybe we'll agree on a
>> standardized dbus protocol or there will be library, I don't know;
>> however, whatever form it may be in, it abstraction level should be
>> way higher than that of direct cgroupfs access.  It's way too low
>> level and very easy to end up in a complete nonsense configuration.
>>
>> e.g. enabling "cpu" on a cgroup whlie leaving other cgroups alone
>> wouldn't enable fair scheduling on that cgroup but drastically reduce
>> the amount of cpu share it gets as it now gets treated as single
>> entity competing with all tasks at the parent level.
>
> Right.  I *think* this can be offered as a daemon which sits as the
> sole consumer of my agent's API, and offers a higher level "do what I
> want" API.  But designing that API is going to be interesting.

This is something we have, partially, and are working to be able to
open-source.  We have a LOT of experience feeding into the semantics
that actually make users happy.

Today it leverages split-hierarchies, but that is not required in the
generic case (only if you want to offer the semantics we do).  It
explicitly delegates some aspects of sub-cgroup control to users, but
that could go away if your lowest-level agency can handle it.

> I should find a good, up-to-date summary of the current behaviors of
> each controller so I can talk more intelligently about it.  (I'll
> start by looking at the kernel Documentation/cgroups, but don't
> feel too confident that they'll be uptodate :)
>
>> At the moment, I'm not sure what the eventual abstraction would look
>> like.  systemd is extending its basic constructs by adding slices and
>> scopes and it does make sense to integrate the general organization of
>> the system (services, user sessions, VMs and so on) with resource
>> management.  Given some time, I'm hoping we'll be able to come up with
>> and agree on some common constructs so that each workload can indicate
>> its resource requirements in a unified way.
>>
>> That said, I really think we should experiment for a while before
>> trying to settle down on things.  We've now just started exploring how
>> system-wide resource managment can be made widely available to systems
>> without requiring extremely specialized hand-crafted configurations
>> and I'm pretty sure we're getting and gonna get quite a few details
>> wrong, so I don't think it'd be a good idea to try to agree on things
>> right now.  As far as such integration goes, I think it's time to play
>> with things and observe the results.
>
> Right,  I'm not attached to my toy implementation at all - except for
> the ability, in some fashion, to have nested agents which don't have
> cgroupfs access but talk to another agent to get the job done.
>
> -serge
