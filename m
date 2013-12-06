Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157Ab3LFNAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:00:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43653 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161114Ab3LFNAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 030/272] ASoC: arizona: Set FLL to free-run before disabling
Date: Fri,  6 Dec 2013 12:55:19 +0000
Message-Id: <1386334761-25517-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

commit 3e68ce1bc72e5d6615677ec5a8b0a9bcb6c7a490 upstream.

The FLL must be placed into free-run mode before disabling
to allow it to entirely shut down.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/arizona.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index de62581..89eff11 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -1462,6 +1462,8 @@ static void arizona_enable_fll(struct arizona_fll *fll,
 	try_wait_for_completion(&fll->ok);
 
 	regmap_update_bits(arizona->regmap, fll->base + 1,
+			   ARIZONA_FLL1_FREERUN, 0);
+	regmap_update_bits(arizona->regmap, fll->base + 1,
 			   ARIZONA_FLL1_ENA, ARIZONA_FLL1_ENA);
 	if (fll->ref_src >= 0 && fll->sync_src >= 0 &&
 	    fll->ref_src != fll->sync_src)
@@ -1480,6 +1482,8 @@ static void arizona_disable_fll(struct arizona_fll *fll)
 	struct arizona *arizona = fll->arizona;
 	bool change;
 
+	regmap_update_bits(arizona->regmap, fll->base + 1,
+			   ARIZONA_FLL1_FREERUN, ARIZONA_FLL1_FREERUN);
 	regmap_update_bits_check(arizona->regmap, fll->base + 1,
 				 ARIZONA_FLL1_ENA, 0, &change);
 	regmap_update_bits(arizona->regmap, fll->base + 0x11,
-- 
1.8.3.2

