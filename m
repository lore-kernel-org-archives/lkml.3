Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3AWLsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:48:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44991 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab3AWLsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:48:39 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 07/12] video: da8xx-fb: minimal dt support
Date: Wed, 23 Jan 2013 17:18:29 +0530
Message-ID: <16c9779fb53323bb68bc9b6c9d86f61da8297088.1358937685.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358937685.git.afzal@ti.com>
References: <cover.1358937685.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver is provided a means to have the probe triggered by DT.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 Documentation/devicetree/bindings/video/fb-da8xx.txt | 16 ++++++++++++++++
 drivers/video/da8xx-fb.c                             |  7 +++++++
 2 files changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/fb-da8xx.txt

diff --git a/Documentation/devicetree/bindings/video/fb-da8xx.txt b/Documentation/devicetree/bindings/video/fb-da8xx.txt
new file mode 100644
index 0000000..581e014
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/fb-da8xx.txt
@@ -0,0 +1,16 @@
+TI LCD Controller on DA830/DA850/AM335x SoC's
+
+Required properties:
+- compatible:
+	DA830 - "ti,da830-lcdc"
+	AM335x SoC's - "ti,am3352-lcdc", "ti,da830-lcdc"
+- reg: Address range of lcdc register set
+- interrupts: lcdc interrupt
+
+Example:
+
+lcdc@4830e000 {
+	compatible = "ti,am3352-lcdc", "ti,da830-lcdc";
+	reg =  <0x4830e000 0x1000>;
+	interrupts = <36>;
+};
diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index b6ea5e9..08ee8eb 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1595,6 +1595,12 @@ static int fb_resume(struct platform_device *dev)
 #define fb_resume NULL
 #endif
 
+static const struct of_device_id da8xx_fb_of_match[] = {
+	{.compatible = "ti,da830-lcdc", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, da8xx_fb_of_match);
+
 static struct platform_driver da8xx_fb_driver = {
 	.probe = fb_probe,
 	.remove = fb_remove,
@@ -1603,6 +1609,7 @@ static struct platform_driver da8xx_fb_driver = {
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(da8xx_fb_of_match),
 		   },
 };
 
-- 
1.7.12

