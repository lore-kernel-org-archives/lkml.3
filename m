Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbbA0MvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:51:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34855 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbbA0MRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 013/126] ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC codecs
Date: Tue, 27 Jan 2015 12:15:18 +0000
Message-Id: <1422361031-19364-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c507de88f6a336bd7296c9ec0073b2d4af8b4f5e upstream.

stac_store_hints() does utterly wrong for masking the values for
gpio_dir and gpio_data, likely due to copy&paste errors.  Fortunately,
this feature is used very rarely, so the impact must be really small.

Reported-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_sigmatel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 619aec71b1e2..3075c765d19c 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -599,9 +599,9 @@ static void stac_store_hints(struct hda_codec *codec)
 			spec->gpio_mask;
 	}
 	if (get_int_hint(codec, "gpio_dir", &spec->gpio_dir))
-		spec->gpio_mask &= spec->gpio_mask;
-	if (get_int_hint(codec, "gpio_data", &spec->gpio_data))
 		spec->gpio_dir &= spec->gpio_mask;
+	if (get_int_hint(codec, "gpio_data", &spec->gpio_data))
+		spec->gpio_data &= spec->gpio_mask;
 	if (get_int_hint(codec, "eapd_mask", &spec->eapd_mask))
 		spec->eapd_mask &= spec->gpio_mask;
 	if (get_int_hint(codec, "gpio_mute", &spec->gpio_mute))
-- 
2.1.4

