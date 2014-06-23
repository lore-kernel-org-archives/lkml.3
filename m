Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaFWIch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55460 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 045/111] ALSA: hda/analog - Fix silent output on ASUS A8JN
Date: Mon, 23 Jun 2014 10:31:20 +0200
Message-Id: <9b3928a84bf3c3c2b2928250225944234905ac71.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 598e306184d26fa1d546334f2eb370b4d94a4ad3 upstream.

ASUS A8JN with AD1986A codec seems following the normal EAPD in the
normal order (0 = off, 1 = on) unlike other machines with AD1986A.
Apply the workaround used for Toshiba laptop that showed the same
problem.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=75041
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_analog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 41ebdd8812b1..01338064260e 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -316,6 +316,7 @@ static const struct hda_fixup ad1986a_fixups[] = {
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x30af, "HP B2800", AD1986A_FIXUP_LAPTOP_IMIC),
+	SND_PCI_QUIRK(0x1043, 0x1447, "ASUS A8JN", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8100, "ASUS P5", AD1986A_FIXUP_3STACK),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8200, "ASUS M2", AD1986A_FIXUP_3STACK),
 	SND_PCI_QUIRK(0x10de, 0xcb84, "ASUS A8N-VM", AD1986A_FIXUP_3STACK),
-- 
2.0.0

