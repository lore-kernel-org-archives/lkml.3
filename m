Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaBKJeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:34:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKJeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:34:15 -0500
Date: Tue, 11 Feb 2014 01:33:54 -0800
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-2c45aada341121438affc4cb8d5b4cfaa2813d3d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, tglx@linutronix.de, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jkosina@suse.cz, paul.gortmaker@windriver.com
In-Reply-To: <1392057610-11514-1-git-send-email-paul.gortmaker@windriver.com>
References: <1392057610-11514-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq:
  Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n
Git-Commit-ID: 2c45aada341121438affc4cb8d5b4cfaa2813d3d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 01:34:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c45aada341121438affc4cb8d5b4cfaa2813d3d
Gitweb:     http://git.kernel.org/tip/2c45aada341121438affc4cb8d5b4cfaa2813d3d
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Mon, 10 Feb 2014 13:39:53 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 11 Feb 2014 10:30:36 +0100

genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n

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
Cc: stable@vger.kernel.org	# 3.4+
Link: http://lkml.kernel.org/r/1392057610-11514-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

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
