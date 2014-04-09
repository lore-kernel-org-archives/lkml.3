Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197AbaDIRyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:54:33 -0400
Received: from mail.tpi.com ([74.45.170.26]:49955 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933323AbaDIRyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:54:31 -0400
X-Greylist: delayed 1412 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 13:54:31 EDT
From: Tim Gardner <tim.gardner@canonical.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Eldad Zack <eldad@fogrefinery.com>,
        Daniel Mack <zonque@gmail.com>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH linux-next] ALSA: usb-audio: Suppress repetitive debug messages from retire_playback_urb()
Date: Wed,  9 Apr 2014 11:30:44 -0600
Message-Id: <1397064644-71907-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 sound/usb/pcm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 49de5c1..131336d 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1501,7 +1501,8 @@ static void retire_playback_urb(struct snd_usb_substream *subs,
 	 * The error should be lower than 2ms since the estimate relies
 	 * on two reads of a counter updated every ms.
 	 */
-	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
+	if (printk_ratelimit() &&
+	    abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
 		dev_dbg(&subs->dev->dev,
 			"delay: estimated %d, actual %d\n",
 			est_delay, subs->last_delay);
-- 
1.7.9.5

