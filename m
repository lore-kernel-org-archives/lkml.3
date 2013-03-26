Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965001Ab3CZPXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53880 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134Ab3CZPWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 079/150] ALSA: hda/cirrus - Fix the digital beep registration
Date: Tue, 26 Mar 2013 15:19:38 +0000
Message-Id: <1364311249-14454-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a86b1a2cd2f81f74e815e07f756edd7bc5b6f034 upstream.

The argument passed to snd_hda_attach_beep_device() is a widget NID
while spec->beep_amp holds the composed value for amp controls.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_conexant.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 2682b3d..5fb90c6 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1170,7 +1170,7 @@ static int patch_cxt5045(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -1949,7 +1949,7 @@ static int patch_cxt5051(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -3136,7 +3136,7 @@ static int patch_cxt5066(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -4528,7 +4528,7 @@ static int patch_conexant_auto(struct hda_codec *codec)
 	spec->capture_stream = &cx_auto_pcm_analog_capture;
 	codec->patch_ops = cx_auto_patch_ops;
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	/* Some laptops with Conexant chips show stalls in S3 resume,
 	 * which falls into the single-cmd mode.
-- 
1.8.1.2

