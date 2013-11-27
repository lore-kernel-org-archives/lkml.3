Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3K0A56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:57:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114Ab3K0A5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 39/80] ALSA: hda - Add pincfg fixup for ASUS W5A
Date: Tue, 26 Nov 2013 16:57:08 -0800
Message-Id: <20131127005643.643903882@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 487a588d09db0d6508261867df208d8bdc718251 upstream.

BIOS on ASUS W5A laptop with ALC880 codec doesn't provide any pin
configurations, so we have to set up all pins manually.

Reported-and-tested-by: nb <nb@dagami.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1037,6 +1037,7 @@ enum {
 	ALC880_FIXUP_UNIWILL,
 	ALC880_FIXUP_UNIWILL_DIG,
 	ALC880_FIXUP_Z71V,
+	ALC880_FIXUP_ASUS_W5A,
 	ALC880_FIXUP_3ST_BASE,
 	ALC880_FIXUP_3ST,
 	ALC880_FIXUP_3ST_DIG,
@@ -1207,6 +1208,26 @@ static const struct hda_fixup alc880_fix
 			{ }
 		}
 	},
+	[ALC880_FIXUP_ASUS_W5A] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			/* set up the whole pins as BIOS is utterly broken */
+			{ 0x14, 0x0121411f }, /* HP */
+			{ 0x15, 0x411111f0 }, /* N/A */
+			{ 0x16, 0x411111f0 }, /* N/A */
+			{ 0x17, 0x411111f0 }, /* N/A */
+			{ 0x18, 0x90a60160 }, /* mic */
+			{ 0x19, 0x411111f0 }, /* N/A */
+			{ 0x1a, 0x411111f0 }, /* N/A */
+			{ 0x1b, 0x411111f0 }, /* N/A */
+			{ 0x1c, 0x411111f0 }, /* N/A */
+			{ 0x1d, 0x411111f0 }, /* N/A */
+			{ 0x1e, 0xb743111e }, /* SPDIF out */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC880_FIXUP_GPIO1,
+	},
 	[ALC880_FIXUP_3ST_BASE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -1328,6 +1349,7 @@ static const struct hda_fixup alc880_fix
 
 static const struct snd_pci_quirk alc880_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1019, 0x0f69, "Coeus G610P", ALC880_FIXUP_W810),
+	SND_PCI_QUIRK(0x1043, 0x10c3, "ASUS W5A", ALC880_FIXUP_ASUS_W5A),
 	SND_PCI_QUIRK(0x1043, 0x1964, "ASUS Z71V", ALC880_FIXUP_Z71V),
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS", ALC880_FIXUP_GPIO1),
 	SND_PCI_QUIRK(0x1558, 0x5401, "Clevo GPIO2", ALC880_FIXUP_GPIO2),


