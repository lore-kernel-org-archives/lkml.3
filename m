Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbaLBTZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:25:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483AbaLBTY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:24:58 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 093/121] ASoC: fsi: remove unsupported PAUSE flag
Date: Tue,  2 Dec 2014 11:19:32 -0800
Message-Id: <1417548000-1794-94-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit c1b9b9b1ad2df6144ca3fbe6989f7bd9ea5c5562 upstream.

FSI doesn't support PAUSE.
Remove SNDRV_PCM_INFO_PAUSE flags from snd_pcm_hardware info

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/sh/fsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index b33ca7c..5dbf494 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -1775,8 +1775,7 @@ static const struct snd_soc_dai_ops fsi_dai_ops = {
 static struct snd_pcm_hardware fsi_pcm_hardware = {
 	.info =		SNDRV_PCM_INFO_INTERLEAVED	|
 			SNDRV_PCM_INFO_MMAP		|
-			SNDRV_PCM_INFO_MMAP_VALID	|
-			SNDRV_PCM_INFO_PAUSE,
+			SNDRV_PCM_INFO_MMAP_VALID,
 	.formats		= FSI_FMTS,
 	.rates			= FSI_RATES,
 	.rate_min		= 8000,
-- 
1.9.1

