Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaABRJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:09:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40516 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaABRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 49/91] ALSA: hda - Initialize missing bass speaker pin for ASUS AIO ET2700
Date: Thu,  2 Jan 2014 09:04:24 -0800
Message-Id: <1388682306-30859-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1f0bbf03cb829162ec8e6d03c98aaaed88c6f534 upstream.

Add a fixup entry for the missing bass speaker pin 0x16 on ASUS ET2700
AiO desktop.  The channel map will be added in the next patch, so that
this can be backported easily to stable kernels.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=65961
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 62de6f1..8a4764a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5080,6 +5080,7 @@ enum {
 	ALC889_FIXUP_IMAC91_VREF,
 	ALC882_FIXUP_INV_DMIC,
 	ALC882_FIXUP_NO_PRIMARY_HP,
+	ALC887_FIXUP_ASUS_BASS,
 };
 
 static void alc889_fixup_coef(struct hda_codec *codec,
@@ -5402,6 +5403,13 @@ static const struct alc_fixup alc882_fixups[] = {
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc882_fixup_no_primary_hp,
 	},
+	[ALC887_FIXUP_ASUS_BASS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{0x16, 0x99130130}, /* bass speaker */
+			{}
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc882_fixup_tbl[] = {
@@ -5435,6 +5443,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1873, "ASUS W90V", ALC882_FIXUP_ASUS_W90V),
 	SND_PCI_QUIRK(0x1043, 0x1971, "Asus W2JC", ALC882_FIXUP_ASUS_W2JC),
 	SND_PCI_QUIRK(0x1043, 0x835f, "Asus Eee 1601", ALC888_FIXUP_EEE1601),
+	SND_PCI_QUIRK(0x1043, 0x84bc, "ASUS ET2700", ALC887_FIXUP_ASUS_BASS),
 	SND_PCI_QUIRK(0x104d, 0x9047, "Sony Vaio TT", ALC889_FIXUP_VAIO_TT),
 	SND_PCI_QUIRK(0x104d, 0x905a, "Sony Vaio Z", ALC882_FIXUP_NO_PRIMARY_HP),
 	SND_PCI_QUIRK(0x104d, 0x9043, "Sony Vaio VGC-LN51JGB", ALC882_FIXUP_NO_PRIMARY_HP),
-- 
1.8.3.2

