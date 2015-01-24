Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbbAXOKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:10:22 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:39353 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbbAXOEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:06 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH 11/32] xtensa: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:17 -0500
Message-Id: <1422108218-25398-12-git-send-email-tj@kernel.org>
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
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
---
 arch/xtensa/kernel/setup.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 06370cc..28fc57e 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -574,12 +574,9 @@ void machine_power_off(void)
 static int
 c_show(struct seq_file *f, void *slot)
 {
-	char buf[NR_CPUS * 5];
-
-	cpulist_scnprintf(buf, sizeof(buf), cpu_online_mask);
 	/* high-level stuff */
 	seq_printf(f, "CPU count\t: %u\n"
-		      "CPU list\t: %s\n"
+		      "CPU list\t: %*pbl\n"
 		      "vendor_id\t: Tensilica\n"
 		      "model\t\t: Xtensa " XCHAL_HW_VERSION_NAME "\n"
 		      "core ID\t\t: " XCHAL_CORE_ID "\n"
@@ -588,7 +585,7 @@ c_show(struct seq_file *f, void *slot)
 		      "cpu MHz\t\t: %lu.%02lu\n"
 		      "bogomips\t: %lu.%02lu\n",
 		      num_online_cpus(),
-		      buf,
+		      cpumask_pr_args(cpu_online_mask),
 		      XCHAL_BUILD_UNIQUE_ID,
 		      XCHAL_HAVE_BE ?  "big" : "little",
 		      ccount_freq/1000000,
-- 
2.1.0

