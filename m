Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaA3GWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:22:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaA3GW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:22:29 -0500
Date: Wed, 29 Jan 2014 22:22:10 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-dd41f818e581bc8244d34d594e20331fcb835524@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, gleb@kernel.org,
        raghavendra.kt@linux.vnet.ibm.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, gleb@kernel.org,
        raghavendra.kt@linux.vnet.ibm.com, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1382458079-24450-7-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-7-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, xen, kvm: Make {xen,
 kvm}_lock_spinning global and visible
Git-Commit-ID: dd41f818e581bc8244d34d594e20331fcb835524
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 29 Jan 2014 22:22:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd41f818e581bc8244d34d594e20331fcb835524
Gitweb:     http://git.kernel.org/tip/dd41f818e581bc8244d34d594e20331fcb835524
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 22 Oct 2013 09:07:58 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Jan 2014 22:17:18 -0800

x86, asmlinkage, xen, kvm: Make {xen,kvm}_lock_spinning global and visible

These functions are called from inline assembler stubs, thus
need to be global and visible.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1382458079-24450-7-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/kvm.c   | 2 +-
 arch/x86/xen/spinlock.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6dd802c..cd1b362 100644
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
index 0e36cde..581521c 100644
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
