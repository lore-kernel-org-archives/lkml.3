Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaJXTKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:10:04 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:41821 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaJXTKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:10:02 -0400
From: Johan Hovold <johan@kernel.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH] ARM: remove redundant irq disable at halt and restart
Date: Fri, 24 Oct 2014 21:06:32 +0200
Message-Id: <1414177592-14547-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant local_irq_disable() at machine halt and restart.

Since commit 44424c34049f ("ARM: 7803/1: Fix deadlock scenario with
smp_send_stop()") interrupts are disabled before stopping secondary
CPUs.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 arch/arm/kernel/process.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index a35f6ebbd2c2..5663ab57cf07 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -195,7 +195,6 @@ void machine_halt(void)
 	local_irq_disable();
 	smp_send_stop();
 
-	local_irq_disable();
 	while (1);
 }
 
@@ -237,7 +236,6 @@ void machine_restart(char *cmd)
 
 	/* Whoops - the platform was unable to reboot. Tell the user! */
 	printk("Reboot failed -- System halted\n");
-	local_irq_disable();
 	while (1);
 }
 
-- 
2.0.4

