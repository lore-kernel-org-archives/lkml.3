Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3FCKXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:23:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57241 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab3FCKXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:23:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
Date: Mon, 03 Jun 2013 12:32:36 +0200
Message-ID: <4899012.FZHBNtJbTr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokGDFvtaBMKxLTJCkx_WN+HN4eZ7LZ2upBLsXAsmcq7kA@mail.gmail.com>
References: <51A7BFA6.3070800@semaphore.gr> <3146671.7pOpkCChrO@vostro.rjw.lan> <CAKohpokGDFvtaBMKxLTJCkx_WN+HN4eZ7LZ2upBLsXAsmcq7kA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 03, 2013 12:21:47 PM Viresh Kumar wrote:
> On 2 June 2013 01:07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, June 01, 2013 08:26:47 PM Viresh Kumar wrote:
> 
> >> Even removal of __cpufreq_driver_getavg() should be done in a separate
> >> patch, so that it can be reverted easily if required later.
> >
> > Why would you want to revert it separately?
> 
> We might not need to revert all the changes that Stratos is doing.
> Only a revert of getavg() and its users + a small fix in governor would
> be enough. Stratos patch isn't only about removing getavg() but how
> ondemand works and so breaking stuff might be more useful.

Yes, it's probably better to do the getavg() removal as a separate patch.

> >> >> "Proportional to load" means C * load, so why is "policy->max / 100" *the* right C?
> >> >
> >> > I think, finally(?) I see your point. The right C should be "policy->cpuinfo.max_freq / 100".
> >>
> >> Why are you changing it to cpuinfo.max_freq?? This is fixed once a driver is
> >> initialized.. but user may request a lower max freq for a governor or policy.
> >> Which is actually reflected in policy->max I believe.
> >
> > Which doesn't matter.  The formula should provide the same results regardless
> > of the user settings except that the selected frequency should be capped by
> > policy->max (instead of being proportional to it).  I think using
> > cpuinfo.max_freq here is correct.
> 
> I am confused now about what to use.. This is how I read it:
> 
> Assumption: CPU supports following freq range.. 500 MHz, 600 MHz, 700 MHz,
> 800 MHz, 900 MHz, 1 GHz
> 
> cpuinfo.max_freq = 1 GHz
> policy->max is set to 600 MHz
> 
> Case 1: Use policy->max:
> 
> We need load to be over 500/600 (i.e. .834) to move to 600 MHz.
> 
> Case 2: Use cpuinfo.max_freq..
> 
> We need load to be over 500/1000 (i.e. .5) to move to 600 MHz.
> 
> So, obviously the calculations aren't the same..

No, they aren't.

My point is that the set of frequencies to choose from doesn't change with
the changes of user settings, so the computation should use things that
don't with the user settings either.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
