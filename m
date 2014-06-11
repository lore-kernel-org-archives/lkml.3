Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaFLAA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:00:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:36031 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaFKX7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:18 -0400
Message-Id: <20140611234607.261629142@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [patch 07/13] kdb: Use ktime_get_ts()
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=kdb-use-ktime-get.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/kernel/debug/kdb/kdb_main.c
===================================================================
--- linux.orig/kernel/debug/kdb/kdb_main.c
+++ linux/kernel/debug/kdb/kdb_main.c
@@ -2472,7 +2472,7 @@ static void kdb_gmtime(struct timespec *
 static void kdb_sysinfo(struct sysinfo *val)
 {
 	struct timespec uptime;
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	memset(val, 0, sizeof(*val));
 	val->uptime = uptime.tv_sec;
 	val->loads[0] = avenrun[0];


