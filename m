Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaIXMZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:25:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31507 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXMZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:25:06 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-6a-5422b81f6a83
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v7 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Wed, 24 Sep 2014 14:24:43 +0200
Message-id: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQV2FHUohBqtXsFhsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLDq/zGKzuH2Z1+LM6UusFif/
	9DJavDrYxmLxc9c8FotVu/4wWmz86uEg6NHS3MPmsXPWXXaPO9f2sHlsXlLvcfvfY2aPLVfb
	WTz6tqxi9Pi8Sc5j49zQAM4oLpuU1JzMstQifbsErox/B9exFsyUq9hy/ghTA+NiyS5GTg4J
	AROJjqVfmSFsMYkL99azgdhCAtMZJXYs5eli5AKyu5gknvXeYgFJsAlYSUxsX8UIYosIqEn0
	LN4KZjML3GaRaLgeAWILC6RI/PzbxQRiswioSmy9eYG9i5GDg1fAXeLDYweIXYoS3c8msE1g
	5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhIn0nvYFzVYHGIUYCDUYmHt2OZUogQ
	a2JZcWXuIUYJDmYlEV6rbUAh3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1ML
	UotgskwcnFINjCK39A4mT2OY7fjIyJ+lyKKf4dyXjydu9S7kb/nFxjVv9t+g0jOs304c2e31
	6FKMO9O3WAtGGy/VenkeRbPb8TxXXk5vdFz+fKpYz8z9G3ecWLE0fPPKoPQ1K19bflF5tHfe
	2blzRKc9yD7u0mnfPe/um6ja1AbeH12Xpfk2pWacfygc/zr1b4ESS3FGoqEWc1FxIgDgtpp/
	TgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds support for AFTR idle mode on boards with
secure firmware enabled and allows EXYNOS cpuidle driver usage on
Exynos4x12 SoCs.

It has been tested on Trats2 board (using Exynos4412 SoC with secure
firmware enabled) on which AFTR mode reduces power consumption by ~12%
when EXYNOS cpuidle driver is enabled (in both cases the default
exynos_defconfig config is used and CPU1-3 are offlined).

Currently Exynos4412 SoC support is limited to Trats2 board.

Depends on:
- for-next branch of linux-samsung.git kernel tree
- [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
  (https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35921.html)

Changes since v6:
- rebased on top of for-next branch of linux-samsung.git kernel tree +
  [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
  (https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35921.html)
- fixed build on Tegra
- updated patch #2 summary line

Changes since v5:
- rebased on top of next-20140904 +
  "irqchip: Properly fetch the per cpu offset" patch
  (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg716674.html)
  [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
  (https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35921.html)
- limit Exynos4412 SoC support to Trats2 board for now

Changes since v4:
- rebased on top of next-20140804 +
  [PATCH v5][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35262.html)
  [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
- call exynos_save_cp15() only on A9 type core (this is needed for the future
  Exynos3250 SoC support)

Changes since v3:
- rebased on top of next-20140804 +
  [PATCH v4][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35192.html)
  [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)
- (re-)added patch fixing S5P_CENTRAL_SEQ_OPTION register setup

Changes since v2:
- rebased on top of next-20140708 +
  [PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html)
  [with rejects fixed]
  [PATCH 6/6] ARM: EXYNOS: Register cpuidle device only on Exynos4210 and 5250
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32808.html)
  [PATCH 0/2] Firmware-assisted suspend/resume of Exynos SoCs
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32991.html)
  [with rejects fixed in patch #2]
- addressed review comments from Tomasz Figa and Daniel Lezcano

Changes since v1:
- synced against next-20140602
- added missing Acked-by-s

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

Bartlomiej Zolnierkiewicz (5):
  ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
  ARM: add AFTR mode support to firmware do_idle method
  ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
  ARM: EXYNOS: PM: fix register setup for AFTR mode code
  ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs

 arch/arm/include/asm/firmware.h        |  2 +-
 arch/arm/mach-exynos/common.h          |  5 +++
 arch/arm/mach-exynos/exynos.c          |  5 ++-
 arch/arm/mach-exynos/firmware.c        | 34 ++++++++++++++-----
 arch/arm/mach-exynos/pm.c              | 60 ++++++++++++++++++++--------------
 arch/arm/mach-tegra/cpuidle-tegra114.c |  2 +-
 6 files changed, 72 insertions(+), 36 deletions(-)

-- 
1.8.2.3

