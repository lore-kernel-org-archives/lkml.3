Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3EHHPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 03:15:46 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64302 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab3EHHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 03:15:42 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 6/6] ASoC: ux500: Use the first two AD slots for capture
Date: Wed,  8 May 2013 09:14:21 +0200
Message-Id: <1367997261-32048-7-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set AD_OUT1 and AD_OUT2, corresponding to LINL and LINR pins, as the
default input slots for the capture interfaces.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 7c026d4..9dafd52 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2334,17 +2334,18 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	case 0:
 		break;
 	case 1:
-		/* AD_OUT3 -> slot 0 & 1 */
-		snd_soc_update_bits(codec, AB8500_ADSLOTSEL1, AB8500_MASK_ALL,
-				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN |
-				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_ODD);
+		/* AD_OUT1 -> slot 0 & 1 */
+		snd_soc_update_bits(codec, AB8500_ADSLOTSEL1,
+				AB8500_MASK_ALL,
+				AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_EVEN |
+				AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_ODD);
 		break;
 	case 2:
-		/* AD_OUT3 -> slot 0, AD_OUT2 -> slot 1 */
+		/* AD_OUT1 -> slot 0, AD_OUT2 -> slot 1 */
 		snd_soc_update_bits(codec,
 				AB8500_ADSLOTSEL1,
 				AB8500_MASK_ALL,
-				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN |
+				AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_EVEN |
 				AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_ODD);
 		break;
 	case 8:
-- 
1.8.2

