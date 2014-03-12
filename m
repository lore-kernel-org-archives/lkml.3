Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaCLDzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:55:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50272 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaCLDzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:55:33 -0400
Message-ID: <531FDA76.9060601@huawei.com>
Date: Wed, 12 Mar 2014 11:54:30 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, smp: fix misleading native_stop_other_cpus() description
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.191]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The description should be for native_stop_other_cpus() instead of
smp_reboot_interrupt().

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 arch/x86/kernel/smp.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 7c3a5a6..f295a18 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -164,10 +164,6 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	return NMI_HANDLED;
 }

-/*
- * this function calls the 'stop' function on all other CPUs in the system.
- */
-
 asmlinkage void smp_reboot_interrupt(void)
 {
 	ack_APIC_irq();
@@ -176,6 +172,9 @@ asmlinkage void smp_reboot_interrupt(void)
 	irq_exit();
 }

+/*
+ * this function calls the 'stop' function on all other CPUs in the system.
+ */
 static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
-- 
1.6.0.2


