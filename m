Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaK0Hgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:36:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41760 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaK0Hfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:34 -0500
X-AuditID: cbfee68e-f79b46d000002b74-14-5476d4388ac5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 19/19] serial: samsung: Add the support for Exynos5433 SoC
Date: Thu, 27 Nov 2014 16:35:16 +0900
Message-id: <1417073716-22997-20-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkQNfySlmIwYsDzBaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0slk0L17PZjHp/gQWixu/2lgtPv/exWrRu+Aqm8XZ
	pjfsFlP+LGey2PT4GqvF5V1z2CxmnN/HZHFmcS+7xdLrF5ksTl3/zGZx+E07q8WMyS/ZLI7N
	WMJosWrXH0aLlx9PsDhIeqyZt4bR4/evSYweO2fdZfe4c20Pm8f+uWvYPTYvqfe4cqKJ1aNv
	yypGjzMLjrB7fN4kF8AVxWWTkpqTWZZapG+XwJWxaOo8poKZMhWTn3s2MC4R72Lk5JAQMJH4
	33+aCcIWk7hwbz1bFyMXh5DAUkaJd/+OMcMUHVl6ih0iMZ1R4uTJeywQThOTxJcrW8Da2QS0
	JPa/uMEGYosIOEs0TG1kAiliFnjIInH35E6wUcICXhK3n7xk7WLk4GARUJX4sSwXJMwr4Cbx
	9vYeRohtChLLls9kBbE5geL7vx4Es4UEXCUWfbsCNlNC4AiHRPf9uWAzWQQEJL5NPsQCMlNC
	QFZi0wGoqyUlDq64wTKBUXgBI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMBIPv3vWd8O
	xpsHrA8xCnAwKvHwWhwoCxFiTSwrrsw9xGgKtGEis5Rocj4wXeSVxBsamxlZmJqYGhuZW5op
	ifMmSP0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBY09kwne+iy8Zv3KW7Dp6a65O64tiq
	xM69rE+OcRq+2ZIjpqbGYZ9yJPyfe7jnjwthm+4/mtJ3P/P5mbZFfGL28gsvm8++JJWjf9vc
	Xn/2aSWlrdGmKWqeK+JSvofxGr6amWg7/9nrW/YpnxKlD6oZb7M86ruIZd4HrrZGIb6g04+f
	fXuuOXOqEktxRqKhFnNRcSIAIcCvDt8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQV2LK2UhBic3m1k8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymbRvHg9m8Wk+xNYLG78amO1+Px7F6tF74KrbBZn
	m96wW0z5s5zJYtPja6wWl3fNYbOYcX4fk8WZxb3sFkuvX2SyOHX9M5vF4TftrBYzJr9kszg2
	YwmjxapdfxgtXn48weIg6bFm3hpGj9+/JjF67Jx1l93jzrU9bB77565h99i8pN7jyokmVo++
	LasYPc4sOMLu8XmTXABXVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7Q40oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjEVT
	5zEVzJSpmPzcs4FxiXgXIyeHhICJxJGlp9ghbDGJC/fWs3UxcnEICUxnlDh58h4LhNPEJPHl
	yhYmkCo2AS2J/S9usIHYIgLOEg1TG5lAipgFHrJI3D25kxkkISzgJXH7yUvWLkYODhYBVYkf
	y3JBwrwCbhJvb+9hhNimILFs+UxWEJsTKL7/60EwW0jAVWLRtytMExh5FzAyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIThPPpHcwrmqwOMQowMGoxMNrcaAsRIg1say4MvcQowQHs5II
	r9QioBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbnA1NYXkm8obGJmZGlkbmhhZGxuZI4742b
	uSFCAumJJanZqakFqUUwfUwcnFINjAwNIR5eZ9YtCihfcaxbVekLd665TOjixA3N1mKe74of
	lC7vXrvIKUVon8p8Y6Hcg6XCcqsL3q518rL11WtxvKv8nU9Nk8tNdnbsDRnPzEA50xmTb3T6
	b8xYMr16uSMT0yqGnTOFurjaPpjxv2brnHHsyobzdYVbLOr+HlZl5t+a2nm2eWOSEktxRqKh
	FnNRcSIAWsJKCSkDAAA=
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
index 2338ad8..6f1fb9a 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1766,32 +1766,43 @@ static struct s3c24xx_serial_drv_data s5pv210_serial_drv_data = {
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
@@ -1813,6 +1824,9 @@ static struct platform_device_id s3c24xx_serial_driver_ids[] = {
 	}, {
 		.name		= "exynos4210-uart",
 		.driver_data	= EXYNOS4210_SERIAL_DRV_DATA,
+	}, {
+		.name		= "exynos5433-uart",
+		.driver_data	= EXYNOS5433_SERIAL_DRV_DATA,
 	},
 	{ },
 };
@@ -1832,6 +1846,8 @@ static const struct of_device_id s3c24xx_uart_dt_match[] = {
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

