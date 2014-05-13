Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbaEMKk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60772 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760038AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 028/182] spi: efm32: use $vendor,$device scheme for compatible string
Date: Tue, 13 May 2014 11:26:20 +0200
Message-Id: <1544d853bb180578a777fac69a2d80e46b75b249.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 12f6dd860cf8bf036c0bec38c00a53da71bcd43a upstream.

Wolfram Sang pointed out that "efm32,$device" is non-standard. So use the
common scheme and prefix device with "efm32-". The old compatible string
is left in place until arch/arm/boot/dts/efm32* is fixed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Documentation/devicetree/bindings/spi/efm32-spi.txt | 4 ++--
 drivers/spi/spi-efm32.c                             | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/efm32-spi.txt b/Documentation/devicetree/bindings/spi/efm32-spi.txt
index a590ca51be75..f762e11bfe11 100644
--- a/Documentation/devicetree/bindings/spi/efm32-spi.txt
+++ b/Documentation/devicetree/bindings/spi/efm32-spi.txt
@@ -3,7 +3,7 @@
 Required properties:
 - #address-cells: see spi-bus.txt
 - #size-cells: see spi-bus.txt
-- compatible: should be "efm32,spi"
+- compatible: should be "energymicro,efm32-spi"
 - reg: Offset and length of the register set for the controller
 - interrupts: pair specifying rx and tx irq
 - clocks: phandle to the spi clock
@@ -15,7 +15,7 @@ Example:
 spi1: spi@0x4000c400 { /* USART1 */
 	#address-cells = <1>;
 	#size-cells = <0>;
-	compatible = "efm32,spi";
+	compatible = "energymicro,efm32-spi";
 	reg = <0x4000c400 0x400>;
 	interrupts = <15 16>;
 	clocks = <&cmu 20>;
diff --git a/drivers/spi/spi-efm32.c b/drivers/spi/spi-efm32.c
index 7d84418a01d8..cc6a997d4cda 100644
--- a/drivers/spi/spi-efm32.c
+++ b/drivers/spi/spi-efm32.c
@@ -491,6 +491,9 @@ static int efm32_spi_remove(struct platform_device *pdev)
 
 static const struct of_device_id efm32_spi_dt_ids[] = {
 	{
+		.compatible = "energymicro,efm32-spi",
+	}, {
+		/* doesn't follow the "vendor,device" scheme, don't use */
 		.compatible = "efm32,spi",
 	}, {
 		/* sentinel */
-- 
1.9.3

