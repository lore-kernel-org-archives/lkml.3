Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaFXUdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:33:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47902 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbaFXUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:33:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 59/65] ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup
Date: Tue, 24 Jun 2014 13:30:19 -0700
Message-Id: <1403641825-12825-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 192a98e280e560510a62aca8cfa83b4ae7c095bb upstream.

The conversion to a fixup table for Replacer model with ALC260 in
commit 20f7d928 took the wrong widget NID for COEF setups.  Namely,
NID 0x1a should have been used instead of NID 0x20, which is the
common node for all Realtek codecs but ALC260.

Fixes: 20f7d928fa6e ('ALSA: hda/realtek - Replace ALC260 model=replacer with the auto-parser')
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 805d79f..6cc07f0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4945,8 +4945,8 @@ static const struct alc_fixup alc260_fixups[] = {
 	[ALC260_FIXUP_REPLACER] = {
 		.type = ALC_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
-			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x07 },
-			{ 0x20, AC_VERB_SET_PROC_COEF,  0x3050 },
+			{ 0x1a, AC_VERB_SET_COEF_INDEX, 0x07 },
+			{ 0x1a, AC_VERB_SET_PROC_COEF,  0x3050 },
 			{ }
 		},
 		.chained = true,
-- 
1.9.1

