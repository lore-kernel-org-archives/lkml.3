Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab3FFLWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:22:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30594 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab3FFLWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:22:40 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 5/7] irq: fix all checkpatch errors and warnings
Date: Thu, 6 Jun 2013 19:20:29 +0800
Message-ID: <1370517631-8684-6-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
In-Reply-To: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following errors and warnings:
WARNING: space prohibited before semicolon
ERROR: space prohibited before open square bracket '['
WARNING: line over 80 characters

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 kernel/irq/proc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 19ed5c4..291e383 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -276,7 +276,7 @@ static int name_unique(unsigned int irq, struct irqaction *new_action)
 	int ret = 1;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	for (action = desc->action ; action; action = action->next) {
+	for (action = desc->action; action; action = action->next) {
 		if ((action != new_action) && action->name &&
 				!strcmp(new_action->name, action->name)) {
 			ret = 0;
@@ -289,7 +289,7 @@ static int name_unique(unsigned int irq, struct irqaction *new_action)
 
 void register_handler_proc(unsigned int irq, struct irqaction *action)
 {
-	char name [MAX_NAMELEN];
+	char name[MAX_NAMELEN];
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (!desc->dir || action->dir || !action->name ||
@@ -309,7 +309,7 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
-	char name [MAX_NAMELEN];
+	char name[MAX_NAMELEN];
 
 	if (!root_irq_dir || (desc->irq_data.chip == &no_irq_chip) || desc->dir)
 		return;
@@ -345,7 +345,7 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 
 void unregister_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
-	char name [MAX_NAMELEN];
+	char name[MAX_NAMELEN];
 
 	if (!root_irq_dir || !desc->dir)
 		return;
@@ -463,7 +463,8 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, " %8s", "None");
 	}
 #ifdef CONFIG_GENERIC_IRQ_SHOW_LEVEL
-	seq_printf(p, " %-8s", irqd_is_level_type(&desc->irq_data) ? "Level" : "Edge");
+	seq_printf(p, " %-8s",
+			irqd_is_level_type(&desc->irq_data) ? "Level" : "Edge");
 #endif
 	if (desc->name)
 		seq_printf(p, "-%-8s", desc->name);
-- 
1.8.2.1


