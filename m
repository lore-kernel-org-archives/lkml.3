Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab3GWTjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:39:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43184 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599Ab3GWTjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:39:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130723192801.GA9923@tp>
References: <20130723181606.GA6342@sergelap>
	<20130723183018.GF21100@mtj.dyndns.org>
	<20130723183841.GA9021@tp>
	<CAOS58YPynQ-QBx5nZEnYrP5kGTVvv9VAj0cV0aYeikTitvTQbA@mail.gmail.com>
	<20130723190426.GA9577@tp>
	<20130723191245.GI21100@mtj.dyndns.org>
	<20130723192801.GA9923@tp>
Date: Tue, 23 Jul 2013 15:39:10 -0400
X-Google-Sender-Auth: 87pJLkOOi0btd-GMg9MIesiq9Pc
Message-ID: <CAOS58YPEKtEiZWsn-8u6OPr-UsyQp=XR+ecGmXyOdT0JnYAmsA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Serge.

On Tue, Jul 23, 2013 at 3:28 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
>> Well, that also is the exact type of priv delegation we're moving away
>> from, so....
>
> I think that's unreasonable, but I guess I'll have to go reread the
> old thread.

Yeah, please do. I think the case is pretty strong for disallowing
delegation of cgroup directories to !root (or whatever CAP it should
be) users. It's inherently unsafe for some controllers and ends up
leaking kernel implementation details into regular binaries thus
cementing those leaked details as APIs, which is a giant no-no.

> If we have decent enforcement of hierarchy for devices.{allow,deny},
> which we now do, then I don't see why this has to be the case.

If you think about devcg in isolation, maybe, but please keep in mind
that devcg itself is already somewhat abusing cgroup and many other
controllers shouldn't be allowed to delegate and we're headed for one
unified hierarchy.

>> kinda moot point.  If there are people actually doing that in the
>> wild, we can conditionalize it on cgroup_sane_behavior().
>
> Guess we'll stop using cgroups for now.

If you're delegating cgroup accesses to !root users, yes, STOP,
please. It'd be doing a lot more harm to the whole kernel and its
maintainability than whatever extra features / benefits it may be
bringing.

Thanks.

--
tejun
