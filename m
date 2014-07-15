Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbaGOWGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:06:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54528 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425AbaGOVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:36:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 134/198] ALSA: hda - Add quirk for external mic on Lifebook U904
Date: Tue, 15 Jul 2014 14:30:04 -0700
Message-Id: <1405459868-15089-135-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 2041d56464a067461d7cc21734a0f024587ed2ff upstream.

According to the bug reporter (Данило Шеган), the external mic
starts to work and has proper jack detection if only pin 0x19
is marked properly as an external headset mic.

AlsaInfo at https://bugs.launchpad.net/ubuntu/+source/pulseaudio/+bug/1328587/+attachment/4128991/+files/AlsaInfo.txt

BugLink: https://bugs.launchpad.net/bugs/1328587
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d370e43..d44229b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3958,6 +3958,7 @@ enum {
 	ALC269_FIXUP_HEADSET_MIC,
 	ALC269_FIXUP_QUANTA_MUTE,
 	ALC269_FIXUP_LIFEBOOK,
+	ALC269_FIXUP_LIFEBOOK_EXTMIC,
 	ALC269_FIXUP_AMIC,
 	ALC269_FIXUP_DMIC,
 	ALC269VB_FIXUP_AMIC,
@@ -4081,6 +4082,13 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_QUANTA_MUTE
 	},
+	[ALC269_FIXUP_LIFEBOOK_EXTMIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1903c }, /* headset mic, with jack detect */
+			{ }
+		},
+	},
 	[ALC269_FIXUP_AMIC] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -4442,6 +4450,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x104d, 0x9084, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),
 	SND_PCI_QUIRK_VENDOR(0x104d, "Sony VAIO", ALC269_FIXUP_SONY_VAIO),
 	SND_PCI_QUIRK(0x10cf, 0x1475, "Lifebook", ALC269_FIXUP_LIFEBOOK),
+	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Thinkpad SL410/510", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Thinkpad L512", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21b8, "Thinkpad Edge 14", ALC269_FIXUP_SKU_IGNORE),
-- 
1.9.1

