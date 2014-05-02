Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaEBQW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:22:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43745 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaEBPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 147/151] ALSA: hda - add headset mic detect quirk for a Dell laptop
Date: Fri,  2 May 2014 08:38:55 -0700
Message-Id: <1399045139-4531-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

commit 137bcc33c6fd775579c7d9d266e1972f56cf5cab upstream.

When we plug a 3-ring headset on the Dell machine (VID: 0x10ec0283,
SID: 0x10280667), the headset mic can't be detected, after apply this
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
index 0080bee..ad45ce4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4408,6 +4408,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0658, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x065f, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0662, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0667, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x15cc, "Dell X5 Precision", ALC269_FIXUP_DELL2_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x15cd, "Dell X5 Precision", ALC269_FIXUP_DELL2_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
-- 
1.9.1

