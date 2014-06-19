Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966084AbaFSVw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:52:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:55825 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965938AbaFSVw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:52:26 -0400
Message-Id: <20140619215140.259138132@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:52:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, spear-devel@list.st.com,
        stable@vger.kernel.org
Subject: [patch 1/2] clk: spear3xx: Use proper control register offset
References: <20140619214858.755664030@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-clk-fix-crap.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The control register is at offset 0x10, not 0x0. This is wreckaged
since commit 5df33a62c (SPEAr: Switch to common clock framework).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/clk/spear/spear3xx_clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/clk/spear/spear3xx_clock.c
===================================================================
--- linux.orig/drivers/clk/spear/spear3xx_clock.c
+++ linux/drivers/clk/spear/spear3xx_clock.c
@@ -211,7 +211,7 @@ static inline void spear310_clk_init(voi
 /* array of all spear 320 clock lookups */
 #ifdef CONFIG_MACH_SPEAR320
 
-#define SPEAR320_CONTROL_REG		(soc_config_base + 0x0000)
+#define SPEAR320_CONTROL_REG		(soc_config_base + 0x0010)
 #define SPEAR320_EXT_CTRL_REG		(soc_config_base + 0x0018)
 
 	#define SPEAR320_UARTX_PCLK_MASK		0x1


