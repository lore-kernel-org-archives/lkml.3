Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaIZKSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:18:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbaIZJqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qiao Zhou <zhouqiao@marvell.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 074/142] ASoC: pcm: fix dpcm_path_put in dpcm runtime update
Date: Fri, 26 Sep 2014 11:44:45 +0200
Message-Id: <672d675e65af79575304b6a9a792aa939fab546a.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiao Zhou <zhouqiao@marvell.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7ed9de76ff342cbd717a9cf897044b99272cb8f8 upstream.

we need to release dapm widget list after dpcm_path_get in
soc_dpcm_runtime_update. otherwise, there will be potential memory
leak. add dpcm_path_put to fix it.

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/soc-pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 330c9a6b5cb5..875cae86d708 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1882,6 +1882,7 @@ int soc_dpcm_runtime_update(struct snd_soc_card *card)
 			dpcm_be_disconnect(fe, SNDRV_PCM_STREAM_PLAYBACK);
 		}
 
+		dpcm_path_put(&list);
 capture:
 		/* skip if FE doesn't have capture capability */
 		if (!fe->cpu_dai->driver->capture.channels_min)
-- 
2.1.0

