Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3GIHC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:02:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64196 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3GIHCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:02:54 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-aa-51dbb59c17be
Date: Tue, 09 Jul 2013 09:02:43 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukasz Majewski <l.majewski@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 0/7] cpufreq:boost: CPU Boost mode support
Message-id: <20130709090243.7d492f82@amdc308.digital.local>
In-reply-to: <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQd05W28HGnQv5bL483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbS43biCzaJ/YS+TxZOH
	fWwWG796OPB5LN7zksnjzrU9bB7rpr1l9ujbsorR49HiFkaP4ze2M3l83iQXwB7FZZOSmpNZ
	llqkb5fAldF1fjFLwVvZinc757A0MB4R72Lk5JAQMJE4dWAPK4QtJnHh3nq2LkYuDiGB6YwS
	V9+/Zodw2pkkFvfvYgKpYhFQlWiZuZkFxGYT0JP4fPcpWFxEwFdi0aLNTCANzAI/mCW+/9gM
	NlZYwFFiw7zTYEW8AtYSr3q/MYLYnAJuEpcv9DBBbGhklNjQ8QFsKr+ApET7vx/MEDfZSZz7
	tIEdollQ4sfke2A1zAJaEpu3NbFC2PISm9e8ZZ7AKDgLSdksJGWzkJQtYGRexSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iREcV8+kdjCubLA4xCjAwajEw/vh8q1AIdbEsuLK3EOMEhzMSiK8
	L1RvBwrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpg5Ps4
	MXKKJtOuOJO1i7xmX4ubsYer5XhPyKS3D/fMnCJx5SfXzvmbDp9/aMZ4Mjzyw7+JcuVT/biu
	i1W6yd78NTdfef5t/19TBPuOBwnIl1Rq74xg+8dsqrVV4fwSXpGfpvZsSnyrl8lHT5titbCW
	vbfD+cuJngtZeUeqzuvM31+38EFzOfPBN0osxRmJhlrMRcWJAIVT+G6nAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Jul 2013 10:50:23 +0200, Lukasz Majewski wrote:

Dear Viresh, Rafael

Do you have any comments/feedback for me regarding those patches?

> This patch series introduces support for CPU overclocking technique
> called Boost.
> 
> It is a follow up of a LAB governor proposal. Boost is a LAB
> component:
> http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> 
> Boost unifies hardware based solution (e.g. Intel Nehalem) with
> software oriented one (like the one done at Exynos).
> For this reason cpufreq/freq_table code has been reorganized to
> include common code.
> 
> Important design decisions:
> 
> - Boost related code is compiled-in unconditionally to cpufreq core
> and disabled by default. The cpufreq_driver is responsibile for
> setting boost_supported flag and providing enable_boost callback(if
> HW support is needed). For software managed boost, special Kconfig
> flag - CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be
> selectable only when a target platform has thermal framework properly
> configured.
> 
> - struct cpufreq_driver has been extended with boost related fields:
>         -- boost_supported - when driver supports boosting
>         -- enable_boost - callback to function, which is necessary to
>            enable boost
> 
> - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is
> visible _only_ when cpufreq driver supports Boost.
> 
> - No special spin_lock for Boost was created. The one from cpufreq
> core was reused.
> 
> - All available policies are now stored in a list.
> 
> - The Boost code doesn't rely on any policy. When boost state is
> changed, then the policy list is iterated and proper adjustements are
> done.
> 
> - To improve safety level, the thermal framework is also extended to
> disable software boosting, when thermal trip point is reached. Then
> it starts monitoring of target temperature to evaluate if boost can
> be enabled again. This emulates behaviour similar to HW managed boost
> (like x86)
> 
> New patches for v5:
> cpufreq:boost:Kconfig: Enable software managed BOOST support at
> Kconfig Documentation:cpufreq:boost: Update BOOST documentation
> 
> Patches dropped at v5:
> cpufreq: Calculate number of busy CPUs
> cpufreq: Enable software boost only when up to one busy core is
> running
> 
> Tested at: HW:
>         Exynos 4412 3.10 linux
>         Exynos 4210 3.10 linux
> Compile tested x86_64 defconfig (acpi) - help with HW (Intel Nehalem)
> test needed
> 
> The code has been rebased on top of kernel_pm/bleeding-edge (3.11-rc1)
> 
> 
> Lukasz Majewski (7):
>   cpufreq: Store cpufreq policies in a list
>   cpufreq: Add boost frequency support in core
>   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common
>     boost solution
>   cpufreq:exynos:Extend Exynos cpufreq driver to support boost
>     framework
>   thermal:boost: Automatic enable/disable of BOOST feature
>   cpufreq:boost:Kconfig: Enable software managed BOOST support at
>     Kconfig
>   Documentation:cpufreq:boost: Update BOOST documentation
> 
>  Documentation/cpu-freq/boost.txt |   26 ++++-----
>  drivers/cpufreq/Kconfig          |   14 +++++
>  drivers/cpufreq/acpi-cpufreq.c   |   69 +++++++----------------
>  drivers/cpufreq/cpufreq.c        |  115
> ++++++++++++++++++++++++++++++++++++++
> drivers/cpufreq/exynos-cpufreq.c |    9 ++-
> drivers/cpufreq/freq_table.c     |   47 +++++++++++++---
> drivers/thermal/thermal_core.c   |   31 ++++++++++
> include/linux/cpufreq.h          |   13 +++++
> include/linux/thermal.h          |    2 + 9 files changed, 257
> insertions(+), 69 deletions(-)
> 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
