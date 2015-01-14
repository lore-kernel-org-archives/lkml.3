Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbbANH2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:28:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbbANH14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.18 076/150] ALSA: hda/realtek - New codec support for ALC256
Date: Tue, 13 Jan 2015 23:22:27 -0800
Message-Id: <20150114072059.287500569@linuxfoundation.org>
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

commit 4344aec84bd84b58a01347f0db7693f73fb6473d upstream.

Add new support for ALC256 codec.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -319,6 +319,7 @@ static void alc_fill_eapd_coef(struct hd
 		break;
 	case 0x10ec0233:
 	case 0x10ec0255:
+	case 0x10ec0256:
 	case 0x10ec0282:
 	case 0x10ec0283:
 	case 0x10ec0286:
@@ -2660,6 +2661,7 @@ enum {
 	ALC269_TYPE_ALC286,
 	ALC269_TYPE_ALC298,
 	ALC269_TYPE_ALC255,
+	ALC269_TYPE_ALC256,
 };
 
 /*
@@ -2688,6 +2690,7 @@ static int alc269_parse_auto_config(stru
 	case ALC269_TYPE_ALC286:
 	case ALC269_TYPE_ALC298:
 	case ALC269_TYPE_ALC255:
+	case ALC269_TYPE_ALC256:
 		ssids = alc269_ssids;
 		break;
 	default:
@@ -5386,6 +5389,9 @@ static int patch_alc269(struct hda_codec
 	case 0x10ec0255:
 		spec->codec_variant = ALC269_TYPE_ALC255;
 		break;
+	case 0x10ec0256:
+		spec->codec_variant = ALC269_TYPE_ALC256;
+		break;
 	}
 
 	if (snd_hda_codec_read(codec, 0x51, 0, AC_VERB_PARAMETERS, 0) == 0x10ec5505) {
@@ -6321,6 +6327,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0233, .name = "ALC233", .patch = patch_alc269 },
 	{ .id = 0x10ec0235, .name = "ALC233", .patch = patch_alc269 },
 	{ .id = 0x10ec0255, .name = "ALC255", .patch = patch_alc269 },
+	{ .id = 0x10ec0256, .name = "ALC256", .patch = patch_alc269 },
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },


