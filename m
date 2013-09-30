Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3I3Khh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:37:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43396 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3I3KLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Dyer <mike.dyer@md-soft.co.uk>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 015/104] ASoC: wm8960: Fix PLL register writes
Date: Mon, 30 Sep 2013 11:09:52 +0100
Message-Id: <1380535881-9239-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Dyer <mike.dyer@md-soft.co.uk>

commit 85fa532b6ef920b32598df86b194571a7059a77c upstream.

Bit 9 of PLL2,3 and 4 is reserved as '0'. The 24bit fractional part
should be split across each register in 8bit chunks.

Signed-off-by: Mike Dyer <mike.dyer@md-soft.co.uk>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm8960.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 8bc659d..f27448b 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -789,9 +789,9 @@ static int wm8960_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 	if (pll_div.k) {
 		reg |= 0x20;
 
-		snd_soc_write(codec, WM8960_PLL2, (pll_div.k >> 18) & 0x3f);
-		snd_soc_write(codec, WM8960_PLL3, (pll_div.k >> 9) & 0x1ff);
-		snd_soc_write(codec, WM8960_PLL4, pll_div.k & 0x1ff);
+		snd_soc_write(codec, WM8960_PLL2, (pll_div.k >> 16) & 0xff);
+		snd_soc_write(codec, WM8960_PLL3, (pll_div.k >> 8) & 0xff);
+		snd_soc_write(codec, WM8960_PLL4, pll_div.k & 0xff);
 	}
 	snd_soc_write(codec, WM8960_PLL1, reg);
 
-- 
1.8.3.2

