Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966219AbaFSVh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:37:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:55677 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965821AbaFSVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:41 -0400
Message-Id: <20140619212712.872379208@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com,
        stable@vger.kernel.org
Subject: [patch 01/13] irqchip: spear_shirq: Fix interrupt offset
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-shirq-fix-offsets.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ras3 block on spear320 claims to have 3 interrupts. In fact it has
one and 6 reserved interrupts. Account the 6 reserved to this block so
it has 7 interrupts total. That matches the datasheet and the device
tree entries.

Broken since commit 80515a5a(ARM: SPEAr3xx: shirq: simplify and move
the shared irq multiplexor to DT). Testing is overrated....

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/irqchip/spear-shirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -125,7 +125,7 @@ static struct spear_shirq spear320_shirq
 };
 
 static struct spear_shirq spear320_shirq_ras3 = {
-	.irq_nr = 3,
+	.irq_nr = 7,
 	.irq_bit_off = 0,
 	.invalid_irq = 1,
 	.regs = {


