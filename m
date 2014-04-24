Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbaDXWzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:55:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35615 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbaDXVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:49 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 02/26] ARM: OMAP: dmtimer: Add comments on OMAP1 clock framework
Date: Thu, 24 Apr 2014 16:43:45 -0500
Message-ID: <1398375849-6017-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP1 doesn't support clock framework, add a comment where needed
and correct a FIXME.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/plat-omap/dmtimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index ecd3f97..f5a674c 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -142,8 +142,7 @@ static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
 	int rc;
 
 	/*
-	 * FIXME: OMAP1 devices do not use the clock framework for dmtimers so
-	 * do not call clk_get() for these devices.
+	 * Do not call clk_get() for OMAP1 due to no clock framework support.
 	 */
 	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET)) {
 		timer->fclk = clk_get(&timer->pdev->dev, "fck");
@@ -461,6 +460,7 @@ int omap_dm_timer_stop(struct omap_dm_timer *timer)
 	if (unlikely(!timer))
 		return -EINVAL;
 
+	/* OMAP1 is not converted to clk framework so avoid clk_get_rate here */
 	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET))
 		rate = clk_get_rate(timer->fclk);
 
-- 
1.7.9.5

