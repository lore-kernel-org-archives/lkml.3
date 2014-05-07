Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaEGUrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:47:08 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:47123 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbaEGUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:47:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocXANWaalNXQBiQ/2dsb2JhbABagwaDPahrCgUBmgoCAoEdF3SCZhwjGIECJBOIRQHQNoVWiHyERgEDjxuKGwGLAId7gzY7
Date: Wed, 7 May 2014 22:46:56 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] kernel/stop_machine.c: remove false assignment to
 static
Message-Id: <20140507224656.e06286af4392251135862718@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also fixes function prototype over 80 characters

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/stop_machine.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 695f0c6..8d29ee2 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -42,7 +42,7 @@ struct cpu_stopper {
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
 static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
-static bool stop_machine_initialized = false;
+static bool stop_machine_initialized;
 
 /*
  * Avoids a race between stop_two_cpus and global stop_cpus, where
@@ -241,7 +241,8 @@ static void irq_cpu_stop_queue_work(void *arg)
  *
  * returns when both are completed.
  */
-int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *arg)
+int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn,
+		  void *arg)
 {
 	struct cpu_stop_done done;
 	struct cpu_stop_work work1, work2;
-- 
1.8.4.5

