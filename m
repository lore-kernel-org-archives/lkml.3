Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaDYMPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:15:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43278 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaDYMPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:02 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-bb-535a51c3fbeb
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 00/10] ARM: Exynos: PMU cleanup and refactoring for using DT
Date: Fri, 25 Apr 2014 21:32:36 +0900
Message-id: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+Zse7hwKhgg9bdJhYbZ6xntVg26S6b
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu8XhN+2sFutnvGaxuPlsO5PFjpbVLA48
	Hi3NPWwem5fUe/RtWcXo8XmTXABLFJdNSmpOZllqkb5dAldG56bDLAUH1SuWNDcwNzBul+9i
	5OSQEDCR+Ld4IzOELSZx4d56ti5GLg4hgWWMEv9WXWWCKdpz/hojiC0ksIhRovNoEERRG5PE
	2udzWEASbAK6Ek/ezwWbJCKQLXGl8T6YzSzwnlHi82H1LkYODmEBf4meF2EgYRYBVYl369pZ
	QWxeAXeJc18fMoKUSAgoSMyZZAMS5hTwkLjf0sIOsdZdYu6NnawgayUEdrFLXFqykhFijoDE
	t8mHWCB6ZSU2HYD6RVLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECImD
	3h2Mtw9YH2JMBho3kVlKNDkfGEd5JfGGxmZGFqYmpsZG5pZmpAkrifMmPUwKEhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cB45w7jpot6OYezvl3c0RE89er99ZLpCikKqUdOh6/7JvH1sNB7
	CYO8OOH3Pz+ue/n2VULuAcnOuTufrnXf422o7HXDm2d/+bQZH3MzZz98v9nlax9P/u4dm2UX
	1Ga/M9yRtHGFmmNbWUn30vifhX1V6pez2jTO9Nq6HMk1q9/x42HIefOuihlKSizFGYmGWsxF
	xYkALEnsPZkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd3DgVHBBg0t+hYbZ6xntVg26S6b
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYtPULu8XhN+2sFutnvGaxuPlsO5PFjpbVLA48
	Hi3NPWwem5fUe/RtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QZUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	wjrGjM5Nh1kKDqpXLGluYG5g3C7fxcjJISFgIrHn/DVGCFtM4sK99WwgtpDAIkaJzqNBXYxc
	QHYbk8Ta53NYQBJsAroST97PZQaxRQSyJa403gezmQXeM0p8PqzexcjBISzgL9HzIgwkzCKg
	KvFuXTsriM0r4C5x7utDRpASCQEFiTmTbEDCnAIeEvdbWtgh1rpLzL2xk3UCI+8CRoZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR9kxqB+PKBotDjAIcjEo8vB/UIoOFWBPLiitzDzFK
	cDArifB+8IsKFuJNSaysSi3Kjy8qzUktPsSYDHTURGYp0eR8YALIK4k3NDYxM7I0MrMwMjE3
	J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG8hPSRbs5j32YcimtIu1wWZCL1FE+T4vX
	zrI6grIT7+69Vht+Q+v2qV8L2+e+X/SQRSrmpqfSlCd/7rJVTKi/9kzi3pVTWvXfMptUbc5c
	0l44Q0eKp2ml5Num+gudvK3iC/ddmR22YJ6LoJ8+W0Hgy3cl/QIWeg95Oo2bFZmlSn23VnlH
	HkxUYinOSDTUYi4qTgQA+YjP9PYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series, does some minor cleanup and modifies Exynos PMU related
code for mapping and initialization of Exynos Power Management Unit (PMU)
base address from device tree. This is also preparation for moving PMU
related code out of machine folder and moving into a "drivers/mfd", so that
ARM64 based SoC can utilize common piece of code. These patches require change
in Exynos4210, Exynos4212 and Exynos4412 dtsi files, which has been posted
as separate patch series [2]

These patches are created on top of Kukjin Kim's for-next (v3.15-rc1 tag)
branch.

These patches depends on following two patch series:
1) mfd: syscon: Support early initialization
   https://lkml.org/lkml/2014/4/8/239
2) Add PMU node for Exynos SoCs
   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg29329.html

We have tested these patches on SMDK5250 and Arndale (Exynos5250) boards for
System boot and PMU initialization and S2R.

For testing on Arndale (Exynos5250) board:
Tested-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Changes Since v1:
 - Rebased on latest for-next of Kukjin Kim's tree.
 - Added patch: "Make exynos machine_ops as static". 
	For making more cleanup in "mach-exynos/common.h"
	as suggested by Tomasz Figa.
 - Addressed comments of Tomasz Figa for cleaning "mach-exynos/common.h".
 - Updated patch: Remove file path from comment section
	As suggested by Michel Simek, instead of updating file path
	lets remove them from each file under "mach-exynos".
	Even though Kukjin pointed out that there is similar patch pending from
	Sachin/Tushar but since I could not find I have included this here. If
	I have missed something please point to any existing such patch.
 - Updated patch: Add support for mapping PMU base address via DT
	- Removed __initdata from declaration of "exynos_pmu_base", as it caused
	kernel crash as pointed out by Vikas Sajjan.
	- Added support for Syscon initialization and getting PMU regmap handle
	as suggested by Sylwester. Since current implementation of early
	intialization [1] has limitation that "early_syscon_init" requires
	DT to be unflattened and system should be able to allocate memory,
	we can't use regmap handles for platsmp.c file as "smp_secondary_init"
	will be called before DT unflattening. So I have kept both method for
	accessing PMU base address. platsmp.c will use ioremmaped address where
	as rest other files can use regmap handle.
 - Added patch: Remove "linux/bug.h" from pmu.c.
 - Updated patch: Refactored code for PMU register mapping via DT
	- Modified to use regmap_read/write when using regmap handle.
 - Added patch: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
 - Added patch: Add device tree based initialization support for PMU.
	- Convert existing PMU implementation to be a device tree based 
	 before moving it to "drivers/mfd" folder. As suggested by Bartlomiej.
	- Dropped making a platform_driver for PMU, as currently PMU binding
	has two compatibility strings as "samsung, exynosxxx-pmu", "syscon",
	once we	enable MFD_SYSCON config option, current "syscon" driver probe
	gets called and PMU probe never gets called. So modified PMU
	initialization code to scan DT and match against supported compatiblity
	string in driver code, and once we get matching node use that for
	accessing PMU regmap handle using "syscon_early_regmap_lookup_by_phandle".
	If there is any better solution please suggest.

Pankaj Dubey (6):
  ARM: EXYNOS: Make exynos machine_ops as static
  ARM: EXYNOS: Cleanup "mach-exynos/common.h" file
  ARM: EXYNOS: Remove file path from comment section
  ARM: EXYNOS: Refactored code for using PMU address via DT
  ARM: EXYNOS: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
  ARM: EXYNOS: Add device tree based initialization support for PMU.

Young-Gun Jang (4):
  ARM: EXYNOS: Move SYSREG definition into sys-reg specific file.
  ARM: EXYNOS: Remove regs-pmu.h header dependency from pm_domain
  ARM: EXYNOS: Add support for mapping PMU base address via DT
  ARM: EXYNOS: Remove "linux/bug.h" from pmu.c

 arch/arm/mach-exynos/Kconfig               |    2 +
 arch/arm/mach-exynos/common.h              |   13 +-
 arch/arm/mach-exynos/cpuidle.c             |   37 +-
 arch/arm/mach-exynos/exynos.c              |  104 +++++-
 arch/arm/mach-exynos/headsmp.S             |    2 -
 arch/arm/mach-exynos/hotplug.c             |    7 +-
 arch/arm/mach-exynos/include/mach/map.h    |    3 -
 arch/arm/mach-exynos/include/mach/memory.h |    3 +-
 arch/arm/mach-exynos/platsmp.c             |   17 +-
 arch/arm/mach-exynos/pm.c                  |   61 ++--
 arch/arm/mach-exynos/pm_domains.c          |    2 +-
 arch/arm/mach-exynos/pmu.c                 |  191 ++++++++---
 arch/arm/mach-exynos/regs-pmu.h            |  512 ++++++++++++++--------------
 arch/arm/mach-exynos/regs-sys.h            |   22 ++
 14 files changed, 585 insertions(+), 391 deletions(-)
 create mode 100644 arch/arm/mach-exynos/regs-sys.h

-- 
1.7.10.4

