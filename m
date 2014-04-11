Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbaDKKGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:06:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:64253 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756529AbaDKKGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:06:02 -0400
X-IronPort-AV: E=Sophos;i="4.97,841,1389715200"; 
   d="scan'208";a="29146063"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: <perex@perex.cz>, <tiwai@suse.de>
CC: <linux-kernel@vger.kernel.org>, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] ASoC: core: replace PTR_RET with PTR_ERR_OR_ZERO
Date: Fri, 11 Apr 2014 18:04:08 +0800
Message-ID: <1397210648-28434-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTR_RET is deprecated. Do not recommend its usage anymore.
Use PTR_ERR_OR_ZERO instead.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 sound/soc/soc-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 051c006..bb7382e 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2153,28 +2153,28 @@ static int snd_soc_ac97_parse_pinctl(struct device *dev,
 	p = devm_pinctrl_get(dev);
 	if (IS_ERR(p)) {
 		dev_err(dev, "Failed to get pinctrl\n");
-		return PTR_RET(p);
+		return PTR_ERR_OR_ZERO(p);
 	}
 	cfg->pctl = p;
 
 	state = pinctrl_lookup_state(p, "ac97-reset");
 	if (IS_ERR(state)) {
 		dev_err(dev, "Can't find pinctrl state ac97-reset\n");
-		return PTR_RET(state);
+		return PTR_ERR_OR_ZERO(state);
 	}
 	cfg->pstate_reset = state;
 
 	state = pinctrl_lookup_state(p, "ac97-warm-reset");
 	if (IS_ERR(state)) {
 		dev_err(dev, "Can't find pinctrl state ac97-warm-reset\n");
-		return PTR_RET(state);
+		return PTR_ERR_OR_ZERO(state);
 	}
 	cfg->pstate_warm_reset = state;
 
 	state = pinctrl_lookup_state(p, "ac97-running");
 	if (IS_ERR(state)) {
 		dev_err(dev, "Can't find pinctrl state ac97-running\n");
-		return PTR_RET(state);
+		return PTR_ERR_OR_ZERO(state);
 	}
 	cfg->pstate_run = state;
 
-- 
1.8.3.1

