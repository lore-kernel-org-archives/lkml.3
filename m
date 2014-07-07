Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaGGWsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:48:18 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44837 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaGGWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:48:17 -0400
Message-ID: <53BB23AA.6060105@samsung.com>
Date: Tue, 08 Jul 2014 07:48:10 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, chow.kim@samsung.com
Subject: Re: [PATCH v6 0/6] Cleanup patches for mach-exynos
References: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1404705056-11965-1-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/14 12:50, Pankaj Dubey wrote:
> This series is doing code cleanup under arch/arm/mach-exynos.
> These patches have been separated from main exynos pmu v4 patch
> posted here [1].
>
> [1]: https://lkml.org/lkml/2014/5/10/29
>
> Changes Since v5:
>   - Rebased on latest for-next of Kukjin Kim's tree.
>   - Using of_machine_is_compatible instead of soc_is_exynos in patch 2.
>
> Changes Since v4:
>   - Rebased on latest for-next of Kukjin Kim's tree.
>   - Removing file path comment from mach-exynos/headsmp.S also.
>   - Removed signed-off-by of Young-Gun Jang<yg1004.jang@samsung.com>,
>     as this id is no more valid. Taking ownership of all his patches.
>   - Separated these patches from main exynos pmu v4 patch series as
>     suggested by Tomasz Figa.
>
> Changes Since v3:
>   - Addressed build fail issue in exynos.c as reported by Sachin Kamat.
>   - Rebased on top of Sysram patches by Sachin Kamat.
>
> Changes Since v2:
>   - Rebased on top of Daniel Lezcano's Exynos cpuidle refactor patches.
>   - Removed exynos_cpuidle_init and exynos_cpufreq_init code as suggested
>     by Tomasz Figa.
>
> Changes Since v1:
>   - Rebased on latest for-next of Kukjin Kim's tree.
>   - Added patch: "Make exynos machine_ops as static".
> 	For making more cleanup in "mach-exynos/common.h"
> 	as suggested by Tomasz Figa.
>   - Addressed comments of Tomasz Figa for cleaning "mach-exynos/common.h".
>   - Updated patch: Remove file path from comment section
> 	As suggested by Michel Simek, instead of updating file path
> 	lets remove them from each file under "mach-exynos".
> 	Even though Kukjin pointed out that there is similar patch pending from
> 	Sachin/Tushar but since I could not find I have included this here. If
> 	I have missed something please point to any existing such patch.
>   - Added patch: Remove "linux/bug.h" from pmu.c.
>   - Added patch: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
>
>
> Pankaj Dubey (6):
>    ARM: EXYNOS: Make exynos machine_ops as static
>    ARM: EXYNOS: Move cpufreq and cpuidle device registration to
>      init_machine
>    ARM: EXYNOS: Move SYSREG definition into sys-reg specific file
>    ARM: EXYNOS: Remove file path from comment section
>    ARM: EXYNOS: Remove regs-pmu.h header dependency from pm_domain
>    ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
>
>   arch/arm/mach-exynos/common.h              |    8 --------
>   arch/arm/mach-exynos/exynos.c              |   27 ++++++++-------------------
>   arch/arm/mach-exynos/headsmp.S             |    1 -
>   arch/arm/mach-exynos/hotplug.c             |    3 +--
>   arch/arm/mach-exynos/include/mach/map.h    |    3 +--
>   arch/arm/mach-exynos/include/mach/memory.h |    3 +--
>   arch/arm/mach-exynos/platsmp.c             |    3 +--
>   arch/arm/mach-exynos/pm.c                  |    1 +
>   arch/arm/mach-exynos/pm_domains.c          |    8 ++++----
>   arch/arm/mach-exynos/pmu.c                 |    1 -
>   arch/arm/mach-exynos/regs-pmu.h            |    4 ----
>   arch/arm/mach-exynos/regs-sys.h            |   22 ++++++++++++++++++++++
>   12 files changed, 39 insertions(+), 45 deletions(-)
>   create mode 100644 arch/arm/mach-exynos/regs-sys.h
>
OK, looks good to me, I think we don't need 4/6 patch though :-)

I've applied this whole series, thanks.

- Kukjin
