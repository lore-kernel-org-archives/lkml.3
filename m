Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbaJ2Oj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:39:56 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52921 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbaJ2Ojz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:39:55 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hdspm: remove unused variable
Date: Wed, 29 Oct 2014 20:09:45 +0530
Message-Id: <1414593585-13277-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed the unused variables. These variables were only being
assigned some value, but the values were never being used.

it has been build tested after removing the variables.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/rme9652/hdspm.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 7f7277b..e09348c1 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -1257,14 +1257,13 @@ static int hdspm_rate_multiplier(struct hdspm *hdspm, int rate)
 /* check for external sample rate, returns the sample rate in Hz*/
 static int hdspm_external_sample_rate(struct hdspm *hdspm)
 {
-	unsigned int status, status2, timecode;
+	unsigned int status, status2;
 	int syncref, rate = 0, rate_bits;
 
 	switch (hdspm->io_type) {
 	case AES32:
 		status2 = hdspm_read(hdspm, HDSPM_statusRegister2);
 		status = hdspm_read(hdspm, HDSPM_statusRegister);
-		timecode = hdspm_read(hdspm, HDSPM_timecodeRegister);
 
 		syncref = hdspm_autosync_ref(hdspm);
 		switch (syncref) {
@@ -4862,18 +4861,15 @@ snd_hdspm_proc_read_madi(struct snd_info_entry *entry,
 			 struct snd_info_buffer *buffer)
 {
 	struct hdspm *hdspm = entry->private_data;
-	unsigned int status, status2, control, freq;
+	unsigned int status, status2;
 
 	char *pref_sync_ref;
 	char *autosync_ref;
 	char *system_clock_mode;
-	char *insel;
 	int x, x2;
 
 	status = hdspm_read(hdspm, HDSPM_statusRegister);
 	status2 = hdspm_read(hdspm, HDSPM_statusRegister2);
-	control = hdspm->control_register;
-	freq = hdspm_read(hdspm, HDSPM_timecodeRegister);
 
 	snd_iprintf(buffer, "%s (Card #%d) Rev.%x Status2first3bits: %x\n",
 			hdspm->card_name, hdspm->card->number + 1,
@@ -4936,17 +4932,6 @@ snd_hdspm_proc_read_madi(struct snd_info_entry *entry,
 	snd_iprintf(buffer, "Line out: %s\n",
 		(hdspm->control_register & HDSPM_LineOut) ? "on " : "off");
 
-	switch (hdspm->control_register & HDSPM_InputMask) {
-	case HDSPM_InputOptical:
-		insel = "Optical";
-		break;
-	case HDSPM_InputCoaxial:
-		insel = "Coaxial";
-		break;
-	default:
-		insel = "Unknown";
-	}
-
 	snd_iprintf(buffer,
 		"ClearTrackMarker = %s, Transmit in %s Channel Mode, "
 		"Auto Input %s\n",
@@ -5191,15 +5176,13 @@ snd_hdspm_proc_read_raydat(struct snd_info_entry *entry,
 			 struct snd_info_buffer *buffer)
 {
 	struct hdspm *hdspm = entry->private_data;
-	unsigned int status1, status2, status3, control, i;
+	unsigned int status1, status2, status3, i;
 	unsigned int lock, sync;
 
 	status1 = hdspm_read(hdspm, HDSPM_RD_STATUS_1); /* s1 */
 	status2 = hdspm_read(hdspm, HDSPM_RD_STATUS_2); /* freq */
 	status3 = hdspm_read(hdspm, HDSPM_RD_STATUS_3); /* s2 */
 
-	control = hdspm->control_register;
-
 	snd_iprintf(buffer, "STATUS1: 0x%08x\n", status1);
 	snd_iprintf(buffer, "STATUS2: 0x%08x\n", status2);
 	snd_iprintf(buffer, "STATUS3: 0x%08x\n", status3);
-- 
1.8.1.2

