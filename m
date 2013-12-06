Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161357Ab3LFNA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:00:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161335Ab3LFNAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 061/272] ALSA: hda - Fix hp-mic mode without VREF bits
Date: Fri,  6 Dec 2013 12:55:50 +0000
Message-Id: <1386334761-25517-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 16c0cefe8951b2c4b824fd06011ac1b359b1ab3b upstream.

When the hp mic pin has no VREF bits, the driver forgot to set PIN_IN
bit.  Spotted during debugging old MacBook Airs.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=65681
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index c443451..a8e3be6 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -2730,7 +2730,7 @@ static int hp_mic_jack_mode_put(struct snd_kcontrol *kcontrol,
 			val &= ~(AC_PINCTL_VREFEN | PIN_HP);
 			val |= get_vref_idx(vref_caps, idx) | PIN_IN;
 		} else
-			val = snd_hda_get_default_vref(codec, nid);
+			val = snd_hda_get_default_vref(codec, nid) | PIN_IN;
 	}
 	snd_hda_set_pin_ctl_cache(codec, nid, val);
 	call_hp_automute(codec, NULL);
-- 
1.8.3.2

