Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaKJI0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:26:55 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:3451 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaKJI0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:26:53 -0500
X-Mailbox-Line: From 3b3dcd0172b0bdd0a661d65d697a73f837565309 Mon Sep 17 00:00:00 2001
Message-Id: <3b3dcd0172b0bdd0a661d65d697a73f837565309.1415605717.git.moinejf@free.fr>
In-Reply-To: <cover.1415605716.git.moinejf@free.fr>
References: <cover.1415605716.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 9 Nov 2014 12:26:19 +0100
Subject: [PATCH v4 4/4] ASoC: simple-card: Remove useless check
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU and CODEC names are checked when getting the DAI names.
There is no need to check them once more.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 61f9500..c1ba78b 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -319,11 +319,6 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	if (ret < 0)
 		goto dai_link_of_err;
 
-	if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name) {
-		ret = -EINVAL;
-		goto dai_link_of_err;
-	}
-
 	/* Simple Card assumes platform == cpu */
 	dai_link->platform_of_node = dai_link->cpu_of_node;
 
-- 
2.1.3

