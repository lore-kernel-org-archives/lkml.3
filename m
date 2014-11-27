Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaK0IqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:41085 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbaK0IqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:05 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 06/91] ALSA: hda - Fix COEF setups for ALC1150 codec
Date: Thu, 27 Nov 2014 16:41:49 +0800
Message-Id: <1417077794-9299-6-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit acf08081adb5e8fe0519eb97bb49797ef52614d6 upstream.

ALC1150 codec seems to need the COEF- and PLL-setups just like its
compatible ALC882 codec.  Some machines (e.g. SunMicro X10SAT) show
the problem like too low output volumes unless the COEF setup is
applied.

Reported-and-tested-by: Dana Goyette <danagoyette@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 36284b8..9461a00 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -811,6 +811,7 @@ static void alc_auto_init_amp(struct hda_codec *codec, int type)
 		case 0x10ec0885:
 		case 0x10ec0887:
 		/*case 0x10ec0889:*/ /* this causes an SPDIF problem */
+		case 0x10ec0900:
 			alc889_coef_init(codec);
 			break;
 		case 0x10ec0888:
@@ -5516,6 +5517,7 @@ static int patch_alc882(struct hda_codec *codec)
 	switch (codec->vendor_id) {
 	case 0x10ec0882:
 	case 0x10ec0885:
+	case 0x10ec0900:
 		break;
 	default:
 		/* ALC883 and variants */
-- 
1.9.1

