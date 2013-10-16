Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab3JPQ0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:26:41 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:48116 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab3JPQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:26:39 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        alsa-devel@alsa-project.org (moderated list:SOUND),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] sound: pci: emu10k1: Remove useless casting in emufx.c
Date: Wed, 16 Oct 2013 13:21:45 -0300
Message-Id: <1381940506-29855-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting (void *) value returned by kcalloc is useless
as mentioned in Documentation/CodingStyle, Chap 14.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 sound/pci/emu10k1/emufx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 0275209..3f51dac 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -1183,9 +1183,8 @@ static int _snd_emu10k1_audigy_init_efx(struct snd_emu10k1 *emu)
 	mm_segment_t seg;
 
 	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL ||
-	    (icode->gpr_map = (u_int32_t __user *)
-	     kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
-		     GFP_KERNEL)) == NULL ||
+	    (icode->gpr_map = kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
+				      GFP_KERNEL)) == NULL ||
 	    (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
 				sizeof(*controls), GFP_KERNEL)) == NULL) {
 		err = -ENOMEM;
@@ -1815,10 +1814,9 @@ static int _snd_emu10k1_init_efx(struct snd_emu10k1 *emu)
 
 	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
-	if ((icode->gpr_map = (u_int32_t __user *)
-	     kcalloc(256 + 160 + 160 + 2 * 512, sizeof(u_int32_t),
-		     GFP_KERNEL)) == NULL ||
-            (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
+	if ((icode->gpr_map = kcalloc(256 + 160 + 160 + 2 * 512, sizeof(u_int32_t),
+				      GFP_KERNEL)) == NULL ||
+	    (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
 				sizeof(struct snd_emu10k1_fx8010_control_gpr),
 				GFP_KERNEL)) == NULL ||
 	    (ipcm = kzalloc(sizeof(*ipcm), GFP_KERNEL)) == NULL) {
-- 
1.8.4

