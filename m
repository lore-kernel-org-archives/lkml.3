Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3JVQIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:08:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:49496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab3JVQII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422985817"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        konrad.wilk@oracle.com, gleb@redhat.com,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH 6/7] x86, asmlinkage, xen, kvm: Make {xen,kvm}_lock_spinning global and visible
Date: Tue, 22 Oct 2013 09:07:58 -0700
Message-Id: <1382458079-24450-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

These functions are called from inline assembler stubs, thus
need to be global and visible.

Cc: konrad.wilk@oracle.com
Cc: gleb@redhat.com
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/kvm.c   | 2 +-
 arch/x86/xen/spinlock.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a0e2a8a..5d10bb5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -673,7 +673,7 @@ static cpumask_t waiting_cpus;
 /* Track spinlock on which a cpu is waiting */
 static DEFINE_PER_CPU(struct kvm_lock_waiting, klock_waiting);
 
-static void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
+__visible void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	struct kvm_lock_waiting *w;
 	int cpu;
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index be6b860..3ab9309 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -106,7 +106,7 @@ static DEFINE_PER_CPU(struct xen_lock_waiting, lock_waiting);
 static cpumask_t waiting_cpus;
 
 static bool xen_pvspin = true;
-static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
+__visible void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	int irq = __this_cpu_read(lock_kicker_irq);
 	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
-- 
1.8.3.1

