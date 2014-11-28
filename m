Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaK1S5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:57:54 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63268 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaK1S5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:57:53 -0500
From: Kyle Chamberlin <kylechamberlin@project20million.org>
X-Google-Original-From: Kyle Chamberlin <KyleChamberlin@project20million.org>
To: perex@perex.cz
Cc: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Kyle Chamberlin <KyleChamberlin@project20million.org>
Subject: [PATCH] Sound: drivers: virmidi: fixed code style issues
Date: Fri, 28 Nov 2014 13:59:56 -0500
Message-Id: <1417201196-12392-1-git-send-email-KyleChamberlin@project20million.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some minor code style issues and also removed some
assignments inside of if conditionals.

Signed-off-by: Kyle Chamberlin <KyleChamberlin@project20million.org>
---
 sound/drivers/virmidi.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/sound/drivers/virmidi.c b/sound/drivers/virmidi.c
index b17872429..0af88d9 100644
--- a/sound/drivers/virmidi.c
+++ b/sound/drivers/virmidi.c
@@ -99,30 +99,33 @@ static int snd_virmidi_probe(struct platform_device *devptr)
 
 	if (midi_devs[dev] > MAX_MIDI_DEVICES) {
 		snd_printk(KERN_WARNING
-			   "too much midi devices for virmidi %d: "
-			   "force to use %d\n", dev, MAX_MIDI_DEVICES);
+			   "too much midi devices for virmidi %d: force to use %d\n",
+			   dev, MAX_MIDI_DEVICES);
 		midi_devs[dev] = MAX_MIDI_DEVICES;
 	}
 	for (idx = 0; idx < midi_devs[dev]; idx++) {
 		struct snd_rawmidi *rmidi;
 		struct snd_virmidi_dev *rdev;
-		if ((err = snd_virmidi_new(card, idx, &rmidi)) < 0)
+
+		err = snd_virmidi_new(card, idx, &rmidi);
+		if (err < 0)
 			goto __nodev;
 		rdev = rmidi->private_data;
 		vmidi->midi[idx] = rmidi;
 		strcpy(rmidi->name, "Virtual Raw MIDI");
 		rdev->seq_mode = SNDRV_VIRMIDI_SEQ_DISPATCH;
 	}
-	
+
 	strcpy(card->driver, "VirMIDI");
 	strcpy(card->shortname, "VirMIDI");
 	sprintf(card->longname, "Virtual MIDI Card %i", dev + 1);
 
-	if ((err = snd_card_register(card)) == 0) {
+	err = snd_card_register(card);
+	if (err) {
 		platform_set_drvdata(devptr, card);
 		return 0;
 	}
-      __nodev:
+__nodev:
 	snd_card_free(card);
 	return err;
 }
@@ -157,13 +160,15 @@ static int __init alsa_card_virmidi_init(void)
 {
 	int i, cards, err;
 
-	if ((err = platform_driver_register(&snd_virmidi_driver)) < 0)
+	err = platform_driver_register(&snd_virmidi_driver);
+	if (err < 0)
 		return err;
 
 	cards = 0;
 	for (i = 0; i < SNDRV_CARDS; i++) {
 		struct platform_device *device;
-		if (! enable[i])
+
+		if (!enable[i])
 			continue;
 		device = platform_device_register_simple(SND_VIRMIDI_DRIVER,
 							 i, NULL, 0);
-- 
2.1.3

