Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaFXN5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:57:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39857 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaFXN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:57:47 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e4-53a983d84130
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 0/6] Various Samsung fixes for v3.16-rc3
Date: Tue, 24 Jun 2014 15:57:09 +0200
Message-id: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJMWRmVeSWpSXmKPExsVy+t/xq7o3mlcGGyzfpmLRu+Aqm8Wmx9dY
	LS7vmsNmMeP8PiaLtUfuslusn/GaxWLVrj+MDuweO2fdZffYvKTeo2/LKkaPz5vkAliiuGxS
	UnMyy1KL9O0SuDIaf89kK7jLWXFm302mBsbP7F2MnBwSAiYSz5/2sUHYYhIX7q0Hsrk4hASW
	MkrsPjeNEcLpY5I42HOaFaSKTUBN4nPDI7AOEQFVic9tC8AmMQs8YZSY9dQNxBYWsJCYu6yN
	EcRmAaqZfWwdWA2vgJPExfm3obbJSfRue8M8gZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS9
	5PzcTYyQ0Piyg3HxMatDjAIcjEo8vBd2rQgWYk0sK67MPcQowcGsJMJ7o2ZlsBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQbG1BL3XO+WFzKHM0T2BTl/KjgZ8NMhwGeR3bYg3379icU8J2cUTgqT
	5vjQa/LHXuD7zhc7rb+fZkmYIJyb9MNeOkFtX0Ua/6cJrKcmC/Qrl+RFT1epbBNafvz0OU3t
	bUtWsEkqBreEt1+/pxIzgzXWYmLX8+vWD5eopKVJb3GomLVjasPVP3JKLMUZiYZazEXFiQAB
	T6aV6wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series inteds to fix various issues spotted while testing v3.16-rc2.
The patches should be reasonably independent from each other and so could be
picked to respective trees. See descriptions of individual patches for more
information.

Tested on Exynos4412-based Trats2 and Exynos4210-based Trats boards.

AFAIK there is no need to backport those fixes to stable.

Tomasz Figa (6):
  mmc: sdhci-s3c: Fix local I/O clock gating
  ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
  clk: samsung: exynos4: Remove SRC_MASK_ISP gates
  ARM: SAMSUNG: Restore Samsung PM Debug functionality
  ARM: EXYNOS: Fix suspend/resume sequencies
  ARM: EXYNOS: Register cpuidle device only on Exynos4210 and 5250

 arch/arm/mach-exynos/exynos.c     |  6 ++----
 arch/arm/mach-exynos/hotplug.c    | 10 ++++++----
 arch/arm/mach-exynos/platsmp.c    | 34 +++++++++++++++++++---------------
 arch/arm/mach-exynos/pm.c         | 20 ++++----------------
 arch/arm/plat-samsung/Kconfig     |  8 +++++++-
 arch/arm/plat-samsung/pm-debug.c  |  1 +
 drivers/clk/samsung/clk-exynos4.c | 16 ++++------------
 drivers/mmc/host/sdhci-s3c.c      | 17 ++++++++++-------
 8 files changed, 53 insertions(+), 59 deletions(-)

-- 
1.9.3

