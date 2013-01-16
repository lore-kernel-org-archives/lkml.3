Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab3APQgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:36:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3APQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 130/222] ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup
Date: Wed, 16 Jan 2013 13:55:30 -0200
Message-Id: <1358351822-7675-131-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b78562b10fa66175e30b76073e32a0ad8d92aa83 upstream.

The workaround to force VREF50 for dallas/hp model with ALC861VD
was introduced in commit 8fdcb6fe4204bdb4c6991652717ab5063751414e,
but it contained wrong pincap override bits.

This patch fixes to exclude VREF80 pincap bit correctly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9011a01..7e3fef0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6387,8 +6387,8 @@ static void alc861vd_fixup_dallas(struct hda_codec *codec,
 				  const struct alc_fixup *fix, int action)
 {
 	if (action == ALC_FIXUP_ACT_PRE_PROBE) {
-		snd_hda_override_pin_caps(codec, 0x18, 0x00001714);
-		snd_hda_override_pin_caps(codec, 0x19, 0x0000171c);
+		snd_hda_override_pin_caps(codec, 0x18, 0x00000734);
+		snd_hda_override_pin_caps(codec, 0x19, 0x0000073c);
 	}
 }
 
-- 
1.7.9.5

