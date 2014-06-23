Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaFWJB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55477 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ronan Marquet <ronan.marquet@orange.fr>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 046/111] ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop
Date: Mon, 23 Jun 2014 10:31:21 +0200
Message-Id: <31c276830276ad8f422d3ad7df2f49ef259e9ecc.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ronan Marquet <ronan.marquet@orange.fr>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_realtek.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d859dd5b99a8..4f9a3f438580 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1597,12 +1597,10 @@ static const struct hda_fixup alc260_fixups[] = {
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
-- 
2.0.0

