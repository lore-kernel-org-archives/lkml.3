Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbaFTIGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:06:41 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42567 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbaFTIGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:06:36 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: dianders@chromium.org, kgene.kim@samsung.com, tiwai@suse.de,
        broonie@kernel.org, lgirdwood@gmail.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, trblinux@gmail.com,
        Wonjoon Lee <woojoo.lee@samsung.com>
Subject: [PATCH 1/2] ASoC: max98090: Add max98091 compatible string
Date: Fri, 20 Jun 2014 13:33:15 +0530
Message-Id: <1403251396-17487-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wonjoon Lee <woojoo.lee@samsung.com>

The MAX98091 CODEC is the same as MAX98090 CODEC, but with an extra
microphone. Existing driver for MAX98090 CODEC already has support
for MAX98091 CODEC. Adding proper compatible string so that MAX98091
CODEC can be specified from device tree.

Signed-off-by: Wonjoon Lee <woojoo.lee@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---

Picked from https://chromium-review.googlesource.com/#/c/184091/

 .../devicetree/bindings/sound/max98090.txt         |    2 +-
 sound/soc/codecs/max98090.c                        |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/max98090.txt b/Documentation/devicetree/bindings/sound/max98090.txt
index a5e63fa..c454e67 100644
--- a/Documentation/devicetree/bindings/sound/max98090.txt
+++ b/Documentation/devicetree/bindings/sound/max98090.txt
@@ -4,7 +4,7 @@ This device supports I2C only.
 
 Required properties:
 
-- compatible : "maxim,max98090".
+- compatible : "maxim,max98090" or "maxim,max98091".
 
 - reg : The I2C address of the device.
 
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index f5fccc7..4f5534d 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2460,12 +2460,14 @@ static const struct dev_pm_ops max98090_pm = {
 
 static const struct i2c_device_id max98090_i2c_id[] = {
 	{ "max98090", MAX98090 },
+	{ "max98091", MAX98091 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max98090_i2c_id);
 
 static const struct of_device_id max98090_of_match[] = {
 	{ .compatible = "maxim,max98090", },
+	{ .compatible = "maxim,max98091", },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, max98090_of_match);
-- 
1.7.9.5

