Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3LBUoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:44:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab3LBTOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 114/173] ALSA: hda - Fix hp-mic mode without VREF bits
Date: Mon,  2 Dec 2013 11:11:37 -0800
Message-Id: <20131202191156.918722083@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 16c0cefe8951b2c4b824fd06011ac1b359b1ab3b upstream.

When the hp mic pin has no VREF bits, the driver forgot to set PIN_IN
bit.  Spotted during debugging old MacBook Airs.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=65681
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -2703,7 +2703,7 @@ static int hp_mic_jack_mode_put(struct s
 			val &= ~(AC_PINCTL_VREFEN | PIN_HP);
 			val |= get_vref_idx(vref_caps, idx) | PIN_IN;
 		} else
-			val = snd_hda_get_default_vref(codec, nid);
+			val = snd_hda_get_default_vref(codec, nid) | PIN_IN;
 	}
 	snd_hda_set_pin_ctl_cache(codec, nid, val);
 	call_hp_automute(codec, NULL);


