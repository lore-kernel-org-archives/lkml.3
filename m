Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbaBFSDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:03:50 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.109]:35167 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867AbaBFSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:03:15 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-13.tower-193.messagelabs.com!1391709788!10904308!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <9ec36c0633ae8291267be6802a34a469a34ae292.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 6 Feb 2014 18:03:09 +0000
Subject: [PATCH v2 2/8] ASoC: da9055: Add DT support for CODEC
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 Documentation/devicetree/bindings/sound/da9055.txt |   22 ++++++++++++++++++++
 sound/soc/codecs/da9055.c                          |    8 +++++++
 2 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/da9055.txt

diff --git a/Documentation/devicetree/bindings/sound/da9055.txt b/Documentation/devicetree/bindings/sound/da9055.txt
new file mode 100644
index 0000000..ed1b7cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/da9055.txt
@@ -0,0 +1,22 @@
+* Dialog DA9055 Audio CODEC
+
+DA9055 provides Audio CODEC support (I2C only).
+
+The Audio CODEC device in DA9055 has it's own I2C address which is configurable,
+so the device is instantiated separately from the PMIC (MFD) device.
+
+For details on accompanying PMIC I2C device, see the following:
+Documentation/devicetree/bindings/mfd/da9055.txt
+
+Required properties:
+
+  - compatible: "dlg,da9055-codec"
+  - reg: Specifies the I2C slave address
+
+
+Example:
+
+	codec: da9055-codec@1a {
+		compatible = "dlg,da9055-codec";
+		reg = <0x1a>;
+	};
diff --git a/sound/soc/codecs/da9055.c b/sound/soc/codecs/da9055.c
index 4228126..be31f3c 100644
--- a/sound/soc/codecs/da9055.c
+++ b/sound/soc/codecs/da9055.c
@@ -18,6 +18,8 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
@@ -1536,11 +1538,17 @@ static const struct i2c_device_id da9055_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);

+static const struct of_device_id da9055_of_match[] = {
+	{ .compatible = "dlg,da9055-codec", },
+	{ }
+};
+
 /* I2C codec control layer */
 static struct i2c_driver da9055_i2c_driver = {
 	.driver = {
 		.name = "da9055-codec",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(da9055_of_match),
 	},
 	.probe		= da9055_i2c_probe,
 	.remove		= da9055_remove,
--
1.7.0.4

