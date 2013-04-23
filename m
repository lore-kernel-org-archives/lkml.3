Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3DWQFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:05:48 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:43572 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3DWQFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:05:43 -0400
From: Cosmin Paraschiv <csmnprschv@gmail.com>
To: rusty@rustcorp.com.au
Cc: lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Cosmin Paraschiv <csmnprschv@gmail.com>,
        Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] lguest: improve code readability in lg_cpu_start.
Date: Tue, 23 Apr 2013 18:23:48 +0300
Message-Id: <1366730628-5342-1-git-send-email-csmnprschv@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the container_of call friendlier and fix some comment slip-ups.

Signed-off-by: Cosmin Paraschiv <csmnprschv@gmail.com>
Cc: Daniel Baluta <dbaluta@ixiacom.com>
---
 drivers/lguest/lguest_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index ff4a0bc..4263f4c 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -250,13 +250,13 @@ static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
  */
 static int lg_cpu_start(struct lg_cpu *cpu, unsigned id, unsigned long start_ip)
 {
-	/* We have a limited number the number of CPUs in the lguest struct. */
+	/* We have a limited number of CPUs in the lguest struct. */
 	if (id >= ARRAY_SIZE(cpu->lg->cpus))
 		return -EINVAL;
 
 	/* Set up this CPU's id, and pointer back to the lguest struct. */
 	cpu->id = id;
-	cpu->lg = container_of((cpu - id), struct lguest, cpus[0]);
+	cpu->lg = container_of(cpu, struct lguest, cpus[id]);
 	cpu->lg->nr_cpus++;
 
 	/* Each CPU has a timer it can set. */
@@ -270,7 +270,7 @@ static int lg_cpu_start(struct lg_cpu *cpu, unsigned id, unsigned long start_ip)
 	if (!cpu->regs_page)
 		return -ENOMEM;
 
-	/* We actually put the registers at the bottom of the page. */
+	/* We actually put the registers at the end of the page. */
 	cpu->regs = (void *)cpu->regs_page + PAGE_SIZE - sizeof(*cpu->regs);
 
 	/*
-- 
1.7.9.5

