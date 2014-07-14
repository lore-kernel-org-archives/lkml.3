Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaGNOo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:44:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59256 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaGNOoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:44:21 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f5-53c3ecc32250
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 0/2] ARM: EXYNOS: Fix builds with PM_SLEEP=n
Date: Mon, 14 Jul 2014 16:43:58 +0200
Message-id: <1405349040-5265-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jAd3Dbw4HG9zpUbPYOGM9q8W8z7IW
	r18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc3iyqVTbBbrZ7xmceDx
	uHNtD5vH5iX1HldONLF69G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8a9rY8ZC35zVOxo72Bq
	YNzL3sXIySEhYCLxpPsPI4QtJnHh3nq2LkYuDiGBRYwSfxZ/ZwZJCAl0MUlcWmEKYrMJWElM
	bF8F1iAioCbRs3grI0gDs8A6Zomd2/4DdXNwCAvYSJz7ZQ1SwyKgKvF81kQ2EJtXwF3iWd9x
	VohlihLdzyawTWDkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKCeSe1gXNlgcYhR
	gINRiYc3g+NwsBBrYllxZe4hRgkOZiURXo8bQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qt
	A4UE0hNLUrNTUwtSi2CyTBycUg1Aez+lzn694o3weZP+Mv5Gg8zdmhfLsxhPrK6fHfT38EL1
	w7Nm2E6qzP+bXr+T4671jm8lC619TM47/ZOJZFxdocDBk2paHT7D+sBiO52t6v/YGLWZPpud
	ai2yMpSR2SelXfRKavKPb4+EGC7GRR5ospH969Zod1JVsCDVXPyUyxG7dxFa4UosxRmJhlrM
	RcWJADZKzR4kAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes builds with CONFIG_PM_SLEEP config option
disabled.

They are on top of:
- next-20140714 +
- "[PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies" +
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32809.html)
- "[PATCH v2] ARM: EXYNOS: Fix build with PM_SLEEP=n"
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34007.html)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

Bartlomiej Zolnierkiewicz (2):
  ARM: EXYNOS: Fix build with PM_SLEEP=n part #2
  ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y

 arch/arm/mach-exynos/Kconfig   |   5 +
 arch/arm/mach-exynos/Makefile  |   3 +-
 arch/arm/mach-exynos/common.h  |   7 ++
 arch/arm/mach-exynos/exynos.c  |   2 +
 arch/arm/mach-exynos/pm.c      | 178 +-----------------------------------
 arch/arm/mach-exynos/suspend.c | 203 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/plat-samsung/Makefile |   1 +
 7 files changed, 224 insertions(+), 175 deletions(-)
 create mode 100644 arch/arm/mach-exynos/suspend.c

-- 
1.8.2.3

