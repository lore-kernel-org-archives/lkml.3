Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3HCL5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 07:57:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53554 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab3HCL46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 07:56:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com
Subject: Re: [PATCH 00/10] CPUFreq: Fixes & Cleanups for 3.12
Date: Sat, 03 Aug 2013 14:07:11 +0200
Message-ID: <1976834.StkbCTGYhN@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 05:19:18 PM Viresh Kumar wrote:
> Hi Rafael,
> 
> This patchset tries to fix & cleanup many existing cpufreq core issues. First
> four patches tries to cleanup basic problems in cpufreq core. Its first patch
> was earlier sent separately but now is part of this series.
> 
> Fifth patch was also sent earlier as reply to your patches and was reviewed by
> Srivatsa. Sixth patch was picked from Lukasz's patchset on introducing software
> "boost" feature in core. It will be used by this patchset.
> 
> And last four are the most significant part of this set. They try to make many
> things simple and robust.
> 
> This is rebased of your bleeding-edge branch + two patches from you:
> 18a6b03 cpufreq: Avoid double kobject_put() for the same kobject in error code path
> d0cde63 cpufreq: Do not hold driver module references for additional policy CPUs
> abe513f Merge branch 'acpi-sleep-next' into linux-next
> 
> They are also pushed in my cpufreq-next branch

How much testing has that received so far?

Rafael


> --
> viresh
> 
> Lukasz Majewski (1):
>   cpufreq: Store cpufreq policies in a list
> 
> Viresh Kumar (9):
>   cpufreq: Cleanup header files included in core
>   cpufreq: Re-arrange declarations in cpufreq.h
>   cpufreq: Give consistent names for struct cpufreq_policy *
>   cpufreq: Use sizeof(*ptr) form for finding size of a struct
>   cpufreq: Pass policy to cpufreq_add_policy_cpu()
>   cpufreq: Use cpufreq_policy_list for iterating over policies
>   cpufreq: Fix broken usage of governor->owner's refcount
>   cpufreq: Don't use cpufreq_driver->owner's refcount to protect
>     critical sections
>   cpufreq: Remove struct cpufreq_driver's owner field
> 
>  Documentation/cpu-freq/cpu-drivers.txt |   2 -
>  drivers/cpufreq/acpi-cpufreq.c         |   5 +-
>  drivers/cpufreq/at32ap-cpufreq.c       |   1 -
>  drivers/cpufreq/blackfin-cpufreq.c     |   1 -
>  drivers/cpufreq/cpufreq-nforce2.c      |   1 -
>  drivers/cpufreq/cpufreq.c              | 389 +++++++++++++++------------------
>  drivers/cpufreq/cpufreq_conservative.c |  14 +-
>  drivers/cpufreq/cpufreq_governor.c     |   6 -
>  drivers/cpufreq/cpufreq_governor.h     |   7 +-
>  drivers/cpufreq/cpufreq_ondemand.c     |  24 +-
>  drivers/cpufreq/cpufreq_performance.c  |   3 +-
>  drivers/cpufreq/cpufreq_powersave.c    |   3 +-
>  drivers/cpufreq/cpufreq_stats.c        |  25 +--
>  drivers/cpufreq/cris-artpec3-cpufreq.c |   1 -
>  drivers/cpufreq/cris-etraxfs-cpufreq.c |   1 -
>  drivers/cpufreq/e_powersaver.c         |   5 +-
>  drivers/cpufreq/elanfreq.c             |   1 -
>  drivers/cpufreq/exynos-cpufreq.c       |   2 +-
>  drivers/cpufreq/freq_table.c           |   4 +-
>  drivers/cpufreq/gx-suspmod.c           |   3 +-
>  drivers/cpufreq/ia64-acpi-cpufreq.c    |   5 +-
>  drivers/cpufreq/intel_pstate.c         |   1 -
>  drivers/cpufreq/kirkwood-cpufreq.c     |   1 -
>  drivers/cpufreq/longhaul.c             |   1 -
>  drivers/cpufreq/longrun.c              |   1 -
>  drivers/cpufreq/loongson2_cpufreq.c    |   1 -
>  drivers/cpufreq/maple-cpufreq.c        |   1 -
>  drivers/cpufreq/p4-clockmod.c          |   1 -
>  drivers/cpufreq/pasemi-cpufreq.c       |   1 -
>  drivers/cpufreq/pcc-cpufreq.c          |   1 -
>  drivers/cpufreq/pmac32-cpufreq.c       |   1 -
>  drivers/cpufreq/pmac64-cpufreq.c       |   6 +-
>  drivers/cpufreq/powernow-k6.c          |   1 -
>  drivers/cpufreq/powernow-k7.c          |  14 +-
>  drivers/cpufreq/powernow-k8.c          |   7 +-
>  drivers/cpufreq/ppc-corenet-cpufreq.c  |   1 -
>  drivers/cpufreq/ppc_cbe_cpufreq.c      |   1 -
>  drivers/cpufreq/s3c2416-cpufreq.c      |   1 -
>  drivers/cpufreq/s3c24xx-cpufreq.c      |   6 +-
>  drivers/cpufreq/s3c64xx-cpufreq.c      |   1 -
>  drivers/cpufreq/sc520_freq.c           |   1 -
>  drivers/cpufreq/sh-cpufreq.c           |   1 -
>  drivers/cpufreq/sparc-us2e-cpufreq.c   |   6 +-
>  drivers/cpufreq/sparc-us3-cpufreq.c    |   6 +-
>  drivers/cpufreq/speedstep-centrino.c   |   1 -
>  drivers/cpufreq/speedstep-ich.c        |   1 -
>  drivers/cpufreq/speedstep-smi.c        |   1 -
>  include/linux/cpufreq.h                | 383 +++++++++++++++-----------------
>  48 files changed, 409 insertions(+), 542 deletions(-)
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
