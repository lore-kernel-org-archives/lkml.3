Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaDWJPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:15:13 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64898 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaDWJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:15:08 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, rdunlap@infradead.org,
        robh+dt@kernel.org
Subject: [PATCH] ASoC: max98095: Add an explicit of_match_table
Date: Wed, 23 Apr 2014 14:43:58 +0530
Message-Id: <1398244438-2124-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create an explicit of_match_table entry for MAX98095 codec. Also
add a binding Documentation for this compatible string.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 .../devicetree/bindings/sound/max98095.txt         |   16 ++++++++++++++++
 sound/soc/codecs/max98095.c                        |    7 +++++++
 2 files changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/max98095.txt

diff --git a/Documentation/devicetree/bindings/sound/max98095.txt b/Documentation/devicetree/bindings/sound/max98095.txt
new file mode 100644
index 0000000..bacbeaa
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/max98095.txt
@@ -0,0 +1,16 @@
+MAX98095 audio CODEC
+
+This device supports I2C only.
+
+Required properties:
+
+- compatible : "maxim,max98095".
+
+- reg : The I2C address of the device.
+
+Example:
+
+max98095: codec@11 {
+	compatible = "maxim,max98095";
+	reg = <0x11>;
+};
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 03f0536..8e548af 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -2399,10 +2399,17 @@ static const struct i2c_device_id max98095_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max98095_i2c_id);
 
+static const struct of_device_id max98095_of_match[] = {
+	{ .compatible = "maxim,max98095", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, max98095_of_match);
+
 static struct i2c_driver max98095_i2c_driver = {
 	.driver = {
 		.name = "max98095",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(max98095_of_match),
 	},
 	.probe  = max98095_i2c_probe,
 	.remove = max98095_i2c_remove,
-- 
1.7.9.5

