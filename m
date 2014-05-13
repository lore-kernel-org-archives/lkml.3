Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaEMDFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:05:21 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8035 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaEMDFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:05:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 May 2014 20:00:22 -0700
From: Aaron Plattner <aplattner@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>, Takashi Iwai <tiwai@suse.de>
CC: Aaron Plattner <aplattner@nvidia.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] ALSA: hda - Add new GPU codec ID to snd-hda
Date: Mon, 12 May 2014 20:05:02 -0700
Message-ID: <1399950302-29012-1-git-send-email-aplattner@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vendor ID 0x10de0071 is used by a yet-to-be-named GPU chip.

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Stephen Warren <swarren@nvidia.com>
---
I verified that the patch_nvhdmi code is still needed for this chip.

 sound/pci/hda/patch_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 0cb5b89cd0c8..347a84b58c39 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3330,6 +3330,7 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x10de0051, .name = "GPU 51 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de0060, .name = "GPU 60 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
+{ .id = 0x10de0071, .name = "GPU 71 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x11069f80, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
 { .id = 0x11069f81, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
@@ -3385,6 +3386,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0044");
 MODULE_ALIAS("snd-hda-codec-id:10de0051");
 MODULE_ALIAS("snd-hda-codec-id:10de0060");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
+MODULE_ALIAS("snd-hda-codec-id:10de0071");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 MODULE_ALIAS("snd-hda-codec-id:11069f80");
 MODULE_ALIAS("snd-hda-codec-id:11069f81");
-- 
1.9.2

