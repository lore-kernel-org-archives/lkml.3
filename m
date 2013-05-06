Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3EFXNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:13:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab3EFXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 062/104] ALSA: hda - Add the support for ALC286 codec
Date: Mon,  6 May 2013 16:12:21 -0700
Message-Id: <20130506230050.004710534@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 7fc7d047216aa4923d401c637be2ebc6e3d5bd9b upstream.

It's yet another ALC269-variant.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5823,6 +5823,7 @@ enum {
 	ALC269_TYPE_ALC280,
 	ALC269_TYPE_ALC282,
 	ALC269_TYPE_ALC284,
+	ALC269_TYPE_ALC286,
 };
 
 /*
@@ -5846,6 +5847,7 @@ static int alc269_parse_auto_config(stru
 	case ALC269_TYPE_ALC269VB:
 	case ALC269_TYPE_ALC269VD:
 	case ALC269_TYPE_ALC282:
+	case ALC269_TYPE_ALC286:
 		ssids = alc269_ssids;
 		break;
 	default:
@@ -6451,6 +6453,9 @@ static int patch_alc269(struct hda_codec
 	case 0x10ec0292:
 		spec->codec_variant = ALC269_TYPE_ALC284;
 		break;
+	case 0x10ec0286:
+		spec->codec_variant = ALC269_TYPE_ALC286;
+		break;
 	}
 
 	/* automatic parse from the BIOS config */
@@ -7157,6 +7162,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0282, .name = "ALC282", .patch = patch_alc269 },
 	{ .id = 0x10ec0283, .name = "ALC283", .patch = patch_alc269 },
 	{ .id = 0x10ec0284, .name = "ALC284", .patch = patch_alc269 },
+	{ .id = 0x10ec0286, .name = "ALC286", .patch = patch_alc269 },
 	{ .id = 0x10ec0290, .name = "ALC290", .patch = patch_alc269 },
 	{ .id = 0x10ec0292, .name = "ALC292", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",


