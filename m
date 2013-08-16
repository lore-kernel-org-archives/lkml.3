Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3HPJc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:32:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35399 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3HPJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:32:25 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <x86@kernel.org>, Jiri Kosina <trivial@kernel.org>
Cc: <mingo@redhat.com>, <hpa@zytor.com>, <gleb@redhat.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH trivial sparse fix] guest x86 kvm: fix sparse warning: symbol 'klock_waiting' was not declared. Should it be static
Date: Fri, 16 Aug 2013 15:08:41 +0530
Message-Id: <1376645921-8056-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <y>
References: <y>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081609-3620-0000-0000-000003F69771
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was not declared as static since it was thought to be used by pv-flushtlb earlier.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 This should apply on top of tip/spinlocks and fixes the sparse warning
 introduced by pvspinlock patch series.

 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ef630..56e2fa4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -529,7 +529,7 @@ arch_initcall(activate_jump_labels);
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 /* Kick a cpu by its apicid. Used to wake up a halted vcpu */
-void kvm_kick_cpu(int cpu)
+static void kvm_kick_cpu(int cpu)
 {
 	int apicid;
 	unsigned long flags = 0;
-- 
1.7.11.7

