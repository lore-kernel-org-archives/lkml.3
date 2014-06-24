Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbaFXUwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:52:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaFXUah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:30:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ronan Marquet <ronan.marquet@orange.fr>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 58/65] ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop
Date: Tue, 24 Jun 2014 13:30:18 -0700
Message-Id: <1403641825-12825-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 61b2990..805d79f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4927,12 +4927,10 @@ static const struct alc_fixup alc260_fixups[] = {
 	[ALC260_FIXUP_COEF] = {
 		.type = ALC_FIXUP_VERBS,
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
 		.type = ALC_FIXUP_VERBS,
-- 
1.9.1

