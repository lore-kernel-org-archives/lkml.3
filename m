Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaC0FZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:25:16 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:17751 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbaC0FZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:25:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 1/2] regmap: mmio: add regmap_mmio_{regsize, count}_check.
Date: Thu, 27 Mar 2014 12:42:42 +0800
Message-ID: <1395895363-31521-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap-mmio.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index 81f9775..4f1efce 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -30,6 +30,16 @@ struct regmap_mmio_context {
 	struct clk *clk;
 };
 
+static inline void regmap_mmio_regsize_check(size_t reg_size)
+{
+	BUG_ON(reg_size != 4);
+}
+
+static inline void regmap_mmio_count_check(size_t count)
+{
+	BUG_ON(count < 4);
+}
+
 static int regmap_mmio_gather_write(void *context,
 				    const void *reg, size_t reg_size,
 				    const void *val, size_t val_size)
@@ -38,7 +48,7 @@ static int regmap_mmio_gather_write(void *context,
 	u32 offset;
 	int ret;
 
-	BUG_ON(reg_size != 4);
+	regmap_mmio_regsize_check(reg_size);
 
 	if (!IS_ERR(ctx->clk)) {
 		ret = clk_enable(ctx->clk);
@@ -81,7 +91,7 @@ static int regmap_mmio_gather_write(void *context,
 
 static int regmap_mmio_write(void *context, const void *data, size_t count)
 {
-	BUG_ON(count < 4);
+	regmap_mmio_count_check(count);
 
 	return regmap_mmio_gather_write(context, data, 4, data + 4, count - 4);
 }
@@ -94,7 +104,7 @@ static int regmap_mmio_read(void *context,
 	u32 offset;
 	int ret;
 
-	BUG_ON(reg_size != 4);
+	regmap_mmio_regsize_check(reg_size);
 
 	if (!IS_ERR(ctx->clk)) {
 		ret = clk_enable(ctx->clk);
-- 
1.8.4


