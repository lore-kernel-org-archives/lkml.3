Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbaCSLgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:36:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbaCSLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:36:47 -0400
Date: Wed, 19 Mar 2014 04:36:31 -0700
From: tip-bot for Chema Gonzalez <tipbot@zytor.com>
Message-ID: <tip-bab5c790cc64adb1ede54b4077444375108ac8da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        edumazet@google.com, tglx@linutronix.de, chema@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        edumazet@google.com, tglx@linutronix.de, chema@google.com
In-Reply-To: <1394765455-1217-1-git-send-email-chema@google.com>
References: <1394765455-1217-1-git-send-email-chema@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: procfs: Make smp_affinity values go+r
Git-Commit-ID: bab5c790cc64adb1ede54b4077444375108ac8da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bab5c790cc64adb1ede54b4077444375108ac8da
Gitweb:     http://git.kernel.org/tip/bab5c790cc64adb1ede54b4077444375108ac8da
Author:     Chema Gonzalez <chema@google.com>
AuthorDate: Thu, 13 Mar 2014 19:50:55 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Mar 2014 12:34:29 +0100

genirq: procfs: Make smp_affinity values go+r

Includes:
- /proc/irq/default_smp_affinity
- /proc/irq/*/affinity_hint
- /proc/irq/*/smp_affinity
- /proc/irq/*/smp_affinity_list

Users can distill the same information by reading /proc/interrupts.

Signed-off-by: Chema Gonzalez <chema@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Link: http://lkml.kernel.org/r/1394765455-1217-1-git-send-email-chema@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
