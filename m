Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaFWNEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:04:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37078 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaFWNEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ronan Marquet <ronan.marquet@orange.fr>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 63/93] ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop
Date: Mon, 23 Jun 2014 14:02:42 +0100
Message-Id: <1403528592-2163-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2d20f930e2f8..f11d5e9f7a9c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1594,12 +1594,10 @@ static const struct hda_fixup alc260_fixups[] = {
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
1.9.1

