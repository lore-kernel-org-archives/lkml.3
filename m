Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3CZXon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:44:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab3CZWnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 29/98] ALSA: hda/cirrus - Fix the digital beep registration
Date: Tue, 26 Mar 2013 15:42:18 -0700
Message-Id: <20130326224245.455566135@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a86b1a2cd2f81f74e815e07f756edd7bc5b6f034 upstream.

The argument passed to snd_hda_attach_beep_device() is a widget NID
while spec->beep_amp holds the composed value for amp controls.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1175,7 +1175,7 @@ static int patch_cxt5045(struct hda_code
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -1954,7 +1954,7 @@ static int patch_cxt5051(struct hda_code
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -3136,7 +3136,7 @@ static int patch_cxt5066(struct hda_code
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -4576,7 +4576,7 @@ static int patch_conexant_auto(struct hd
 	spec->capture_stream = &cx_auto_pcm_analog_capture;
 	codec->patch_ops = cx_auto_patch_ops;
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	/* Some laptops with Conexant chips show stalls in S3 resume,
 	 * which falls into the single-cmd mode.


