Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab3FAT3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:29:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56429 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab3FAT3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:29:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
Date: Sat, 01 Jun 2013 21:37:57 +0200
Message-ID: <3146671.7pOpkCChrO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokmn-Rf-1w2aQHMMMkMbJqxokWXm5ye3DNuc-yzzk=7pQ@mail.gmail.com>
References: <51A7BFA6.3070800@semaphore.gr> <51A8D0C2.1080801@semaphore.gr> <CAKohpokmn-Rf-1w2aQHMMMkMbJqxokWXm5ye3DNuc-yzzk=7pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 01, 2013 08:26:47 PM Viresh Kumar wrote:
> On 31 May 2013 22:03, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> > On 05/31/2013 11:51 AM, Viresh Kumar wrote:
> >> I believe you should have removed other users of getavg() in a separate
> >> patch and also cc'd relevant people so that you can some review comments
> >> from  them.
> >
> > I will split the patch in two. If it's OK, I will keep the removal of
> > __cpufreq_driver_getavg in the original patch and move the clean up of
> > APERF/MPERF support in a second patch. I will also cc relevant people.
> 
> Even removal of __cpufreq_driver_getavg() should be done in a separate
> patch, so that it can be reverted easily if required later.

Why would you want to revert it separately?

> >> "Proportional to load" means C * load, so why is "policy->max / 100" *the* right C?
> >
> > I think, finally(?) I see your point. The right C should be "policy->cpuinfo.max_freq / 100".
> 
> Why are you changing it to cpuinfo.max_freq?? This is fixed once a driver is
> initialized.. but user may request a lower max freq for a governor or policy.
> Which is actually reflected in policy->max I believe.

Which doesn't matter.  The formula should provide the same results regardless
of the user settings except that the selected frequency should be capped by
policy->max (instead of being proportional to it).  I think using
cpuinfo.max_freq here is correct.

> Over that why keeping following check is useful anymore?
> 
> if (load_freq > od_tuners->up_threshold)
>     goto max.
> 
> As, if load is over 95, then even policy->max * 95 / 100 will even give almost
> the same freq.

Yes, in the majority of cases.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
