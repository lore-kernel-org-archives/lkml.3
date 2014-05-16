Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaEPQDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:03:20 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:15197 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757349AbaEPQDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:03:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai0SAFk1dlNXQB71/2dsb2JhbABZgwaqaAUFBQGaGQICgRYXdIJTExwjGIECJBOIRQHSE4VViHqERwEDjy2KKgGLEYgIgzk7
Date: Fri, 16 May 2014 18:03:15 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] kernel/hrtimer.c: convert printk to pr_foo()
Message-Id: <20140516180315.116d6c58d3fd125472e35cd7@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and define pr_fmt

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/hrtimer.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6b715c0..14f9030 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -31,6 +31,8 @@
  *  For licencing details see kernel-base/COPYING
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/cpu.h>
 #include <linux/export.h>
 #include <linux/percpu.h>
@@ -717,8 +719,8 @@ static int hrtimer_switch_to_hres(void)
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
-		printk(KERN_WARNING "Could not switch to high resolution "
-				    "mode on CPU %d\n", cpu);
+		pr_warn("Could not switch to high resolution mode on CPU %d\n",
+			cpu);
 		return 0;
 	}
 	base->hres_active = 1;
@@ -1410,8 +1412,7 @@ retry:
 	else
 		expires_next = ktime_add(now, delta);
 	tick_program_event(expires_next, 1);
-	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
-		    ktime_to_ns(delta));
+	pr_warn_once("interrupt took %llu ns\n", ktime_to_ns(delta));
 }
 
 /*
-- 
1.8.4.5

