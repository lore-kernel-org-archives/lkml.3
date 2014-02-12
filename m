Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBLIOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:14:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50148 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbaBLIN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Charles Keepax" <ckeepax@opensource.wolfsonmicro.com>,
        "Mark Brown" <broonie@linaro.org>, "Bo Shen" <voice.shen@atmel.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.365780973@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 52/79] ASoC: wm8904: fix DSP mode B configuration
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Shen <voice.shen@atmel.com>

commit f0199bc5e3a3ec13f9bc938556517ec430b36437 upstream.

When wm8904 work in DSP mode B, we still need to configure it to
work in DSP mode. Or else, it will work in Right Justified mode.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8904.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -1714,7 +1714,7 @@ static int wm8904_set_fmt(struct snd_soc
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_DSP_B:
-		aif1 |= WM8904_AIF_LRCLK_INV;
+		aif1 |= 0x3 | WM8904_AIF_LRCLK_INV;
 	case SND_SOC_DAIFMT_DSP_A:
 		aif1 |= 0x3;
 		break;

