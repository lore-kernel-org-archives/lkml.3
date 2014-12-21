Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaLUVQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:16:40 -0500
Received: from sauhun.de ([89.238.76.85]:52963 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbaLUVP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:56 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org
Subject: [PATCH 26/28] ASoC: pxa: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:47 +0100
Message-Id: <1419196495-9626-27-git-send-email-wsa@the-dreams.de>
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

 sound/soc/pxa/spitz.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/pxa/spitz.c b/sound/soc/pxa/spitz.c
index d7d5fb20ea6f..a6d680acd907 100644
--- a/sound/soc/pxa/spitz.c
+++ b/sound/soc/pxa/spitz.c
@@ -352,7 +352,6 @@ static int spitz_remove(struct platform_device *pdev)
 static struct platform_driver spitz_driver = {
 	.driver		= {
 		.name	= "spitz-audio",
-		.owner	= THIS_MODULE,
 		.pm     = &snd_soc_pm_ops,
 	},
 	.probe		= spitz_probe,
-- 
2.1.3

