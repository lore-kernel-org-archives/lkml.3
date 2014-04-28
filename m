Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaD1OIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:08:17 -0400
Received: from ring0.de ([5.45.105.125]:52026 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbaD1OII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:08:08 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv2 7/9] ASoC: omap: rx51: Add some error messages
Date: Mon, 28 Apr 2014 16:07:25 +0200
Message-Id: <1398694047-28596-8-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398694047-28596-1-git-send-email-sre@kernel.org>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more error messages making it easier to identify problems.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/omap/rx51.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 30cfac0..110deca 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -298,20 +298,26 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_nc_pin(dapm, "LINE1R");
 
 	err = tpa6130a2_add_controls(codec);
-	if (err < 0)
+	if (err < 0) {
+		dev_err(card->dev, "Failed to add TPA6130A2 controls\n");
 		return err;
+	}
 	snd_soc_limit_volume(codec, "TPA6130A2 Headphone Playback Volume", 42);
 
 	err = omap_mcbsp_st_add_controls(rtd, 2);
-	if (err < 0)
+	if (err < 0) {
+		dev_err(card->dev, "Failed to add MCBSP controls\n");
 		return err;
+	}
 
 	/* AV jack detection */
 	err = snd_soc_jack_new(codec, "AV Jack",
 			       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
 			       &rx51_av_jack);
-	if (err)
+	if (err) {
+		dev_err(card->dev, "Failed to add AV Jack\n");
 		return err;
+	}
 
 	/* prepare gpio for snd_soc_jack_add_gpios */
 	rx51_av_jack_gpios[0].gpio = desc_to_gpio(pdata->jack_detection_gpio);
@@ -320,6 +326,10 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 	err = snd_soc_jack_add_gpios(&rx51_av_jack,
 				     ARRAY_SIZE(rx51_av_jack_gpios),
 				     rx51_av_jack_gpios);
+	if (err) {
+		dev_err(card->dev, "Failed to add GPIOs\n");
+		return err;
+	}
 
 	return err;
 }
-- 
1.9.2

