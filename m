Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3FYTP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:15:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3FYSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 05/95] ALSA: hda - Fix pin configurations for MacBook Air 4,2
Date: Tue, 25 Jun 2013 11:31:52 -0700
Message-Id: <20130625182154.260147762@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6ab982e8cf8e5760da407ccdc4abc815bea23179 upstream.

MacBook Air 4,2 requires the whole default pin configuration table to
be overridden by the driver, as usual, as Apple's machines don't set
up properly after boot.  Otherwise mic won't work, and other ill
effect may happen.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=59381
Reported-and-tested-by: Peter John Hartman <peterjohnhartman@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_cirrus.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -58,6 +58,7 @@ enum {
 	CS420X_GPIO_23,
 	CS420X_MBP101,
 	CS420X_MBP81,
+	CS420X_MBA42,
 	CS420X_AUTO,
 	/* aliases */
 	CS420X_IMAC27_122 = CS420X_GPIO_23,
@@ -345,6 +346,7 @@ static const struct hda_model_fixup cs42
 	{ .id = CS420X_APPLE, .name = "apple" },
 	{ .id = CS420X_MBP101, .name = "mbp101" },
 	{ .id = CS420X_MBP81, .name = "mbp81" },
+	{ .id = CS420X_MBA42, .name = "mba42" },
 	{}
 };
 
@@ -360,6 +362,7 @@ static const struct snd_pci_quirk cs420x
 	SND_PCI_QUIRK(0x106b, 0x1c00, "MacBookPro 8,1", CS420X_MBP81),
 	SND_PCI_QUIRK(0x106b, 0x2000, "iMac 12,2", CS420X_IMAC27_122),
 	SND_PCI_QUIRK(0x106b, 0x2800, "MacBookPro 10,1", CS420X_MBP101),
+	SND_PCI_QUIRK(0x106b, 0x5b00, "MacBookAir 4,2", CS420X_MBA42),
 	SND_PCI_QUIRK_VENDOR(0x106b, "Apple", CS420X_APPLE),
 	{} /* terminator */
 };
@@ -413,6 +416,20 @@ static const struct hda_pintbl mbp101_pi
 	{} /* terminator */
 };
 
+static const struct hda_pintbl mba42_pincfgs[] = {
+	{ 0x09, 0x012b4030 }, /* HP */
+	{ 0x0a, 0x400000f0 },
+	{ 0x0b, 0x90100120 }, /* speaker */
+	{ 0x0c, 0x400000f0 },
+	{ 0x0d, 0x90a00110 }, /* mic */
+	{ 0x0e, 0x400000f0 },
+	{ 0x0f, 0x400000f0 },
+	{ 0x10, 0x400000f0 },
+	{ 0x12, 0x400000f0 },
+	{ 0x15, 0x400000f0 },
+	{} /* terminator */
+};
+
 static void cs420x_fixup_gpio_13(struct hda_codec *codec,
 				 const struct hda_fixup *fix, int action)
 {
@@ -481,6 +498,12 @@ static const struct hda_fixup cs420x_fix
 		.chained = true,
 		.chain_id = CS420X_GPIO_13,
 	},
+	[CS420X_MBA42] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = mba42_pincfgs,
+		.chained = true,
+		.chain_id = CS420X_GPIO_13,
+	},
 };
 
 static struct cs_spec *cs_alloc_spec(struct hda_codec *codec, int vendor_nid)


