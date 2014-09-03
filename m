Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaICJzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:55:38 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57294 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755456AbaICJzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:55:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 21/56] ALSA: hda - fix an external mic jack problem on a HP machine
Date: Wed,  3 Sep 2014 11:26:40 +0200
Message-Id: <e091fa4e253635c5f40cf5dc45a8ac0392a0df8d.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7440850c20b69658f322119d20a94dc914127cc7 upstream.

ON the machine, two pin complex (0xb and 0xe) are both routed to
the same external right-side mic jack, this makes the jack can't work.

To fix this problem, set the 0xe to "not connected".

BugLink: https://bugs.launchpad.net/bugs/1350148
Tested-by: Franz Hsieh <franz.hsieh@canonical.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_sigmatel.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 53e7c9bb99e8..3c90447c5810 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -84,6 +84,7 @@ enum {
 	STAC_DELL_EQ,
 	STAC_ALIENWARE_M17X,
 	STAC_92HD89XX_HP_FRONT_JACK,
+	STAC_92HD89XX_HP_Z1_G2_RIGHT_MIC_JACK,
 	STAC_92HD73XX_MODELS
 };
 
@@ -1792,6 +1793,11 @@ static const struct hda_pintbl stac92hd89xx_hp_front_jack_pin_configs[] = {
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
@@ -1914,6 +1920,10 @@ static const struct hda_fixup stac92hd73xx_fixups[] = {
 	[STAC_92HD89XX_HP_FRONT_JACK] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = stac92hd89xx_hp_front_jack_pin_configs,
+	},
+	[STAC_92HD89XX_HP_Z1_G2_RIGHT_MIC_JACK] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = stac92hd89xx_hp_z1_g2_right_mic_jack_pin_configs,
 	}
 };
 
@@ -1974,6 +1984,8 @@ static const struct snd_pci_quirk stac92hd73xx_fixup_tbl[] = {
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0490,
 		      "Alienware M17x R3", STAC_DELL_EQ),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1927,
+				"HP Z1 G2", STAC_92HD89XX_HP_Z1_G2_RIGHT_MIC_JACK),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x2b17,
 				"unknown HP", STAC_92HD89XX_HP_FRONT_JACK),
 	{} /* terminator */
-- 
2.1.0

