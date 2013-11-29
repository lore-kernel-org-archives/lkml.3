Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3K2Klf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:41:35 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:3979 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3K2Kle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:41:34 -0500
Message-ID: <52986E85.5070906@huawei.com>
Date: Fri, 29 Nov 2013 18:37:57 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Andi Kleen <ak@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: x86, smp: fix misleading native_stop_other_cpus() description
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

