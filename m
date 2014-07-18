Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030374AbaGRNJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:09:50 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17459 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030335AbaGRNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:09:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 151/170] clk: spear3xx: Use proper control register offset
Date: Fri, 18 Jul 2014 14:12:36 +0200
Message-Id: <3d84500701239b649de3a1887dcac6356e1516ad.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 15ebb05248d025534773c9ef64915bd888f04e4b upstream.

The control register is at offset 0x10, not 0x0. This is wreckaged
since commit 5df33a62c (SPEAr: Switch to common clock framework).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/clk/spear/spear3xx_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index c2d204315546..125eba86c844 100644
--- a/drivers/clk/spear/spear3xx_clock.c
+++ b/drivers/clk/spear/spear3xx_clock.c
@@ -211,7 +211,7 @@ static inline void spear310_clk_init(void) { }
 /* array of all spear 320 clock lookups */
 #ifdef CONFIG_MACH_SPEAR320
 
-#define SPEAR320_CONTROL_REG		(soc_config_base + 0x0000)
+#define SPEAR320_CONTROL_REG		(soc_config_base + 0x0010)
 #define SPEAR320_EXT_CTRL_REG		(soc_config_base + 0x0018)
 
 	#define SPEAR320_UARTX_PCLK_MASK		0x1
-- 
2.0.0

