Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732AbaKMPOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:14:30 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37861 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933611AbaKMPO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:14:27 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ALSA: ice1712: remove unneeded return statement
Date: Thu, 13 Nov 2014 20:44:16 +0530
Message-Id: <1415891657-7244-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the functions:
	snd_ice1712_akm4xxx_build_controls
	snd_ice1712_build_pro_mixer
	snd_ctl_add
	snd_ak4114_build
	prodigy192_ak4114_init
	snd_ak4113_build
are all returning either 0 or a negetive error value.
so we can easily remove the check for a negative value and return
the value instead.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

i have not given Jaroslav Kysela <perex@perex.cz> in the To list,
as in my last mail, all mails bounced with the error:
"cant create user output file"

 sound/pci/ice1712/hoontech.c   |  5 +----
 sound/pci/ice1712/ice1712.c    | 13 +++----------
 sound/pci/ice1712/ice1724.c    |  5 +----
 sound/pci/ice1712/juli.c       |  4 +---
 sound/pci/ice1712/prodigy192.c |  4 +---
 sound/pci/ice1712/quartet.c    |  4 +---
 6 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/sound/pci/ice1712/hoontech.c b/sound/pci/ice1712/hoontech.c
index 59e37c5..2c53154 100644
--- a/sound/pci/ice1712/hoontech.c
+++ b/sound/pci/ice1712/hoontech.c
@@ -310,10 +310,7 @@ static int snd_ice1712_value_init(struct snd_ice1712 *ice)
 
 	/* ak4524 controls */
 	err = snd_ice1712_akm4xxx_build_controls(ice);
-	if (err < 0)
-		return err;
-
-	return 0;
+	return err;
 }
 
 static int snd_ice1712_ez8_init(struct snd_ice1712 *ice)
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 48a0c33..b97a0f9 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -1296,9 +1296,7 @@ static int snd_ice1712_pcm_profi(struct snd_ice1712 *ice, int device, struct snd
 	}
 
 	err = snd_ice1712_build_pro_mixer(ice);
-	if (err < 0)
-		return err;
-	return 0;
+	return err;
 }
 
 /*
@@ -1546,9 +1544,7 @@ static int snd_ice1712_ac97_mixer(struct snd_ice1712 *ice)
 				 "cannot initialize ac97 for consumer, skipped\n");
 		else {
 			err = snd_ctl_add(ice->card, snd_ctl_new1(&snd_ice1712_mixer_digmix_route_ac97, ice));
-			if (err < 0)
-				return err;
-			return 0;
+			return err;
 		}
 	}
 
@@ -2498,10 +2494,7 @@ static int snd_ice1712_build_controls(struct snd_ice1712 *ice)
 	if (err < 0)
 		return err;
 	err = snd_ctl_add(ice->card, snd_ctl_new1(&snd_ice1712_mixer_pro_peak, ice));
-	if (err < 0)
-		return err;
-
-	return 0;
+	return err;
 }
 
 static int snd_ice1712_free(struct snd_ice1712 *ice)
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index f633e3b..fa88485 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2498,10 +2498,7 @@ static int snd_vt1724_build_controls(struct snd_ice1712 *ice)
 	}
 
 	err = snd_ctl_add(ice->card, snd_ctl_new1(&snd_vt1724_mixer_pro_peak, ice));
-	if (err < 0)
-		return err;
-
-	return 0;
+	return err;
 }
 
 static int snd_vt1724_free(struct snd_ice1712 *ice)
diff --git a/sound/pci/ice1712/juli.c b/sound/pci/ice1712/juli.c
index 7a6c078..d6f2fb0 100644
--- a/sound/pci/ice1712/juli.c
+++ b/sound/pci/ice1712/juli.c
@@ -477,9 +477,7 @@ static int juli_add_controls(struct snd_ice1712 *ice)
 	/* only capture SPDIF over AK4114 */
 	err = snd_ak4114_build(spec->ak4114, NULL,
 			ice->pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream);
-	if (err < 0)
-		return err;
-	return 0;
+	return err;
 }
 
 /*
diff --git a/sound/pci/ice1712/prodigy192.c b/sound/pci/ice1712/prodigy192.c
index 1eb151aa..3919aed 100644
--- a/sound/pci/ice1712/prodigy192.c
+++ b/sound/pci/ice1712/prodigy192.c
@@ -758,10 +758,8 @@ static int prodigy192_init(struct snd_ice1712 *ice)
 			"AK4114 initialized with status %d\n", err);
 	} else
 		dev_dbg(ice->card->dev, "AK4114 not found\n");
-	if (err < 0)
-		return err;
 
-	return 0;
+	return err;
 }
 
 
diff --git a/sound/pci/ice1712/quartet.c b/sound/pci/ice1712/quartet.c
index d4caf9d..3903e05 100644
--- a/sound/pci/ice1712/quartet.c
+++ b/sound/pci/ice1712/quartet.c
@@ -835,9 +835,7 @@ static int qtet_add_controls(struct snd_ice1712 *ice)
 	/* only capture SPDIF over AK4113 */
 	err = snd_ak4113_build(spec->ak4113,
 			ice->pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream);
-	if (err < 0)
-		return err;
-	return 0;
+	return err;
 }
 
 static inline int qtet_is_spdif_master(struct snd_ice1712 *ice)
-- 
1.8.1.2

