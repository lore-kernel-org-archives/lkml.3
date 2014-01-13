Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaAMOtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:49:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaAMO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 47/96] ASoC: wm8904: fix DSP mode B configuration
Date: Mon, 13 Jan 2014 14:24:10 +0000
Message-Id: <1389623099-18783-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Shen <voice.shen@atmel.com>

commit f0199bc5e3a3ec13f9bc938556517ec430b36437 upstream.

When wm8904 work in DSP mode B, we still need to configure it to
work in DSP mode. Or else, it will work in Right Justified mode.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm8904.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 812acd8..dce77c5 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -1456,7 +1456,7 @@ static int wm8904_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_DSP_B:
-		aif1 |= WM8904_AIF_LRCLK_INV;
+		aif1 |= 0x3 | WM8904_AIF_LRCLK_INV;
 	case SND_SOC_DAIFMT_DSP_A:
 		aif1 |= 0x3;
 		break;
-- 
1.8.3.2

