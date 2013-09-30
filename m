Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3I3KPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:15:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3I3KNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 100/104] ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist
Date: Mon, 30 Sep 2013 11:11:17 +0100
Message-Id: <1380535881-9239-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 83f72151352791836a1b9c1542614cc9bf71ac61 upstream.

Toshiba Satellite C870 shows interrupt problems occasionally when
certain mixer controls like "Mic Switch" is toggled.  This seems
worked around by not using MSI.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=833585
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index d086bbf..c4b29d4 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2812,6 +2812,7 @@ static struct snd_pci_quirk msi_black_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
 	SND_PCI_QUIRK(0x1043, 0x822d, "ASUS", 0), /* Athlon64 X2 + nvidia MCP55 */
+	SND_PCI_QUIRK(0x1179, 0xfb44, "Toshiba Satellite C870", 0), /* AMD Hudson */
 	SND_PCI_QUIRK(0x1849, 0x0888, "ASRock", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0xa0a0, 0x0575, "Aopen MZ915-M", 0), /* ICH6 */
 	{}
-- 
1.8.3.2

