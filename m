Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3AXDsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:48:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3AXD1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:27:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 04/74] ASoC: wm2200: Fix setting dai format in wm2200_set_fmt
Date: Thu, 24 Jan 2013 01:26:16 -0200
Message-Id: <1358998046-613-5-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 2a5f431592343b78896013b055582f94c12a5049 upstream.

According to the defines in wm2200.h:
/*
 * R1284 (0x504) - Audio IF 1_5
 */

We should not left shift 1 bit for fmt_val when setting dai format.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/wm2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index c8bff6d..201fc58 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -1440,7 +1440,7 @@ static int wm2200_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 			    WM2200_AIF1TX_LRCLK_MSTR | WM2200_AIF1TX_LRCLK_INV,
 			    lrclk);
 	snd_soc_update_bits(codec, WM2200_AUDIO_IF_1_5,
-			    WM2200_AIF1_FMT_MASK << 1, fmt_val << 1);
+			    WM2200_AIF1_FMT_MASK, fmt_val);
 
 	return 0;
 }
-- 
1.7.9.5

