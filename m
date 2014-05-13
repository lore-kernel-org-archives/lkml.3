Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbaEMKpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:45:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60741 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759846AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "W. Trevor King" <wking@tremily.us>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 022/182] ALSA: hda - Enable beep for ASUS 1015E
Date: Tue, 13 May 2014 11:26:14 +0200
Message-Id: <c988654163bcfa8da501a80a5728cfd2fed2b346.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "W. Trevor King" <wking@tremily.us>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a4b7f21d7b42b33609df3f86992a8deff80abfaf upstream.

The `lspci -nnvv` output contains (wrapped for line length):

  00:1b.0 Audio device [0403]:
    Intel Corporation 7 Series/C210 Series Chipset Family
    High Definition Audio Controller [8086:1e20] (rev 04)
        Subsystem: ASUSTeK Computer Inc. Device [1043:115d]

Signed-off-by: W. Trevor King <wking@tremily.us>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 855074950e6c..69ae2ef1b138 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -944,6 +944,7 @@ static int alc_codec_rename_from_preset(struct hda_codec *codec)
 
 static const struct snd_pci_quirk beep_white_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x103c, "ASUS", 1),
+	SND_PCI_QUIRK(0x1043, 0x115d, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x8376, "EeePC", 1),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
-- 
1.9.3

