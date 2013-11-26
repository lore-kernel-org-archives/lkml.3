Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3KZEZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:25:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47518 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3KZEZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:25:24 -0500
X-AuditID: cbfee68f-b7f336d00000481b-06-529422b2e211
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: sjg@chromium.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, wsa@the-dreams.de,
        ben-linux@fluff.org, grant.likely@secretlab.ca, broonie@kernel.org,
        dianders@chromium.org, cpgs@samsung.com, t.figa@samsung.com
Subject: [PATCH 2/2 v2] i2c: exynos5: configure fifo_depth based on HSI2C
 module version
Date: Tue, 26 Nov 2013 09:56:39 +0530
Message-id: <1385439999-19123-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
References: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkWneT0pQgg3dbxCwmrTvAZDH14RM2
	i5eHNC3OLjvIZvHqzEY2i46/XxgtLu+aw2Yx4/w+JotvW7YxWqyf8ZrFYuWJWcwO3B6zGy6y
	ePxd9YLZY9OqTjaPvi2rGD1+vtTxOHnqCYvH501yAexRXDYpqTmZZalF+nYJXBmN1+exFCyR
	qviz/gNzA+Me0S5GTg4JAROJDavvMUPYYhIX7q1n62Lk4hASWMoo8aurgwWmaNM2kCKQxHRG
	iU0fXrFDOD1MEoemvmIDqWITMJM4uGg1O4gtIiAr0fpgDVgHs8B7Rol7t7vBEsICURLzbj4D
	s1kEVCWuX54HtIKDg1fAVeL5PhWIbYoS3c8mgM3kFHCT+PdkIhNIiRBQyfWJkSAjJQSOsUtM
	ejOLEWKMgMS3yYfAxkgA7d10AOobSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4NC9d
	Lzk/dxMjMD5O/3vWv4Px7gHrQ4zJQOMmMkuJJucD4yuvJN7Q2MzIwtTE1NjI3NKMNGElcd77
	D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDO1OpzE5nBUhNQI2J3y79BOntqkv/jBZ9v
	8cuEaWp0JN44xyMft1DO4/PV4B9qHdaOkiJzE/UTtRumrLe+GMbiuT1p50LTJ56FXkuiv2wu
	80kU03uz5MAdhxd917lKLz9aYcH9OjZ6/Q7DT7eP9c5S4me828ZldqQy8EdG8zPu1v3OD7f6
	SiqxFGckGmoxFxUnAgAuuuTHpQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd1NSlOCDCY85bOYtO4Ak8XUh0/Y
	LF4e0rQ4u+wgm8WrMxvZLDr+fmG0uLxrDpvFjPP7mCy+bdnGaLF+xmsWi5UnZjE7cHvMbrjI
	4vF31Qtmj02rOtk8+rasYvT4+VLH4+SpJywenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGHMaLw+j6VgiVTFn/UfmBsY94h2MXJySAiYSGzado8ZwhaTuHBvPVsX
	IxeHkMB0RolNH16xQzg9TBKHpr5iA6liEzCTOLhoNTuILSIgK9H6YA0zSBGzwHtGiXu3u8ES
	wgJREvNuPgOzWQRUJa5fnsfSxcjBwSvgKvF8nwrENkWJ7mcTwGZyCrhJ/HsykQmkRAio5PrE
	yAmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEffM+kdjKsaLA4xCnAwKvHwSnRO
	DhJiTSwrrsw9xCjBwawkwut6HyjEm5JYWZValB9fVJqTWnyIMRnoponMUqLJ+cDEkFcSb2hs
	Ym5qbGppYmFiZkmasJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjAYytXf6njMVXhe/llSR
	KmFg+cMy5/Wbni0fs+O/LOJfctLZ9eyO3/1ua1nZ5yQ0zGRXCTY+/J5h8qHtrfeTo1Q0eSqm
	38rU/50Z5b8+6tHuzxHVz/6p3w1XTo30OZDpssBVzfnAlHvOhd9/35z0aZZxx4681knr2TZV
	3GPs2izz+sX165LJl5VYijMSDbWYi4oTAThl7uACAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fifo_depth of the HSI2C is not constant
Exynos5420 and Exynos5250 supports fifo_depth of 64bytes
Exynos5260 supports fifo_depth of 16bytes

This patch configures the fifo_depth based on HSI2C modules version.

Signed-off-by: Naveen Krishna Chatradhi <ich.naveen@samsung.com>
[For finding out the difference and initial contribution]
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
Changes since v1:
Added missed out Signed-off-by line for initial contribution
Also rebasing on linux-i2c for-next

 drivers/i2c/busses/i2c-exynos5.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 497ff91..a3fdcd8 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -77,12 +77,6 @@
 #define HSI2C_RXFIFO_TRIGGER_LEVEL(x)		((x) << 4)
 #define HSI2C_TXFIFO_TRIGGER_LEVEL(x)		((x) << 16)
 
-/* As per user manual FIFO max depth is 64bytes */
-#define HSI2C_FIFO_MAX				0x40
-/* default trigger levels for Tx and Rx FIFOs */
-#define HSI2C_DEF_TXFIFO_LVL			(HSI2C_FIFO_MAX - 0x30)
-#define HSI2C_DEF_RXFIFO_LVL			(HSI2C_FIFO_MAX - 0x10)
-
 /* I2C_TRAILING_CTL Register bits */
 #define HSI2C_TRAILING_COUNT			(0xf)
 
@@ -187,6 +181,9 @@ struct exynos5_i2c {
 
 	/* Version of HS-I2C Hardware */
 	unsigned int		version;
+
+	/* FIFO depth */
+	unsigned int		fifo_depth;
 };
 
 enum hsi2c_version {
@@ -437,7 +434,7 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
 		fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
 		fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
 
-		len = HSI2C_FIFO_MAX - fifo_level;
+		len = i2c->fifo_depth - fifo_level;
 		if (len > (i2c->msg->len - i2c->msg_ptr))
 			len = i2c->msg->len - i2c->msg_ptr;
 
@@ -505,6 +502,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	u32 i2c_auto_conf = 0;
 	u32 fifo_ctl;
 	unsigned long flags;
+	unsigned short trig_lvl;
 
 	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
 	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
@@ -515,13 +513,19 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 
 		i2c_auto_conf = HSI2C_READ_WRITE;
 
-		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(HSI2C_DEF_TXFIFO_LVL);
+		trig_lvl = (i2c->msg->len > i2c->fifo_depth) ?
+			(i2c->fifo_depth * 3/4) : i2c->msg->len;
+		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(trig_lvl);
+
 		int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
 			HSI2C_INT_TRAILING_EN);
 	} else {
 		i2c_ctl |= HSI2C_TXCHON;
 
-		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(HSI2C_DEF_RXFIFO_LVL);
+		trig_lvl = (i2c->msg->len > i2c->fifo_depth) ?
+			(i2c->fifo_depth * 1/4) : i2c->msg->len;
+		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(trig_lvl);
+
 		int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
 	}
 
@@ -716,10 +720,13 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	i2c->version = exynos5_i2c_get_version(pdev);
 
 	/* The HS-I2C core on Exynos5260 needs a reset to start with */
-	if (i2c->version == EXYNOS_5260)
+	if (i2c->version == EXYNOS_5260) {
+		i2c->fifo_depth = 16;
 		exynos5_i2c_reset(i2c);
-	else
+	} else {
+		i2c->fifo_depth = 64;
 		exynos5_i2c_init(i2c);
+	}
 
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret < 0) {
-- 
1.7.10.4

