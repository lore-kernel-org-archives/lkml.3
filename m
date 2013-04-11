Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab3DKUc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:32:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702Ab3DKU0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:15 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=445dodzYXisA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AlSCNJA0bYMA:10 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202550.637315985@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [ 027/171 ] ALSA: hda/cirrus - Fix the digital beep registration
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0027-ALSA-hda-cirrus-Fix-the-digital-beep-registration.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a86b1a2cd2f81f74e815e07f756edd7bc5b6f034 ]

The argument passed to snd_hda_attach_beep_device() is a widget NID
while spec->beep_amp holds the composed value for amp controls.

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/pci/hda/patch_conexant.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 784017e..ee23081 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1182,7 +1182,7 @@ static int patch_cxt5045(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -1961,7 +1961,7 @@ static int patch_cxt5051(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -3143,7 +3143,7 @@ static int patch_cxt5066(struct hda_codec *codec)
 	}
 
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	return 0;
 }
@@ -4538,7 +4538,7 @@ static int patch_conexant_auto(struct hda_codec *codec)
 	spec->capture_stream = &cx_auto_pcm_analog_capture;
 	codec->patch_ops = cx_auto_patch_ops;
 	if (spec->beep_amp)
-		snd_hda_attach_beep_device(codec, spec->beep_amp);
+		snd_hda_attach_beep_device(codec, get_amp_nid_(spec->beep_amp));
 
 	/* Some laptops with Conexant chips show stalls in S3 resume,
 	 * which falls into the single-cmd mode.
-- 
1.7.10.4


