Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276AbaFIWqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:46:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933872AbaFIWpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ronan Marquet <ronan.marquet@orange.fr>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 53/78] ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop
Date: Mon,  9 Jun 2014 15:48:33 -0700
Message-Id: <20140609224815.055145047@linuxfoundation.org>
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

From: Ronan Marquet <ronan.marquet@orange.fr>

commit e30cf2d2bed3aed74a651c64de323ba26e4ff7d0 upstream.

Correcion of wrong fixup entries add in commit ca8f0424 to replace
static model quirk for PB V7900 laptop (will model).

[note: the removal of ALC260_FIXUP_HP_PIN_0F chain is also needed as a
 part of the fix; otherwise the pin is set up wrongly as a headphone,
 and user-space (PulseAudio) may be wrongly trying to detect the jack
 state -- tiwai]

Fixes: ca8f04247eaa ('ALSA: hda/realtek - Add the fixup codes for ALC260 model=will')
Signed-off-by: Ronan Marquet <ronan.marquet@orange.fr>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1646,12 +1646,10 @@ static const struct hda_fixup alc260_fix
 	[ALC260_FIXUP_COEF] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
-			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x07 },
-			{ 0x20, AC_VERB_SET_PROC_COEF,  0x3040 },
+			{ 0x1a, AC_VERB_SET_COEF_INDEX, 0x07 },
+			{ 0x1a, AC_VERB_SET_PROC_COEF,  0x3040 },
 			{ }
 		},
-		.chained = true,
-		.chain_id = ALC260_FIXUP_HP_PIN_0F,
 	},
 	[ALC260_FIXUP_GPIO1] = {
 		.type = HDA_FIXUP_VERBS,


