Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbaGORGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:06:10 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36492 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbaGORCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:22 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 87/94] clk: spear3xx: Use proper control register offset
Date: Tue, 15 Jul 2014 20:01:42 +0300
Message-Id: <1405443709-15288-87-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The control register is at offset 0x10, not 0x0. This is wreckaged
since commit 5df33a62c (SPEAr: Switch to common clock framework).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/spear/spear3xx_clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index c2d2043..125eba8 100644
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
1.7.10.4

