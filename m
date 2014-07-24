Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934994AbaGXJvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:51:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55218 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934859AbaGXJtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/128] clk: spear3xx: Use proper control register offset
Date: Thu, 24 Jul 2014 10:46:12 +0100
Message-Id: <1406195177-8656-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 15ebb05248d025534773c9ef64915bd888f04e4b upstream.

The control register is at offset 0x10, not 0x0. This is wreckaged
since commit 5df33a62c (SPEAr: Switch to common clock framework).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clk/spear/spear3xx_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index 080c3c5e33f6..1fe259021747 100644
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
1.9.1

