Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705AbaFJUkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:40:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34810 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaFJTqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 015/160] ALSA: hda - add headset mic detect quirk for a Dell laptop
Date: Tue, 10 Jun 2014 12:44:15 -0700
Message-Id: <1402429600-20477-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

commit 67807ce55f6e5ad5c04a748aa195333d6af05654 upstream.

When we plug a 3-ring headset on the Dell machine (VID: 0x10ec0255,
SID: 0x1028067f), the headset mic can't be detected, after apply this
patch, the headset mic can work well.

BugLink: https://bugs.launchpad.net/bugs/1297581
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 93b95b8..076b83a9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4409,6 +4409,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x065f, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0662, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0667, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x067f, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x15cc, "Dell X5 Precision", ALC269_FIXUP_DELL2_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x15cd, "Dell X5 Precision", ALC269_FIXUP_DELL2_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
-- 
1.9.1

