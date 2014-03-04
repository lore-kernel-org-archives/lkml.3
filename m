Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbaCDUUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:20:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbaCDUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Gerald Yang <gerald.yang@canonical.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 43/97] ALSA: hda - Enable front audio jacks on one HP desktop model
Date: Tue,  4 Mar 2014 12:03:56 -0800
Message-Id: <20140304200347.457321008@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

commit 1de7ca5e844866f56bebb2fc47fa18e090677e88 upstream.

The front headphone and mic jackes on a HP desktop model (Vendor Id:
0x111d76c7 Subsystem Id: 0x103c2b17) can not work, the codec on this
machine has 8 physical ports, 6 of them are routed to rear jackes
and all of them work very well, while the remaining 2 ports are
routed to front headphone and mic jackes, but the corresponding
pin complex node are not defined correctly.

After apply this fix, the front audio jackes can work very well.

[trivial fix of enum definition by tiwai]

BugLink: https://bugs.launchpad.net/bugs/1282369
Cc: David Henningsson <david.henningsson@canonical.com>
Tested-by: Gerald Yang <gerald.yang@canonical.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -83,6 +83,7 @@ enum {
 	STAC_DELL_M6_BOTH,
 	STAC_DELL_EQ,
 	STAC_ALIENWARE_M17X,
+	STAC_92HD89XX_HP_FRONT_JACK,
 	STAC_92HD73XX_MODELS
 };
 
@@ -1775,6 +1776,12 @@ static const struct hda_pintbl intel_dg4
 	{}
 };
 
+static const struct hda_pintbl stac92hd89xx_hp_front_jack_pin_configs[] = {
+	{ 0x0a, 0x02214030 },
+	{ 0x0b, 0x02A19010 },
+	{}
+};
+
 static void stac92hd73xx_fixup_ref(struct hda_codec *codec,
 				   const struct hda_fixup *fix, int action)
 {
@@ -1893,6 +1900,10 @@ static const struct hda_fixup stac92hd73
 	[STAC_92HD73XX_NO_JD] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = stac92hd73xx_fixup_no_jd,
+	},
+	[STAC_92HD89XX_HP_FRONT_JACK] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = stac92hd89xx_hp_front_jack_pin_configs,
 	}
 };
 
@@ -1953,6 +1964,8 @@ static const struct snd_pci_quirk stac92
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0490,
 		      "Alienware M17x R3", STAC_DELL_EQ),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x2b17,
+				"unknown HP", STAC_92HD89XX_HP_FRONT_JACK),
 	{} /* terminator */
 };
 


