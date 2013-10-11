Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3JKUYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:24:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3JKTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher <DIDI2002@web.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 100/110] ALSA: hda - Fix GPIO for Acer Aspire 3830TG
Date: Fri, 11 Oct 2013 12:39:20 -0700
Message-Id: <20131011193818.689003764@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4a4370442c996be0fd08234a167c8a127c2488bb upstream.

Acer Aspire 3830TG seems requiring GPIO bit 0 as the primary mute
control.  When a machine is booted after Windows 8, the GPIO pin is
turned off and it results in the silent output.

This patch adds the manual fixup of GPIO bit 0 for this model.

Reported-by: Christopher <DIDI2002@web.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 sound/pci/hda/patch_conexant.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3225,6 +3225,7 @@ enum {
 	CXT_PINCFG_LEMOTE_A1205,
 	CXT_FIXUP_STEREO_DMIC,
 	CXT_FIXUP_INC_MIC_BOOST,
+	CXT_FIXUP_GPIO1,
 };
 
 static void cxt_fixup_stereo_dmic(struct hda_codec *codec,
@@ -3303,6 +3304,15 @@ static const struct hda_fixup cxt_fixups
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt5066_increase_mic_boost,
 	},
+	[CXT_FIXUP_GPIO1] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x01, AC_VERB_SET_GPIO_MASK, 0x01 },
+			{ 0x01, AC_VERB_SET_GPIO_DIRECTION, 0x01 },
+			{ 0x01, AC_VERB_SET_GPIO_DATA, 0x01 },
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk cxt5051_fixups[] = {
@@ -3312,6 +3322,7 @@ static const struct snd_pci_quirk cxt505
 
 static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x1025, 0x0543, "Acer Aspire One 522", CXT_FIXUP_STEREO_DMIC),
+	SND_PCI_QUIRK(0x1025, 0x054c, "Acer Aspire 3830TG", CXT_FIXUP_GPIO1),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo T410", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x215f, "Lenovo T510", CXT_PINCFG_LENOVO_TP410),


