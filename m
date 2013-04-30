Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab3D3OKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:10:42 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:43132 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab3D3OKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:10:38 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/3] ASoC: ux500: move clock controls to ab8500-codec
Date: Tue, 30 Apr 2013 16:09:53 +0200
Message-Id: <1367330994-7259-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
References: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ab8500 clock control definitions to the ab8500 codec driver,
leaving only card specific setting in mop500_ab8500_ctrls.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c | 10 ++++++++++
 sound/soc/ux500/mop500_ab8500.c | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index a153b16..925e625 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1615,6 +1615,16 @@ static SOC_ENUM_SINGLE_EXT_DECL(soc_enum_sidstate, enum_sid_state);
 static SOC_ENUM_SINGLE_EXT_DECL(soc_enum_ancstate, enum_anc_state);
 
 static struct snd_kcontrol_new ab8500_ctrls[] = {
+	/* Digital interface - Clocks */
+	SOC_SINGLE("Digital Interface Master Generator Switch",
+		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENMASTGEN,
+		1, 0),
+	SOC_SINGLE("Digital Interface 0 Bit-clock Switch",
+		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENFSBITCLK0,
+		1, 0),
+	SOC_SINGLE("Digital Interface 1 Bit-clock Switch",
+		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENFSBITCLK1,
+		1, 0),
 	/* Charge pump */
 	SOC_ENUM("Charge Pump High Threshold For Low Voltage",
 		soc_enum_envdeththre),
diff --git a/sound/soc/ux500/mop500_ab8500.c b/sound/soc/ux500/mop500_ab8500.c
index 78cce23..1a5c6b9 100644
--- a/sound/soc/ux500/mop500_ab8500.c
+++ b/sound/soc/ux500/mop500_ab8500.c
@@ -162,16 +162,6 @@ static struct snd_kcontrol_new mop500_ab8500_ctrls[] = {
 	SOC_ENUM_EXT("Master Clock Select",
 		soc_enum_mclk,
 		mclk_input_control_get, mclk_input_control_put),
-	/* Digital interface - Clocks */
-	SOC_SINGLE("Digital Interface Master Generator Switch",
-		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENMASTGEN,
-		1, 0),
-	SOC_SINGLE("Digital Interface 0 Bit-clock Switch",
-		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENFSBITCLK0,
-		1, 0),
-	SOC_SINGLE("Digital Interface 1 Bit-clock Switch",
-		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENFSBITCLK1,
-		1, 0),
 	SOC_DAPM_PIN_SWITCH("Headset Left"),
 	SOC_DAPM_PIN_SWITCH("Headset Right"),
 	SOC_DAPM_PIN_SWITCH("Earpiece"),
-- 
1.8.2

