Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbaDXWxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:53:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53142 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbaDXVou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:50 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 03/26] ARM: OMAP: dmtimer: Add note to set parent from DT
Date: Thu, 24 Apr 2014 16:43:46 -0500
Message-ID: <1398375849-6017-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once clock-parents or default-parent support for DT clocks is available,
we should use it to set clock parent and turn clk_set_parent into a NOOP.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/plat-omap/dmtimer.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index f5a674c..4debb3d 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -165,6 +165,10 @@ static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
 	__omap_dm_timer_enable_posted(timer);
 	omap_dm_timer_disable(timer);
 
+	/*
+	 * FIXME: Once DT clock-parents or set-parents support is upstream,
+	 * this is to become a NOOP.
+	 */
 	return omap_dm_timer_set_source(timer, OMAP_TIMER_SRC_32_KHZ);
 }
 
-- 
1.7.9.5

