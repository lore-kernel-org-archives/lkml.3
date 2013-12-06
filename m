Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab3LFXrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:47:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161376Ab3LFXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 046/152] ALSA: hda - Enable SPDIF for Acer TravelMate 6293
Date: Fri,  6 Dec 2013 15:09:30 -0800
Message-Id: <1386371476-2477-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 24eff328f65c8ef352c90b6adb7c2f39eb94205d upstream.

BIOS on Acer TravelMate 6293 doesn't set up the SPDIF output pin
correctly as default, so enable it via a fixup entry.

Reported-and-tested-by: Hagen Heiduck <heiduck.suse@fmail.postpro.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index fe2138d..500c00a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5687,6 +5687,7 @@ static const struct hda_verb alc268_beep_init_verbs[] = {
 enum {
 	ALC268_FIXUP_INV_DMIC,
 	ALC268_FIXUP_HP_EAPD,
+	ALC268_FIXUP_SPDIF,
 };
 
 static const struct alc_fixup alc268_fixups[] = {
@@ -5701,6 +5702,13 @@ static const struct alc_fixup alc268_fixups[] = {
 			{}
 		}
 	},
+	[ALC268_FIXUP_SPDIF] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1e, 0x014b1180 }, /* enable SPDIF out */
+			{}
+		}
+	},
 };
 
 static const struct alc_model_fixup alc268_fixup_models[] = {
@@ -5710,6 +5718,7 @@ static const struct alc_model_fixup alc268_fixup_models[] = {
 };
 
 static const struct snd_pci_quirk alc268_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1025, 0x0139, "Acer TravelMate 6293", ALC268_FIXUP_SPDIF),
 	SND_PCI_QUIRK(0x1025, 0x015b, "Acer AOA 150 (ZG5)", ALC268_FIXUP_INV_DMIC),
 	/* below is codec SSID since multiple Toshiba laptops have the
 	 * same PCI SSID 1179:ff00
-- 
1.8.3.2

