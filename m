Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab3HRUm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:42:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab3HRUfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 27/45] ALSA: hda - Add pinfix for LG LW25 laptop
Date: Sun, 18 Aug 2013 13:36:16 -0700
Message-Id: <20130818203622.886162329@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit db8a38e5063a4daf61252e65d47ab3495c705f4c upstream.

Correct the pins for a line-in and a headphone on LG LW25 laptop with
ALC880 codec.  Other pins seem fine.

Reported-and-tested-by: Joonas Saarinen <jonskunator@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1027,6 +1027,7 @@ enum {
 	ALC880_FIXUP_GPIO2,
 	ALC880_FIXUP_MEDION_RIM,
 	ALC880_FIXUP_LG,
+	ALC880_FIXUP_LG_LW25,
 	ALC880_FIXUP_W810,
 	ALC880_FIXUP_EAPD_COEF,
 	ALC880_FIXUP_TCL_S700,
@@ -1085,6 +1086,14 @@ static const struct hda_fixup alc880_fix
 			{ }
 		}
 	},
+	[ALC880_FIXUP_LG_LW25] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x0181344f }, /* line-in */
+			{ 0x1b, 0x0321403f }, /* headphone */
+			{ }
+		}
+	},
 	[ALC880_FIXUP_W810] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -1337,6 +1346,7 @@ static const struct snd_pci_quirk alc880
 	SND_PCI_QUIRK(0x1854, 0x003b, "LG", ALC880_FIXUP_LG),
 	SND_PCI_QUIRK(0x1854, 0x005f, "LG P1 Express", ALC880_FIXUP_LG),
 	SND_PCI_QUIRK(0x1854, 0x0068, "LG w1", ALC880_FIXUP_LG),
+	SND_PCI_QUIRK(0x1854, 0x0077, "LG LW25", ALC880_FIXUP_LG_LW25),
 	SND_PCI_QUIRK(0x19db, 0x4188, "TCL S700", ALC880_FIXUP_TCL_S700),
 
 	/* Below is the copied entries from alc880_quirks.c.


