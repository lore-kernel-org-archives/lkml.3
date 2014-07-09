Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaGIPHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:07:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48316 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755401AbaGIPHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 03/34] ARM: at91: prepare common clk transition for rm9200
Date: Wed,  9 Jul 2014 17:06:31 +0200
Message-Id: <1404918422-7562-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclose the rm9200 old clk registration in "#if defined(CONFIG_OLD_CLK_AT91)
 #endif"

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/mach-at91/at91rm9200.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index 787bb50a4dff..038702ee8bc6 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -26,10 +26,11 @@
 #include "at91_aic.h"
 #include "soc.h"
 #include "generic.h"
-#include "clock.h"
 #include "sam9_smc.h"
 #include "pm.h"
 
+#if defined(CONFIG_OLD_CLK_AT91)
+#include "clock.h"
 /* --------------------------------------------------------------------
  *  Clocks
  * -------------------------------------------------------------------- */
@@ -277,6 +278,9 @@ static void __init at91rm9200_register_clocks(void)
 	clk_register(&pck2);
 	clk_register(&pck3);
 }
+#else
+#define at91rm9200_register_clocks NULL
+#endif
 
 /* --------------------------------------------------------------------
  *  GPIO
-- 
1.9.1

