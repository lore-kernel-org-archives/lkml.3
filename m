Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3HAWJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:09:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46949 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab3HAWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:09:03 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] spi: fix SPI_BIT_MASK so it always fits into 32-bits
Date: Thu,  1 Aug 2013 16:08:57 -0600
Message-Id: <1375394937-8785-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

On a 64-bit platform, ~0UL fills 64-bits, which causes SPI_BIT_MASK(32)
not to fit into 32 bits. This causes a warning when the result is assigned
to a 32-bit variable. Use ~0U instead to prevent this. This fixes:

drivers/spi/spi-gpio.c: In function 'spi_gpio_probe':
drivers/spi/spi-gpio.c:446:2: warning: large integer implicitly truncated to unsigned type [-Woverflow]

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/spi/spi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index c28ac12..8515190 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -314,7 +314,7 @@ struct spi_master {
 	/* bitmask of supported bits_per_word for transfers */
 	u32			bits_per_word_mask;
 #define SPI_BPW_MASK(bits) BIT((bits) - 1)
-#define SPI_BIT_MASK(bits) (((bits) == 32) ? ~0UL : (BIT(bits) - 1))
+#define SPI_BIT_MASK(bits) (((bits) == 32) ? ~0U : (BIT(bits) - 1))
 #define SPI_BPW_RANGE_MASK(min, max) (SPI_BIT_MASK(max) - SPI_BIT_MASK(min - 1))
 
 	/* limits on transfer speed */
-- 
1.8.1.5

