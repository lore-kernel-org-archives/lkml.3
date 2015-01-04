Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbbADMuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 07:50:20 -0500
Received: from mout.web.de ([212.227.15.4]:63695 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbADMuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 07:50:19 -0500
Message-ID: <54A93702.4040705@users.sourceforge.net>
Date: Sun, 04 Jan 2015 13:50:10 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/13] ALSA: seq: Deletion of unnecessary checks before the
 function call "snd_midi_event_free"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:9hNl2d2IySe6VGUlDVJE5awi4gvcYWU03jW3xcC5zGRugTtdAEM
 HFcURlSD6Rw7UHdSKUCVrdi5erUe0C9p0FXb4XpTF+W4MUSzry2UQJ8vZ7pEyXqDPD43HMh
 GDAvrGt8Np5fll1O9JcDGSlBKmNKERsiX7GFJjRF3lBGnu4ZUDVTAXN3PpcURmziOSLb/ZP
 i7jkBf186djt8RK9vRmGw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 3 Jan 2015 14:54:56 +0100

The snd_midi_event_free() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/core/seq/oss/seq_oss_midi.c | 6 ++----
 sound/core/seq/seq_midi.c         | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index 3a45696..e79cc44 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -237,8 +237,7 @@ snd_seq_oss_midi_check_exit_port(int client, int port)
 		spin_unlock_irqrestore(&register_lock, flags);
 		snd_use_lock_free(&mdev->use_lock);
 		snd_use_lock_sync(&mdev->use_lock);
-		if (mdev->coder)
-			snd_midi_event_free(mdev->coder);
+		snd_midi_event_free(mdev->coder);
 		kfree(mdev);
 	}
 	spin_lock_irqsave(&register_lock, flags);
@@ -265,8 +264,7 @@ snd_seq_oss_midi_clear_all(void)
 	spin_lock_irqsave(&register_lock, flags);
 	for (i = 0; i < max_midi_devs; i++) {
 		if ((mdev = midi_devs[i]) != NULL) {
-			if (mdev->coder)
-				snd_midi_event_free(mdev->coder);
+			snd_midi_event_free(mdev->coder);
 			kfree(mdev);
 			midi_devs[i] = NULL;
 		}
diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index a1fd77a..68fec77 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -268,8 +268,7 @@ static void snd_seq_midisynth_delete(struct seq_midisynth *msynth)
 		snd_seq_event_port_detach(msynth->seq_client, msynth->seq_port);
 	}
 
-	if (msynth->parser)
-		snd_midi_event_free(msynth->parser);
+	snd_midi_event_free(msynth->parser);
 }
 
 /* register new midi synth port */
-- 
2.2.1

