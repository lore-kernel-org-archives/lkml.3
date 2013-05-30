Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057Ab3E3QAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:00:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58902 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934049Ab3E3P7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:59:49 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/3] spi: fix incorrect handling of min param in SPI_BPW_RANGE_MASK
Date: Thu, 30 May 2013 09:59:40 -0600
Message-Id: <1369929581-30258-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369929581-30258-1-git-send-email-swarren@wwwdotorg.org>
References: <1369929581-30258-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

SPI_BPW_RANGE_MASK is intended to work by calculating two masks; one
representing support for all bits up-to-and-including the "max" supported
value, and one representing support for all bits up-to-but-not-including
the "min" supported value, and then taking the difference between the
two, resulting in a mask representing support for all bits between
(inclusive) the min and max values.

However, the second mask ended up representing all bits up-to-and-
including rather up-to-but-not-including. Fix this bug.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/spi/spi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 3e94791..28e440b 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -310,7 +310,7 @@ struct spi_master {
 	u32			bits_per_word_mask;
 #define SPI_BPW_MASK(bits) BIT((bits) - 1)
 #define SPI_BIT_MASK(bits) (((bits) == 32) ? ~0UL : (BIT(bits) - 1))
-#define SPI_BPW_RANGE_MASK(min, max) (SPI_BIT_MASK(max) - SPI_BIT_MASK(min))
+#define SPI_BPW_RANGE_MASK(min, max) (SPI_BIT_MASK(max) - SPI_BIT_MASK(min - 1))
 
 	/* other constraints relevant to this driver */
 	u16			flags;
-- 
1.7.10.4

