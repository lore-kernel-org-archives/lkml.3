Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaGHA0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:26:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbaGGXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Eldad Zack <eldad@fogrefinery.com>, Daniel Mack <zonque@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 3.14 88/94] ALSA: usb-audio: Suppress repetitive debug messages from retire_playback_urb()
Date: Mon,  7 Jul 2014 16:58:18 -0700
Message-Id: <20140707235759.362657270@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Gardner <tim.gardner@canonical.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1487,7 +1487,8 @@ static void retire_playback_urb(struct s
 	 * The error should be lower than 2ms since the estimate relies
 	 * on two reads of a counter updated every ms.
 	 */
-	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
+	if (printk_ratelimit() &&
+	    abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
 		snd_printk(KERN_DEBUG "delay: estimated %d, actual %d\n",
 			est_delay, subs->last_delay);
 


