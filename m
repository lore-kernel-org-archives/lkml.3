Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab3LFXQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:16:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759237Ab3LFXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:16:01 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 150/152] ALSA: hda - Provide missing pin configs for VAIO with ALC260
Date: Fri,  6 Dec 2013 15:11:14 -0800
Message-Id: <1386371476-2477-151-git-send-email-kamal@canonical.com>
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

commit d08c5ef2a039393eaf2ab2152db5f07790fa0f40 upstream.

Some models (or maybe depending on BIOS version) of Sony VAIO with
ALC260 give no proper pin configurations as default, resulting in the
non-working speaker, etc.  Just provide the whole pin configurations
via a fixup.

Reported-by: Matthew Markus <mmarkus@hearit.co>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c6c9e58..876948f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4850,6 +4850,7 @@ enum {
 	ALC260_FIXUP_REPLACER,
 	ALC260_FIXUP_HP_B1900,
 	ALC260_FIXUP_KN1,
+	ALC260_FIXUP_VAIO_PINS,
 };
 
 static void alc260_gpio1_automute(struct hda_codec *codec)
@@ -4962,6 +4963,24 @@ static const struct alc_fixup alc260_fixups[] = {
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc260_fixup_kn1,
 	},
+	[ALC260_FIXUP_VAIO_PINS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			/* Pin configs are missing completely on some VAIOs */
+			{ 0x0f, 0x01211020 },
+			{ 0x10, 0x0001003f },
+			{ 0x11, 0x411111f0 },
+			{ 0x12, 0x01a15930 },
+			{ 0x13, 0x411111f0 },
+			{ 0x14, 0x411111f0 },
+			{ 0x15, 0x411111f0 },
+			{ 0x16, 0x411111f0 },
+			{ 0x17, 0x411111f0 },
+			{ 0x18, 0x411111f0 },
+			{ 0x19, 0x411111f0 },
+			{ }
+		}
+	},
 };
 
 static const struct snd_pci_quirk alc260_fixup_tbl[] = {
@@ -4970,6 +4989,7 @@ static const struct snd_pci_quirk alc260_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x008f, "Acer", ALC260_FIXUP_GPIO1),
 	SND_PCI_QUIRK(0x103c, 0x280a, "HP dc5750", ALC260_FIXUP_HP_DC5750),
 	SND_PCI_QUIRK(0x103c, 0x30ba, "HP Presario B1900", ALC260_FIXUP_HP_B1900),
+	SND_PCI_QUIRK(0x104d, 0x81bb, "Sony VAIO", ALC260_FIXUP_VAIO_PINS),
 	SND_PCI_QUIRK(0x104d, 0x81e2, "Sony VAIO TX", ALC260_FIXUP_HP_PIN_0F),
 	SND_PCI_QUIRK(0x1509, 0x4540, "Favorit 100XS", ALC260_FIXUP_GPIO1),
 	SND_PCI_QUIRK(0x152d, 0x0729, "Quanta KN1", ALC260_FIXUP_KN1),
-- 
1.8.3.2

