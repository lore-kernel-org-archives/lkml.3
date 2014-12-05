Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaLEWqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:46:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaLEWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 034/122] ASoC: rsnd: remove unsupported PAUSE flag
Date: Fri,  5 Dec 2014 14:43:28 -0800
Message-Id: <20141205223310.618148890@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 706c66213e5e623e23f521b1acbd8171af7a3549 upstream.

R-Car sound doesn't support PAUSE.
Remove SNDRV_PCM_INFO_PAUSE flags from snd_pcm_hardware info

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sh/rcar/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -888,8 +888,7 @@ static int rsnd_dai_probe(struct platfor
 static struct snd_pcm_hardware rsnd_pcm_hardware = {
 	.info =		SNDRV_PCM_INFO_INTERLEAVED	|
 			SNDRV_PCM_INFO_MMAP		|
-			SNDRV_PCM_INFO_MMAP_VALID	|
-			SNDRV_PCM_INFO_PAUSE,
+			SNDRV_PCM_INFO_MMAP_VALID,
 	.buffer_bytes_max	= 64 * 1024,
 	.period_bytes_min	= 32,
 	.period_bytes_max	= 8192,


