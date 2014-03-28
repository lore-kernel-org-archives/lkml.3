Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaC1NGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:06:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17811 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaC1NGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:06:12 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-30-533573c01242
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] clocksource: exynos_mct: Change exynos4_mct_tick_clear
 return type to void
Date: Fri, 28 Mar 2014 14:06:01 +0100
Message-id: <1396011962-4467-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com>
References: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e/4Fd0DxabBBh1ftSw2zljPajHvs6zF
	6xeGFr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/JYu2Ru+wW62e8ZrHYvGkqswO3x51re9g8
	3p07x+6xeUm9R9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGUcm/mQseAMR8X8nVvYGhgXsncx
	cnJICJhIdE/fxgphi0lcuLeerYuRi0NIYCmjxKT23cwQTh+TxJELBxhBqtgEjCU2L18CViUi
	8JRR4nfDI7AEs8BzRomn38NBbGGBRIk735YwgdgsAqoSf3f+B1rHwcEr4CbR2ykGYkoIKEjM
	mWQDUsEp4C5xYu5zsIOEgCq2XfvJNoGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2M
	kLD7uoNx6TGrQ4wCHIxKPLwzrEyChVgTy4orcw8xSnAwK4nwLrE1DRbiTUmsrEotyo8vKs1J
	LT7EyMTBKdXAeHXdrNSpSsG2h5c3LD1w5sQRma4H5asvuKf+n3SxkceL/dkO/fdp3AI66Xdf
	O7/df/FZlky7TtPs/PPL7xw7lVNzfpLH6XLbQ5flVj7KO95c71qvfHvP9cV9uw9plZa7f4lu
	eb+aedeMC1Vdt71z+5Kv1orOVLmx/O6cBlmr376uFiKLThlr5SmxFGckGmoxFxUnAgCANNy0
	GQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value of exynos4_mct_tick_clear() was never checked so it can
be safely changed to void.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clocksource/exynos_mct.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 0b49b09dd1a9..2ac7d228743a 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -376,15 +376,11 @@ static inline void exynos4_tick_set_mode(enum clock_event_mode mode,
 	}
 }
 
-static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
+static void exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
 {
 	/* Clear the MCT tick interrupt */
-	if (__raw_readl(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1) {
+	if (__raw_readl(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1)
 		exynos4_mct_write(0x1, mevt->base + MCT_L_INT_CSTAT_OFFSET);
-		return 1;
-	}
-
-	return 0;
 }
 
 static irqreturn_t exynos4_mct_tick_isr(int irq, void *dev_id)
-- 
1.7.9.5

