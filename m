Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbbAIK7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:59:43 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44497 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757102AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 33/78] ALSA: hda - Add EAPD fixup for ASUS Z99He laptop
Date: Fri,  9 Jan 2015 11:31:42 +0100
Message-Id: <c93808a19c2d8820b1323519e7d8627eac885e88.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f62f5eff3d40a56ad1cf0d81a6cac8dd8743e8a1 upstream.

The same fixup to enable EAPD is needed for ASUS Z99He with AD1986A
codec like another ASUS machine.

Reported-and-tested-by: Dmitry V. Zimin <pfzim@mail.ru>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_analog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 01338064260e..10dc0c8fbb87 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -316,6 +316,7 @@ static const struct hda_fixup ad1986a_fixups[] = {
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x30af, "HP B2800", AD1986A_FIXUP_LAPTOP_IMIC),
+	SND_PCI_QUIRK(0x1043, 0x1443, "ASUS Z99He", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1043, 0x1447, "ASUS A8JN", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8100, "ASUS P5", AD1986A_FIXUP_3STACK),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8200, "ASUS M2", AD1986A_FIXUP_3STACK),
-- 
2.2.1

