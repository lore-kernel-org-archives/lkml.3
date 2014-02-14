Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaBNVX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:23:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:48789 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbaBNVWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="455752587"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>, mingo@kernel.org
Subject: [PATCH 17/19] lto: Mark spinlocks noinline when inline spinlocks are disabled
Date: Fri, 14 Feb 2014 22:21:41 +0100
Message-Id: <1392412903-25733-18-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Otherwise LTO will inline them anyways

Cc: mingo@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/locking/spinlock.c | 56 +++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/kernel/locking/spinlock.c b/kernel/locking/spinlock.c
index 4b082b5..975bfe9 100644
--- a/kernel/locking/spinlock.c
+++ b/kernel/locking/spinlock.c
@@ -130,7 +130,7 @@ BUILD_LOCK_OPS(write, rwlock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK
-int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)
+noinline int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)
 {
 	return __raw_spin_trylock(lock);
 }
@@ -138,7 +138,7 @@ EXPORT_SYMBOL(_raw_spin_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
-int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)
+noinline int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)
 {
 	return __raw_spin_trylock_bh(lock);
 }
@@ -146,7 +146,7 @@ EXPORT_SYMBOL(_raw_spin_trylock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK
-void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)
 {
 	__raw_spin_lock(lock);
 }
@@ -154,7 +154,7 @@ EXPORT_SYMBOL(_raw_spin_lock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
+noinline unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
 {
 	return __raw_spin_lock_irqsave(lock);
 }
@@ -162,7 +162,7 @@ EXPORT_SYMBOL(_raw_spin_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQ
-void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
 {
 	__raw_spin_lock_irq(lock);
 }
@@ -170,7 +170,7 @@ EXPORT_SYMBOL(_raw_spin_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_BH
-void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
 {
 	__raw_spin_lock_bh(lock);
 }
@@ -178,7 +178,7 @@ EXPORT_SYMBOL(_raw_spin_lock_bh);
 #endif
 
 #ifdef CONFIG_UNINLINE_SPIN_UNLOCK
-void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
 {
 	__raw_spin_unlock(lock);
 }
@@ -186,7 +186,7 @@ EXPORT_SYMBOL(_raw_spin_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
-void __lockfunc _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
+noinline void __lockfunc _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_unlock_irqrestore(lock, flags);
 }
@@ -194,7 +194,7 @@ EXPORT_SYMBOL(_raw_spin_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
-void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
 {
 	__raw_spin_unlock_irq(lock);
 }
@@ -202,7 +202,7 @@ EXPORT_SYMBOL(_raw_spin_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
-void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)
+noinline void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)
 {
 	__raw_spin_unlock_bh(lock);
 }
@@ -210,7 +210,7 @@ EXPORT_SYMBOL(_raw_spin_unlock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_READ_TRYLOCK
-int __lockfunc _raw_read_trylock(rwlock_t *lock)
+noinline int __lockfunc _raw_read_trylock(rwlock_t *lock)
 {
 	return __raw_read_trylock(lock);
 }
@@ -218,7 +218,7 @@ EXPORT_SYMBOL(_raw_read_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK
-void __lockfunc _raw_read_lock(rwlock_t *lock)
+noinline void __lockfunc _raw_read_lock(rwlock_t *lock)
 {
 	__raw_read_lock(lock);
 }
@@ -226,7 +226,7 @@ EXPORT_SYMBOL(_raw_read_lock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
+noinline unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
 {
 	return __raw_read_lock_irqsave(lock);
 }
@@ -234,7 +234,7 @@ EXPORT_SYMBOL(_raw_read_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_IRQ
-void __lockfunc _raw_read_lock_irq(rwlock_t *lock)
+noinline void __lockfunc _raw_read_lock_irq(rwlock_t *lock)
 {
 	__raw_read_lock_irq(lock);
 }
@@ -242,7 +242,7 @@ EXPORT_SYMBOL(_raw_read_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_BH
-void __lockfunc _raw_read_lock_bh(rwlock_t *lock)
+noinline void __lockfunc _raw_read_lock_bh(rwlock_t *lock)
 {
 	__raw_read_lock_bh(lock);
 }
@@ -250,7 +250,7 @@ EXPORT_SYMBOL(_raw_read_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK
-void __lockfunc _raw_read_unlock(rwlock_t *lock)
+noinline void __lockfunc _raw_read_unlock(rwlock_t *lock)
 {
 	__raw_read_unlock(lock);
 }
@@ -258,7 +258,7 @@ EXPORT_SYMBOL(_raw_read_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
-void __lockfunc _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+noinline void __lockfunc _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__raw_read_unlock_irqrestore(lock, flags);
 }
@@ -266,7 +266,7 @@ EXPORT_SYMBOL(_raw_read_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_IRQ
-void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)
+noinline void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)
 {
 	__raw_read_unlock_irq(lock);
 }
@@ -274,7 +274,7 @@ EXPORT_SYMBOL(_raw_read_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_BH
-void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)
+noinline void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)
 {
 	__raw_read_unlock_bh(lock);
 }
@@ -282,7 +282,7 @@ EXPORT_SYMBOL(_raw_read_unlock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_TRYLOCK
-int __lockfunc _raw_write_trylock(rwlock_t *lock)
+noinline int __lockfunc _raw_write_trylock(rwlock_t *lock)
 {
 	return __raw_write_trylock(lock);
 }
@@ -290,7 +290,7 @@ EXPORT_SYMBOL(_raw_write_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK
-void __lockfunc _raw_write_lock(rwlock_t *lock)
+noinline void __lockfunc _raw_write_lock(rwlock_t *lock)
 {
 	__raw_write_lock(lock);
 }
@@ -298,7 +298,7 @@ EXPORT_SYMBOL(_raw_write_lock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
-unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
+noinline unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
 {
 	return __raw_write_lock_irqsave(lock);
 }
@@ -306,7 +306,7 @@ EXPORT_SYMBOL(_raw_write_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_IRQ
-void __lockfunc _raw_write_lock_irq(rwlock_t *lock)
+noinline void __lockfunc _raw_write_lock_irq(rwlock_t *lock)
 {
 	__raw_write_lock_irq(lock);
 }
@@ -314,7 +314,7 @@ EXPORT_SYMBOL(_raw_write_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_BH
-void __lockfunc _raw_write_lock_bh(rwlock_t *lock)
+noinline void __lockfunc _raw_write_lock_bh(rwlock_t *lock)
 {
 	__raw_write_lock_bh(lock);
 }
@@ -322,7 +322,7 @@ EXPORT_SYMBOL(_raw_write_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK
-void __lockfunc _raw_write_unlock(rwlock_t *lock)
+noinline void __lockfunc _raw_write_unlock(rwlock_t *lock)
 {
 	__raw_write_unlock(lock);
 }
@@ -330,7 +330,7 @@ EXPORT_SYMBOL(_raw_write_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
-void __lockfunc _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+noinline void __lockfunc _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__raw_write_unlock_irqrestore(lock, flags);
 }
@@ -338,7 +338,7 @@ EXPORT_SYMBOL(_raw_write_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQ
-void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)
+noinline void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)
 {
 	__raw_write_unlock_irq(lock);
 }
@@ -346,7 +346,7 @@ EXPORT_SYMBOL(_raw_write_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_BH
-void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)
+noinline void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)
 {
 	__raw_write_unlock_bh(lock);
 }
-- 
1.8.5.2

