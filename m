Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab3K0B2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:28:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab3K0A6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 044/116] ALSA: hda - Add support of ALC255 codecs
Date: Tue, 26 Nov 2013 16:56:57 -0800
Message-Id: <20131127005739.997607259@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 1d04c9de5c76df113e4af7120feb53c628b5efcc upstream.

It's just another variant of ALC269 & co.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2540,6 +2540,7 @@ enum {
 	ALC269_TYPE_ALC283,
 	ALC269_TYPE_ALC284,
 	ALC269_TYPE_ALC286,
+	ALC269_TYPE_ALC255,
 };
 
 /*
@@ -2565,6 +2566,7 @@ static int alc269_parse_auto_config(stru
 	case ALC269_TYPE_ALC282:
 	case ALC269_TYPE_ALC283:
 	case ALC269_TYPE_ALC286:
+	case ALC269_TYPE_ALC255:
 		ssids = alc269_ssids;
 		break;
 	default:
@@ -4128,6 +4130,9 @@ static int patch_alc269(struct hda_codec
 	case 0x10ec0286:
 		spec->codec_variant = ALC269_TYPE_ALC286;
 		break;
+	case 0x10ec0255:
+		spec->codec_variant = ALC269_TYPE_ALC255;
+		break;
 	}
 
 	if (snd_hda_codec_read(codec, 0x51, 0, AC_VERB_PARAMETERS, 0) == 0x10ec5505) {
@@ -4842,6 +4847,7 @@ static int patch_alc680(struct hda_codec
 static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0221, .name = "ALC221", .patch = patch_alc269 },
 	{ .id = 0x10ec0233, .name = "ALC233", .patch = patch_alc269 },
+	{ .id = 0x10ec0255, .name = "ALC255", .patch = patch_alc269 },
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },


