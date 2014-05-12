Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbaELR41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:56:27 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:33432 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932577AbaELR4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:56:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KABQKcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxiBAiQTiEUBz0qFVoh8hEcBA48liiIBiwSIA4M4Ow
Date: Mon, 12 May 2014 19:56:23 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/workqueue.c: pr_warning/pr_warn & printk/pr_info
Message-Id: <20140512195623.bedc6e41683596d8d3b486c7@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/workqueue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..6824afc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4098,8 +4098,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	/* create a new pwq */
 	pwq = alloc_unbound_pwq(wq, target_attrs);
 	if (!pwq) {
-		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
-			   wq->name);
+		pr_warn("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
+			wq->name);
 		goto out_unlock;
 	}
 
@@ -4548,7 +4548,7 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 		probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
 
 	if (fn || name[0] || desc[0]) {
-		printk("%sWorkqueue: %s %pf", log_lvl, name, fn);
+		pr_info("%sWorkqueue: %s %pf", log_lvl, name, fn);
 		if (desc[0])
 			pr_cont(" (%s)", desc);
 		pr_cont("\n");
-- 
1.9.1
