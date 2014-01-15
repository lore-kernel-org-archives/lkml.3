Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaAOWBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:01:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaAOWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:01:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 069/166] ALSA: hda - Add enable_msi=0 workaround for four HP machines
Date: Wed, 15 Jan 2014 13:51:23 -0800
Message-Id: <1389822780-4729-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 693e0cb052c607e2d41edf9e9f1fa99ff8c266c1 upstream.

While enabling these machines, we found we would sometimes lose an
interrupt if we change hardware volume during playback, and that
disabling msi fixed this issue. (Losing the interrupt caused underruns
and crackling audio, as the one second timeout is usually bigger than
the period size.)

The machines were all machines from HP, running AMD Hudson controller,
and Realtek ALC282 codec.

BugLink: https://bugs.launchpad.net/bugs/1260225
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 0614bf4..c142402 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3100,6 +3100,10 @@ static void check_probe_mask(struct azx *chip, int dev)
  * white/black-list for enable_msi
  */
 static struct snd_pci_quirk msi_black_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x2191, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x2192, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x21f7, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x21fa, "HP", 0), /* AMD Hudson */
 	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
 	SND_PCI_QUIRK(0x1043, 0x822d, "ASUS", 0), /* Athlon64 X2 + nvidia MCP55 */
-- 
1.8.3.2

