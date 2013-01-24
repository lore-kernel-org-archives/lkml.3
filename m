Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3AXDsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:48:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44124 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3AXD1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:27:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick Lai <plai@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 03/74] ASoC: pcm: allow backend hardware to be freed in pause state
Date: Thu, 24 Jan 2013 01:26:15 -0200
Message-Id: <1358998046-613-4-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Lai <plai@codeaurora.org>

commit 08b27848da620f206a8b6d80f26184485dd7aa40 upstream.

When front-end PCM session is in paused state, back-end
PCM session will be put in paused state as well if given
front-end PCM session is the only client of given back-end.
Then, application closes front-end PCM session, DPCM
framework will not allow back-end enters HW_FREE state
so back-end will never get shutdown completely.

Signed-off-by: Patrick Lai <plai@codeaurora.org>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/soc-pcm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 48fd15b..6f2bad0 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1240,6 +1240,7 @@ static int dpcm_be_dai_hw_free(struct snd_soc_pcm_runtime *fe, int stream)
 		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PREPARE) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE) &&
+		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP))
 			continue;
 
-- 
1.7.9.5

