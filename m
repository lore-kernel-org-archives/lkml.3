Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664AbaFIXDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:03:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861AbaFIWpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 52/78] ALSA: hda/analog - Fix silent output on ASUS A8JN
Date: Mon,  9 Jun 2014 15:48:32 -0700
Message-Id: <20140609224815.026861497@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 598e306184d26fa1d546334f2eb370b4d94a4ad3 upstream.

ASUS A8JN with AD1986A codec seems following the normal EAPD in the
normal order (0 = off, 1 = on) unlike other machines with AD1986A.
Apply the workaround used for Toshiba laptop that showed the same
problem.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=75041
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -333,6 +333,7 @@ static const struct hda_fixup ad1986a_fi
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x30af, "HP B2800", AD1986A_FIXUP_LAPTOP_IMIC),
+	SND_PCI_QUIRK(0x1043, 0x1447, "ASUS A8JN", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8100, "ASUS P5", AD1986A_FIXUP_3STACK),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8200, "ASUS M2", AD1986A_FIXUP_3STACK),
 	SND_PCI_QUIRK(0x10de, 0xcb84, "ASUS A8N-VM", AD1986A_FIXUP_3STACK),


