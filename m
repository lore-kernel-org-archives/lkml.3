Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaHYNfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:35:09 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49293 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaHYNfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:35:07 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: ctxfi: ctpcm.c: printk replacement
Date: Mon, 25 Aug 2014 19:04:52 +0530
Message-Id: <1408973692-22742-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replaced printk with corresponding pr_err

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctpcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/ctxfi/ctpcm.c b/sound/pci/ctxfi/ctpcm.c
index e8a4feb..6826c2c 100644
--- a/sound/pci/ctxfi/ctpcm.c
+++ b/sound/pci/ctxfi/ctpcm.c
@@ -217,7 +217,7 @@ static int ct_pcm_playback_prepare(struct snd_pcm_substream *substream)
 		err = atc->pcm_playback_prepare(atc, apcm);
 
 	if (err < 0) {
-		printk(KERN_ERR "ctxfi: Preparing pcm playback failed!!!\n");
+		pr_err("ctxfi: Preparing pcm playback failed!!!\n");
 		return err;
 	}
 
@@ -324,7 +324,7 @@ static int ct_pcm_capture_prepare(struct snd_pcm_substream *substream)
 
 	err = atc->pcm_capture_prepare(atc, apcm);
 	if (err < 0) {
-		printk(KERN_ERR "ctxfi: Preparing pcm capture failed!!!\n");
+		pr_err("ctxfi: Preparing pcm capture failed!!!\n");
 		return err;
 	}
 
@@ -435,7 +435,7 @@ int ct_alsa_pcm_create(struct ct_atc *atc,
 	err = snd_pcm_new(atc->card, "ctxfi", device,
 			  playback_count, capture_count, &pcm);
 	if (err < 0) {
-		printk(KERN_ERR "ctxfi: snd_pcm_new failed!! Err=%d\n", err);
+		pr_err("ctxfi: snd_pcm_new failed!! Err=%d\n", err);
 		return err;
 	}
 
-- 
1.8.1.2

