Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3IYB2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:28:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3IYAM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Dyer <mike.dyer@md-soft.co.uk>, Mark Brown <broonie@linaro.org>
Subject: [ 16/40] ASoC: wm8960: Fix PLL register writes
Date: Tue, 24 Sep 2013 17:11:48 -0700
Message-Id: <20130925001043.718874937@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Dyer <mike.dyer@md-soft.co.uk>

commit 85fa532b6ef920b32598df86b194571a7059a77c upstream.

Bit 9 of PLL2,3 and 4 is reserved as '0'. The 24bit fractional part
should be split across each register in 8bit chunks.

Signed-off-by: Mike Dyer <mike.dyer@md-soft.co.uk>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8960.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -790,9 +790,9 @@ static int wm8960_set_dai_pll(struct snd
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
 


