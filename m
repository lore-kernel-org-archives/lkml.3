Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967843Ab3DRKND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:13:03 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:60942 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967796Ab3DRKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:12:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 14/32] dmaengine: ste_dma40: Remove 'always true' checking
Date: Thu, 18 Apr 2013 11:11:56 +0100
Message-Id: <1366279934-30761-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before allocating memory for logical channels, the current driver
checks to see if there are any. Well as the dma40_memcpy_channels[]
array is always populated, the check is always true. Best to
remove the check.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index a39ef74..ec0d6ab 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3273,17 +3273,11 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	if (!base->lookup_phy_chans)
 		goto failure;
 
-	if (num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) {
-		/*
-		 * The max number of logical channels are event lines for all
-		 * src devices and dst devices
-		 */
-		base->lookup_log_chans = kzalloc(num_log_chans *
-						 sizeof(struct d40_chan *),
-						 GFP_KERNEL);
-		if (!base->lookup_log_chans)
-			goto failure;
-	}
+	base->lookup_log_chans = kzalloc(num_log_chans *
+					 sizeof(struct d40_chan *),
+					 GFP_KERNEL);
+	if (!base->lookup_log_chans)
+		goto failure;
 
 	base->reg_val_backup_chan = kmalloc(base->num_phy_chans *
 					    sizeof(d40_backup_regs_chan),
-- 
1.7.10.4

