Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbbATHnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:43:39 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:22436 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293AbbATHnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:43:37 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <Songjun.Wu@atmel.com>, <peda@lysator.liu.se>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v2 2/2] ASoC: atmel_ssc_dai: remove clock pin comments
Date: Tue, 20 Jan 2015 15:43:17 +0800
Message-ID: <1421739797-25988-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.3.0.rc0
In-Reply-To: <1421739797-25988-1-git-send-email-voice.shen@atmel.com>
References: <1421739797-25988-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the clock can be get from TK/RK pin, so remove the comments.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

Changes in v2:
 - remove the comments for DSP mode A, codec as master

 sound/soc/atmel/atmel_ssc_dai.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index e691aab..3cd7059 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -450,13 +450,7 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 		break;
 
 	case SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBM_CFM:
-		/*
-		 * I2S format, CODEC supplies BCLK and LRC clocks.
-		 *
-		 * The SSC transmit clock is obtained from the BCLK signal on
-		 * on the TK line, and the SSC receive clock is
-		 * generated from the transmit clock.
-		 */
+		/* I2S format, CODEC supplies BCLK and LRC clocks. */
 		rcmr =	  SSC_BF(RCMR_PERIOD, 0)
 			| SSC_BF(RCMR_STTDLY, START_DELAY)
 			| SSC_BF(RCMR_START, SSC_START_FALLING_RF)
@@ -535,10 +529,6 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 		/*
 		 * DSP/PCM Mode A format, CODEC supplies BCLK and LRC clocks.
 		 *
-		 * The SSC transmit clock is obtained from the BCLK signal on
-		 * on the TK line, and the SSC receive clock is
-		 * generated from the transmit clock.
-		 *
 		 * Data is transferred on first BCLK after LRC pulse rising
 		 * edge.If stereo, the right channel data is contiguous with
 		 * the left channel data.
-- 
2.3.0.rc0

