Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab3BHM0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:26:23 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34204 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100Ab3BHM0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:26:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: valdis.kletnieks@vt.edu, artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
Date: Fri, 08 Feb 2013 13:32:39 +0100
Message-ID: <2130803.VQA31hf2jE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomrLAQiP58+OVBrm3jb8rd5DK3z+7_kyB_MsKM7UyyWRw@mail.gmail.com>
References: <cover.1360232293.git.viresh.kumar@linaro.org> <2896238.eRV3G7kyl2@vostro.rjw.lan> <CAKohpomrLAQiP58+OVBrm3jb8rd5DK3z+7_kyB_MsKM7UyyWRw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 08, 2013 08:20:55 AM Viresh Kumar wrote:
> On 8 February 2013 05:03, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > I should have done that before, sorry about it.
> >
> > Can you please rework this series on top of linux-pm.git/pm-cpufreq and
> > try to avoid introducing new issues this time?
> 
> Even i want to do that, but when i fetch your repo i don't see all applied
> patches in this branch.

The top-most commit in that branch is

commit 73bf0fc2b03d1f4fdada0ec430dc20bfb089cfd5
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Feb 5 22:21:14 2013 +0100

    cpufreq: Don't remove sysfs link for policy->cpu

because that's when the locking problems were first reported and I stopped
putting new commits into that branch.  And since the locking problems were
introduced by b8eed8a "cpufreq: Simplify __cpufreq_remove_dev()" I want them
to be fixed on top of pm-cpufreq rather than on top of more new stuff that
very well may introduce *more* problems.

So as I said, please rework the fixes on top of linux-pm.git/pm-cpufreq.

Moreover, I'd very much prefer it if you fixed the problems introduced by
b8eed8a "cpufreq: Simplify __cpufreq_remove_dev()" separately and *then* any
other locking problems you're seeing in the code, although people are not
reporting them.

You seem to have a clear picture of how the code should work now, so that
won't be a big trouble I guess.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
