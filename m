Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbaFTRyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:54:38 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:57207 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbaFTRyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:54:37 -0400
From: Doug Anderson <dianders@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, olof@lixom.net,
        linux-samsung-soc@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        javier.martinez@collabora.co.uk, Doug Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/3] Exynos MCT udelay, MCT cleanup, MCT to 32-bits
Date: Fri, 20 Jun 2014 10:47:49 -0700
Message-Id: <1403286472-6817-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of 3 patches related to the exynos MCT (multi core
timer).  The first allows MCT to function as a udelay() timer which
fixes broken udelay on 5400, 5800, and even (to a lesser extent) on
5250.  The second is some general cleanup.  The third moves MCT to
32-bits where possible to give us a nice speedup.

The first probably ought to be destined for 3.16 as a bugfix whereas
the others could land in a future kernel release.

This series is based on (clocksource: exynos_mct: Fix ftrace).

With this series we can drop the patches I submitted:
- clocksource: exynos_mct: cache mct upper count
- clocksource: exynos_mct: Optimize register reads with ldmia

Changes in v3:
- Back to exynos_frc_read for now until 32/64 is resolved.
- Now returns cycles_t which matches arch/arm/include/asm/timex.h.
- Rebased.
- Moved registration to its own function.
- __raw_readl / __raw_writel patch new for version 3
- Now 32-bit version instead of ldmia version

Changes in v2:
- Added #defines for ARM and ARM64 as pointed by Doug Anderson.

Amit Daniel Kachhap (1):
  clocksource: exynos_mct: Register the timer for stable udelay

Doug Anderson (2):
  clocksource: exynos_mct: __raw_readl/__raw_writel =>
    readl_relaxed/writel_relaxed
  clocksource: exynos_mct: Only use 32-bits where possible

 drivers/clocksource/Kconfig      |  1 +
 drivers/clocksource/exynos_mct.c | 72 ++++++++++++++++++++++++++++++----------
 2 files changed, 55 insertions(+), 18 deletions(-)

-- 
2.0.0.526.g5318336

