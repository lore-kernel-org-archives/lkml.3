Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaF3MMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:12:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51999 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753463AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anssi Hannula <anssi.hannula@iki.fi>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/181] ALSA: hda - hdmi: Use TFx channel positions instead of FxH
Date: Mon, 30 Jun 2014 13:51:43 +0200
Message-Id: <36dc25905f646a2d854b2e15dc0248fc47674dab.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anssi Hannula <anssi.hannula@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 94908a39ce971f25c3695c334d88eec4d2837428 upstream.

Channel map positions FLH, FCH, FRH duplicate positions TFL, TFC, TFR.
Both are the speakers above the front speakers (CEA uses "high" and USB
audio uses "top" nomenclature).

Since the USB audio code has used the TFx positions since v3.8
(04324ccc75f96, "ALSA: usb-audio: add channel map support") but the HDMI
code only just started using FxH in a5b7d510b2220cccb ("ALSA: hda -
hdmi: Fix channel maps with less common speakers") which is not yet in
any released kernel, standardize on TFx instead.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_hdmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 2949c8d34d33..9d1a53f2a510 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -743,12 +743,12 @@ static struct channel_map_table map_tables[] = {
 	{ SNDRV_CHMAP_RC,	RC },
 	{ SNDRV_CHMAP_FLC,	FLC },
 	{ SNDRV_CHMAP_FRC,	FRC },
-	{ SNDRV_CHMAP_FLH,	FLH },
-	{ SNDRV_CHMAP_FRH,	FRH },
+	{ SNDRV_CHMAP_TFL,	FLH },
+	{ SNDRV_CHMAP_TFR,	FRH },
 	{ SNDRV_CHMAP_FLW,	FLW },
 	{ SNDRV_CHMAP_FRW,	FRW },
 	{ SNDRV_CHMAP_TC,	TC },
-	{ SNDRV_CHMAP_FCH,	FCH },
+	{ SNDRV_CHMAP_TFC,	FCH },
 	{} /* terminator */
 };
 
-- 
2.0.0

