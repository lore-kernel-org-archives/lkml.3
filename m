Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab3HGAK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:10:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58570 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab3HGAKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:10:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH V2 00/11] CPUFreq: Fixes & Cleanups for 3.12
Date: Wed, 07 Aug 2013 02:21:12 +0200
Message-ID: <1627831.GMXVKIrL9l@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 10:53:02 PM Viresh Kumar wrote:
> Hi Rafael,
> 
> This is V2 of the patch series which was posted here earlier:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/1759514
> 
> This patchset tries to fix & cleanup many existing cpufreq core issues. First
> four patches tries to cleanup basic problems in cpufreq core. Its first patch
> was earlier sent separately but now is part of this series.
> 
> Fifth patch was also sent earlier as reply to your patches and was reviewed by
> Srivatsa. Sixth patch was picked from Lukasz's patchset on introducing software
> "boost" feature in core. It will be used by this patchset.
> 
> And 7-10 are are the most significant part of this set. They try to make many
> things simple and robust.
> 
> Last patch in the series is new and wasn't part of V1.
> 
> This is rebased of your bleeding-edge branch + two patches from you:
> 18a6b03 cpufreq: Avoid double kobject_put() for the same kobject in error code path
> d0cde63 cpufreq: Do not hold driver module references for additional policy CPUs
> abe513f Merge branch 'acpi-sleep-next' into linux-next
> 
> They are also pushed in my cpufreq-next branch.
> 
> They are tested fairly well on ARM Vexpress TC2 board (big LITTLE).
> 
> Lukasz Majewski (1):
>   cpufreq: Store cpufreq policies in a list
> 
> Viresh Kumar (10):
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
>   cpufreq: improve error checking on return values of
>     __cpufreq_governor()

Applied to bleeding-edge except for patch [05/11] that I've applied already
earlier.

>  Documentation/cpu-freq/cpu-drivers.txt |   2 -
>  drivers/cpufreq/acpi-cpufreq.c         |   5 +-
>  drivers/cpufreq/at32ap-cpufreq.c       |   1 -
>  drivers/cpufreq/blackfin-cpufreq.c     |   1 -
>  drivers/cpufreq/cpufreq-nforce2.c      |   1 -
>  drivers/cpufreq/cpufreq.c              | 426 ++++++++++++++++-----------------
>  drivers/cpufreq/cpufreq_conservative.c |  14 +-
>  drivers/cpufreq/cpufreq_governor.c     |   6 -
>  drivers/cpufreq/cpufreq_governor.h     |   7 +-
>  drivers/cpufreq/cpufreq_ondemand.c     |  24 +-
>  drivers/cpufreq/cpufreq_performance.c  |   3 +-
>  drivers/cpufreq/cpufreq_powersave.c    |   3 +-
>  drivers/cpufreq/cpufreq_stats.c        |  23 +-
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
>  include/linux/cpufreq.h                | 386 ++++++++++++++---------------
>  48 files changed, 442 insertions(+), 547 deletions(-)

I like these statistics. :-)

Thanks,
Rafael

