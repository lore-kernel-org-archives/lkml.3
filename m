Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3LPGNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:13:11 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:45059 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3LPGNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:13:10 -0500
Message-ID: <52AE98FD.3060704@huawei.com>
Date: Mon, 16 Dec 2013 14:09:01 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, smp: fix misleading native_stop_other_cpus() description
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The description should be for native_stop_other_cpus() instead of
smp_reboot_interrupt().

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 arch/x86/kernel/smp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

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
1.8.2.2


