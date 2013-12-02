Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3LBUny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:43:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3LBTOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 116/173] ALSA: hda - Initialize missing bass speaker pin for ASUS AIO ET2700
Date: Mon,  2 Dec 2013 11:11:39 -0800
Message-Id: <20131202191157.089947628@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1f0bbf03cb829162ec8e6d03c98aaaed88c6f534 upstream.

Add a fixup entry for the missing bass speaker pin 0x16 on ASUS ET2700
AiO desktop.  The channel map will be added in the next patch, so that
this can be backported easily to stable kernels.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=65961
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1765,6 +1765,7 @@ enum {
 	ALC889_FIXUP_IMAC91_VREF,
 	ALC882_FIXUP_INV_DMIC,
 	ALC882_FIXUP_NO_PRIMARY_HP,
+	ALC887_FIXUP_ASUS_BASS,
 };
 
 static void alc889_fixup_coef(struct hda_codec *codec,
@@ -2086,6 +2087,13 @@ static const struct hda_fixup alc882_fix
 		.type = HDA_FIXUP_FUNC,
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
@@ -2119,6 +2127,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1043, 0x1873, "ASUS W90V", ALC882_FIXUP_ASUS_W90V),
 	SND_PCI_QUIRK(0x1043, 0x1971, "Asus W2JC", ALC882_FIXUP_ASUS_W2JC),
 	SND_PCI_QUIRK(0x1043, 0x835f, "Asus Eee 1601", ALC888_FIXUP_EEE1601),
+	SND_PCI_QUIRK(0x1043, 0x84bc, "ASUS ET2700", ALC887_FIXUP_ASUS_BASS),
 	SND_PCI_QUIRK(0x104d, 0x9047, "Sony Vaio TT", ALC889_FIXUP_VAIO_TT),
 	SND_PCI_QUIRK(0x104d, 0x905a, "Sony Vaio Z", ALC882_FIXUP_NO_PRIMARY_HP),
 	SND_PCI_QUIRK(0x104d, 0x9043, "Sony Vaio VGC-LN51JGB", ALC882_FIXUP_NO_PRIMARY_HP),


