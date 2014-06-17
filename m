Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966339AbaFQVtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:49:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966306AbaFQVtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 202/212] ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup
Date: Tue, 17 Jun 2014 14:44:56 -0700
Message-Id: <1403041506-13646-203-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
index de8805a..c8a66e0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1625,8 +1625,8 @@ static const struct hda_fixup alc260_fixups[] = {
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
1.9.1

