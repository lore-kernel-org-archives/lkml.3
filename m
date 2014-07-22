Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaGVCL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:11:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15730 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaGVCLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:11:21 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-f0-53cdc84619a9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/2] iio: adc: exynos_adc: add support for s3c64xx adc
Date: Tue, 22 Jul 2014 11:11:13 +0900
Message-id: <1405995074-3271-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com>
References: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkSNftxNlggxt3DSz+TjrGbnH3+WFG
	i+tfnrNazD9yjtXiQdMqJoveBVfZLM42vWG32PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	1s94zeLA6/H71yRGj02rOtk8Ni+p9+jbsorR4/MmuQDWKC6blNSczLLUIn27BK6Mlh2tbAVv
	pCsuvT3E1MDYKd7FyMkhIWAisfr1J1YIW0ziwr31bF2MXBxCAksZJb5vXgaU4AAraromARGf
	zijx+P4HFginiUliUcdWFpBuNgEtif0vbrCB2CICIhL3Tn9gBCliFrjKJLF9x3p2kISwgJvE
	7gW/mUCmsgioShz+XA0S5hVwkXh5Yxs7xBVyEh/2PAKzOQVcJbrPbWcGsYWAap5MaAO7TkLg
	FLtE67qFYGezCAhIfJt8iAXiUlmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJ
	ucWleel6yfm5mxiBEXL637O+HYw3D1gfYkwGGjeRWUo0OR8YYXkl8YbGZkYWpiamxkbmlmak
	CSuJ8y56mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTHfVf/MiYKIB1mOtxd11Ucbfy5V
	+D3jWWZWkuq5iLe2G2Im9xl/ctpUtzNnL7fLzdlvw2+Z9j9bJMhoky+0bclG8UVhD/SKcldd
	/jFtY7ONyuqrJ4L8JjAYPLSUKHRNf/1wYuc/g8MJmy53r9h+didDeeerYNY9TbPnbM5Nqr7L
	0rU+b4HATW8lluKMREMt5qLiRABWCdQlpgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQV23E2eDDfoXqVn8nXSM3eLu88OM
	Fte/PGe1mH/kHKvFg6ZVTBa9C66yWZxtesNusenxNVaLhW1LWCzmHXnHYnF51xw2ixnn9zFZ
	rJ/xmsWB1+P3r0mMHptWdbJ5bF5S79G3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM1p2tLIVvJGuuPT2EFMDY6d4FyMHh4SAiUTTNYkuRk4gU0ziwr31
	bF2MXBxCAtMZJR7f/8AC4TQxSSzq2MoCUsUmoCWx/8UNNhBbREBE4t7pD4wgRcwCV5kktu9Y
	zw6SEBZwk9i94DcTyAYWAVWJw5+rQcK8Ai4SL29sY4fYJifxYc8jMJtTwFWi+9x2ZhBbCKjm
	yYQ2tgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMffM6kdjCsbLA4xCnAwKvHw
	TlA8GyzEmlhWXJl7iFGCg1lJhLd9D1CINyWxsiq1KD++qDQntfgQoynQUROZpUST84GpIa8k
	3tDYxMzI0sjc0MLI2FxJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA2PuWevbC4uWlK3R+/z1
	851JPpt/1HOu6jr/vjB2f4rvh7j0qv4f9u8nmK/X0/1wdI5k36osvcu29woy040y3J8HHrw5
	uWS3nUHzmr1XDlyMesYqxrg53rz1+1U3USdP3U09zBwtX3XbdZlf5Kx2mfnb9+fikvypeaXL
	/RnVRXd5O22N//OmX0+JpTgj0VCLuag4EQCTZJ751QIAAA==
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
 drivers/iio/adc/exynos_adc.c                       | 32 +++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 6d34891..b6e3989 100644
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
index 87e0895..05bdd2f12 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -40,12 +40,16 @@
 #include <linux/iio/machine.h>
 #include <linux/iio/driver.h>
 
-/* EXYNOS4412/5250 ADC_V1 registers definitions */
+/* S3C/EXYNOS4412/5250 ADC_V1 registers definitions */
 #define ADC_V1_CON(x)		((x) + 0x00)
+#define ADC_V1_TSC(x)		((x) + 0x04)
 #define ADC_V1_DLY(x)		((x) + 0x08)
 #define ADC_V1_DATX(x)		((x) + 0x0C)
+#define ADC_V1_DATY(x)		((x) + 0x10)
+#define ADC_V1_UPDN(x)		((x) + 0x14)
 #define ADC_V1_INTCLR(x)	((x) + 0x18)
 #define ADC_V1_MUX(x)		((x) + 0x1c)
+#define ADC_V1_CLRINTPNDNUP(x)	((x) + 0x20)
 
 /* Future ADC_V2 registers definitions */
 #define ADC_V2_CON1(x)		((x) + 0x00)
@@ -61,6 +65,9 @@
 #define ADC_V1_CON_PRSCLV(x)	(((x) & 0xFF) << 6)
 #define ADC_V1_CON_STANDBY	(1u << 2)
 
+/* Bit definitions for S3C2410 ADC */
+#define ADC_S3C2410_CON_SELMUX(x) (((x) & 7) <<3)
+
 /* Bit definitions for ADC_V2 */
 #define ADC_V2_CON1_SOFT_RESET	(1u << 2)
 
@@ -217,6 +224,26 @@ static const struct exynos_adc_data const exynos_adc_v1_data = {
 	.start_conv	= exynos_adc_v1_start_conv,
 };
 
+static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
+					  unsigned long addr)
+{
+	u32 con1;
+
+	con1 = readl(ADC_V1_CON(info->regs));
+	con1 &= ~ADC_S3C2410_CON_SELMUX(7);
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
@@ -285,6 +312,9 @@ static const struct exynos_adc_data const exynos3250_adc_data = {
 
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

