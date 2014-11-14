Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbaKNKjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:39:19 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60644 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965102AbaKNKjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:39:17 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] ALSA: ice1712: remove unneeded return statement
Date: Fri, 14 Nov 2014 16:09:05 +0530
Message-Id: <1415961547-10330-1-git-send-email-sudipm.mukherjee@gmail.com>
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

change in v2: returning the return value of the function directly.

 sound/pci/ice1712/hoontech.c   |  6 +-----
 sound/pci/ice1712/ice1712.c    | 19 ++++++-------------
 sound/pci/ice1712/ice1724.c    |  7 ++-----
 sound/pci/ice1712/juli.c       |  5 +----
 sound/pci/ice1712/prodigy192.c |  4 +---
 sound/pci/ice1712/quartet.c    |  5 +----
 6 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/sound/pci/ice1712/hoontech.c b/sound/pci/ice1712/hoontech.c
index 59e37c5..a40001c 100644
--- a/sound/pci/ice1712/hoontech.c
+++ b/sound/pci/ice1712/hoontech.c
@@ -309,11 +309,7 @@ static int snd_ice1712_value_init(struct snd_ice1712 *ice)
 		return err;
 
 	/* ak4524 controls */
-	err = snd_ice1712_akm4xxx_build_controls(ice);
-	if (err < 0)
-		return err;
-
-	return 0;
+	return snd_ice1712_akm4xxx_build_controls(ice);
 }
 
 static int snd_ice1712_ez8_init(struct snd_ice1712 *ice)
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 48a0c33..5975334 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -1295,10 +1295,7 @@ static int snd_ice1712_pcm_profi(struct snd_ice1712 *ice, int device, struct snd
 			return err;
 	}
 
-	err = snd_ice1712_build_pro_mixer(ice);
-	if (err < 0)
-		return err;
-	return 0;
+	return snd_ice1712_build_pro_mixer(ice);
 }
 
 /*
@@ -1545,10 +1542,9 @@ static int snd_ice1712_ac97_mixer(struct snd_ice1712 *ice)
 			dev_warn(ice->card->dev,
 				 "cannot initialize ac97 for consumer, skipped\n");
 		else {
-			err = snd_ctl_add(ice->card, snd_ctl_new1(&snd_ice1712_mixer_digmix_route_ac97, ice));
-			if (err < 0)
-				return err;
-			return 0;
+			return snd_ctl_add(ice->card,
+			snd_ctl_new1(&snd_ice1712_mixer_digmix_route_ac97,
+				     ice));
 		}
 	}
 
@@ -2497,11 +2493,8 @@ static int snd_ice1712_build_controls(struct snd_ice1712 *ice)
 	err = snd_ctl_add(ice->card, snd_ctl_new1(&snd_ice1712_mixer_pro_volume_rate, ice));
 	if (err < 0)
 		return err;
-	err = snd_ctl_add(ice->card, snd_ctl_new1(&snd_ice1712_mixer_pro_peak, ice));
-	if (err < 0)
-		return err;
-
-	return 0;
+	return snd_ctl_add(ice->card,
+			   snd_ctl_new1(&snd_ice1712_mixer_pro_peak, ice));
 }
 
 static int snd_ice1712_free(struct snd_ice1712 *ice)
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index f633e3b..ea53167 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2497,11 +2497,8 @@ static int snd_vt1724_build_controls(struct snd_ice1712 *ice)
 			return err;
 	}
 
-	err = snd_ctl_add(ice->card, snd_ctl_new1(&snd_vt1724_mixer_pro_peak, ice));
-	if (err < 0)
-		return err;
-
-	return 0;
+	return snd_ctl_add(ice->card,
+			   snd_ctl_new1(&snd_vt1724_mixer_pro_peak, ice));
 }
 
 static int snd_vt1724_free(struct snd_ice1712 *ice)
diff --git a/sound/pci/ice1712/juli.c b/sound/pci/ice1712/juli.c
index 7a6c078..a1536c1 100644
--- a/sound/pci/ice1712/juli.c
+++ b/sound/pci/ice1712/juli.c
@@ -475,11 +475,8 @@ static int juli_add_controls(struct snd_ice1712 *ice)
 		return err;
 
 	/* only capture SPDIF over AK4114 */
-	err = snd_ak4114_build(spec->ak4114, NULL,
+	return snd_ak4114_build(spec->ak4114, NULL,
 			ice->pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream);
-	if (err < 0)
-		return err;
-	return 0;
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
index d4caf9d..6f55e02 100644
--- a/sound/pci/ice1712/quartet.c
+++ b/sound/pci/ice1712/quartet.c
@@ -833,11 +833,8 @@ static int qtet_add_controls(struct snd_ice1712 *ice)
 	if (err < 0)
 		return err;
 	/* only capture SPDIF over AK4113 */
-	err = snd_ak4113_build(spec->ak4113,
+	return snd_ak4113_build(spec->ak4113,
 			ice->pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream);
-	if (err < 0)
-		return err;
-	return 0;
 }
 
 static inline int qtet_is_spdif_master(struct snd_ice1712 *ice)
-- 
1.8.1.2

