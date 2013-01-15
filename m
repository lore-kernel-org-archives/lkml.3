Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab3AOSyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:54:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:34539 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271Ab3AOSyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:54:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 028/221] ASoC: wm8994: Use the same DCS codes for all WM1811 variants
Date: Tue, 15 Jan 2013 10:49:15 -0800
Message-Id: <20130115185000.069789181@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 72222be39afbd39c16eb180646b0ac44bb1ba460 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3839,20 +3839,8 @@ static int wm8994_codec_probe(struct snd
 		wm8994->hubs.no_cache_dac_hp_direct = true;
 		wm8994->fll_byp = true;
 
-		switch (control->cust_id) {
-		case 0:
-		case 2:
-			wm8994->hubs.dcs_codes_l = -9;
-			wm8994->hubs.dcs_codes_r = -7;
-			break;
-		case 1:
-		case 3:
-			wm8994->hubs.dcs_codes_l = -8;
-			wm8994->hubs.dcs_codes_r = -7;
-			break;
-		default:
-			break;
-		}
+		wm8994->hubs.dcs_codes_l = -9;
+		wm8994->hubs.dcs_codes_r = -7;
 
 		snd_soc_update_bits(codec, WM8994_ANALOGUE_HP_1,
 				    WM1811_HPOUT1_ATTN, WM1811_HPOUT1_ATTN);


