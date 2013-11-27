Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3K0B2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:28:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab3K0A6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 046/116] ALSA: hda - Enable SPDIF for Acer TravelMate 6293
Date: Tue, 26 Nov 2013 16:56:59 -0800
Message-Id: <20131127005740.135626402@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 24eff328f65c8ef352c90b6adb7c2f39eb94205d upstream.

BIOS on Acer TravelMate 6293 doesn't set up the SPDIF output pin
correctly as default, so enable it via a fixup entry.

Reported-and-tested-by: Hagen Heiduck <heiduck.suse@fmail.postpro.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2388,6 +2388,7 @@ static const struct hda_verb alc268_beep
 enum {
 	ALC268_FIXUP_INV_DMIC,
 	ALC268_FIXUP_HP_EAPD,
+	ALC268_FIXUP_SPDIF,
 };
 
 static const struct hda_fixup alc268_fixups[] = {
@@ -2402,6 +2403,13 @@ static const struct hda_fixup alc268_fix
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
 
 static const struct hda_model_fixup alc268_fixup_models[] = {
@@ -2411,6 +2419,7 @@ static const struct hda_model_fixup alc2
 };
 
 static const struct snd_pci_quirk alc268_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1025, 0x0139, "Acer TravelMate 6293", ALC268_FIXUP_SPDIF),
 	SND_PCI_QUIRK(0x1025, 0x015b, "Acer AOA 150 (ZG5)", ALC268_FIXUP_INV_DMIC),
 	/* below is codec SSID since multiple Toshiba laptops have the
 	 * same PCI SSID 1179:ff00


