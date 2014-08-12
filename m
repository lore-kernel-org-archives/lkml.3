Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaHLLn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:43:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50423 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbaHLLn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:43:57 -0400
From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] ASoC: wm8994: register irq handler for mic1 detect
Date: Tue, 12 Aug 2014 12:43:49 +0100
Message-Id: <1407843829-4908-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm8994.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 247b390..24bcbe3 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -4099,6 +4099,15 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 				dev_warn(codec->dev,
 					 "Failed to request Mic1 detect IRQ: %d\n",
 					 ret);
+		} else {
+			ret = wm8994_request_irq(wm8994->wm8994,
+					WM8994_IRQ_MIC1_DET,
+					wm8994_mic_irq, "Mic 1 detect",
+					wm8994);
+			if (ret != 0)
+				dev_warn(codec->dev,
+				"Failed to request Mic1 detect IRQ: %d\n",
+				ret);
 		}
 
 		ret = wm8994_request_irq(wm8994->wm8994,
-- 
1.7.9.5

