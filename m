Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab3L2DFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:05:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55000 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab3L2CJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bo Shen" <voice.shen@atmel.com>,
        "Mark Brown" <broonie@linaro.org>,
        "Charles Keepax" <ckeepax@opensource.wolfsonmicro.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.542096980@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 122/185] ASoC: wm8731: fix dsp mode configuration
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Shen <voice.shen@atmel.com>

commit b4af6ef99a60c5b56df137d7accd81ba1ee1254e upstream.

According to WM8731 "PD, Rev 4.9 October 2012" datasheet, when it
works in DSP mode A, LRP = 1, while works in DSP mode B, LRP = 0.
So, fix LRP for DSP mode as the datesheet specification.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8731.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -392,10 +392,10 @@ static int wm8731_set_dai_fmt(struct snd
 		iface |= 0x0001;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-		iface |= 0x0003;
+		iface |= 0x0013;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
-		iface |= 0x0013;
+		iface |= 0x0003;
 		break;
 	default:
 		return -EINVAL;

