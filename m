Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaFWNQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:16:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaFWNEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 64/93] ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup
Date: Mon, 23 Jun 2014 14:02:43 +0100
Message-Id: <1403528592-2163-65-git-send-email-luis.henriques@canonical.com>
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

commit 192a98e280e560510a62aca8cfa83b4ae7c095bb upstream.

The conversion to a fixup table for Replacer model with ALC260 in
commit 20f7d928 took the wrong widget NID for COEF setups.  Namely,
NID 0x1a should have been used instead of NID 0x20, which is the
common node for all Realtek codecs but ALC260.

Fixes: 20f7d928fa6e ('ALSA: hda/realtek - Replace ALC260 model=replacer with the auto-parser')
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f11d5e9f7a9c..cdb307f2e028 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1612,8 +1612,8 @@ static const struct hda_fixup alc260_fixups[] = {
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

