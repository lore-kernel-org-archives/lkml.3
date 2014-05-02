Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaEBPqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:46:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44327 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbaEBPqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "W. Trevor King" <wking@tremily.us>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 110/151] ALSA: hda - Enable beep for ASUS 1015E
Date: Fri,  2 May 2014 08:38:18 -0700
Message-Id: <1399045139-4531-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3739a66..331ede8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -954,6 +954,7 @@ static int alc_codec_rename_from_preset(struct hda_codec *codec)
 
 static const struct snd_pci_quirk beep_white_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x103c, "ASUS", 1),
+	SND_PCI_QUIRK(0x1043, 0x115d, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x8376, "EeePC", 1),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
-- 
1.9.1

