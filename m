Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3BCO46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34400 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab3BCO4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:50 -0500
Message-Id: <20130203144650.528447302@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>
Subject: [ 073/128] ALSA: hda - Add Conexant CX20751/2/3/4 codec support
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 61d648fb4726f8a89c07cd1904f9c2e11bf26df5 upstream.

These are almost compatible with the older Conexant codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 2cfcec0..a03fc33 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4559,6 +4559,10 @@ static int patch_conexant_auto(struct hda_codec *codec)
  */
 
 static const struct hda_codec_preset snd_hda_preset_conexant[] = {
+	{ .id = 0x14f11510, .name = "CX20751/2",
+	  .patch = patch_conexant_auto },
+	{ .id = 0x14f11511, .name = "CX20753/4",
+	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15045, .name = "CX20549 (Venice)",
 	  .patch = patch_cxt5045 },
 	{ .id = 0x14f15047, .name = "CX20551 (Waikiki)",
@@ -4596,6 +4600,8 @@ static const struct hda_codec_preset snd_hda_preset_conexant[] = {
 	{} /* terminator */
 };
 
+MODULE_ALIAS("snd-hda-codec-id:14f11510");
+MODULE_ALIAS("snd-hda-codec-id:14f11511");
 MODULE_ALIAS("snd-hda-codec-id:14f15045");
 MODULE_ALIAS("snd-hda-codec-id:14f15047");
 MODULE_ALIAS("snd-hda-codec-id:14f15051");


