Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaLBIyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:54:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52358 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaLBIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:06 -0500
X-AuditID: cbfee68d-f79296d000004278-10-547d7d3771c1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 17/19] serial: samsung: Add the support for Exynos5433 SoC
Date: Tue, 02 Dec 2014 17:49:54 +0900
Message-id: <1417510196-6714-18-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkSNeitjbEYOEWNovHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2SyaF69ns5h0fwKLxY1fbawWn3/vYrXoXXCVzeJs
	0xt2i02Pr7FaXN41h81ixvl9TBZnFveyW/y984/NYun1i0wWp65/ZrNYtPULu8XhN+2sFjMm
	v2SzWLXrD6PFy48nWBwkPdbMW8Po8fvXJEaPnbPusnvsn7uG3WPzknqPKyeaWD36tqxi9Diz
	4Ai7x+dNcgGcUVw2Kak5mWWpRfp2CVwZ067uZy6YKVNxeekclgbGJeJdjBwcEgImEtMvOncx
	cgKZYhIX7q1n62Lk4hASWMooseDUCjaIhInE9atn2CES0xklWid/YYFwmpgklh2ezQ5SxSag
	JbH/xQ2wDhEBZ4mGqY1MIEXMAndYJGZeb2ACSQgLeEns+nkerIhFQFXi2L7/YM28Aq4Sx6+d
	ZoJYpyCxbPlMVhCbEyjedaYPrEZIwEXiV+tHsDMkBPZwSDT8hhkkIPFt8iEWiH9kJTYdYIaY
	IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBEbw6X/Pencw3j5gfYhR
	gINRiYf35PmaECHWxLLiytxDjKZAGyYyS4km5wPTRF5JvKGxmZGFqYmpsZG5pZmSOK+i1M9g
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw5Mvm3TecFKs2/OYFvyo8Zs2a9OBg7uebJMrFA
	7ofznv3Q0JM19Bc79VSsZV7Sm0OxmosZbrwKXH3D6PNCFblji6KeZ3Is2zyP62mHaOhhwWvb
	Flk2XfV2f/TBdGE15793AU/rrndyHOmf9bf9eEjRxKXLSgKLThrtCeA61xxcuTRJqKVRauoR
	JZbijERDLeai4kQAtQs18dsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jQV3z2toQg95uS4vHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2SyaF69ns5h0fwKLxY1fbawWn3/vYrXoXXCVzeJs
	0xt2i02Pr7FaXN41h81ixvl9TBZnFveyW/y984/NYun1i0wWp65/ZrNYtPULu8XhN+2sFjMm
	v2SzWLXrD6PFy48nWBwkPdbMW8Po8fvXJEaPnbPusnvsn7uG3WPzknqPKyeaWD36tqxi9Diz
	4Ai7x+dNcgGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+
	AbpumTlAPysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM6Zd3c9cMFOm
	4vLSOSwNjEvEuxg5OSQETCSuXz3DDmGLSVy4t56ti5GLQ0hgOqNE6+QvLBBOE5PEssOzwarY
	BLQk9r+4wQZiiwg4SzRMbWQCKWIWuMMiMfN6AxNIQljAS2LXz/NgRSwCqhLH9v0Ha+YVcJU4
	fu00E8Q6BYlly2eygticQPGuM31gNUICLhK/Wj+yT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4
	NC9dLzk/dxMjOEE8k97BuKrB4hCjAAejEg/vifM1IUKsiWXFlbmHGCU4mJVEeH8Z14YI8aYk
	VlalFuXHF5XmpBYfYjQFumois5Rocj4weeWVxBsam5gZWRqZG1oYGZsrifPeuJkbIiSQnliS
	mp2aWpBaBNPHxMEp1cDoOi9b8Z+6/wXJy1siT1691BR4Z+ZCpuDVdmse7E01WjvTR3DBzrUv
	DXsTugvmf52Qwt9/v8eGh7+MuSBZfnHbrR8CW56LBfkqJ3yTWeRV9fkJu9P6k0fVEt5skfmW
	EPogdOfG+Y3dj5YvkWPf1JB3spBTdJ/SQuGFdTF6Nm88arSMluw+mq6hxFKckWioxVxUnAgA
	OG37VCYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new s3c24xx_serial_drv_data structure for Exynos5433 SoC
because Exynos5433 has different fifo size from existing Exynos4 SoC.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 drivers/tty/serial/samsung.c | 56 ++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c78f43a..1747fdc 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1771,32 +1771,43 @@ static struct s3c24xx_serial_drv_data s5pv210_serial_drv_data = {
 #endif
 
 #if defined(CONFIG_ARCH_EXYNOS)
+#define EXYNOS_COMMON_SERIAL_DRV_DATA				\
+	.info = &(struct s3c24xx_uart_info) {			\
+		.name		= "Samsung Exynos UART",	\
+		.type		= PORT_S3C6400,			\
+		.has_divslot	= 1,				\
+		.rx_fifomask	= S5PV210_UFSTAT_RXMASK,	\
+		.rx_fifoshift	= S5PV210_UFSTAT_RXSHIFT,	\
+		.rx_fifofull	= S5PV210_UFSTAT_RXFULL,	\
+		.tx_fifofull	= S5PV210_UFSTAT_TXFULL,	\
+		.tx_fifomask	= S5PV210_UFSTAT_TXMASK,	\
+		.tx_fifoshift	= S5PV210_UFSTAT_TXSHIFT,	\
+		.def_clk_sel	= S3C2410_UCON_CLKSEL0,		\
+		.num_clks	= 1,				\
+		.clksel_mask	= 0,				\
+		.clksel_shift	= 0,				\
+	},							\
+	.def_cfg = &(struct s3c2410_uartcfg) {			\
+		.ucon		= S5PV210_UCON_DEFAULT,		\
+		.ufcon		= S5PV210_UFCON_DEFAULT,	\
+		.has_fracval	= 1,				\
+	}							\
+
 static struct s3c24xx_serial_drv_data exynos4210_serial_drv_data = {
-	.info = &(struct s3c24xx_uart_info) {
-		.name		= "Samsung Exynos4 UART",
-		.type		= PORT_S3C6400,
-		.has_divslot	= 1,
-		.rx_fifomask	= S5PV210_UFSTAT_RXMASK,
-		.rx_fifoshift	= S5PV210_UFSTAT_RXSHIFT,
-		.rx_fifofull	= S5PV210_UFSTAT_RXFULL,
-		.tx_fifofull	= S5PV210_UFSTAT_TXFULL,
-		.tx_fifomask	= S5PV210_UFSTAT_TXMASK,
-		.tx_fifoshift	= S5PV210_UFSTAT_TXSHIFT,
-		.def_clk_sel	= S3C2410_UCON_CLKSEL0,
-		.num_clks	= 1,
-		.clksel_mask	= 0,
-		.clksel_shift	= 0,
-	},
-	.def_cfg = &(struct s3c2410_uartcfg) {
-		.ucon		= S5PV210_UCON_DEFAULT,
-		.ufcon		= S5PV210_UFCON_DEFAULT,
-		.has_fracval	= 1,
-	},
+	EXYNOS_COMMON_SERIAL_DRV_DATA,
 	.fifosize = { 256, 64, 16, 16 },
 };
+
+static struct s3c24xx_serial_drv_data exynos5433_serial_drv_data = {
+	EXYNOS_COMMON_SERIAL_DRV_DATA,
+	.fifosize = { 64, 256, 16, 256 },
+};
+
 #define EXYNOS4210_SERIAL_DRV_DATA ((kernel_ulong_t)&exynos4210_serial_drv_data)
+#define EXYNOS5433_SERIAL_DRV_DATA ((kernel_ulong_t)&exynos5433_serial_drv_data)
 #else
 #define EXYNOS4210_SERIAL_DRV_DATA (kernel_ulong_t)NULL
+#define EXYNOS5433_SERIAL_DRV_DATA (kernel_ulong_t)NULL
 #endif
 
 static struct platform_device_id s3c24xx_serial_driver_ids[] = {
@@ -1818,6 +1829,9 @@ static struct platform_device_id s3c24xx_serial_driver_ids[] = {
 	}, {
 		.name		= "exynos4210-uart",
 		.driver_data	= EXYNOS4210_SERIAL_DRV_DATA,
+	}, {
+		.name		= "exynos5433-uart",
+		.driver_data	= EXYNOS5433_SERIAL_DRV_DATA,
 	},
 	{ },
 };
@@ -1837,6 +1851,8 @@ static const struct of_device_id s3c24xx_uart_dt_match[] = {
 		.data = (void *)S5PV210_SERIAL_DRV_DATA },
 	{ .compatible = "samsung,exynos4210-uart",
 		.data = (void *)EXYNOS4210_SERIAL_DRV_DATA },
+	{ .compatible = "samsung,exynos5433-uart",
+		.data = (void *)EXYNOS5433_SERIAL_DRV_DATA },
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c24xx_uart_dt_match);
-- 
1.8.5.5

