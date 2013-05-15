Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab3EOJxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:53:22 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:36280 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721Ab3EOJxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/39] ARM: ux500: Remove recently unused stedma40_xfer_dir enums
Date: Wed, 15 May 2013 10:51:55 +0100
Message-Id: <1368611522-9984-33-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're now using the transfer direction definitions provided by the DMA
sub-system, so the home-brew ones have become obsolete.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/platform_data/dma-ste-dma40.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index 288dc24..54ddca6 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -77,14 +77,6 @@ enum stedma40_periph_data_width {
 	STEDMA40_DOUBLEWORD_WIDTH = STEDMA40_ESIZE_64_BIT
 };
 
-enum stedma40_xfer_dir {
-	STEDMA40_MEM_TO_MEM = 1,
-	STEDMA40_MEM_TO_PERIPH,
-	STEDMA40_PERIPH_TO_MEM,
-	STEDMA40_PERIPH_TO_PERIPH
-};
-
-
 /**
  * struct stedma40_half_channel_info - dst/src channel configuration
  *
@@ -120,7 +112,7 @@ struct stedma40_half_channel_info {
  *
  */
 struct stedma40_chan_cfg {
-	enum stedma40_xfer_dir			 dir;
+	enum dma_transfer_direction		 dir;
 	bool					 high_priority;
 	bool					 realtime;
 	enum stedma40_mode			 mode;
-- 
1.7.10.4

