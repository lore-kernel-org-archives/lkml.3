Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab3BLHzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 02:55:06 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:58984 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3BLHzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 02:55:04 -0500
Message-ID: <1360655656.13766.6.camel@nexus.lab.ntt.co.jp>
Subject: [PATCH 2/3] ALSA: hda - no-primary-hp is a quirk for model ALC889
 not ALC882
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 16:54:16 +0900
In-Reply-To: <1360655264.13766.2.camel@nexus.lab.ntt.co.jp>
References: <1360655264.13766.2.camel@nexus.lab.ntt.co.jp>
Organization: NTT Open Source Software Center
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Substitute ALC889 for ALC882 in macro and function names.

Cc: stable@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.7.6-orig/sound/pci/hda/patch_realtek.c linux-3.7.6/sound/pci/hda/patch_realtek.c
--- linux-3.7.6-orig/sound/pci/hda/patch_realtek.c	2013-02-09 22:52:40.301209823 +0900
+++ linux-3.7.6/sound/pci/hda/patch_realtek.c	2013-02-09 22:58:54.695063675 +0900
@@ -5030,7 +5030,7 @@ enum {
 	ALC889_FIXUP_MBP_VREF,
 	ALC889_FIXUP_IMAC91_VREF,
 	ALC882_FIXUP_INV_DMIC,
-	ALC882_FIXUP_NO_PRIMARY_HP,
+	ALC889_FIXUP_NO_PRIMARY_HP,
 };
 
 static void alc889_fixup_coef(struct hda_codec *codec,
@@ -5156,7 +5156,7 @@ static void alc889_fixup_imac91_vref(str
  * Strangely, the speaker output doesn't work on Vaio Z and some Vaio
  * all-in-one desktop PCs (for example VGC-LN51JGB) through DAC 0x05
  */
-static void alc882_fixup_no_primary_hp(struct hda_codec *codec,
+static void alc889_fixup_no_primary_hp(struct hda_codec *codec,
 				       const struct alc_fixup *fix, int action)
 {
 	struct alc_spec *spec = codec->spec;
@@ -5350,9 +5350,9 @@ static const struct alc_fixup alc882_fix
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc_fixup_inv_dmic_0x12,
 	},
-	[ALC882_FIXUP_NO_PRIMARY_HP] = {
+	[ALC889_FIXUP_NO_PRIMARY_HP] = {
 		.type = ALC_FIXUP_FUNC,
-		.v.func = alc882_fixup_no_primary_hp,
+		.v.func = alc889_fixup_no_primary_hp,
 	},
 };
 
@@ -5388,8 +5388,8 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1043, 0x1971, "Asus W2JC", ALC882_FIXUP_ASUS_W2JC),
 	SND_PCI_QUIRK(0x1043, 0x835f, "Asus Eee 1601", ALC888_FIXUP_EEE1601),
 	SND_PCI_QUIRK(0x104d, 0x9047, "Sony Vaio TT", ALC889_FIXUP_VAIO_TT),
-	SND_PCI_QUIRK(0x104d, 0x905a, "Sony Vaio Z", ALC882_FIXUP_NO_PRIMARY_HP),
-	SND_PCI_QUIRK(0x104d, 0x9043, "Sony Vaio VGC-LN51JGB", ALC882_FIXUP_NO_PRIMARY_HP),
+	SND_PCI_QUIRK(0x104d, 0x905a, "Sony Vaio Z", ALC889_FIXUP_NO_PRIMARY_HP),
+	SND_PCI_QUIRK(0x104d, 0x9043, "Sony Vaio VGC-LN51JGB", ALC889_FIXUP_NO_PRIMARY_HP),
 
 	/* All Apple entries are in codec SSIDs */
 	SND_PCI_QUIRK(0x106b, 0x00a0, "MacBookPro 3,1", ALC889_FIXUP_MBP_VREF),
@@ -5432,7 +5432,7 @@ static const struct alc_model_fixup alc8
 	{.id = ALC882_FIXUP_ACER_ASPIRE_8930G, .name = "acer-aspire-8930g"},
 	{.id = ALC883_FIXUP_ACER_EAPD, .name = "acer-aspire"},
 	{.id = ALC882_FIXUP_INV_DMIC, .name = "inv-dmic"},
-	{.id = ALC882_FIXUP_NO_PRIMARY_HP, .name = "no-primary-hp"},
+	{.id = ALC889_FIXUP_NO_PRIMARY_HP, .name = "no-primary-hp"},
 	{}
 };
 


