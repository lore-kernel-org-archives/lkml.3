Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaIXOUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:20:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23099 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaIXOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:20:14 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-99-5422d31c39c7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v3 0/1] ARM: EXYNOS: Fix builds with PM_SLEEP=n
Date: Wed, 24 Sep 2014 16:20:01 +0200
Message-id: <1411568402-24561-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jAV2Zy0ohBqeXqVlsnLGe1WLeZ1mL
	1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txdojd9ktTl3/zGax+cNLNosrl06xWaza
	9YfRgdejpbmHzWPnrLvsHneu7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL
	4Mr4u3Ylc8F7noqmxVfZGxhfc3UxcnJICJhIPL+5mBHCFpO4cG89WxcjF4eQwCJGiYcts5kh
	nC4miTlr3rCBVLEJWElMbF8F1iEioCbRs3grI0gRs8BDZonO8zdZQRLCAvYS//c3g9ksAqoS
	cw4fB7N5BTwkZnxtYoZYpyjR/WwC2wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcx
	gkPumfQOxlUNFocYBTgYlXh4O5YphQixJpYVV+YeYpTgYFYS4T16ASjEm5JYWZValB9fVJqT
	WnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBMWLL2pauyQcX838vKraa/PCrrTbP
	ss6X1+YqPuop2/vmZ2KFoNs3s0fPNf9zK2YVV/7MK4nfwGVwIa35jtrRnIDjUsI/bm/NnfdP
	WK5W71CG05LGswfv6Eao6BYH6yy9OkviyP9JW5h06jhMll/nZxc4+1OTVdfri75OnUrrra/F
	R+aU+x+/r8RSnJFoqMVcVJwIAOQng781AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes builds with CONFIG_PM_SLEEP config option disabled.
It has been runtime tested on Exynos4210 based Origen board.

Depends on:
- for-next branch of linux-samsung.git kernel tree
- [PATCH v7 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with secure
  firmware enabled
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg37073.html)

Changes since v2:
(http://www.mail-archive.com/linux-samsung-soc%40vger.kernel.org/msg35430.html)
- rebased on top of for-next branch of linux-samsung.git kernel tree +
  [PATCH v7 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with secure
  firmware enabled
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg37073.html)

Changes since v1:
(http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34079.html)
- rebased on top of next-20140811
- fixed OOPS on the first try to enter cpuidle AFTR mode
  (config with CONFIG_PM_SLEEP=n and CONFIG_ARM_EXYNOS_CPUIDLE=y)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (1):
  ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y

 arch/arm/mach-exynos/Kconfig   |   5 +
 arch/arm/mach-exynos/Makefile  |   5 +-
 arch/arm/mach-exynos/common.h  |   4 +
 arch/arm/mach-exynos/pm.c      | 338 +-------------------------------------
 arch/arm/mach-exynos/suspend.c | 356 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/plat-samsung/Makefile |   1 +
 6 files changed, 374 insertions(+), 335 deletions(-)
 create mode 100644 arch/arm/mach-exynos/suspend.c

-- 
1.8.2.3

