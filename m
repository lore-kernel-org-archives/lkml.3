Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaGGNS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:18:28 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:49382 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaGGNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:18:27 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: max98090: Fix build warning
Date: Mon,  7 Jul 2014 15:18:19 +0200
Message-Id: <1404739099-20717-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The max98090_{suspend,resume}() functions are used for system sleep and
therefore need to be guarded by CONFIG_PM_SLEEP rather than CONFIG_PM.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 sound/soc/codecs/max98090.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index ca74f502a4cb..e806065d68cc 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2415,7 +2415,7 @@ static int max98090_runtime_suspend(struct device *dev)
 }
 #endif
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int max98090_resume(struct device *dev)
 {
 	struct max98090_priv *max98090 = dev_get_drvdata(dev);
-- 
2.0.1

