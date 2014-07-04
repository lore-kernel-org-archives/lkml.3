Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaGDI4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:56:39 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34705 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbaGDI4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:56:36 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dianders@chromium.org, tiwai@suse.de, perex@perex.cz,
        broonie@kernel.org, lgirdwood@gmail.com, galak@codeaurora.org,
        kgene.kim@samsung.com, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        trblinux@gmail.com
Subject: [PATCH 1/2] ASoC: samsung: Update sound-card name for Snow
Date: Fri,  4 Jul 2014 14:22:59 +0530
Message-Id: <1404463980-25027-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Snow sound-card driver supports multiple boards with different
audio codecs. Updating the sound card name per board basis would provide
some more information to the end-user.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 Documentation/devicetree/bindings/sound/snow.txt |    4 ++++
 sound/soc/samsung/snow.c                         |    3 +++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/snow.txt b/Documentation/devicetree/bindings/sound/snow.txt
index e0b7a82..6df74f1 100644
--- a/Documentation/devicetree/bindings/sound/snow.txt
+++ b/Documentation/devicetree/bindings/sound/snow.txt
@@ -8,11 +8,15 @@ Required properties:
 - samsung,i2s-controller: The phandle of the Samsung I2S controller
 - samsung,audio-codec: The phandle of the audio codec
 
+Optional:
+- samsung,model: The name of the sound-card
+
 Example:
 
 sound {
 		compatible = "google,snow-audio-max98095";
 
+		samsung,model = "Snow-I2S-MAX98095";
 		samsung,i2s-controller = <&i2s0>;
 		samsung,audio-codec = <&max98095>;
 };
diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
index 8bbd348..0acf5d0 100644
--- a/sound/soc/samsung/snow.c
+++ b/sound/soc/samsung/snow.c
@@ -92,6 +92,9 @@ static int snow_probe(struct platform_device *pdev)
 
 	card->dev = &pdev->dev;
 
+	/* Update card-name if provided through DT, else use default name */
+	snd_soc_of_parse_card_name(card, "samsung,model");
+
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
-- 
1.7.9.5

