Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab3DXIkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:40:01 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47013 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab3DXIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:39:50 -0400
Date: Wed, 24 Apr 2013 09:39:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 21/32 v2] dmaengine: ste_dma40: Also report the number of
 logical channels
Message-ID: <20130424083944.GG17416@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-22-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-22-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine: ste_dma40: Also report the number of logical channels

Now we know the total of physical and logical channels, we may as
well report them within the information log.

Before:
dma40 dma40.0: hardware revision: 3 @ 0x801c0000 with 8 physical channels

After:
<as above ...> and 256 logical channels

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4c6df0e..d5a15ec 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3200,8 +3200,9 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
 
-	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
-		 rev, res->start, num_phy_chans);
+	dev_info(&pdev->dev,
+		 "hardware rev: %d @ 0x%x with %d physical chans and %d logical chans\n",
+		 rev, res->start, num_phy_chans, num_log_chans);
 
 	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
 		       (num_phy_chans + num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) *
