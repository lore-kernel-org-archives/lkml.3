Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279AbaLLG0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:26:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759360AbaLLGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@kernel.org>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.488701783@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 092/164] ASoC: fsi: remove unsupported PAUSE flag
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit c1b9b9b1ad2df6144ca3fbe6989f7bd9ea5c5562 upstream.

FSI doesn't support PAUSE.
Remove SNDRV_PCM_INFO_PAUSE flags from snd_pcm_hardware info

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/sh/fsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -1096,8 +1096,7 @@ static struct snd_soc_dai_ops fsi_dai_op
 static struct snd_pcm_hardware fsi_pcm_hardware = {
 	.info =		SNDRV_PCM_INFO_INTERLEAVED	|
 			SNDRV_PCM_INFO_MMAP		|
-			SNDRV_PCM_INFO_MMAP_VALID	|
-			SNDRV_PCM_INFO_PAUSE,
+			SNDRV_PCM_INFO_MMAP_VALID,
 	.formats		= FSI_FMTS,
 	.rates			= FSI_RATES,
 	.rate_min		= 8000,

