Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbbANH17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:27:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbbANH14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.18 075/150] ALSA: hda/realtek - New codec support for ALC298
Date: Tue, 13 Jan 2015 23:22:26 -0800
Message-Id: <20150114072059.236414445@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 506b62c33a7444b91a93bf2da772f4c7e6656410 upstream.

Add new support for ALC298 codec.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -323,6 +323,7 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
+	case 0x10ec0298:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
 	case 0x10ec0285:
@@ -2657,6 +2658,7 @@ enum {
 	ALC269_TYPE_ALC284,
 	ALC269_TYPE_ALC285,
 	ALC269_TYPE_ALC286,
+	ALC269_TYPE_ALC298,
 	ALC269_TYPE_ALC255,
 };
 
@@ -2684,6 +2686,7 @@ static int alc269_parse_auto_config(stru
 	case ALC269_TYPE_ALC282:
 	case ALC269_TYPE_ALC283:
 	case ALC269_TYPE_ALC286:
+	case ALC269_TYPE_ALC298:
 	case ALC269_TYPE_ALC255:
 		ssids = alc269_ssids;
 		break;
@@ -5377,6 +5380,9 @@ static int patch_alc269(struct hda_codec
 		spec->codec_variant = ALC269_TYPE_ALC286;
 		spec->shutup = alc286_shutup;
 		break;
+	case 0x10ec0298:
+		spec->codec_variant = ALC269_TYPE_ALC298;
+		break;
 	case 0x10ec0255:
 		spec->codec_variant = ALC269_TYPE_ALC255;
 		break;
@@ -6334,6 +6340,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0290, .name = "ALC290", .patch = patch_alc269 },
 	{ .id = 0x10ec0292, .name = "ALC292", .patch = patch_alc269 },
 	{ .id = 0x10ec0293, .name = "ALC293", .patch = patch_alc269 },
+	{ .id = 0x10ec0298, .name = "ALC298", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
 	  .patch = patch_alc861 },
 	{ .id = 0x10ec0660, .name = "ALC660-VD", .patch = patch_alc861vd },


