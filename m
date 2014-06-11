Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbaFLAB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:01:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:36014 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbaFKX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:17 -0400
Message-Id: <20140611234607.110555376@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 05/13] sound: Use ktime_get_ts()
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=sound-use-ktime-get.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
---
 include/sound/pcm.h |    2 +-
 sound/core/timer.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/include/sound/pcm.h
===================================================================
--- linux.orig/include/sound/pcm.h
+++ linux/include/sound/pcm.h
@@ -932,7 +932,7 @@ static inline void snd_pcm_gettime(struc
 				   struct timespec *tv)
 {
 	if (runtime->tstamp_type == SNDRV_PCM_TSTAMP_TYPE_MONOTONIC)
-		do_posix_clock_monotonic_gettime(tv);
+		ktime_get_ts(tv);
 	else
 		getnstimeofday(tv);
 }
Index: linux/sound/core/timer.c
===================================================================
--- linux.orig/sound/core/timer.c
+++ linux/sound/core/timer.c
@@ -390,7 +390,7 @@ static void snd_timer_notify1(struct snd
 	struct timespec tstamp;
 
 	if (timer_tstamp_monotonic)
-		do_posix_clock_monotonic_gettime(&tstamp);
+		ktime_get_ts(&tstamp);
 	else
 		getnstimeofday(&tstamp);
 	if (snd_BUG_ON(event < SNDRV_TIMER_EVENT_START ||
@@ -1203,7 +1203,7 @@ static void snd_timer_user_tinterrupt(st
 	}
 	if (tu->last_resolution != resolution || ticks > 0) {
 		if (timer_tstamp_monotonic)
-			do_posix_clock_monotonic_gettime(&tstamp);
+			ktime_get_ts(&tstamp);
 		else
 			getnstimeofday(&tstamp);
 	}


