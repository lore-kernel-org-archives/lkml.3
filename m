Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483Ab3K0Bvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:51:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab3K0A5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 35/80] ALSA: hda - Add support of ALC255 codecs
Date: Tue, 26 Nov 2013 16:57:04 -0800
Message-Id: <20131127005643.367549296@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2531,6 +2531,7 @@ enum {
 	ALC269_TYPE_ALC282,
 	ALC269_TYPE_ALC284,
 	ALC269_TYPE_ALC286,
+	ALC269_TYPE_ALC255,
 };
 
 /*
@@ -2555,6 +2556,7 @@ static int alc269_parse_auto_config(stru
 	case ALC269_TYPE_ALC269VD:
 	case ALC269_TYPE_ALC282:
 	case ALC269_TYPE_ALC286:
+	case ALC269_TYPE_ALC255:
 		ssids = alc269_ssids;
 		break;
 	default:
@@ -3765,6 +3767,9 @@ static int patch_alc269(struct hda_codec
 	case 0x10ec0286:
 		spec->codec_variant = ALC269_TYPE_ALC286;
 		break;
+	case 0x10ec0255:
+		spec->codec_variant = ALC269_TYPE_ALC255;
+		break;
 	}
 
 	/* automatic parse from the BIOS config */
@@ -4472,6 +4477,7 @@ static int patch_alc680(struct hda_codec
 static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0221, .name = "ALC221", .patch = patch_alc269 },
 	{ .id = 0x10ec0233, .name = "ALC233", .patch = patch_alc269 },
+	{ .id = 0x10ec0255, .name = "ALC255", .patch = patch_alc269 },
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },


