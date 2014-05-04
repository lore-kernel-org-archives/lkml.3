Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaEDPl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaEDPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 030/158] spi: efm32: use $vendor,$device scheme for compatible string
Date: Sun,  4 May 2014 11:38:59 -0400
Message-Id: <20140504154034.082668346@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 12f6dd860cf8bf036c0bec38c00a53da71bcd43a upstream.

Wolfram Sang pointed out that "efm32,$device" is non-standard. So use the
common scheme and prefix device with "efm32-". The old compatible string
is left in place until arch/arm/boot/dts/efm32* is fixed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/spi/efm32-spi.txt |    4 ++--
 drivers/spi/spi-efm32.c                             |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

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
--- a/drivers/spi/spi-efm32.c
+++ b/drivers/spi/spi-efm32.c
@@ -487,6 +487,9 @@ static int efm32_spi_remove(struct platf
 
 static const struct of_device_id efm32_spi_dt_ids[] = {
 	{
+		.compatible = "energymicro,efm32-spi",
+	}, {
+		/* doesn't follow the "vendor,device" scheme, don't use */
 		.compatible = "efm32,spi",
 	}, {
 		/* sentinel */


