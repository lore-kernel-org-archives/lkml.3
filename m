Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaBUNJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:09:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264AbaBUNCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 51/60] genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n
Date: Fri, 21 Feb 2014 13:01:18 +0000
Message-Id: <1392987687-15367-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit 2c45aada341121438affc4cb8d5b4cfaa2813d3d upstream.

In allmodconfig builds for sparc and any other arch which does
not set CONFIG_SPARSE_IRQ, the following will be seen at modpost:

  CC [M]  lib/cpu-notifier-error-inject.o
  CC [M]  lib/pm-notifier-error-inject.o
ERROR: "irq_to_desc" [drivers/gpio/gpio-mcp23s08.ko] undefined!
make[2]: *** [__modpost] Error 1

This happens because commit 3911ff30f5 ("genirq: export
handle_edge_irq() and irq_to_desc()") added one export for it, but
there were actually two instances of it, in an if/else clause for
CONFIG_SPARSE_IRQ.  Add the second one.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Link: http://lkml.kernel.org/r/1392057610-11514-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/irq/irqdesc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..8ab8e93 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -274,6 +274,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 {
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
+EXPORT_SYMBOL(irq_to_desc);
 
 static void free_desc(unsigned int irq)
 {
-- 
1.9.0

