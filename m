Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3JGRgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:36:46 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:11535
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756475Ab3JGRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:36:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz1102Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <shawn.guo@linaro.org>
CC: <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>
Subject: [PATCH 2/2] mmc: sdhci-esdhc-imx: Remove custom properties
Date: Mon, 7 Oct 2013 14:32:24 -0300
Message-ID: <1381167144-18098-2-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381167144-18098-1-git-send-email-fabio.estevam@freescale.com>
References: <1381167144-18098-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/devicetree/bindings/mmc/mmc.txt:

"Card detection:
If no property below is supplied, host native card detect is used.
Only one of the properties in this section should be supplied:
  - broken-cd: There is no card detection available; polling must be used.
  - cd-gpios: Specify GPIOs for card detection, see gpio binding
  - non-removable: non-removable slot (like eMMC); assume always present. "

So remove the custom fsl,cd-controller and fsl,wp-controller properties, as the
mmc core can take care of it.

Tested on mx51babbage, mx53qsb boards and mx6qsabresd boards.

Cc: Chris Ball <cjb@laptop.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt | 6 ------
 drivers/mmc/host/sdhci-esdhc-imx.c                      | 6 ------
 2 files changed, 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
index 1dd6225..5da8ab0 100644
--- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
+++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
@@ -9,18 +9,12 @@ by mmc.txt and the properties used by the sdhci-esdhc-imx driver.
 Required properties:
 - compatible : Should be "fsl,<chip>-esdhc"
 
-Optional properties:
-- fsl,cd-controller : Indicate to use controller internal card detection
-- fsl,wp-controller : Indicate to use controller internal write protection
-
 Examples:
 
 esdhc@70004000 {
 	compatible = "fsl,imx51-esdhc";
 	reg = <0x70004000 0x4000>;
 	interrupts = <1>;
-	fsl,cd-controller;
-	fsl,wp-controller;
 };
 
 esdhc@70008000 {
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index b9899e9..07662d1 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -796,12 +796,6 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
 	if (of_get_property(np, "non-removable", NULL))
 		boarddata->cd_type = ESDHC_CD_PERMANENT;
 
-	if (of_get_property(np, "fsl,cd-controller", NULL))
-		boarddata->cd_type = ESDHC_CD_CONTROLLER;
-
-	if (of_get_property(np, "fsl,wp-controller", NULL))
-		boarddata->wp_type = ESDHC_WP_CONTROLLER;
-
 	boarddata->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
 	if (gpio_is_valid(boarddata->cd_gpio))
 		boarddata->cd_type = ESDHC_CD_GPIO;
-- 
1.8.1.2


