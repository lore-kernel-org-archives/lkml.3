Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaBIOj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:39:28 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53368 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbaBIOj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:39:27 -0500
Message-ID: <1391956765.25424.9.camel@x220>
Subject: [PATCH] dmaengine: Remove dependency on MACH_BCM2708
From: Paul Bolle <pebolle@tiscali.nl>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 15:39:25 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 14:39:26.0011 (UTC) FILETIME=[BB0D50B0:01CF25A4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 96286b576690 ("dmaengine: Add support for BCM2835") added an
optional dependency on MACH_BCM2708. But there's no Kconfig symbol
MACH_BCM2708.

(There was an entry for MACH_BCM2708 in arch/arm/tools/mach-types from
v2.6.37 until v3.2. But it seems that entry was never used in the tree.)

This optional dependency can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9bed1a2..e4382ec 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -308,7 +308,7 @@ config DMA_OMAP
 
 config DMA_BCM2835
 	tristate "BCM2835 DMA engine support"
-	depends on (ARCH_BCM2835 || MACH_BCM2708)
+	depends on ARCH_BCM2835
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
-- 
1.8.5.

