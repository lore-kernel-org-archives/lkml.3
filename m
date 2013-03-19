Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab3CSKID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:08:03 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:63581 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab3CSKIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:08:00 -0400
Message-ID: <1363687677.1390.6.camel@x61.thuisdomein>
Subject: [PATCH] ARM: OMAP: remove "config FB_OMAP_CONSISTENT_DMA_SIZE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 11:07:57 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 10:07:57.0521 (UTC) FILETIME=[A146BC10:01CE2489]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of Kconfig symbol FB_OMAP_CONSISTENT_DMA_SIZE got removed
in v3.8, with commit 6ba54ab4a49bbad736b0254aa6bdf0cb83013815 ("ARM:
OMAP: Remove omap_init_consistent_dma_size()"). Remove this symbol too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested only.

 drivers/video/omap/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/video/omap/Kconfig b/drivers/video/omap/Kconfig
index e512581..0bc3a93 100644
--- a/drivers/video/omap/Kconfig
+++ b/drivers/video/omap/Kconfig
@@ -39,17 +39,6 @@ config FB_OMAP_LCD_MIPID
 	  the Mobile Industry Processor Interface DBI-C/DCS
 	  specification. (Supported LCDs: Philips LPH8923, Sharp LS041Y3)
 
-config FB_OMAP_CONSISTENT_DMA_SIZE
-	int "Consistent DMA memory size (MB)"
-	depends on FB_OMAP
-	range 1 14
-	default 2
-	help
-	  Increase the DMA consistent memory size according to your video
-	  memory needs, for example if you want to use multiple planes.
-	  The size must be 2MB aligned.
-	  If unsure say 1.
-
 config FB_OMAP_DMA_TUNE
         bool "Set DMA SDRAM access priority high"
         depends on FB_OMAP
-- 
1.7.11.7

