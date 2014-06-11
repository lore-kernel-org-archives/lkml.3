Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbaFLABd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:01:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:36023 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaFKX7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:18 -0400
Message-Id: <20140611234607.351283464@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 08/13] firewire: Use ktime_get_ts()
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=firewire-use-ktime-get-ts.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/core-cdev.c
===================================================================
--- linux.orig/drivers/firewire/core-cdev.c
+++ linux/drivers/firewire/core-cdev.c
@@ -1215,7 +1215,7 @@ static int ioctl_get_cycle_timer2(struct
 
 	switch (a->clk_id) {
 	case CLOCK_REALTIME:      getnstimeofday(&ts);                   break;
-	case CLOCK_MONOTONIC:     do_posix_clock_monotonic_gettime(&ts); break;
+	case CLOCK_MONOTONIC:     ktime_get_ts(&ts); break;
 	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);                  break;
 	default:
 		ret = -EINVAL;


