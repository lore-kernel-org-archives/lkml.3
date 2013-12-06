Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab3LFXmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:42:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422787Ab3LFXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:16:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 067/152] ALSA: hda - Add pincfg fixup for ASUS W5A
Date: Fri,  6 Dec 2013 15:09:51 -0800
Message-Id: <1386371476-2477-68-git-send-email-kamal@canonical.com>
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

commit 487a588d09db0d6508261867df208d8bdc718251 upstream.

BIOS on ASUS W5A laptop with ALC880 codec doesn't provide any pin
configurations, so we have to set up all pins manually.

Reported-and-tested-by: nb <nb@dagami.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 500c00a..a9a177a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4411,6 +4411,7 @@ enum {
 	ALC880_FIXUP_UNIWILL,
 	ALC880_FIXUP_UNIWILL_DIG,
 	ALC880_FIXUP_Z71V,
+	ALC880_FIXUP_ASUS_W5A,
 	ALC880_FIXUP_3ST_BASE,
 	ALC880_FIXUP_3ST,
 	ALC880_FIXUP_3ST_DIG,
@@ -4572,6 +4573,26 @@ static const struct alc_fixup alc880_fixups[] = {
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
 		.type = ALC_FIXUP_PINS,
 		.v.pins = (const struct alc_pincfg[]) {
@@ -4684,6 +4705,7 @@ static const struct alc_fixup alc880_fixups[] = {
 
 static const struct snd_pci_quirk alc880_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1019, 0x0f69, "Coeus G610P", ALC880_FIXUP_W810),
+	SND_PCI_QUIRK(0x1043, 0x10c3, "ASUS W5A", ALC880_FIXUP_ASUS_W5A),
 	SND_PCI_QUIRK(0x1043, 0x1964, "ASUS Z71V", ALC880_FIXUP_Z71V),
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS", ALC880_FIXUP_GPIO1),
 	SND_PCI_QUIRK(0x1558, 0x5401, "Clevo GPIO2", ALC880_FIXUP_GPIO2),
-- 
1.8.3.2

