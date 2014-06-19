Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966013AbaFSVep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:34:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:55689 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965872AbaFSVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:41 -0400
Message-Id: <20140619212713.310591579@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 06/13] irqchip: spear_shirq: Reorder the spear320 ras blocks
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-reorder-320.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Order the ras blocks in the order of interrupts not alphabetically.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -138,20 +138,22 @@ static struct spear_shirq *spear310_shir
 #define SPEAR320_INT_CLR_MASK_REG		0x04
 #define SPEAR320_INT_ENB_MASK_REG		0x08
 
-static struct spear_shirq spear320_shirq_ras1 = {
-	.offset		= 7,
-	.nr_irqs	= 3,
+static struct spear_shirq spear320_shirq_ras3 = {
+	.offset		= 0,
+	.nr_irqs	= 7,
+	.disabled	= 1,
 	.regs = {
-		.enb_reg = -1,
+		.enb_reg = SPEAR320_INT_ENB_MASK_REG,
+		.reset_to_enb = 1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
 		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
 		.reset_to_clear = 1,
 	},
 };
 
-static struct spear_shirq spear320_shirq_ras2 = {
-	.offset		= 10,
-	.nr_irqs	= 1,
+static struct spear_shirq spear320_shirq_ras1 = {
+	.offset		= 7,
+	.nr_irqs	= 3,
 	.regs = {
 		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
@@ -160,13 +162,11 @@ static struct spear_shirq spear320_shirq
 	},
 };
 
-static struct spear_shirq spear320_shirq_ras3 = {
-	.offset		= 0,
-	.nr_irqs	= 7,
-	.disabled	= 1,
+static struct spear_shirq spear320_shirq_ras2 = {
+	.offset		= 10,
+	.nr_irqs	= 1,
 	.regs = {
-		.enb_reg = SPEAR320_INT_ENB_MASK_REG,
-		.reset_to_enb = 1,
+		.enb_reg = -1,
 		.status_reg = SPEAR320_INT_STS_MASK_REG,
 		.clear_reg = SPEAR320_INT_CLR_MASK_REG,
 		.reset_to_clear = 1,


