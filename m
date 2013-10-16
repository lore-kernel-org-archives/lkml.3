Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971Ab3JPSXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:23:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761058Ab3JPRpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 04/69] ALSA: hda - Fix microphone for Sony VAIO Pro 13 (Haswell model)
Date: Wed, 16 Oct 2013 10:44:13 -0700
Message-Id: <20131016174313.407315616@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 88cfcf86aa3ada84d97195bcad74f4dadb4ae23b upstream.

The external mic showed up with a precense detect of "always present",
essentially disabling the internal mic. Therefore turn off presence
detection for this pin.

Note: The external mic seems not yet working, but an internal mic is
certainly better than no mic at all.

BugLink: https://bugs.launchpad.net/bugs/1227093
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3223,6 +3223,7 @@ enum {
 	ALC269_FIXUP_HP_GPIO_LED,
 	ALC269_FIXUP_INV_DMIC,
 	ALC269_FIXUP_LENOVO_DOCK,
+	ALC286_FIXUP_SONY_MIC_NO_PRESENCE,
 	ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT,
 	ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC269_FIXUP_DELL2_MIC_NO_PRESENCE,
@@ -3420,6 +3421,13 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_headset_mode_no_hp_mic,
 	},
+	[ALC286_FIXUP_SONY_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x18, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+	},
 	[ALC269_FIXUP_ASUS_X101_FUNC] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc269_fixup_x101_headset_mic,
@@ -3529,6 +3537,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x8398, "ASUS P1005", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "ASUS P1005", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x8516, "ASUS X101CH", ALC269_FIXUP_ASUS_X101),
+	SND_PCI_QUIRK(0x104d, 0x90b6, "Sony VAIO Pro 13", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x104d, 0x9073, "Sony VAIO", ALC275_FIXUP_SONY_VAIO_GPIO2),
 	SND_PCI_QUIRK(0x104d, 0x907b, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),
 	SND_PCI_QUIRK(0x104d, 0x9084, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),


