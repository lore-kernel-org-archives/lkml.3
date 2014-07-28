Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaG1MoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:44:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38565 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaG1MoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:44:08 -0400
X-AuditID: cbfee691-b7f306d000003d81-22-53d64595331f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, heiko@sntech.de, knaack.h@gmx.de,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/3] iio: adc: exynos_adc: add support for s3c64xx adc
Date: Mon, 28 Jul 2014 21:44:00 +0900
Message-id: <1406551442-15186-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1406551442-15186-1-git-send-email-cw00.choi@samsung.com>
References: <1406551442-15186-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkUHeq67Vgg33XtS3+TjrGbnH3+WFG
	i+tfnrNazD9yjtXi/6PXrBYPmlYxWfQuuMpmsev/G2aLs01v2C02Pb7GarGwbQmLxbwj71gs
	Lu+aw2Yx4/w+Jov1M16zOPB7/P41idHjw8c4j02rOtk8Ni+p9+jbsorRY/u1ecwenzfJBbBH
	cdmkpOZklqUW6dslcGXMfvGFtWCpZMX1FYeZGhj/iXQxcnJICJhInH16ihnCFpO4cG89Wxcj
	F4eQwFJGiWMHdrB2MXKAFU2YaQcRX8Qo8XHKL2YIp4lJYteE1+wg3WwCWhL7X9xgA7FFBEQk
	7p3+wAhiMwv8ZJLY8bQIZJCwgIfE/j5rkDCLgKrEx65fYIt5BVwlzrYsZoc4Qk7iw55HYDan
	gJvEmh1bwWwhoJpPizrZQfZKCDxil9iy4CATxCABiW+TD7FAHCorsekA1DOSEgdX3GCZwCi8
	gJFhFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZgFJ3+92ziDsb7B6wPMSYDjZvILCWanA+M
	wrySeENjMyMLUxNTYyNzSzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDxs
	1XVvfWVWiHW3s2Yl7w/Z/e/D1v7L+Tep63gz6/lvktnZCuuYnIzmJsxcKX/s1o+CFTntk6//
	DDA9km40wzrUn1Gr9YjA9sQvgj8S7ln+VBHUC5QMvtf3TljO2T1Zar7Xpl3Tws4dz9/BOCPv
	U3yD+b4bkzZqNXg1VX5a4hStHNjI/2TbWSWW4oxEQy3mouJEADhg5PW4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd2prteCDX61KFr8nXSM3eLu88OM
	Fte/PGe1mH/kHKvF/0evWS0eNK1isuhdcJXNYtf/N8wWZ5vesFtsenyN1WJh2xIWi3lH3rFY
	XN41h81ixvl9TBbrZ7xmceD3+P1rEqPHh49xHptWdbJ5bF5S79G3ZRWjx/Zr85g9Pm+SC2CP
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYMfvFF9aCpZIV11ccZmpg/CfS
	xcjBISFgIjFhpl0XIyeQKSZx4d56ti5GLg4hgUWMEh+n/GKGcJqYJHZNeM0OUsUmoCWx/8UN
	NhBbREBE4t7pD4wgNrPATyaJHU+LQIYKC3hI7O+zBgmzCKhKfOwCmcPJwSvgKnG2ZTE7xDI5
	iQ97HoHZnAJuEmt2bAWzhYBqPi3qZJ/AyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4m
	RnCMPpPewbiqweIQowAHoxIPr0Xw1WAh1sSy4srcQ4wSHMxKIrzWTteChXhTEiurUovy44tK
	c1KLDzGaAl01kVlKNDkfmD7ySuINjU3MjCyNzA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0
	MXFwSjUwLrp8aN1yod0Gr1t3T+nwWB/xbFHb90tNRyX6n2RKB8ocWH0vYYmIn2fVMt5yzVXT
	FSUCzWbOX/KUgUtOqVquekqigPMTmRu56x8sUo1v7S26MHGCs9KvT/XWL3zUnj9IvST91Hrn
	d7G5Hl5ilYtnTd/1PqjwzOfzbIf9i4+xcccs5THPadecp8RSnJFoqMVcVJwIAPZkFXznAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ADC in s3c64xx is almost the same as exynosv1, but
has a different 'select' method. Adding this here will be
helpful to move over the existing s3c64xx platform from the
legacy plat-samsung/adc driver to the new exynos-adc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt |  2 ++
 drivers/iio/adc/exynos_adc.c                       | 28 +++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index adc61b0..d3dad46 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -16,6 +16,8 @@ Required properties:
 				future controllers.
 			Must be "samsung,exynos3250-adc" for
 				controllers compatible with ADC of Exynos3250.
+			Must be "samsung,s3c6410-adc" for
+				the ADC in s3c6410 and compatibles
 - reg:			Contains ADC register address range (base address and
 			length) and the address of the phy enable register.
 - interrupts: 		Contains the interrupt information for the timer. The
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 87e0895..ed9e4c8 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -40,7 +40,7 @@
 #include <linux/iio/machine.h>
 #include <linux/iio/driver.h>
 
-/* EXYNOS4412/5250 ADC_V1 registers definitions */
+/* S3C/EXYNOS4412/5250 ADC_V1 registers definitions */
 #define ADC_V1_CON(x)		((x) + 0x00)
 #define ADC_V1_DLY(x)		((x) + 0x08)
 #define ADC_V1_DATX(x)		((x) + 0x0C)
@@ -61,6 +61,9 @@
 #define ADC_V1_CON_PRSCLV(x)	(((x) & 0xFF) << 6)
 #define ADC_V1_CON_STANDBY	(1u << 2)
 
+/* Bit definitions for S3C2410 ADC */
+#define ADC_S3C2410_CON_SELMUX(x) (((x) & 7) << 3)
+
 /* Bit definitions for ADC_V2 */
 #define ADC_V2_CON1_SOFT_RESET	(1u << 2)
 
@@ -217,6 +220,26 @@ static const struct exynos_adc_data const exynos_adc_v1_data = {
 	.start_conv	= exynos_adc_v1_start_conv,
 };
 
+static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
+					  unsigned long addr)
+{
+	u32 con1;
+
+	con1 = readl(ADC_V1_CON(info->regs));
+	con1 &= ~ADC_S3C2410_CON_SELMUX(0x7);
+	con1 |= ADC_S3C2410_CON_SELMUX(addr);
+	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
+}
+
+static struct exynos_adc_data const exynos_adc_s3c64xx_data = {
+	.num_channels	= MAX_ADC_V1_CHANNELS,
+
+	.init_hw	= exynos_adc_v1_init_hw,
+	.exit_hw	= exynos_adc_v1_exit_hw,
+	.clear_irq	= exynos_adc_v1_clear_irq,
+	.start_conv	= exynos_adc_s3c64xx_start_conv,
+};
+
 static void exynos_adc_v2_init_hw(struct exynos_adc *info)
 {
 	u32 con1, con2;
@@ -285,6 +308,9 @@ static const struct exynos_adc_data const exynos3250_adc_data = {
 
 static const struct of_device_id exynos_adc_match[] = {
 	{
+		.compatible = "samsung,s3c6410-adc",
+		.data = &exynos_adc_s3c64xx_data,
+	}, {
 		.compatible = "samsung,exynos-adc-v1",
 		.data = &exynos_adc_v1_data,
 	}, {
-- 
1.8.0

