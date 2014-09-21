Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaIUQEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:04:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62758 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaIUQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:03:58 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] sound: pci: ctxfi: ctatc.c: added reference to card
Date: Sun, 21 Sep 2014 21:33:38 +0530
Message-Id: <1411315421-24138-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added reference of the card in the convert_format function
so that we can know which card has called the function

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctatc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index b21eda4..3e29e13 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -171,7 +171,8 @@ static unsigned long atc_get_ptp_phys(struct ct_atc *atc, int index)
 	return atc->vm->get_ptp_phys(atc->vm, index);
 }
 
-static unsigned int convert_format(snd_pcm_format_t snd_format)
+static unsigned int convert_format(snd_pcm_format_t snd_format,
+				   struct snd_card *card)
 {
 	switch (snd_format) {
 	case SNDRV_PCM_FORMAT_U8:
@@ -268,7 +269,8 @@ static int atc_pcm_playback_prepare(struct ct_atc *atc, struct ct_atc_pcm *apcm)
 	src = apcm->src;
 	src->ops->set_pitch(src, pitch);
 	src->ops->set_rom(src, select_rom(pitch));
-	src->ops->set_sf(src, convert_format(apcm->substream->runtime->format));
+	src->ops->set_sf(src, convert_format(apcm->substream->runtime->format,
+					     atc->card));
 	src->ops->set_pm(src, (src->ops->next_interleave(src) != NULL));
 
 	/* Get AMIXER resource */
@@ -738,7 +740,8 @@ static int atc_pcm_capture_start(struct ct_atc *atc, struct ct_atc_pcm *apcm)
 
 	/*  Set up recording SRC */
 	src = apcm->src;
-	src->ops->set_sf(src, convert_format(apcm->substream->runtime->format));
+	src->ops->set_sf(src, convert_format(apcm->substream->runtime->format,
+					     atc->card));
 	src->ops->set_sa(src, apcm->vm_block->addr);
 	src->ops->set_la(src, apcm->vm_block->addr + apcm->vm_block->size);
 	src->ops->set_ca(src, apcm->vm_block->addr);
@@ -807,7 +810,8 @@ static int spdif_passthru_playback_get_resources(struct ct_atc *atc,
 	src = apcm->src;
 	src->ops->set_pitch(src, pitch);
 	src->ops->set_rom(src, select_rom(pitch));
-	src->ops->set_sf(src, convert_format(apcm->substream->runtime->format));
+	src->ops->set_sf(src, convert_format(apcm->substream->runtime->format,
+					     atc->card));
 	src->ops->set_pm(src, (src->ops->next_interleave(src) != NULL));
 	src->ops->set_bp(src, 1);
 
-- 
1.8.1.2

