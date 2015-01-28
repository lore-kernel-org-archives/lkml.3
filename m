Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbbA2KJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:09:18 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44744 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757299AbbA2JBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:37 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 031/176] ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC codecs
Date: Wed, 28 Jan 2015 15:27:41 +0100
Message-Id: <ba412300046121eb98bff798f221fdcc7f13424f.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c507de88f6a336bd7296c9ec0073b2d4af8b4f5e upstream.

stac_store_hints() does utterly wrong for masking the values for
gpio_dir and gpio_data, likely due to copy&paste errors.  Fortunately,
this feature is used very rarely, so the impact must be really small.

Reported-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_sigmatel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 38b47b7b9cb6..121336b0d3a8 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -582,9 +582,9 @@ static void stac_store_hints(struct hda_codec *codec)
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
2.2.2

