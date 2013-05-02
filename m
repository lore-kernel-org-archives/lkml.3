Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3EBJxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:53:17 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:55248 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3EBJxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:53:16 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2 2/3] ASoC: ux500: drop clock gating widgets from machine driver
Date: Thu,  2 May 2013 11:52:51 +0200
Message-Id: <1367488371-18346-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <20130502075421.GA23346@balto.lan>
References: <20130502075421.GA23346@balto.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop ab8500 clock gating widgets from mop500_ab8500_ctrls, as these bits
are already controlled by ab8500 codec driver and should not be exposed
to the user.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Was: ASoC: ux500: move clock controls to ab8500-codec

Changes from v1:
- rewrote the patch to just drop the widgets, as those allowed the user
  to control some bits already handled by the codec driver.

 sound/soc/ux500/mop500_ab8500.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/sound/soc/ux500/mop500_ab8500.c b/sound/soc/ux500/mop500_ab8500.c
index 2c122de..4606194 100644
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

