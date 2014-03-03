Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaCCKLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:11:14 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:51235 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaCCKK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:10:27 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com
Cc: plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v5 8/9] ARM: at91: prepare common clk transition for sam9261 SoC
Date: Mon,  3 Mar 2014 11:06:01 +0100
Message-Id: <1393841162-25339-9-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch encloses sam9261 old clk registration in
"#if defined(CONFIG_OLD_CLK_AT91) #endif" sections.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/mach-at91/at91sam9261.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 5c90581..3345a2b 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -25,10 +25,12 @@
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
-#include "clock.h"
 #include "sam9_smc.h"
 #include "pm.h"
 
+#if defined(CONFIG_OLD_CLK_AT91)
+#include "clock.h"
+
 /* --------------------------------------------------------------------
  *  Clocks
  * -------------------------------------------------------------------- */
@@ -264,7 +266,9 @@ static void __init at91sam9261_register_clocks(void)
 	clk_register(&hck0);
 	clk_register(&hck1);
 }
-
+#else
+#define at91sam9261_register_clocks NULL
+#endif
 /* --------------------------------------------------------------------
  *  GPIO
  * -------------------------------------------------------------------- */
-- 
1.9.0

