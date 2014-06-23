Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaFWNRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:17:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37073 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaFWNEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 62/93] ALSA: hda/analog - Fix silent output on ASUS A8JN
Date: Mon, 23 Jun 2014 14:02:41 +0100
Message-Id: <1403528592-2163-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 598e306184d26fa1d546334f2eb370b4d94a4ad3 upstream.

ASUS A8JN with AD1986A codec seems following the normal EAPD in the
normal order (0 = off, 1 = on) unlike other machines with AD1986A.
Apply the workaround used for Toshiba laptop that showed the same
problem.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=75041
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_analog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 570bce096759..c1432027e2ff 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1235,6 +1235,7 @@ static const struct hda_fixup ad1986a_fixups[] = {
 };
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1043, 0x1447, "ASUS A8JN", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x17aa, 0x2066, "Lenovo N100", AD1986A_FIXUP_INV_JACK_DETECT),
 	SND_PCI_QUIRK(0x1179, 0xff40, "Toshiba Satellite L40", AD1986A_FIXUP_EAPD),
 	{}
-- 
1.9.1

