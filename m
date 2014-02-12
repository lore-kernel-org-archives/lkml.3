Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaBLJp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:45:56 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:65501 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbaBLJpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:45:54 -0500
Message-ID: <1392198352.23759.10.camel@x220>
Subject: [PATCH] ARM: OMAP2+: Remove legacy macros for zoom platforms
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 10:45:52 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2014 09:45:52.0962 (UTC) FILETIME=[38189220:01CF27D7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 97411608fd5f ("ARM: OMAP2+: Remove legacy support for zoom
platforms") removed the Kconfig symbols MACH_OMAP_ZOOM2 and
MACH_OMAP_ZOOM3. Remove the last usage of the related macros too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, but should have zero impact.

 arch/arm/mach-omap2/io.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index d408b15..af432b1 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -179,15 +179,6 @@ static struct map_desc omap34xx_io_desc[] __initdata = {
 		.length		= L4_EMU_34XX_SIZE,
 		.type		= MT_DEVICE
 	},
-#if defined(CONFIG_DEBUG_LL) &&							\
-	(defined(CONFIG_MACH_OMAP_ZOOM2) || defined(CONFIG_MACH_OMAP_ZOOM3))
-	{
-		.virtual	= ZOOM_UART_VIRT,
-		.pfn		= __phys_to_pfn(ZOOM_UART_BASE),
-		.length		= SZ_1M,
-		.type		= MT_DEVICE
-	},
-#endif
 };
 #endif
 
-- 
1.8.5.3

