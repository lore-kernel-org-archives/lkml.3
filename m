Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030884AbaGRNSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:18:47 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17983 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030582AbaGRNSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Eldad Zack <eldad@fogrefinery.com>, Daniel Mack <zonque@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 123/170] ALSA: usb-audio: Suppress repetitive debug messages from retire_playback_urb()
Date: Fri, 18 Jul 2014 14:12:08 +0200
Message-Id: <0606474195abb007a1b74fb636b1770d61f393e6.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a5065eb6da55b226661456e6a7435f605df98111 upstream.

BugLink: http://bugs.launchpad.net/bugs/1305133

Malfunctioning or slow devices can cause a flood of dmesg SPAM.

I've ignored checkpatch.pl complaints about the use of printk_ratelimit() in favour
of prior art in sound/usb/pcm.c.

WARNING: Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit
+	if (printk_ratelimit() &&

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Eldad Zack <eldad@fogrefinery.com>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b375d58871e7..d59e0c1a3e20 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1491,7 +1491,8 @@ static void retire_playback_urb(struct snd_usb_substream *subs,
 	 * The error should be lower than 2ms since the estimate relies
 	 * on two reads of a counter updated every ms.
 	 */
-	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
+	if (printk_ratelimit() &&
+	    abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
 		snd_printk(KERN_DEBUG "delay: estimated %d, actual %d\n",
 			est_delay, subs->last_delay);
 
-- 
2.0.0

