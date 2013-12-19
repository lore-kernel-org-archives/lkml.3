Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3LSPMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:12:30 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35819 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3LSPFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:00 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 23/38] sound: soc: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:34 +0100
Message-Id: <1387465429-3568-24-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 sound/soc/soc-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 4e53d87..21caa09 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -536,6 +536,7 @@ static int soc_ac97_dev_register(struct snd_soc_codec *codec)
 	err = device_register(&codec->ac97->dev);
 	if (err < 0) {
 		dev_err(codec->dev, "ASoC: Can't register ac97 bus\n");
+		put_device(&codec->ac97->dev);
 		codec->ac97->dev.bus = NULL;
 		return err;
 	}
-- 
1.8.3.1

