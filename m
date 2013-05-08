Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3EHHOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 03:14:54 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60721 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3EHHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 03:14:52 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/6] ASoC: ab8500-codec: Add missing ad_to_slot definitions
Date: Wed,  8 May 2013 09:14:16 +0200
Message-Id: <1367997261-32048-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the AB8500 user manual AD to Slot register multiplexer
accept values from 0 to 15 where:

   0 to  7 corresponds to AD_OUTx slots
   8 to 11 corresponds to zero output
  12 to 15 sets the output in tristate mode

Update enum_ad_to_slot_map array to reflect this definition.

This also allows alsamixer to properly display the default
configuration, as all controls are set to tristate (=12) at reset.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index a153b16..3126cac 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1496,6 +1496,12 @@ static const char * const enum_ad_to_slot_map[] = {"AD_OUT1",
 					"AD_OUT7",
 					"AD_OUT8",
 					"zeroes",
+					"zeroes",
+					"zeroes",
+					"zeroes",
+					"tristate",
+					"tristate",
+					"tristate",
 					"tristate"};
 static SOC_ENUM_SINGLE_DECL(soc_enum_adslot0map,
 			AB8500_ADSLOTSEL1, AB8500_ADSLOTSELX_EVEN_SHIFT,
-- 
1.8.2

