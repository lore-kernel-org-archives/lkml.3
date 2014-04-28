Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaD1EJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:09:08 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57203 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaD1EJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:09:05 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] sound: usb: Fix format string mismatch in mixer.c
Date: Mon, 28 Apr 2014 13:08:55 +0900
Message-Id: <1398658135-19971-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in parse_audio_selector_unit().

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/usb/mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index d40a285..6fe83e4 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1986,7 +1986,7 @@ static int parse_audio_selector_unit(struct mixer_build *state, int unitid, void
 		if (! len && check_input_term(state, desc->baSourceID[i], &iterm) >= 0)
 			len = get_term_name(state, &iterm, namelist[i], MAX_ITEM_NAME_LEN, 0);
 		if (! len)
-			sprintf(namelist[i], "Input %d", i);
+			sprintf(namelist[i], "Input %u", i);
 	}
 
 	kctl = snd_ctl_new1(&mixer_selectunit_ctl, cval);
-- 
2.0.0.rc1

