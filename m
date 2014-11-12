Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaKLNqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:46:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:41637 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaKLNnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:00 -0500
Message-Id: <20141112134120.299325814@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Subject: [patch 06/16] genirq: Split out flow handler typedefs into seperate
 header file
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=genirq-splitout-handler-typedef-into-seperate-header.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required to avoid circular include dependencies.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h        |    6 +-----
 include/linux/irqhandler.h |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/gfp.h>
+#include <linux/irqhandler.h>
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/errno.h>
@@ -27,12 +28,7 @@
 
 struct seq_file;
 struct module;
-struct irq_desc;
-struct irq_data;
 struct msi_msg;
-typedef	void (*irq_flow_handler_t)(unsigned int irq,
-					    struct irq_desc *desc);
-typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
 
 /*
  * IRQ line status.
Index: tip/include/linux/irqhandler.h
===================================================================
--- /dev/null
+++ tip/include/linux/irqhandler.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_IRQHANDLER_H
+#define _LINUX_IRQHANDLER_H
+
+/*
+ * Interrupt flow handler typedefs are defined here to avoid circular
+ * include dependencies.
+ */
+
+struct irq_desc;
+struct irq_data;
+typedef	void (*irq_flow_handler_t)(unsigned int irq, struct irq_desc *desc);
+typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
+
+#endif


