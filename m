Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaLUVPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:15:53 -0500
Received: from sauhun.de ([89.238.76.85]:52950 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbaLUVPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:51 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 23/28] ASoC: intel: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:44 +0100
Message-Id: <1419196495-9626-24-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 sound/soc/intel/bytcr_dpcm_rt5640.c | 1 -
 sound/soc/intel/cht_bsw_rt5672.c    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/sound/soc/intel/bytcr_dpcm_rt5640.c b/sound/soc/intel/bytcr_dpcm_rt5640.c
index f5d0fc1ab10c..9277f2baefb1 100644
--- a/sound/soc/intel/bytcr_dpcm_rt5640.c
+++ b/sound/soc/intel/bytcr_dpcm_rt5640.c
@@ -215,7 +215,6 @@ static int snd_byt_mc_probe(struct platform_device *pdev)
 
 static struct platform_driver snd_byt_mc_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "bytt100_rt5640",
 		.pm = &snd_soc_pm_ops,
 	},
diff --git a/sound/soc/intel/cht_bsw_rt5672.c b/sound/soc/intel/cht_bsw_rt5672.c
index 9b8b561171b7..a406c6104897 100644
--- a/sound/soc/intel/cht_bsw_rt5672.c
+++ b/sound/soc/intel/cht_bsw_rt5672.c
@@ -270,7 +270,6 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 
 static struct platform_driver snd_cht_mc_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "cht-bsw-rt5672",
 		.pm = &snd_soc_pm_ops,
 	},
-- 
2.1.3

