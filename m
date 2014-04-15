Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaDOUjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:39:39 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:47396 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaDOUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:39:38 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com, broonie@kernel.org
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] ASoC: core: use PTR_ERR instead of PTR_RET
Date: Tue, 15 Apr 2014 22:39:01 +0200
Message-Id: <1397594341-7817-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTR_RET is deprecated. PTR_ERR_OR_ZERO should be used instead. However,
we already know that IS_ERR is true, and thus PTR_ERR_OR_ZERO would
never yield zero, so we can use PTR_ERR here.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 sound/soc/soc-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 051c006..2dc69845 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2153,28 +2153,28 @@ static int snd_soc_ac97_parse_pinctl(struct device *dev,
 	p = devm_pinctrl_get(dev);
 	if (IS_ERR(p)) {
 		dev_err(dev, "Failed to get pinctrl\n");
-		return PTR_RET(p);
+		return PTR_ERR(p);
 	}
 	cfg->pctl = p;
 
 	state = pinctrl_lookup_state(p, "ac97-reset");
 	if (IS_ERR(state)) {
 		dev_err(dev, "Can't find pinctrl state ac97-reset\n");
-		return PTR_RET(state);
+		return PTR_ERR(state);
 	}
 	cfg->pstate_reset = state;
 
 	state = pinctrl_lookup_state(p, "ac97-warm-reset");
 	if (IS_ERR(state)) {
 		dev_err(dev, "Can't find pinctrl state ac97-warm-reset\n");
-		return PTR_RET(state);
+		return PTR_ERR(state);
 	}
 	cfg->pstate_warm_reset = state;
 
 	state = pinctrl_lookup_state(p, "ac97-running");
 	if (IS_ERR(state)) {
 		dev_err(dev, "Can't find pinctrl state ac97-running\n");
-		return PTR_RET(state);
+		return PTR_ERR(state);
 	}
 	cfg->pstate_run = state;
 
-- 
1.9.0

