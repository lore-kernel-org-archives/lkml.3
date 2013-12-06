Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab3LFOOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:14:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161220Ab3LFNAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/272] ALSA: hda - Provide missing pin configs for VAIO with ALC260
Date: Fri,  6 Dec 2013 12:55:31 +0000
Message-Id: <1386334761-25517-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d08c5ef2a039393eaf2ab2152db5f07790fa0f40 upstream.

Some models (or maybe depending on BIOS version) of Sony VAIO with
ALC260 give no proper pin configurations as default, resulting in the
non-working speaker, etc.  Just provide the whole pin configurations
via a fixup.

Reported-by: Matthew Markus <mmarkus@hearit.co>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3e133e7..084ec6c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1477,6 +1477,7 @@ enum {
 	ALC260_FIXUP_KN1,
 	ALC260_FIXUP_FSC_S7020,
 	ALC260_FIXUP_FSC_S7020_JWSE,
+	ALC260_FIXUP_VAIO_PINS,
 };
 
 static void alc260_gpio1_automute(struct hda_codec *codec)
@@ -1617,6 +1618,24 @@ static const struct hda_fixup alc260_fixups[] = {
 		.chained = true,
 		.chain_id = ALC260_FIXUP_FSC_S7020,
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
@@ -1625,6 +1644,7 @@ static const struct snd_pci_quirk alc260_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x008f, "Acer", ALC260_FIXUP_GPIO1),
 	SND_PCI_QUIRK(0x103c, 0x280a, "HP dc5750", ALC260_FIXUP_HP_DC5750),
 	SND_PCI_QUIRK(0x103c, 0x30ba, "HP Presario B1900", ALC260_FIXUP_HP_B1900),
+	SND_PCI_QUIRK(0x104d, 0x81bb, "Sony VAIO", ALC260_FIXUP_VAIO_PINS),
 	SND_PCI_QUIRK(0x104d, 0x81e2, "Sony VAIO TX", ALC260_FIXUP_HP_PIN_0F),
 	SND_PCI_QUIRK(0x10cf, 0x1326, "FSC LifeBook S7020", ALC260_FIXUP_FSC_S7020),
 	SND_PCI_QUIRK(0x1509, 0x4540, "Favorit 100XS", ALC260_FIXUP_GPIO1),
-- 
1.8.3.2

