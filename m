Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3BEJ5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:57:01 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:43967 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3BEJ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:56:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org
Subject: Re: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
Date: Tue, 05 Feb 2013 11:03:13 +0100
Message-ID: <3480441.gCEh0J5edK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOh2x=n+ASeLpGHexxDvPGrN6ia+bLnNUNCb-covGDoABVk_wQ@mail.gmail.com>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com> <2765418.Ft0GYkgNgL@vostro.rjw.lan> <CAOh2x=n+ASeLpGHexxDvPGrN6ia+bLnNUNCb-covGDoABVk_wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 05, 2013 01:58:20 PM Viresh Kumar wrote:
> On Tue, Feb 5, 2013 at 6:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, February 04, 2013 04:45:11 PM Nathan Zimmer wrote:
> >> I am noticing the cpufreq_driver_lock is quite hot.
> >> On an idle 512 system perf shows me most of the system time is spent on this
> >> lock.  This is quite signifigant as top shows 5% of time in system time.
> >> My solution was to first convert the lock to a rwlock and then to the rcu.
> >>
> >>
> >> Nathan Zimmer (2):
> >>   cpufreq: Convert the cpufreq_driver_lock to a rwlock
> >>   cpufreq: Convert the cpufreq_driver_lock to use the rcu
> >>
> >>  drivers/cpufreq/cpufreq.c | 139 ++++++++++++++++++++++++++--------------------
> >>  1 file changed, 79 insertions(+), 60 deletions(-)
> >
> > I like these changes.
> >
> > Viresh, anyone, any comments?
> 
> Hi Nathan/Rafael,
> 
> Even i liked the basic idea behind the patchset, but didn't like the way it
> is divided into patches. For me, it is highly discouraged to undo something
> that you added in the same patchset. And you did exactly the same thing.
> 
> Patch 2 is revert of 1 + rcu stuff.
> 
> So, i would expect a single patch, i.e. merge of both patches + rebased
> on latest stuff.

I actually don't agree with that, becuase the Nathan's apprach shows the
reasoning that leads to the RCU introduction quite clearly.  So if you
don't have technical problems with the patchset, I'm going to take it as is.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
