Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaFWIcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55464 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/111] ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup
Date: Mon, 23 Jun 2014 10:31:22 +0200
Message-Id: <7588d0a2ca8c6b5f180ae899f99d9fc356dad62e.1403512281.git.jslaby@suse.cz>
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

commit 192a98e280e560510a62aca8cfa83b4ae7c095bb upstream.

The conversion to a fixup table for Replacer model with ALC260 in
commit 20f7d928 took the wrong widget NID for COEF setups.  Namely,
NID 0x1a should have been used instead of NID 0x20, which is the
common node for all Realtek codecs but ALC260.

Fixes: 20f7d928fa6e ('ALSA: hda/realtek - Replace ALC260 model=replacer with the auto-parser')
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4f9a3f438580..23971aa25fef 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1615,8 +1615,8 @@ static const struct hda_fixup alc260_fixups[] = {
 	[ALC260_FIXUP_REPLACER] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
-			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x07 },
-			{ 0x20, AC_VERB_SET_PROC_COEF,  0x3050 },
+			{ 0x1a, AC_VERB_SET_COEF_INDEX, 0x07 },
+			{ 0x1a, AC_VERB_SET_PROC_COEF,  0x3050 },
 			{ }
 		},
 		.chained = true,
-- 
2.0.0

