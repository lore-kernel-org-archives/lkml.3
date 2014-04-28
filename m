Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaD1OO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:14:58 -0400
Received: from ring0.de ([5.45.105.125]:51772 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbaD1OHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:07:40 -0400
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
Subject: [PATCHv2 1/9] ASoC: omap: rx51: Use static const char * const arrays
Date: Mon, 28 Apr 2014 16:07:19 +0200
Message-Id: <1398694047-28596-2-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398694047-28596-1-git-send-email-sre@kernel.org>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the array and the string const by using "static const char * const
foo[]" instead of "static const char* foo[]".

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/omap/rx51.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index add0047..1a3f05c 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -258,9 +258,11 @@ static const struct snd_soc_dapm_route audio_map[] = {
 	{"b Mic Bias", NULL, "HS Mic"}
 };
 
-static const char *spk_function[] = {"Off", "On"};
-static const char *input_function[] = {"ADC", "Digital Mic"};
-static const char *jack_function[] = {"Off", "TV-OUT", "Headphone", "Headset"};
+static const char * const spk_function[] = {"Off", "On"};
+static const char * const input_function[] = {"ADC", "Digital Mic"};
+static const char * const jack_function[] = {
+	"Off", "TV-OUT", "Headphone", "Headset"
+};
 
 static const struct soc_enum rx51_enum[] = {
 	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(spk_function), spk_function),
-- 
1.9.2

