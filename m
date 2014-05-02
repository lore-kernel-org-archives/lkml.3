Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaEBQAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:00:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44149 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaEBPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 089/151] spi: efm32: use $vendor,$device scheme for compatible string
Date: Fri,  2 May 2014 08:37:57 -0700
Message-Id: <1399045139-4531-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

commit 12f6dd860cf8bf036c0bec38c00a53da71bcd43a upstream.

Wolfram Sang pointed out that "efm32,$device" is non-standard. So use the
common scheme and prefix device with "efm32-". The old compatible string
is left in place until arch/arm/boot/dts/efm32* is fixed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/devicetree/bindings/spi/efm32-spi.txt | 4 ++--
 drivers/spi/spi-efm32.c                             | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/efm32-spi.txt b/Documentation/devicetree/bindings/spi/efm32-spi.txt
index a590ca5..f762e11 100644
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
index d4d3cc5..8933eb7 100644
--- a/drivers/spi/spi-efm32.c
+++ b/drivers/spi/spi-efm32.c
@@ -487,6 +487,9 @@ static int efm32_spi_remove(struct platform_device *pdev)
 
 static const struct of_device_id efm32_spi_dt_ids[] = {
 	{
+		.compatible = "energymicro,efm32-spi",
+	}, {
+		/* doesn't follow the "vendor,device" scheme, don't use */
 		.compatible = "efm32,spi",
 	}, {
 		/* sentinel */
-- 
1.9.1

