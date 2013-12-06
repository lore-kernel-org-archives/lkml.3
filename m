Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162870Ab3LFXxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:53:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab3LFXMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 021/152] ALSA: hda - Add support of ALC255 codecs
Date: Fri,  6 Dec 2013 15:09:05 -0800
Message-Id: <1386371476-2477-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 1d04c9de5c76df113e4af7120feb53c628b5efcc upstream.

It's just another variant of ALC269 & co.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5267e48..fe2138d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5824,6 +5824,7 @@ enum {
 	ALC269_TYPE_ALC282,
 	ALC269_TYPE_ALC284,
 	ALC269_TYPE_ALC286,
+	ALC269_TYPE_ALC255,
 };
 
 /*
@@ -5848,6 +5849,7 @@ static int alc269_parse_auto_config(struct hda_codec *codec)
 	case ALC269_TYPE_ALC269VD:
 	case ALC269_TYPE_ALC282:
 	case ALC269_TYPE_ALC286:
+	case ALC269_TYPE_ALC255:
 		ssids = alc269_ssids;
 		break;
 	default:
@@ -6466,6 +6468,9 @@ static int patch_alc269(struct hda_codec *codec)
 	case 0x10ec0286:
 		spec->codec_variant = ALC269_TYPE_ALC286;
 		break;
+	case 0x10ec0255:
+		spec->codec_variant = ALC269_TYPE_ALC255;
+		break;
 	}
 
 	/* automatic parse from the BIOS config */
@@ -7164,6 +7169,7 @@ static int patch_alc680(struct hda_codec *codec)
 static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0221, .name = "ALC221", .patch = patch_alc269 },
 	{ .id = 0x10ec0233, .name = "ALC233", .patch = patch_alc269 },
+	{ .id = 0x10ec0255, .name = "ALC255", .patch = patch_alc269 },
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },
-- 
1.8.3.2

