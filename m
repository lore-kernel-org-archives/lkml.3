Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaEBP5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:57:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaEBPpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 090/151] ALSA: hda - add headset mic detect quirks for three Dell laptops
Date: Fri,  2 May 2014 08:37:58 -0700
Message-Id: <1399045139-4531-91-git-send-email-kamal@canonical.com>
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

commit a870593bab179ca402ead455f45af6e4404a2a7f upstream.

When we plug a 3-ring headset on the Dell machines (VID: 0x10ec0255,
SID: 0x10280632; VID: 0x10ec0293, SID: 0x1028062c; VID: 0x10ec0293,
SID: 0x1028062e), the headset mic can't be detected, after apply this
patch, the headset mic can work well.

BugLink: https://bugs.launchpad.net/bugs/1297581
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4afa7a0..3739a66 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4391,6 +4391,9 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0616, "Dell Vostro 5470", ALC290_FIXUP_MONO_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x061f, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0629, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x062c, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x062e, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0632, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0638, "Dell Inspiron 5439", ALC290_FIXUP_MONO_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x063e, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x063f, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
1.9.1

