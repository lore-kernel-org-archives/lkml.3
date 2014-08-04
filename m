Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaHDRqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:46:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17554 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaHDRp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:45:59 -0400
X-AuditID: cbfee61b-f79f86d00000144c-49-53dfc6d5c129
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v4 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Mon, 04 Aug 2014 19:45:40 +0200
Message-id: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd2rx+4HG+zbzWWxccZ6Vot5n2Ut
	ehdcZbM42/SG3eL9oWfMFpseX2O1uLxrDpvF594jjBYzzu9jsjhz+hKrxck/vYwW62e8ZrHY
	+NXDgdfjzrU9bB6bl9R73P73mNljy9V2Fo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DK6Jub
	WrBWtGLulKfMDYzNQl2MnBwSAiYSW5ffZoewxSQu3FvP1sXIxSEksIhR4uOr2cwQTheTxI49
	DxhBqtgErCQmtq8Cs0UE1CR6Fm9lBCliFtjLLLG0exPYKGGBFIkVJ1cwg9gsAqoSaz71soHY
	vAIeEtNv/GGCWKco0f1sAtsERu4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLD7Jn0
	DsZVDRaHGAU4GJV4eAXU7gcLsSaWFVfmHmKU4GBWEuGtOwAU4k1JrKxKLcqPLyrNSS0+xCjN
	waIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwCi101085entLPNVwZ27jd1Szsk7GhzccLS3
	QvPEtoMBnienht5JkRf6tqc04NHmrQy7TlhEfPt9T9L0dJ4YQ2Sba7Gr/QnO6ppNN5jO83st
	6d+pbu709tt8v1Lrc9rBTHve7DV9IHBp0rPu0GVefrW55opZ65asithjdMZUjlX9Zfm611Hy
	5kosxRmJhlrMRcWJAOS30rIvAgAA
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

Depends on:
- next-20140804 branch of linux-next kernel tree
- [PATCH v4][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35192.html)
- [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34282.html)

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
  ARM: EXYNOS: add AFTR mode support to firmware do_idle method
  ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code
  ARM: EXYNOS: PM: fix register setup for AFTR mode code
  ARM: EXYNOS: cpuidle: allow driver usage on Exynos4x12 SoCs

 arch/arm/include/asm/firmware.h |  2 +-
 arch/arm/mach-exynos/common.h   |  5 ++++
 arch/arm/mach-exynos/exynos.c   |  4 ++-
 arch/arm/mach-exynos/firmware.c | 33 ++++++++++++++++-------
 arch/arm/mach-exynos/pm.c       | 60 ++++++++++++++++++++++++-----------------
 5 files changed, 69 insertions(+), 35 deletions(-)

-- 
1.8.2.3

