Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbaBUAqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:46:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbaBTXvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.10 62/66] genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n
Date: Thu, 20 Feb 2014 15:52:01 -0800
Message-Id: <20140220234911.265789232@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/irqdesc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -274,6 +274,7 @@ struct irq_desc *irq_to_desc(unsigned in
 {
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
+EXPORT_SYMBOL(irq_to_desc);
 
 static void free_desc(unsigned int irq)
 {


