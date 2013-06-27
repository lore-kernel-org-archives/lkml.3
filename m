Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3F0G5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:57:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65265 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3F0G5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:57:19 -0400
From: Girish K S <girishks2000@gmail.com>
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: broonie@kernel.org
Subject: [PATCH] spi: s3c64xx: add missing check for polling mode
Date: Thu, 27 Jun 2013 12:26:53 +0530
Message-Id: <1372316213-30671-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the patch "spi/s3c64xx: Fix non-dmaengine usage"
with commit id 563b444e33810f3120838620c990480304e24e63
submitted by Mark Brown, the spi device detection in polling
mode breaks. This revealed the missing check for polling during
dma prepare. This patch adds the missing check.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index d170cc0..ea82baa 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -434,6 +434,9 @@ static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
 	dma_cap_mask_t mask;
 	int ret;
 
+	if (is_polling(sdd))
+		return 0;
+
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-- 
1.7.10.4

