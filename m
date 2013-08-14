Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3HNEfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 00:35:48 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41433 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3HNEfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 00:35:47 -0400
From: Ma Haijun <mahaijuns@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ASoC: wm8960: Fix ADC volume bits
Date: Wed, 14 Aug 2013 09:15:38 +0800
Message-Id: <1376442946-2803-1-git-send-email-mahaijuns@gmail.com>
X-Mailer: git-send-email 1.8.1.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ma Haijun <mahaijuns@gmail.com>
---
 sound/soc/codecs/wm8960.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 0a4ffdd..368d39f 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -263,8 +263,8 @@ SOC_SINGLE("ALC Attack", WM8960_ALC3, 0, 15, 0),
 SOC_SINGLE("Noise Gate Threshold", WM8960_NOISEG, 3, 31, 0),
 SOC_SINGLE("Noise Gate Switch", WM8960_NOISEG, 0, 1, 0),
 
-SOC_DOUBLE_R("ADC PCM Capture Volume", WM8960_LINPATH, WM8960_RINPATH,
-	0, 127, 0),
+SOC_DOUBLE_R_TLV("ADC PCM Capture Volume", WM8960_LADC, WM8960_RADC,
+	0, 255, 0, adc_tlv),
 
 SOC_SINGLE_TLV("Left Output Mixer Boost Bypass Volume",
 	       WM8960_BYPASS1, 4, 7, 1, bypass_tlv),
-- 
1.8.1.2

