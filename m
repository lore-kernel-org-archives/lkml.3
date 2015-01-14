Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbbANHiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:38:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbbANHis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:38:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 27/44] ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC codecs
Date: Tue, 13 Jan 2015 23:23:48 -0800
Message-Id: <20150114072229.008565202@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c507de88f6a336bd7296c9ec0073b2d4af8b4f5e upstream.

stac_store_hints() does utterly wrong for masking the values for
gpio_dir and gpio_data, likely due to copy&paste errors.  Fortunately,
this feature is used very rarely, so the impact must be really small.

Reported-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -573,9 +573,9 @@ static void stac_store_hints(struct hda_
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


