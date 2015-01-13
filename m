Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbbAMJeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:34:19 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:61390 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921AbbAMJeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:34:17 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: <ckeepax@opensource.wolfsonmicro.com>, <lars@metafoo.de>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v2] ASoC: wm8904: fix runtime warning
Date: Tue, 13 Jan 2015 17:34:02 +0800
Message-ID: <1421141643-30105-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the path name for mux to get rid of the following warning:

--->8---
wm8904 1-001a: Control not supported for path ADCL -> [Left] -> AIFOUTL
wm8904 1-001a: ASoC: no dapm match for ADCL --> Left --> AIFOUTL
wm8904 1-001a: ASoC: Failed to add route ADCL -> Left -> AIFOUTL
wm8904 1-001a: Control not supported for path ADCR -> [Right] -> AIFOUTL
wm8904 1-001a: ASoC: no dapm match for ADCR --> Right --> AIFOUTL
wm8904 1-001a: ASoC: Failed to add route ADCR -> Right -> AIFOUTL
wm8904 1-001a: Control not supported for path ADCL -> [Left] -> AIFOUTR
wm8904 1-001a: ASoC: no dapm match for ADCL --> Left --> AIFOUTR
wm8904 1-001a: ASoC: Failed to add route ADCL -> Left -> AIFOUTR
wm8904 1-001a: Control not supported for path ADCR -> [Right] -> AIFOUTR
wm8904 1-001a: ASoC: no dapm match for ADCR --> Right --> AIFOUTR
wm8904 1-001a: ASoC: Failed to add route ADCR -> Right -> AIFOUTR
wm8904 1-001a: Control not supported for path AIFINR -> [Right] -> DACL
wm8904 1-001a: ASoC: no dapm match for AIFINR --> Right --> DACL
wm8904 1-001a: ASoC: Failed to add route AIFINR -> Right -> DACL
wm8904 1-001a: Control not supported for path AIFINL -> [Left] -> DACL
wm8904 1-001a: ASoC: no dapm match for AIFINL --> Left --> DACL
wm8904 1-001a: ASoC: Failed to add route AIFINL -> Left -> DACL
wm8904 1-001a: Control not supported for path AIFINR -> [Right] -> DACR
wm8904 1-001a: ASoC: no dapm match for AIFINR --> Right --> DACR
wm8904 1-001a: ASoC: Failed to add route AIFINR -> Right -> DACR
wm8904 1-001a: Control not supported for path AIFINL -> [Left] -> DACR
wm8904 1-001a: ASoC: no dapm match for AIFINL --> Left --> DACR
wm8904 1-001a: ASoC: Failed to add route AIFINL -> Left -> DACR
---8<---

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

Changes in v2:
- Correct the mux path name.
- Route the mux to the pins.

 sound/soc/codecs/wm8904.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 4d2d2b1..110d0e6 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -1076,10 +1076,13 @@ static const struct snd_soc_dapm_route adc_intercon[] = {
 	{ "Right Capture PGA", NULL, "Right Capture Mux" },
 	{ "Right Capture PGA", NULL, "Right Capture Inverting Mux" },
 
-	{ "AIFOUTL", "Left",  "ADCL" },
-	{ "AIFOUTL", "Right", "ADCR" },
-	{ "AIFOUTR", "Left",  "ADCL" },
-	{ "AIFOUTR", "Right", "ADCR" },
+	{ "AIFOUTL Mux", "Left", "ADCL" },
+	{ "AIFOUTL Mux", "Right", "ADCR" },
+	{ "AIFOUTR Mux", "Left", "ADCL" },
+	{ "AIFOUTR Mux", "Right", "ADCR" },
+
+	{ "AIFOUTL", NULL, "AIFOUTL Mux" },
+	{ "AIFOUTR", NULL, "AIFOUTR Mux" },
 
 	{ "ADCL", NULL, "CLK_DSP" },
 	{ "ADCL", NULL, "Left Capture PGA" },
@@ -1089,14 +1092,20 @@ static const struct snd_soc_dapm_route adc_intercon[] = {
 };
 
 static const struct snd_soc_dapm_route dac_intercon[] = {
-	{ "DACL", "Right", "AIFINR" },
-	{ "DACL", "Left",  "AIFINL" },
+	{ "DACL", NULL, "AIFINL" },
+	{ "DACL", NULL, "AIFINR" },
 	{ "DACL", NULL, "CLK_DSP" },
 
-	{ "DACR", "Right", "AIFINR" },
-	{ "DACR", "Left",  "AIFINL" },
+	{ "DACR", NULL, "AIFINL" },
+	{ "DACR", NULL, "AIFINR" },
 	{ "DACR", NULL, "CLK_DSP" },
 
+	{ "DACL Mux", "Left", "DACL" },
+	{ "DACL Mux", "Right", "DACR" },
+
+	{ "DACR Mux", "Left", "DACL" },
+	{ "DACR Mux", "Right", "DACR" },
+
 	{ "Charge pump", NULL, "SYSCLK" },
 
 	{ "Headphone Output", NULL, "HPL PGA" },
-- 
2.1.0.24.g4109c28

