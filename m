Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaD1KrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:47:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64391 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaD1KrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:47:02 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-94-535e31a5e0ab
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Subject: [PATCH 3/7 v8] crypto:s5p-sss: Add support for SSS module on Exynos
Date: Mon, 28 Apr 2014 16:14:55 +0530
Message-id: <1398681899-20782-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkSnepYVywwZ+fXBYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLdbPeM1icXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKuH1jPmvBBu+KNxtOsTQwtlt3MXJySAiYSHw8t5oN
	whaTuHBvPZDNxSEksJRRYvrG2awwRfvufmKCSExnlJjy8w87hNPPJLH84DomkCo2ATOJg4tW
	s4PYIgLOEr+b17CCFDELrGOU+PTmMFiRsICPxLJX98D2sQioSmz7dBAszivgKjHlVANQAwfQ
	OgWJOZNsQMKcAm4SV9efYwSxhYBKlvb+YAaZKSGwil3i2Zyf7BBzBCS+TT7EAtErK7HpADPE
	1ZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmDYn/73rH8H490D1ocY
	k4HGTWSWEk3OB8ZNXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgzHBLvb/tzfO1dQe3HHmdYvXC8e2MdQs6K9Tsb+++pTE94se3hYY8WYI6ezym
	iWivqRKrVunrnO631FZe8o6izcwJ2j6aq1/Okqwx1Snv0BGW1REXWnzX1rr4135u93tGm1OP
	ZZ3oz9x+kuHqUs7PnIlH9jk631/8KNY/9W9jr5tku0Wyfl6jEktxRqKhFnNRcSIA3HZU1pEC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd2lhnHBBvsiLV4e0rSYc76FxaL7
	lYzF/Xs/mSwu75rDZjHj/D4mi0Xb/jNbrJ/xmsXi7JxDTA6cHltW3mTy2DnrLrvHtgOqHn1b
	VjF6fN4kF8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQN0jZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/aN+awFG7wr
	3mw4xdLA2G7dxcjJISFgIrHv7icmCFtM4sK99WxdjFwcQgLTGSWm/PzDDuH0M0ksP7gOrIpN
	wEzi4KLV7CC2iICzxO/mNawgRcwC6xglPr05DFYkLOAjsezVPTYQm0VAVWLbp4NgcV4BV4kp
	pxqAGjiA1ilIzJlkAxLmFHCTuLr+HCOILQRUsrT3B/MERt4FjAyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYJj6pnUDsaVDRaHGAU4GJV4eCPmxAYLsSaWFVfmHmKU4GBWEuHdLxEXLMSb
	klhZlVqUH19UmpNafIgxGeioicxSosn5wHjPK4k3NDYxNzU2tTSxMDGzJE1YSZz3QKt1oJBA
	emJJanZqakFqEcwWJg5OqQbGji0rZHS3JcSGzfY/vuPTd86GtS8sXs0VNnnH9/Nj/tKnKqev
	Tl/XJJp9hmXjbzE9tvPbnCb6766d9/eiieUJrj9nqpI6bk7tUm9YbWtxuHaCxZHsqpwjsU83
	PXFcMU+fj3eqa/43R6ttNwPOCCZb+C67ley0MHnRN8bnrWcE63/aBOs8LuduUWIpzkg01GIu
	Kk4EAHfgovPtAgAA
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

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v7:
Added Acked-by from Herbert Xu
Change since v6:
None
Change since v5:
1. Rewritten the interrupt definition in the documentation
2. Added Reviewed-by: Tomasz Figa <t.figa@samsung.com>

 .../devicetree/bindings/crypto/samsung-sss.txt     |   15 ++-
 drivers/crypto/s5p-sss.c                           |  107 +++++++++++++++-----
 2 files changed, 95 insertions(+), 27 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
index 3876f71..1702773 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -8,16 +8,25 @@ The SSS module in S5PV210 SoC supports the following:
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
+  - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
+		Exynos5260 and Exynos5420 SoCs.
 - reg : Offset and length of the register set for the module
 - interrupts : interrupt specifiers of SSS module interrupts, should contain
-		two entries:
-		- first : feed control interrupt,
-		- second : hash interrupt.
+		following entries:
+		- first : feed control interrupt (required for all variants),
+		- second : hash interrupt (required only for samsung,s5pv210-secss).
 
 - clocks : list of clock phandle and specifier pairs for all clocks  listed in
 		clock-names property.
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index c6aafe8..37e0598 100644
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
@@ -122,21 +122,25 @@
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
+#define SSS_REG_AES_IN_DATA(s)		(0x10 + (s << 2))
+#define SSS_REG_AES_OUT_DATA(s)		(0x20 + (s << 2))
+#define SSS_REG_AES_IV_DATA(s)		(0x30 + (s << 2))
+#define SSS_REG_AES_CNT_DATA(s)		(0x40 + (s << 2))
+#define SSS_REG_AES_KEY_DATA(s)		(0x80 + (s << 2))
 
 #define SSS_REG(dev, reg)               ((dev)->ioaddr + (SSS_REG_##reg))
 #define SSS_READ(dev, reg)              __raw_readl(SSS_REG(dev, reg))
 #define SSS_WRITE(dev, reg, val)        __raw_writel((val), SSS_REG(dev, reg))
 
+#define SSS_AES_REG(dev, reg)           ((dev)->aes_ioaddr + SSS_REG_##reg)
+#define SSS_AES_WRITE(dev, reg, val)    __raw_writel((val), \
+						SSS_AES_REG(dev, reg))
+
 /* HW engine modes */
 #define FLAGS_AES_DECRYPT               _BIT(0)
 #define FLAGS_AES_MODE_MASK             _SBF(1, 0x03)
@@ -146,6 +150,20 @@
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
@@ -162,6 +180,7 @@ struct s5p_aes_dev {
 	struct device              *dev;
 	struct clk                 *clk;
 	void __iomem               *ioaddr;
+	void __iomem               *aes_ioaddr;
 	int                         irq_hash;
 	int                         irq_fc;
 
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
-	{ .compatible = "samsung,s5pv210-secss" },
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
@@ -329,14 +380,14 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 {
 	void __iomem *keystart;
 
-	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+	memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(0);
+		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
 	else if (keylen == AES_KEYSIZE_192)
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(2);
+		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(2);
 	else
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(4);
+		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(4);
 
 	memcpy(keystart, key, keylen);
 }
@@ -386,7 +437,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	if (err)
 		goto outdata_error;
 
-	SSS_WRITE(dev, AES_CONTROL, aes_control);
+	SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
 	s5p_set_aes(dev, dev->ctx->aes_key, req->info, dev->ctx->keylen);
 
 	s5p_set_dma_indata(dev,  req->src);
@@ -571,6 +622,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	struct s5p_aes_dev *pdata;
 	struct device      *dev = &pdev->dev;
 	struct resource    *res;
+	struct samsung_aes_variant *variant;
 
 	if (s5p_dev)
 		return -EEXIST;
@@ -584,6 +636,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	if (IS_ERR(pdata->ioaddr))
 		return PTR_ERR(pdata->ioaddr);
 
+	variant = find_s5p_sss_version(pdev);
+
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
 		dev_err(dev, "failed to find secss clock source\n");
@@ -594,6 +648,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	spin_lock_init(&pdata->lock);
 
+	pdata->aes_ioaddr = pdata->ioaddr + variant->aes_offset;
+
 	pdata->irq_fc = platform_get_irq(pdev, 0);
 	if (pdata->irq_fc < 0) {
 		err = pdata->irq_fc;
@@ -607,19 +663,22 @@ static int s5p_aes_probe(struct platform_device *pdev)
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

