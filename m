Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3DZMYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:24:12 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41858 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3DZMXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:23:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/6] ARM: ux500: Remove recently unused stedma40_xfer_dir enums
Date: Fri, 26 Apr 2013 12:38:12 +0100
Message-Id: <1366976295-11728-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366976295-11728-1-git-send-email-lee.jones@linaro.org>
References: <1366976295-11728-1-git-send-email-lee.jones@linaro.org>
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

