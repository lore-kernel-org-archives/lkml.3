Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaAGLwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:52:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21919 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaAGLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:51:38 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-84-52cbea464b03
From: Naveen Krishna Ch <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/5] crypto:s5p-sss: Add support for SSS module on Exynos5
Date: Tue, 07 Jan 2014 17:21:47 +0530
Message-id: <1389095509-14357-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkVtft1ekgg9vTuC1eHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW5ydc4jJgcNjy8qbTB47Z91l99h2QNWjb8sqRo/P
	m+QCWKO4bFJSczLLUov07RK4Mubtn8Ne0KhT8ejGd8YGxnNKXYycHBICJhI9p9+xQthiEhfu
	rWfrYuTiEBJYyiix4eMBVpii/f92skMkFjFKHDl4lBXC6WeSmL/0JRtIFZuAvsSy64sZQWwR
	AWeJ381rwIqYBdYxSrz8OxusSFjAS+LYmY/MIDaLgKrEjzUP2EFsXgFXiU3nbgI1cACtU5CY
	M8kGJMwp4CZx+tBFdpCwEFDJ4SNpICMlBJaxSzQ83AY1RkDi2+RDLBCtshKbDjBDHC0pcXDF
	DZYJjMILGBlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgSG+ul/z3p3MN4+YH2IMRlo3ERm
	KdHkfGCs5JXEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMH
	p1QD45z+PVdkxByceW6KLF2x/Vm5r4v2guhba66VfD0c+3ndy2rHtTLyXZlP7I7O+d/ksuRs
	T83M/4tEjadGLJpyPOXcog99TW3O5pPz24wt+2f5ShzdJuRd2K4eMMstJd5AY9JDhhihKytk
	dNayfXboSa0vE7bq0tf0v7eHc3U461OP4Nj1a9RjlFiKMxINtZiLihMBtqxb4IsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAV23V6eDDJa3Mlm8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHlpU3mTx2zrrL7rHtgKpH35ZVjB6f
	N8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcyYt38Oe0GjTsWjG98Z
	GxjPKXUxcnJICJhI7P+3kx3CFpO4cG89WxcjF4eQwCJGiSMHj7JCOP1MEvOXvmQDqWIT0JdY
	dn0xI4gtIuAs8bt5DVgRs8A6RomXf2eDFQkLeEkcO/ORGcRmEVCV+LHmAdgKXgFXiU3nbgI1
	cACtU5CYM8kGJMwp4CZx+tBFdpCwEFDJ4SNpExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvX
	S87P3cQIjqRn0jsYVzVYHGIU4GBU4uF9sfdUkBBrYllxZe4hRgkOZiURXuYbp4OEeFMSK6tS
	i/Lji0pzUosPMSYD3TSRWUo0OR8Y5Xkl8YbGJuamxqaWJhYmZpakCSuJ8x5stQ4UEkhPLEnN
	Tk0tSC2C2cLEwSnVwCj6fe7bI1e6hYwMV/+akL+wcNLO+dOm3b1yUCDhxYuHpmtSg/3DQox+
	NmTdVJkXb7Gsu0vzdEblBsHz2Uc83vYFrcvJNd49sz7OXE5XqLv9f4L1l70F99b+PrD1Xizv
	0x3nysquHpvNq5lx1vr+eVcfgeWd9q7XDj09JX2v6kur96MPMw9lbq9TYinOSDTUYi4qTgQA
	wwK2vOgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The differences between SSS modules on S5PV210 and Exynos5
(AFA the driver supports)
1. AES register are at an offset of 0x200 on Exynos5
2. hash interrupt is no longer needed on Exynos5

This patch adds code needed to address the above changes.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
 drivers/crypto/s5p-sss.c |   59 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index dcb9fc1..a11cd0e 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -106,7 +106,7 @@
 #define SSS_REG_FCPKDMAO                0x005C
 
 /* AES registers */
-#define SSS_REG_AES_CONTROL             0x4000
+#define SSS_REG_AES_CONTROL(dev)	((dev)->aes_offset + 0x00)
 #define SSS_AES_BYTESWAP_DI             _BIT(11)
 #define SSS_AES_BYTESWAP_DO             _BIT(10)
 #define SSS_AES_BYTESWAP_IV             _BIT(9)
@@ -122,21 +122,26 @@
 #define SSS_AES_CHAIN_MODE_CTR          _SBF(1, 0x02)
 #define SSS_AES_MODE_DECRYPT            _BIT(0)
 
-#define SSS_REG_AES_STATUS              0x4004
+#define SSS_REG_AES_STATUS(dev)		((dev)->aes_offset + 0x04)
 #define SSS_AES_BUSY                    _BIT(2)
 #define SSS_AES_INPUT_READY             _BIT(1)
 #define SSS_AES_OUTPUT_READY            _BIT(0)
 
-#define SSS_REG_AES_IN_DATA(s)          (0x4010 + (s << 2))
-#define SSS_REG_AES_OUT_DATA(s)         (0x4020 + (s << 2))
-#define SSS_REG_AES_IV_DATA(s)          (0x4030 + (s << 2))
-#define SSS_REG_AES_CNT_DATA(s)         (0x4040 + (s << 2))
-#define SSS_REG_AES_KEY_DATA(s)         (0x4080 + (s << 2))
+#define SSS_REG_AES_IN_DATA(dev, s)	((dev)->aes_offset + 0x10 + (s << 2))
+#define SSS_REG_AES_OUT_DATA(dev, s)	((dev)->aes_offset + 0x20 + (s << 2))
+#define SSS_REG_AES_IV_DATA(dev, s)	((dev)->aes_offset + 0x30 + (s << 2))
+#define SSS_REG_AES_CNT_DATA(dev, s)	((dev)->aes_offset + 0x40 + (s << 2))
+#define SSS_REG_AES_KEY_DATA(dev, s)	((dev)->aes_offset + 0x80 + (s << 2))
 
 #define SSS_REG(dev, reg)               ((dev)->ioaddr + (SSS_REG_##reg))
 #define SSS_READ(dev, reg)              __raw_readl(SSS_REG(dev, reg))
 #define SSS_WRITE(dev, reg, val)        __raw_writel((val), SSS_REG(dev, reg))
 
+#define SSS_AES_REG(dev, reg)		((dev)->ioaddr + (SSS_REG_##reg(dev)))
+#define SSS_AES_READ(dev, reg)          __raw_readl(SSS_AES_REG(dev, reg))
+#define SSS_AES_WRITE(dev, reg, val)    __raw_writel((val),	\
+							SSS_AES_REG(dev, reg))
+
 /* HW engine modes */
 #define FLAGS_AES_DECRYPT               _BIT(0)
 #define FLAGS_AES_MODE_MASK             _SBF(1, 0x03)
@@ -177,6 +182,13 @@ struct s5p_aes_dev {
 
 	/* To support SSS versions across Samsung SoCs */
 	unsigned int		    version;
+
+	/*
+	 * Register banks corresponding to various algorithms
+	 * (Ex: AES, TDES, HASH, TRNG, PKA etc.)
+	 * are at an offsets from the base (depending on SSS verion)
+	 */
+	unsigned int		    aes_offset;
 };
 
 static struct s5p_aes_dev *s5p_dev;
@@ -358,14 +370,14 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 {
 	void __iomem *keystart;
 
-	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA(dev, 0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(0);
+		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(dev, 0);
 	else if (keylen == AES_KEYSIZE_192)
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(2);
+		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(dev, 2);
 	else
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(4);
+		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(dev, 4);
 
 	memcpy(keystart, key, keylen);
 }
@@ -415,7 +427,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	if (err)
 		goto outdata_error;
 
-	SSS_WRITE(dev, AES_CONTROL, aes_control);
+	SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
 	s5p_set_aes(dev, dev->ctx->aes_key, req->info, dev->ctx->keylen);
 
 	s5p_set_dma_indata(dev,  req->src);
@@ -618,6 +630,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	pdata->version = find_s5p_sss_version(pdev);
 
+	if (pdata->version == SSS_VER_5)
+		pdata->aes_offset = 0x200;
+	else
+		pdata->aes_offset = 0x4000;
+
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
 		dev_err(dev, "failed to find secss clock source\n");
@@ -643,17 +660,23 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+	/*
+	 * SSS module present in Exynos5 Series SoCs
+	 * does not use hash interrupt
+	 */
 	pdata->irq_hash = platform_get_irq(pdev, 1);
-	if (pdata->irq_hash < 0) {
+	if ((pdata->version == SSS_VER_4) && (pdata->irq_hash < 0)) {
 		err = pdata->irq_hash;
 		dev_warn(dev, "hash interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
-			       IRQF_SHARED, pdev->name, pdev);
-	if (err < 0) {
-		dev_warn(dev, "hash interrupt is not available.\n");
-		goto err_irq;
+	if (pdata->version == SSS_VER_4) {
+		err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
+				       IRQF_SHARED, pdev->name, pdev);
+		if (err < 0) {
+			dev_warn(dev, "hash interrupt is not available.\n");
+			goto err_irq;
+		}
 	}
 
 	pdata->dev = dev;
-- 
1.7.9.5

