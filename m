Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaBUMtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46797 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbaBUMtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 022/121] ALSA: hda - Fix missing VREF setup for Mac Pro 1,1
Date: Fri, 21 Feb 2014 12:47:26 +0000
Message-Id: <1392986945-9693-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c20f31ec421ea4fabea5e95a6afd46c5f41e5599 upstream.

Mac Pro 1,1 with ALC889A codec needs the VREF setup on NID 0x18 to
VREF50, in order to make the speaker working.  The same fixup was
already needed for MacBook Air 1,1, so we can reuse it.

Reported-by: Nicolai Beuermann <mail@nico-beuermann.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cd4cbad..0fc8bd2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1769,6 +1769,7 @@ enum {
 	ALC889_FIXUP_IMAC91_VREF,
 	ALC889_FIXUP_MBA11_VREF,
 	ALC889_FIXUP_MBA21_VREF,
+	ALC889_FIXUP_MP11_VREF,
 	ALC882_FIXUP_INV_DMIC,
 	ALC882_FIXUP_NO_PRIMARY_HP,
 	ALC887_FIXUP_ASUS_BASS,
@@ -2123,6 +2124,12 @@ static const struct hda_fixup alc882_fixups[] = {
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
@@ -2180,7 +2187,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x00a0, "MacBookPro 3,1", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x00a1, "Macbook", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x00a4, "MacbookPro 4,1", ALC889_FIXUP_MBP_VREF),
-	SND_PCI_QUIRK(0x106b, 0x0c00, "Mac Pro", ALC885_FIXUP_MACPRO_GPIO),
+	SND_PCI_QUIRK(0x106b, 0x0c00, "Mac Pro", ALC889_FIXUP_MP11_VREF),
 	SND_PCI_QUIRK(0x106b, 0x1000, "iMac 24", ALC885_FIXUP_MACPRO_GPIO),
 	SND_PCI_QUIRK(0x106b, 0x2800, "AppleTV", ALC885_FIXUP_MACPRO_GPIO),
 	SND_PCI_QUIRK(0x106b, 0x2c00, "MacbookPro rev3", ALC889_FIXUP_MBP_VREF),
-- 
1.9.0

