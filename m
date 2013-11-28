Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab3K1PAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:00:22 -0500
Received: from 18.mo6.mail-out.ovh.net ([46.105.73.110]:56466 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758963Ab3K1PAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:00:17 -0500
X-Greylist: delayed 8031 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Nov 2013 10:00:17 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/6] ARM: at91: prepare common clk transition for sama5d3 SoC
Date: Thu, 28 Nov 2013 15:50:20 +0100
Message-Id: <1385650220-8870-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com>
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6357393825827944627
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch encloses sama5d3 old clk registration in
"#if defined(CONFIG_OLD_CLK_AT91) #endif" sections.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/sama5d3.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index 0003949..3426098 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -19,9 +19,10 @@
 
 #include "soc.h"
 #include "generic.h"
-#include "clock.h"
 #include "sam9_smc.h"
 
+#if defined(CONFIG_OLD_CLK_AT91)
+#include "clock.h"
 /* --------------------------------------------------------------------
  *  Clocks
  * -------------------------------------------------------------------- */
@@ -361,6 +362,7 @@ static void __init sama5d3_register_clocks(void)
 	clk_register(&pck1);
 	clk_register(&pck2);
 }
+#endif
 
 /* --------------------------------------------------------------------
  *  AT91SAM9x5 processor initialization
@@ -373,5 +375,7 @@ static void __init sama5d3_map_io(void)
 
 AT91_SOC_START(sama5d3)
 	.map_io = sama5d3_map_io,
+#if defined(CONFIG_OLD_CLK_AT91)
 	.register_clocks = sama5d3_register_clocks,
+#endif
 AT91_SOC_END
-- 
1.7.9.5

