Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaAOWHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:07:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaAOWAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 081/166] ASoC: wm8904: fix DSP mode B configuration
Date: Wed, 15 Jan 2014 13:51:35 -0800
Message-Id: <1389822780-4729-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Shen <voice.shen@atmel.com>

commit f0199bc5e3a3ec13f9bc938556517ec430b36437 upstream.

When wm8904 work in DSP mode B, we still need to configure it to
work in DSP mode. Or else, it will work in Right Justified mode.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm8904.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 3ff195c..af62f84 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -1449,7 +1449,7 @@ static int wm8904_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_DSP_B:
-		aif1 |= WM8904_AIF_LRCLK_INV;
+		aif1 |= 0x3 | WM8904_AIF_LRCLK_INV;
 	case SND_SOC_DAIFMT_DSP_A:
 		aif1 |= 0x3;
 		break;
-- 
1.8.3.2

