Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaJMG7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:59:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62653 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaJMG7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:59:06 -0400
Date: Mon, 13 Oct 2014 08:59:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf/watchdog changes for v3.18
Message-ID: <20141013065900.GA12989@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-watchdog-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-watchdog-for-linus

   # HEAD: df577149594cefacd62740e86de080c6336d699e watchdog: Fix print-once on enable

Two small watchdog subsystem fixes.

 Thanks,

	Ingo

------------------>
Ulrich Obergfell (1):
      watchdog: Fix print-once on enable

chai wen (1):
      watchdog: Remove unnecessary header files


 kernel/watchdog.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c3319bd1b040..df5494edf694 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -15,11 +15,6 @@
 #include <linux/cpu.h>
 #include <linux/nmi.h>
 #include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/freezer.h>
-#include <linux/kthread.h>
-#include <linux/lockdep.h>
-#include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/smpboot.h>
@@ -511,7 +506,10 @@ static void watchdog_nmi_disable(unsigned int cpu)
 		/* should be in cleanup, but blocks oprofile */
 		perf_event_release_kernel(event);
 	}
-	return;
+	if (cpu == 0) {
+		/* watchdog_nmi_enable() expects this to be zero initially. */
+		cpu0_err = 0;
+	}
 }
 #else
 static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
