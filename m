Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3FNJtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:49:16 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:46069 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3FNJtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:49:15 -0400
From: Emil Goode <emilgoode@gmail.com>
To: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] ASoC: Fix double assignment of .owner in struct snd_soc_card
Date: Fri, 14 Jun 2013 11:48:56 +0200
Message-Id: <1371203336-16972-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In struct snd_soc_card zylonite .owner is assigned THIS_MODULE
twice, remove one of them.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 sound/soc/pxa/zylonite.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/pxa/zylonite.c b/sound/soc/pxa/zylonite.c
index ceb6566..db8aadf 100644
--- a/sound/soc/pxa/zylonite.c
+++ b/sound/soc/pxa/zylonite.c
@@ -256,7 +256,6 @@ static struct snd_soc_card zylonite = {
 	.resume_pre = &zylonite_resume_pre,
 	.dai_link = zylonite_dai,
 	.num_links = ARRAY_SIZE(zylonite_dai),
-	.owner = THIS_MODULE,
 };
 
 static struct platform_device *zylonite_snd_ac97_device;
-- 
1.7.10.4

