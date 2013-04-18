Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3DRJR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:17:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab3DRJRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 32/72] ALSA: hda - Enabling Realtek ALC 671 codec
Date: Thu, 18 Apr 2013 10:16:17 +0100
Message-Id: <1366276617-3553-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>

commit 1d87caa69c04008e09f5ff47b5e6acb6116febc7 upstream.

* Added the device ID to the modalias list and assinged ALC662 patches
for it
* Added 4 port support for the device ID 0671 in alc662_parse_auto_config

Signed-off-by: Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a351a6f..1baf0dc 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6525,7 +6525,8 @@ static int alc662_parse_auto_config(struct hda_codec *codec)
 	const hda_nid_t *ssids;
 
 	if (codec->vendor_id == 0x10ec0272 || codec->vendor_id == 0x10ec0663 ||
-	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670)
+	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670 ||
+	    codec->vendor_id == 0x10ec0671)
 		ssids = alc663_ssids;
 	else
 		ssids = alc662_ssids;
@@ -6970,6 +6971,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0665, .name = "ALC665", .patch = patch_alc662 },
 	{ .id = 0x10ec0668, .name = "ALC668", .patch = patch_alc662 },
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
+	{ .id = 0x10ec0671, .name = "ALC671", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
-- 
1.8.1.2

