Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaCNC4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:56:22 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62831 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaCNC4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:56:20 -0400
From: Chema Gonzalez <chema@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Eric Dumazet <edumazet@google.com>
Cc: linux-kernel@vger.kernel.org, Chema Gonzalez <chema@google.com>
Subject: [PATCH] procfs: make smp_affinity values go+r
Date: Thu, 13 Mar 2014 19:50:55 -0700
Message-Id: <1394765455-1217-1-git-send-email-chema@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes:
- /proc/irq/default_smp_affinity
- /proc/irq/*/affinity_hint
- /proc/irq/*/smp_affinity
- /proc/irq/*/smp_affinity_list

Users can distill the same information by reading /proc/interrupts.

Signed-off-by: Chema Gonzalez <chema@google.com>
---
 kernel/irq/proc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 36f6ee1..ac1ba2f 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -324,15 +324,15 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 
 #ifdef CONFIG_SMP
 	/* create /proc/irq/<irq>/smp_affinity */
-	proc_create_data("smp_affinity", 0600, desc->dir,
+	proc_create_data("smp_affinity", 0644, desc->dir,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
 
 	/* create /proc/irq/<irq>/affinity_hint */
-	proc_create_data("affinity_hint", 0400, desc->dir,
+	proc_create_data("affinity_hint", 0444, desc->dir,
 			 &irq_affinity_hint_proc_fops, (void *)(long)irq);
 
 	/* create /proc/irq/<irq>/smp_affinity_list */
-	proc_create_data("smp_affinity_list", 0600, desc->dir,
+	proc_create_data("smp_affinity_list", 0644, desc->dir,
 			 &irq_affinity_list_proc_fops, (void *)(long)irq);
 
 	proc_create_data("node", 0444, desc->dir,
@@ -372,7 +372,7 @@ void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 static void register_default_affinity_proc(void)
 {
 #ifdef CONFIG_SMP
-	proc_create("irq/default_smp_affinity", 0600, NULL,
+	proc_create("irq/default_smp_affinity", 0644, NULL,
 		    &default_affinity_proc_fops);
 #endif
 }
-- 
1.9.0.279.gdc9e3eb

