Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaAJLmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:42:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44287 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaAJLmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:42:35 -0500
X-AuditID: cbfee68f-b7f156d00000276c-9d-52cfdcaae0ef
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/8 v3] crypto:s5p-sss: Add support for SSS module on Exynos
Date: Fri, 10 Jan 2014 17:12:51 +0530
Message-id: <1389354171-31816-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-4-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-4-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkSnfVnfNBBstXqFm8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntli16w+jxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoErY86JTywFVzwrln5ewNjAOMWqi5GTQ0LARGJqy392
	CFtM4sK99WxdjFwcQgJLGSXu9d1hgila37yPHSIxnVHi66kOFginn0li9o9bYO1sAmYSBxet
	BrNFBJwlfjevYQUpYhY4yijxec5FsFHCAj4SZ+dfYQSxWQRUJfo2vWIDsXkFXCWmvtsANJUD
	aJ2CxJxJNiBhTgE3id43X8FahYBK2r8eYYO4aBW7xNxj/hBjBCS+TT4E1SorsekAM0SJpMTB
	FTdYJjAKL2BkWMUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGPSn/z3r38F494D1IcZkoHET
	maVEk/OBUZNXEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhj9lqkqRsrFhHBPirVPSeM/NOX6lH/VZzZHzthnWa0gva9u7km3c2XczodFf/6KLtj+
	9rz7RfGra7RtdHPaQnfLKt28dnuq9GWNGzYSS81dF1m3HW55oqEgkTxzzjyvE5rrRNdzmy25
	ckqyIXNPo8D29xdjt//Ja37K5hd1a8siHY4aiY96k/SVWIozEg21mIuKEwEl8tDlkAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd1Vd84HGdz9L2fx8pCmxZzzLSwW
	3a9kLO7f+8lkcXnXHDaLGef3MVks2vaf2WLVrj+MFmfnHGJy4PTYsvImk8fOWXfZPbYdUPXo
	27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoHOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlzTnxiKbji
	WbH08wLGBsYpVl2MnBwSAiYS65v3sUPYYhIX7q1n62Lk4hASmM4o8fVUBwuE088kMfvHLbAq
	NgEziYOLVoPZIgLOEr+b17CCFDELHGWU+DznIhNIQljAR+Ls/CuMIDaLgKpE36ZXbCA2r4Cr
	xNR3G4CmcgCtU5CYM8kGJMwp4CbR++YrWKsQUEn71yNsExh5FzAyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIjqpn0jsYVzVYHGIU4GBU4uEtmHU+SIg1say4MvcQowQHs5IIr/kFoBBv
	SmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnAyM+ryTe0NjE3NTY1NLEwsTMkjRhJXHeg63WgUIC
	6YklqdmpqQWpRTBbmDg4pRoYtYVU/m2R4d0oOL9cZknPiz0z1e84NyyYmFxbLz3fQHFdsXbm
	n5QOj4hwfYONllyPJspsEU9cIhHScMTMU0BG9XWKhdUsK+nt4uanwr6ufb05q5/jmUbBds7Q
	mXf/9e3vyJq561/z2S7BtIML106YOi3q5LObiRM2ejrs1Hp14ge/e2DR2bZ7SizFGYmGWsxF
	xYkAvqqOTO4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new compatible and variant struct to support the SSS
module on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250)
for which
1. AES register are at an offset of 0x200 and
2. hash interrupt is not available

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v2:
1. Added variant struct to handle the differences in SSS modules
2. Changed the compatible strings to exynos4210-secss
3. Other changes suggested by Tomasz

 .../devicetree/bindings/crypto/samsung-sss.txt     |   20 ++++
 drivers/crypto/s5p-sss.c                           |  110 +++++++++++++++-----
 2 files changed, 106 insertions(+), 24 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
index 2f9d7e4..fdc7d8b 100644
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
   - "samsung,s5pv210-secss" for S5PV210 SoC.
+  - "samsung,exynos4210-secss" for Exynos4210, Exynos5250 and Exynos5420 SoCs.
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
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+	};
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 2da5617..f274f5f 100644
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
+						dev->variant->aes_offset)
+#define SSS_AES_WRITE(dev, reg, val)    __raw_writel((val), \
+						SSS_AES_REG(dev, reg))
+
 /* HW engine modes */
 #define FLAGS_AES_DECRYPT               _BIT(0)
 #define FLAGS_AES_MODE_MASK             _SBF(1, 0x03)
@@ -146,6 +151,20 @@
 #define AES_KEY_LEN         16
 #define CRYPTO_QUEUE_LEN    1
 
+/**
+ * struct samsung_aes_variant - platform specific SSS driver data
+ * @has_hash_irq: true if SSS module uses hash interrupt, false otherwise
+ * @aes_offset: AES register offset from SSS module's base.
+ *
+ * Specifies platform specific configuration of SSS module.
+ * Note: A structure for driver specific platform data is used for future
+ * expansion of its usage.
+ */
+struct samsung_aes_variant {
+	bool			    has_hash_irq;
+	unsigned int		    aes_offset;
+};
+
 struct s5p_aes_reqctx {
 	unsigned long mode;
 };
@@ -174,16 +193,48 @@ struct s5p_aes_dev {
 	struct crypto_queue         queue;
 	bool                        busy;
 	spinlock_t                  lock;
+
+	struct samsung_aes_variant *variant;
 };
 
 static struct s5p_aes_dev *s5p_dev;
 
+static const struct samsung_aes_variant s5p_aes_data = {
+	.has_hash_irq	= true,
+	.aes_offset	= 0x4000,
+};
+
+static const struct samsung_aes_variant exynos_aes_data = {
+	.has_hash_irq	= false,
+	.aes_offset	= 0x200,
+};
+
 static const struct of_device_id s5p_sss_dt_match[] = {
-	{ .compatible = "samsung,s5pv210-secss", },
+	{
+		.compatible = "samsung,s5pv210-secss",
+		.data = &s5p_aes_data,
+	},
+	{
+		.compatible = "samsung,exynos4210-secss",
+		.data = &exynos_aes_data,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
 
+static inline struct samsung_aes_variant *find_s5p_sss_version
+				   (struct platform_device *pdev)
+{
+	if (IS_ENABLED(CONFIG_OF) && (pdev->dev.of_node)) {
+		const struct of_device_id *match;
+		match = of_match_node(s5p_sss_dt_match,
+					pdev->dev.of_node);
+		return (struct samsung_aes_variant *)match->data;
+	}
+	return (struct samsung_aes_variant *)
+			platform_get_device_id(pdev)->driver_data;
+}
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -327,16 +378,21 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 static void s5p_set_aes(struct s5p_aes_dev *dev,
 			uint8_t *key, uint8_t *iv, unsigned int keylen)
 {
+	struct samsung_aes_variant *var = dev->variant;
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
@@ -386,7 +442,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	if (err)
 		goto outdata_error;
 
-	SSS_WRITE(dev, AES_CONTROL, aes_control);
+	SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
 	s5p_set_aes(dev, dev->ctx->aes_key, req->info, dev->ctx->keylen);
 
 	s5p_set_dma_indata(dev,  req->src);
@@ -571,6 +627,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	struct s5p_aes_dev *pdata;
 	struct device      *dev = &pdev->dev;
 	struct resource    *res;
+	struct samsung_aes_variant *variant;
 
 	if (s5p_dev)
 		return -EEXIST;
@@ -587,6 +644,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 				     resource_size(res), pdev->name))
 		return -EBUSY;
 
+	variant = find_s5p_sss_version(pdev);
+
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
 		dev_err(dev, "failed to find secss clock source\n");
@@ -612,19 +671,22 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	pdata->irq_hash = platform_get_irq(pdev, 1);
-	if (pdata->irq_hash < 0) {
-		err = pdata->irq_hash;
-		dev_warn(dev, "hash interrupt is not available.\n");
-		goto err_irq;
-	}
-	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
-			       IRQF_SHARED, pdev->name, pdev);
-	if (err < 0) {
-		dev_warn(dev, "hash interrupt is not available.\n");
-		goto err_irq;
+	if (variant->has_hash_irq) {
+		pdata->irq_hash = platform_get_irq(pdev, 1);
+		if (pdata->irq_hash < 0) {
+			err = pdata->irq_hash;
+			dev_warn(dev, "hash interrupt is not available.\n");
+			goto err_irq;
+		}
+		err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
+				       IRQF_SHARED, pdev->name, pdev);
+		if (err < 0) {
+			dev_warn(dev, "hash interrupt is not available.\n");
+			goto err_irq;
+		}
 	}
 
+	pdata->variant = variant;
 	pdata->dev = dev;
 	platform_set_drvdata(pdev, pdata);
 	s5p_dev = pdata;
-- 
1.7.9.5

