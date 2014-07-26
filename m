Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaGZOUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:20:09 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37058 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGZOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:20:07 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hid: hid-prodikeys.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:21:32 +0200
Message-Id: <1406384492-2442-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/hid/hid-prodikeys.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 91fab97..007c7f5 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -641,9 +641,9 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 		goto fail;
 	}
 
-	strncpy(card->driver, shortname, sizeof(card->driver));
-	strncpy(card->shortname, shortname, sizeof(card->shortname));
-	strncpy(card->longname, longname, sizeof(card->longname));
+	strlcpy(card->driver, shortname, sizeof(card->driver));
+	strlcpy(card->shortname, shortname, sizeof(card->shortname));
+	strlcpy(card->longname, longname, sizeof(card->longname));
 
 	/* Set up rawmidi */
 	err = snd_rawmidi_new(card, card->shortname, 0,
@@ -654,7 +654,7 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 		goto fail;
 	}
 	pm->rwmidi = rwmidi;
-	strncpy(rwmidi->name, card->shortname, sizeof(rwmidi->name));
+	strlcpy(rwmidi->name, card->shortname, sizeof(rwmidi->name));
 	rwmidi->info_flags = SNDRV_RAWMIDI_INFO_INPUT;
 	rwmidi->private_data = pm;
 
-- 
1.7.10.4

