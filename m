Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3HRCnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:43:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52861 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab3HRCnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:39 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 07/14] crypto: omap-aes: Add IRQ info and helper macros
Date: Sat, 17 Aug 2013 21:42:28 -0500
Message-ID: <1376793755-30478-8-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQ information to pdata and helper macros. These are required
for PIO-mode support.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index bbdd1c3..9a964e8 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -75,6 +75,10 @@
 
 #define AES_REG_LENGTH_N(x)		(0x54 + ((x) * 0x04))
 
+#define AES_REG_IRQ_STATUS(dd)         ((dd)->pdata->irq_status_ofs)
+#define AES_REG_IRQ_ENABLE(dd)         ((dd)->pdata->irq_enable_ofs)
+#define AES_REG_IRQ_DATA_IN            BIT(1)
+#define AES_REG_IRQ_DATA_OUT           BIT(2)
 #define DEFAULT_TIMEOUT		(5*HZ)
 
 #define FLAGS_MODE_MASK		0x000f
@@ -120,6 +124,8 @@ struct omap_aes_pdata {
 	u32		data_ofs;
 	u32		rev_ofs;
 	u32		mask_ofs;
+	u32             irq_enable_ofs;
+	u32             irq_status_ofs;
 
 	u32		dma_enable_in;
 	u32		dma_enable_out;
@@ -836,6 +842,8 @@ static const struct omap_aes_pdata omap_aes_pdata_omap4 = {
 	.data_ofs	= 0x60,
 	.rev_ofs	= 0x80,
 	.mask_ofs	= 0x84,
+	.irq_status_ofs = 0x8c,
+	.irq_enable_ofs = 0x90,
 	.dma_enable_in	= BIT(5),
 	.dma_enable_out	= BIT(6),
 	.major_mask	= 0x0700,
-- 
1.7.9.5

