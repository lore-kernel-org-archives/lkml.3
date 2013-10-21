Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3JUJ0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:26:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39420 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511Ab3JUIvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mike Dyer" <mike.dyer@md-soft.co.uk>,
        "Mark Brown" <broonie@linaro.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.707929734@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 028/149] ASoC: wm8960: Fix PLL register writes
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Dyer <mike.dyer@md-soft.co.uk>

commit 85fa532b6ef920b32598df86b194571a7059a77c upstream.

Bit 9 of PLL2,3 and 4 is reserved as '0'. The 24bit fractional part
should be split across each register in 8bit chunks.

Signed-off-by: Mike Dyer <mike.dyer@md-soft.co.uk>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8960.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -805,9 +805,9 @@ static int wm8960_set_dai_pll(struct snd
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
 

