Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbbAIIx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:53:56 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:56479 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754154AbbAIIxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:53:54 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] ASoC: wm8904: fix runtime warning
Date: Fri, 9 Jan 2015 16:53:40 +0800
Message-ID: <1420793620-2866-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the commit 5fe5b76 (ASoC: dapm: Do not pretend to support
controls for non mixer/mux widgets) remove the fake control.

Then, the wm8904 throw out the following warning at runtime.
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

This patch is used to remove these warning.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 sound/soc/codecs/wm8904.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 4d2d2b1..38582d7 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -1076,10 +1076,10 @@ static const struct snd_soc_dapm_route adc_intercon[] = {
 	{ "Right Capture PGA", NULL, "Right Capture Mux" },
 	{ "Right Capture PGA", NULL, "Right Capture Inverting Mux" },
 
-	{ "AIFOUTL", "Left",  "ADCL" },
-	{ "AIFOUTL", "Right", "ADCR" },
-	{ "AIFOUTR", "Left",  "ADCL" },
-	{ "AIFOUTR", "Right", "ADCR" },
+	{ "AIFOUTL", NULL, "ADCL" },
+	{ "AIFOUTL", NULL, "ADCR" },
+	{ "AIFOUTR", NULL, "ADCL" },
+	{ "AIFOUTR", NULL, "ADCR" },
 
 	{ "ADCL", NULL, "CLK_DSP" },
 	{ "ADCL", NULL, "Left Capture PGA" },
@@ -1089,12 +1089,12 @@ static const struct snd_soc_dapm_route adc_intercon[] = {
 };
 
 static const struct snd_soc_dapm_route dac_intercon[] = {
-	{ "DACL", "Right", "AIFINR" },
-	{ "DACL", "Left",  "AIFINL" },
+	{ "DACL", NULL, "AIFINR" },
+	{ "DACL", NULL, "AIFINL" },
 	{ "DACL", NULL, "CLK_DSP" },
 
-	{ "DACR", "Right", "AIFINR" },
-	{ "DACR", "Left",  "AIFINL" },
+	{ "DACR", NULL, "AIFINR" },
+	{ "DACR", NULL, "AIFINL" },
 	{ "DACR", NULL, "CLK_DSP" },
 
 	{ "Charge pump", NULL, "SYSCLK" },
-- 
2.1.0.24.g4109c28

