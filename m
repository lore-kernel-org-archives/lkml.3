Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaI3VqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:46:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaI3Vit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 096/103] ALSA: hda - Fix COEF setups for ALC1150 codec
Date: Tue, 30 Sep 2014 14:31:41 -0700
Message-Id: <1412112708-27356-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit acf08081adb5e8fe0519eb97bb49797ef52614d6 upstream.

ALC1150 codec seems to need the COEF- and PLL-setups just like its
compatible ALC882 codec.  Some machines (e.g. SunMicro X10SAT) show
the problem like too low output volumes unless the COEF setup is
applied.

Reported-and-tested-by: Dana Goyette <danagoyette@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6b1f38a..b2a5832 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -323,6 +323,7 @@ static void alc_auto_init_amp(struct hda_codec *codec, int type)
 		case 0x10ec0885:
 		case 0x10ec0887:
 		/*case 0x10ec0889:*/ /* this causes an SPDIF problem */
+		case 0x10ec0900:
 			alc889_coef_init(codec);
 			break;
 		case 0x10ec0888:
@@ -2281,6 +2282,7 @@ static int patch_alc882(struct hda_codec *codec)
 	switch (codec->vendor_id) {
 	case 0x10ec0882:
 	case 0x10ec0885:
+	case 0x10ec0900:
 		break;
 	default:
 		/* ALC883 and variants */
-- 
1.9.1

