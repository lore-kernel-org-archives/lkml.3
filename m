Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaBCXyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:54:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49027 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaBCXyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:54:11 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: stable@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Anssi Hannula <anssi.hannula@iki.fi>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] ALSA: hda - hdmi: introduce patch_nvhdmi()
Date: Mon,  3 Feb 2014 16:54:03 -0700
Message-Id: <1391471644-16256-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anssi Hannula <anssi.hannula@iki.fi>

(This is a backport of *part* of upstream 611885bc963a "ALSA: hda -
hdmi: Disallow unsupported 2ch remapping on NVIDIA codecs" to stable
3.10 through 3.12. Later stable already contain all of the original
patch.)

Mainline commit 611885bc963a "ALSA: hda - hdmi: Disallow unsupported 2ch
remapping on NVIDIA codecs" introduces function patch_nvhdmi(). That
function is edited by 75fae117a5db "ALSA: hda/hdmi - allow PIN_OUT to be
dynamically enabled". In order to backport the PIN_OUT patch, I am first
back-porting just the addition of function patch_nvhdmi(), so that the
conflicts applying the PIN_OUT patch are simplified.

Ideally, one might backport all of 611885bc963a. However, that commit
doesn't apply to stable kernels, since it relies on a chain of other
patches which implement new features.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[swarren, extracted just a small part of the original patch]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 sound/pci/hda/patch_hdmi.c | 60 ++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index f26c42c92db7..aad73a1fc2cd 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2560,6 +2560,20 @@ static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
 	return 0;
 }
 
+static int patch_nvhdmi(struct hda_codec *codec)
+{
+	struct hdmi_spec *spec;
+	int err;
+
+	err = patch_generic_hdmi(codec);
+	if (err)
+		return err;
+
+	spec = codec->spec;
+
+	return 0;
+}
+
 /*
  * ATI-specific implementations
  *
@@ -2632,30 +2646,30 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x10de0005, .name = "MCP77/78 HDMI",	.patch = patch_nvhdmi_8ch_7x },
 { .id = 0x10de0006, .name = "MCP77/78 HDMI",	.patch = patch_nvhdmi_8ch_7x },
 { .id = 0x10de0007, .name = "MCP79/7A HDMI",	.patch = patch_nvhdmi_8ch_7x },
-{ .id = 0x10de000a, .name = "GPU 0a HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de000b, .name = "GPU 0b HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de000c, .name = "MCP89 HDMI",	.patch = patch_generic_hdmi },
-{ .id = 0x10de000d, .name = "GPU 0d HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0010, .name = "GPU 10 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0011, .name = "GPU 11 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0012, .name = "GPU 12 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0013, .name = "GPU 13 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0014, .name = "GPU 14 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0015, .name = "GPU 15 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0016, .name = "GPU 16 HDMI/DP",	.patch = patch_generic_hdmi },
+{ .id = 0x10de000a, .name = "GPU 0a HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de000b, .name = "GPU 0b HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de000c, .name = "MCP89 HDMI",	.patch = patch_nvhdmi },
+{ .id = 0x10de000d, .name = "GPU 0d HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0010, .name = "GPU 10 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0011, .name = "GPU 11 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0012, .name = "GPU 12 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0013, .name = "GPU 13 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0014, .name = "GPU 14 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0015, .name = "GPU 15 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0016, .name = "GPU 16 HDMI/DP",	.patch = patch_nvhdmi },
 /* 17 is known to be absent */
-{ .id = 0x10de0018, .name = "GPU 18 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0019, .name = "GPU 19 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de001a, .name = "GPU 1a HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de001b, .name = "GPU 1b HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de001c, .name = "GPU 1c HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0040, .name = "GPU 40 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0041, .name = "GPU 41 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0042, .name = "GPU 42 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0043, .name = "GPU 43 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0044, .name = "GPU 44 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0051, .name = "GPU 51 HDMI/DP",	.patch = patch_generic_hdmi },
-{ .id = 0x10de0060, .name = "GPU 60 HDMI/DP",	.patch = patch_generic_hdmi },
+{ .id = 0x10de0018, .name = "GPU 18 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0019, .name = "GPU 19 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de001a, .name = "GPU 1a HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de001b, .name = "GPU 1b HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de001c, .name = "GPU 1c HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0040, .name = "GPU 40 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0041, .name = "GPU 41 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0042, .name = "GPU 42 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0043, .name = "GPU 43 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0044, .name = "GPU 44 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0051, .name = "GPU 51 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0060, .name = "GPU 60 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x11069f80, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
-- 
1.8.1.5

