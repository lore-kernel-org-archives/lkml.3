Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3KTOhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:37:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49631 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976Ab3KTOhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:37:13 -0500
Date: Wed, 20 Nov 2013 14:37:09 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, tiwai@suse.de, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        perex@perex.cz
Subject: [PATCH v2 1/1] ASoC: arizona: Set FLL to free-run before disabling
Message-ID: <20131120143709.GA12897@opensource.wolfsonmicro.com>
References: <20131120131547.GA7357@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120131547.GA7357@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FLL must be placed into free-run mode before disabling
to allow it to entirely shut down.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/arizona.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index 6f05b17..fea9910 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -1529,6 +1529,8 @@ static void arizona_enable_fll(struct arizona_fll *fll,
 	try_wait_for_completion(&fll->ok);
 
 	regmap_update_bits(arizona->regmap, fll->base + 1,
+			   ARIZONA_FLL1_FREERUN, 0);
+	regmap_update_bits(arizona->regmap, fll->base + 1,
 			   ARIZONA_FLL1_ENA, ARIZONA_FLL1_ENA);
 	if (use_sync)
 		regmap_update_bits(arizona->regmap, fll->base + 0x11,
@@ -1546,6 +1548,8 @@ static void arizona_disable_fll(struct arizona_fll *fll)
 	struct arizona *arizona = fll->arizona;
 	bool change;
 
+	regmap_update_bits(arizona->regmap, fll->base + 1,
+			   ARIZONA_FLL1_FREERUN, ARIZONA_FLL1_FREERUN);
 	regmap_update_bits_check(arizona->regmap, fll->base + 1,
 				 ARIZONA_FLL1_ENA, 0, &change);
 	regmap_update_bits(arizona->regmap, fll->base + 0x11,
-- 
1.7.2.5


