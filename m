Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaAIE7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:59:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54651 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaAIE7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:59:12 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-e2-52ce2c9f97aa
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/6 v2] crypto:s5p-sss: Add support for SSS module on Exynos
Date: Thu, 09 Jan 2014 10:29:29 +0530
Message-id: <1389243569-13161-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-4-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-4-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkRne+zrkgg22L1CxeHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW6za9YfR4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CVsfrKPqaCOYYVG2+sYG5gbFbvYuTkkBAwkTj19Coj
	hC0mceHeerYuRi4OIYGljBIdp++ywhTdaD7AApFYxCixeNtkKKefSeLv/2lg7WwCZhIHF61m
	B7FFBJwlfjevYQUpYhY4yijxec5FJpCEsICPxJR9t8DGsgioSjQs+gQW5xVwlbj14ATQVA6g
	dQoScybZgIQ5Bdwket98BSsRAipp/3oE7DwJgXXsEmvufGeCmCMg8W3yIaheWYlNB5ghrpaU
	OLjiBssERuEFjAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQLD/vS/ZxN3MN4/YH2IMRlo
	3ERmKdHkfGDc5JXEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDI1fJokviRvkbiryLXvEuNarNnrcsrjXkPhPbsffMe7xu8flvK089e2Fb7OXuqT9/
	3PtnGjOb6eBUZ+ZbyXxrco1PBKezLsvv4K3uaWd3OLu2r/bdy/w1P583/5t8N0BWRD6FY1Xc
	2TOix7WMnByMf5bveHrq/JoHpkfWHWm4Ip5R6xpfGhF3WYmlOCPRUIu5qDgRAN2C9DaRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd35OueCDKY9l7N4eUjTYs75FhaL
	7lcyFvfv/WSyuLxrDpvFjPP7mCwWbfvPbLFq1x9Gi7NzDjE5cHpsWXmTyWPnrLvsHtsOqHr0
	bVnF6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0DlKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozVV/YxFcwx
	rNh4YwVzA2OzehcjJ4eEgInEjeYDLBC2mMSFe+vZuhi5OIQEFjFKLN42mQXC6WeS+Pt/GiNI
	FZuAmcTBRavZQWwRAWeJ381rWEGKmAWOMkp8nnORCSQhLOAjMWXfLVYQm0VAVaJh0SewOK+A
	q8StByeApnIArVOQmDPJBiTMKeAm0fvmK1iJEFBJ+9cjbBMYeRcwMqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECI6qZ9I7GFc1WBxiFOBgVOLhXVF8NkiINbGsuDL3EKMEB7OSCO9f1XNB
	QrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPjPi8knhDYxNzU2NTSxMLEzNL0oSVxHkPtloH
	CgmkJ5akZqemFqQWwWxh4uCUamAMq7z+2O54twe7oE+JTv1ciRghmdq5B0Q/dNf2LTljsTKl
	43zC/xPtOrdl9zy3upC+9onk0m+v+s9s+VxxxytV46TAHU+jy/yOi8uaa6wWe0mFzE5aarRg
	oXL7xPLzzZv/7DViMzl6LO59osne63LVdUsz7nku3PX38Hq9C8KvZzRc0hXYJW6qxFKckWio
	xVxUnAgA99FjJu4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new compatible and varient to support the SSS module
on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250) for which
1. AES register are at an offset of 0x200 and
2. hash interrupt is not available

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v1:
1. Used varient struct
2. Added description in Documentation

 .../devicetree/bindings/crypto/samsung-sss.txt     |   20 +++++++++
 drivers/crypto/s5p-sss.c                           |   43 ++++++++++++++------
 2 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
index 0e45b0d..4531da2 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -8,13 +8,33 @@ The SSS module in S5PV210 SoC supports the following:
 -- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
 -- PRNG: Pseudo Random Number Generator
 
+The SSS module in Exynos4 (Exynos4210) and
+Exynos5 (Exynos5420 and Exynos5250) SoCs
+supports the following also:
+-- ARCFOUR (ARC4)
+-- True Random Number Generator (TRNG)
+-- Secure Key Manager
+
 Required properties:
 
 - compatible : Should contain entries for this and backward compatible
   SSS versions:
   - "samsung,s5p-secss" for S5PV210 SoC.
+  - "samsung,exynos-secss" for Exynos4210, Exynos5250 and Exynos5420 SoCs.
 - reg : Offset and length of the register set for the module
 - interrupts : the interrupt-specifier for the SSS module.
 		Two interrupts "feed control and hash" in case of S5PV210
+		One interrupts "feed control" in case of Exynos4210,
+			Exynos5250 and Exynos5420 SoCs.
 - clocks : the required gating clock for the SSS module.
 - clock-names : the gating clock name to be requested in the SSS driver.
+
+Example:
+	/* SSS_VER_5 */
+	sss@10830000 {
+		compatible = "samsung,exynos-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+	};
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 78e0c37..7c31a5f 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -106,7 +106,7 @@
 #define SSS_REG_FCPKDMAO                0x005C
 
 /* AES registers */
-#define SSS_REG_AES_CONTROL             0x4000
+#define SSS_REG_AES_CONTROL		0x00
 #define SSS_AES_BYTESWAP_DI             _BIT(11)
 #define SSS_AES_BYTESWAP_DO             _BIT(10)
 #define SSS_AES_BYTESWAP_IV             _BIT(9)
@@ -122,21 +122,26 @@
 #define SSS_AES_CHAIN_MODE_CTR          _SBF(1, 0x02)
 #define SSS_AES_MODE_DECRYPT            _BIT(0)
 
-#define SSS_REG_AES_STATUS              0x4004
+#define SSS_REG_AES_STATUS		0x04
 #define SSS_AES_BUSY                    _BIT(2)
 #define SSS_AES_INPUT_READY             _BIT(1)
 #define SSS_AES_OUTPUT_READY            _BIT(0)
 
-#define SSS_REG_AES_IN_DATA(s)          (0x4010 + (s << 2))
-#define SSS_REG_AES_OUT_DATA(s)         (0x4020 + (s << 2))
-#define SSS_REG_AES_IV_DATA(s)          (0x4030 + (s << 2))
-#define SSS_REG_AES_CNT_DATA(s)         (0x4040 + (s << 2))
-#define SSS_REG_AES_KEY_DATA(s)         (0x4080 + (s << 2))
+#define SSS_REG_AES_IN_DATA(off, s)	((off + 0x10) + (s << 2))
+#define SSS_REG_AES_OUT_DATA(off, s)	((off + 0x20) + (s << 2))
+#define SSS_REG_AES_IV_DATA(off, s)	((off + 0x30) + (s << 2))
+#define SSS_REG_AES_CNT_DATA(off, s)	((off + 0x40) + (s << 2))
+#define SSS_REG_AES_KEY_DATA(off, s)	((off + 0x80) + (s << 2))
 
 #define SSS_REG(dev, reg)               ((dev)->ioaddr + (SSS_REG_##reg))
 #define SSS_READ(dev, reg)              __raw_readl(SSS_REG(dev, reg))
 #define SSS_WRITE(dev, reg, val)        __raw_writel((val), SSS_REG(dev, reg))
 
+#define SSS_AES_REG(dev, reg)           ((dev)->ioaddr + SSS_REG_##reg + \
+						dev->varient->aes_offset)
+#define SSS_AES_WRITE(dev, reg, val)    __raw_writel((val), \
+						SSS_AES_REG(dev, reg))
+
 /* HW engine modes */
 #define FLAGS_AES_DECRYPT               _BIT(0)
 #define FLAGS_AES_MODE_MASK             _SBF(1, 0x03)
@@ -199,6 +204,11 @@ static struct samsung_aes_varient s5p_aes_data = {
 	.aes_offset	= 0x4000,
 };
 
+static struct samsung_aes_varient exynos_aes_data = {
+	.has_hash_irq	= false,
+	.aes_offset	= 0x200,
+};
+
 static const struct platform_device_id s5p_sss_ids[] = {
 	{
 		.name		= "s5p-secss",
@@ -214,6 +224,10 @@ static const struct of_device_id s5p_sss_dt_match[] = {
 		.compatible = "samsung,s5p-secss",
 		.data = (void *)&s5p_aes_data,
 	},
+	{
+		.compatible = "samsung,exynos-secss",
+		.data = (void *)&exynos_aes_data,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
@@ -381,16 +395,21 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 static void s5p_set_aes(struct s5p_aes_dev *dev,
 			uint8_t *key, uint8_t *iv, unsigned int keylen)
 {
+	struct samsung_aes_varient *var = dev->varient;
 	void __iomem *keystart;
 
-	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
+				(var->aes_offset, 0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(0);
+		keystart = dev->ioaddr +
+				SSS_REG_AES_KEY_DATA(var->aes_offset, 0);
 	else if (keylen == AES_KEYSIZE_192)
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(2);
+		keystart = dev->ioaddr +
+				SSS_REG_AES_KEY_DATA(var->aes_offset, 2);
 	else
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(4);
+		keystart = dev->ioaddr +
+				SSS_REG_AES_KEY_DATA(var->aes_offset, 4);
 
 	memcpy(keystart, key, keylen);
 }
@@ -440,7 +459,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	if (err)
 		goto outdata_error;
 
-	SSS_WRITE(dev, AES_CONTROL, aes_control);
+	SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
 	s5p_set_aes(dev, dev->ctx->aes_key, req->info, dev->ctx->keylen);
 
 	s5p_set_dma_indata(dev,  req->src);
-- 
1.7.9.5

