Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbbAXOEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:44 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:58382 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbbAXOEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:35 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/32] profile: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:37 -0500
Message-Id: <1422108218-25398-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/profile.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 54bf5ba..a7bcd28 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -422,8 +422,7 @@ void profile_tick(int type)
 
 static int prof_cpu_mask_proc_show(struct seq_file *m, void *v)
 {
-	seq_cpumask(m, prof_cpu_mask);
-	seq_putc(m, '\n');
+	seq_printf(m, "%*pb\n", cpumask_pr_args(prof_cpu_mask));
 	return 0;
 }
 
-- 
2.1.0

