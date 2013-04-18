Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968034Ab3DRKRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:17:37 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40360 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967865Ab3DRKNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 21/32] dmaengine: ste_dma40: Also report the number of logical channels
Date: Thu, 18 Apr 2013 11:12:03 +0100
Message-Id: <1366279934-30761-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/dma/ste_dma40.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 282dd59..805049c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3200,8 +3200,9 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
 
-	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
-		 rev, res->start, num_phy_chans);
+	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with "
+		"%d physical channels and %d logical channels\n",
+		rev, res->start, num_phy_chans, num_log_chans);
 
 	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
 		       (num_phy_chans + num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) *
-- 
1.7.10.4

