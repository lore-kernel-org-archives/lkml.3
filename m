Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaBRWqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaBRWqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolai Beuermann <mail@nico-beuermann.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 15/32] ALSA: hda - Fix missing VREF setup for Mac Pro 1,1
Date: Tue, 18 Feb 2014 14:47:15 -0800
Message-Id: <20140218224500.535250785@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c20f31ec421ea4fabea5e95a6afd46c5f41e5599 upstream.

Mac Pro 1,1 with ALC889A codec needs the VREF setup on NID 0x18 to
VREF50, in order to make the speaker working.  The same fixup was
already needed for MacBook Air 1,1, so we can reuse it.

Reported-by: Nicolai Beuermann <mail@nico-beuermann.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1771,6 +1771,7 @@ enum {
 	ALC889_FIXUP_IMAC91_VREF,
 	ALC889_FIXUP_MBA11_VREF,
 	ALC889_FIXUP_MBA21_VREF,
+	ALC889_FIXUP_MP11_VREF,
 	ALC882_FIXUP_INV_DMIC,
 	ALC882_FIXUP_NO_PRIMARY_HP,
 	ALC887_FIXUP_ASUS_BASS,
@@ -2127,6 +2128,12 @@ static const struct hda_fixup alc882_fix
 		.chained = true,
 		.chain_id = ALC889_FIXUP_MBP_VREF,
 	},
+	[ALC889_FIXUP_MP11_VREF] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc889_fixup_mba11_vref,
+		.chained = true,
+		.chain_id = ALC885_FIXUP_MACPRO_GPIO,
+	},
 	[ALC882_FIXUP_INV_DMIC] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_inv_dmic_0x12,
@@ -2184,7 +2191,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x106b, 0x00a0, "MacBookPro 3,1", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x00a1, "Macbook", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x00a4, "MacbookPro 4,1", ALC889_FIXUP_MBP_VREF),
-	SND_PCI_QUIRK(0x106b, 0x0c00, "Mac Pro", ALC885_FIXUP_MACPRO_GPIO),
+	SND_PCI_QUIRK(0x106b, 0x0c00, "Mac Pro", ALC889_FIXUP_MP11_VREF),
 	SND_PCI_QUIRK(0x106b, 0x1000, "iMac 24", ALC885_FIXUP_MACPRO_GPIO),
 	SND_PCI_QUIRK(0x106b, 0x2800, "AppleTV", ALC885_FIXUP_MACPRO_GPIO),
 	SND_PCI_QUIRK(0x106b, 0x2c00, "MacbookPro rev3", ALC889_FIXUP_MBP_VREF),


