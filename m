Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3LBUY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:24:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3LBTRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 024/212] ASoC: arizona: Set FLL to free-run before disabling
Date: Mon,  2 Dec 2013 11:13:35 -0800
Message-Id: <20131202191251.358384912@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

commit 3e68ce1bc72e5d6615677ec5a8b0a9bcb6c7a490 upstream.

The FLL must be placed into free-run mode before disabling
to allow it to entirely shut down.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/arizona.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -1525,6 +1525,8 @@ static void arizona_enable_fll(struct ar
 	try_wait_for_completion(&fll->ok);
 
 	regmap_update_bits(arizona->regmap, fll->base + 1,
+			   ARIZONA_FLL1_FREERUN, 0);
+	regmap_update_bits(arizona->regmap, fll->base + 1,
 			   ARIZONA_FLL1_ENA, ARIZONA_FLL1_ENA);
 	if (fll->ref_src >= 0 && fll->sync_src >= 0 &&
 	    fll->ref_src != fll->sync_src)
@@ -1543,6 +1545,8 @@ static void arizona_disable_fll(struct a
 	struct arizona *arizona = fll->arizona;
 	bool change;
 
+	regmap_update_bits(arizona->regmap, fll->base + 1,
+			   ARIZONA_FLL1_FREERUN, ARIZONA_FLL1_FREERUN);
 	regmap_update_bits_check(arizona->regmap, fll->base + 1,
 				 ARIZONA_FLL1_ENA, 0, &change);
 	regmap_update_bits(arizona->regmap, fll->base + 0x11,


