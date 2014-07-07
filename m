Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaGGOcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:32:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57303 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753823AbaGGOa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:30:27 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 15/18] AT91: Remove poweroff code
Date: Mon,  7 Jul 2014 16:25:28 +0200
Message-Id: <1404743131-24569-16-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404743131-24569-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404743131-24569-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all the SoC have been converted to use the new poweroff driver, we can
remove the poweroff code defined in mach-at91.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/setup.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index ae269291d19d..cdd717a4fa30 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -321,17 +321,11 @@ void __init at91_map_io(void)
 
 void __iomem *at91_shdwc_base = NULL;
 
-static void at91sam9_poweroff(void)
-{
-	at91_shdwc_write(AT91_SHDW_CR, AT91_SHDW_KEY | AT91_SHDW_SHDW);
-}
-
 void __init at91_ioremap_shdwc(u32 base_addr)
 {
 	at91_shdwc_base = ioremap(base_addr, 16);
 	if (!at91_shdwc_base)
 		panic(pr_fmt("Impossible to ioremap at91_shdwc_base\n"));
-	pm_power_off = at91sam9_poweroff;
 }
 
 void __iomem *at91_rstc_base;
-- 
2.0.1

