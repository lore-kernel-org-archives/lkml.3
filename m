Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaEOTlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:41:47 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:62808 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbaEOTlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:41:45 -0400
Message-ID: <1400182902.11786.21.camel@x220>
Subject: [PATCH] ARM: OMAP: SX1: remove check for CONFIG_SX1_OLD_FLASH
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 21:41:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 19:41:43.0152 (UTC) FILETIME=[B2DFA700:01CF7075]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_SX1_OLD_FLASH was added in v2.6.24. But the related
Kconfig symbol was never part of the tree. So we can remove some dead
code.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Also untested.

 arch/arm/mach-omap1/board-sx1.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/arch/arm/mach-omap1/board-sx1.c b/arch/arm/mach-omap1/board-sx1.c
index 0a8d3349149c..29e526235dc2 100644
--- a/arch/arm/mach-omap1/board-sx1.c
+++ b/arch/arm/mach-omap1/board-sx1.c
@@ -266,31 +266,6 @@ static struct physmap_flash_data sx1_flash_data = {
 	.nr_parts	= ARRAY_SIZE(sx1_partitions),
 };
 
-#ifdef CONFIG_SX1_OLD_FLASH
-/* MTD Intel StrataFlash - old flashes */
-static struct resource sx1_old_flash_resource[] = {
-	[0] = {
-		.start	= OMAP_CS0_PHYS,	/* Physical */
-		.end	= OMAP_CS0_PHYS + SZ_16M - 1,,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= OMAP_CS1_PHYS,
-		.end	= OMAP_CS1_PHYS + SZ_8M - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device sx1_flash_device = {
-	.name		= "physmap-flash",
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &sx1_flash_data,
-	},
-	.num_resources	= 2,
-	.resource	= &sx1_old_flash_resource,
-};
-#else
 /* MTD Intel 4000 flash - new flashes */
 static struct resource sx1_new_flash_resource = {
 	.start		= OMAP_CS0_PHYS,
@@ -307,7 +282,6 @@ static struct platform_device sx1_flash_device = {
 	.num_resources	= 1,
 	.resource	= &sx1_new_flash_resource,
 };
-#endif
 
 /*----------- USB -------------------------*/
 
-- 
1.9.0

