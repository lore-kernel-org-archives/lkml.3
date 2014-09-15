Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbaIOW2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:28:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485AbaIOWUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 111/187] ALSA: hda - fix an external mic jack problem on a HP machine
Date: Mon, 15 Sep 2014 15:08:41 -0700
Message-Id: <1410818997-9432-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

commit 7440850c20b69658f322119d20a94dc914127cc7 upstream.

ON the machine, two pin complex (0xb and 0xe) are both routed to
the same external right-side mic jack, this makes the jack can't work.

To fix this problem, set the 0xe to "not connected".

BugLink: https://bugs.launchpad.net/bugs/1350148
Tested-by: Franz Hsieh <franz.hsieh@canonical.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_sigmatel.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 0f28aa2..c7b0ba6 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -84,6 +84,7 @@ enum {
 	STAC_DELL_EQ,
 	STAC_ALIENWARE_M17X,
 	STAC_92HD89XX_HP_FRONT_JACK,
+	STAC_92HD89XX_HP_Z1_G2_RIGHT_MIC_JACK,
 	STAC_92HD73XX_MODELS
 };
 
@@ -1785,6 +1786,11 @@ static const struct hda_pintbl stac92hd89xx_hp_front_jack_pin_configs[] = {
 	{}
 };
 
+static const struct hda_pintbl stac92hd89xx_hp_z1_g2_right_mic_jack_pin_configs[] = {
+	{ 0x0e, 0x400000f0 },
+	{}
+};
+
 static void stac92hd73xx_fixup_ref(struct hda_codec *codec,
 				   const struct hda_fixup *fix, int action)
 {
@@ -1907,6 +1913,10 @@ static const struct hda_fixup stac92hd73xx_fixups[] = {
 	[STAC_92HD89XX_HP_FRONT_JACK] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = stac92hd89xx_hp_front_jack_pin_configs,
+	},
+	[STAC_92HD89XX_HP_Z1_G2_RIGHT_MIC_JACK] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = stac92hd89xx_hp_z1_g2_right_mic_jack_pin_configs,
 	}
 };
 
@@ -1967,6 +1977,8 @@ static const struct snd_pci_quirk stac92hd73xx_fixup_tbl[] = {
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0490,
 		      "Alienware M17x R3", STAC_DELL_EQ),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1927,
+				"HP Z1 G2", STAC_92HD89XX_HP_Z1_G2_RIGHT_MIC_JACK),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x2b17,
 				"unknown HP", STAC_92HD89XX_HP_FRONT_JACK),
 	{} /* terminator */
-- 
1.9.1

