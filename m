Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3LBTo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:44:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3LBTSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 160/212] ALSA: hda - Fix hp-mic mode without VREF bits
Date: Mon,  2 Dec 2013 11:15:51 -0800
Message-Id: <20131202191305.584064000@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2764,7 +2764,7 @@ static int hp_mic_jack_mode_put(struct s
 			val &= ~(AC_PINCTL_VREFEN | PIN_HP);
 			val |= get_vref_idx(vref_caps, idx) | PIN_IN;
 		} else
-			val = snd_hda_get_default_vref(codec, nid);
+			val = snd_hda_get_default_vref(codec, nid) | PIN_IN;
 	}
 	snd_hda_set_pin_ctl_cache(codec, nid, val);
 	call_hp_automute(codec, NULL);


