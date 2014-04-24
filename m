Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaDXJyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:54:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaDXIyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "W. Trevor King" <wking@tremily.us>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 108/182] ALSA: hda - Enable beep for ASUS 1015E
Date: Thu, 24 Apr 2014 09:50:33 +0100
Message-Id: <1398329507-5911-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "W. Trevor King" <wking@tremily.us>

commit a4b7f21d7b42b33609df3f86992a8deff80abfaf upstream.

The `lspci -nnvv` output contains (wrapped for line length):

  00:1b.0 Audio device [0403]:
    Intel Corporation 7 Series/C210 Series Chipset Family
    High Definition Audio Controller [8086:1e20] (rev 04)
        Subsystem: ASUSTeK Computer Inc. Device [1043:115d]

Signed-off-by: W. Trevor King <wking@tremily.us>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index add9f3d..740902f1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -941,6 +941,7 @@ static int alc_codec_rename_from_preset(struct hda_codec *codec)
 
 static const struct snd_pci_quirk beep_white_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x103c, "ASUS", 1),
+	SND_PCI_QUIRK(0x1043, 0x115d, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x8376, "EeePC", 1),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
-- 
1.9.1

