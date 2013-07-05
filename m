Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3GEJsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:48:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab3GEJsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:48:51 -0400
Date: Fri, 5 Jul 2013 02:48:28 -0700
From: tip-bot for Axel Lin <tipbot@zytor.com>
Message-ID: <tip-e658718e478fb2591f38afd9643eab06698790fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux@prisktech.co.nz, hpa@zytor.com,
        mingo@kernel.org, olof@lixom.net, tglx@linutronix.de,
        axel.lin@ingics.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux@prisktech.co.nz,
        linux-kernel@vger.kernel.org, olof@lixom.net, tglx@linutronix.de,
        axel.lin@ingics.com
In-Reply-To: <1372995229.4038.1.camel@phoenix>
References: <1372995229.4038.1.camel@phoenix>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irqchip: vt8500: Staticize local symbols
Git-Commit-ID: e658718e478fb2591f38afd9643eab06698790fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Jul 2013 02:48:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e658718e478fb2591f38afd9643eab06698790fe
Gitweb:     http://git.kernel.org/tip/e658718e478fb2591f38afd9643eab06698790fe
Author:     Axel Lin <axel.lin@ingics.com>
AuthorDate: Fri, 5 Jul 2013 11:33:49 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 5 Jul 2013 11:39:24 +0200

irqchip: vt8500: Staticize local symbols

This driver is converted to use IRQCHIP_DECLARE and irqchip_init.
vt8500_handle_irq() and vt8500_irq_init() are only referenced in this file, so
make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Tony Prisk <linux@prisktech.co.nz>
Cc: Olof Johansson <olof@lixom.net>
Link: http://lkml.kernel.org/r/1372995229.4038.1.camel@phoenix
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-vt8500.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index d970595..1846e7d 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -178,7 +178,8 @@ static struct irq_domain_ops vt8500_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
+static asmlinkage
+void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 {
 	u32 stat, i;
 	int irqnr, virq;
@@ -203,7 +204,8 @@ asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 	}
 }
 
-int __init vt8500_irq_init(struct device_node *node, struct device_node *parent)
+static int __init vt8500_irq_init(struct device_node *node,
+				  struct device_node *parent)
 {
 	int irq, i;
 	struct device_node *np = node;
