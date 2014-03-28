Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbaC1F4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 01:56:24 -0400
Received: from [65.55.88.11] ([65.55.88.11]:56775 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbaC1F4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 01:56:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzbb2dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: mmio: Add regmap_mmio_regbits_check.
Date: Fri, 28 Mar 2014 13:12:56 +0800
Message-ID: <1395983576-4258-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the support for 1/2/8 bytes wide register address checking.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---


Sorry, this patch has been missed yesterday.



 drivers/base/regmap/regmap-mmio.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index ed080a4..de45a1e 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -47,6 +47,21 @@ static inline void regmap_mmio_regsize_check(size_t reg_size)
 	}
 }
 
+static int regmap_mmio_regbits_check(size_t reg_bits)
+{
+	switch (reg_bits) {
+	case 8:
+	case 16:
+	case 32:
+#ifdef CONFIG_64BIT
+	case 64:
+#endif
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static inline void regmap_mmio_count_check(size_t count)
 {
 	BUG_ON(count % 2 != 0);
@@ -191,8 +206,9 @@ static struct regmap_mmio_context *regmap_mmio_gen_context(struct device *dev,
 	int min_stride;
 	int ret;
 
-	if (config->reg_bits != 32)
-		return ERR_PTR(-EINVAL);
+	ret = regmap_mmio_regbits_check(config->reg_bits);
+	if (ret)
+		return ERR_PTR(ret);
 
 	if (config->pad_bits)
 		return ERR_PTR(-EINVAL);
-- 
1.8.4


