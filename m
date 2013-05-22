Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3EVCgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:36:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59825 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3EVCgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:36:44 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 1/2] spi: introduce macros to set bits_per_word_mask
Date: Tue, 21 May 2013 20:36:34 -0600
Message-Id: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce two macros to make setting up spi_master.bits_per_word_mask
easier, and avoid mistakes like writing BIT(n) instead of BIT(n - 1).

SPI_BPW_MASK is for a single supported value of bits_per_word_mask.

SPI_BPW_RANGE_MASK represents a contiguous set of bit lengths.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 include/linux/spi/spi.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 6ff26c8..1737256 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -308,6 +308,8 @@ struct spi_master {
 
 	/* bitmask of supported bits_per_word for transfers */
 	u32			bits_per_word_mask;
+#define SPI_BPW_MASK(bits) BIT((bits) - 1)
+#define SPI_BPW_RANGE_MASK(min, max) ((BIT(max) - 1) - (BIT(min) - 1))
 
 	/* other constraints relevant to this driver */
 	u16			flags;
-- 
1.7.10.4

