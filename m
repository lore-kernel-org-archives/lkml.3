Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3KFLUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:20:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47528 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:20:35 -0500
Date: Wed, 6 Nov 2013 03:20:02 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-b81ol0z3mon45m51o131yc9j@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move the spinlock code to kernel/
 locking/
Git-Commit-ID: 60fc28746a7b61775ae28950ddf7a4ac15955639
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:20:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60fc28746a7b61775ae28950ddf7a4ac15955639
Gitweb:     http://git.kernel.org/tip/60fc28746a7b61775ae28950ddf7a4ac15955639
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 18:15:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 07:55:21 +0100

locking: Move the spinlock code to kernel/locking/

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-b81ol0z3mon45m51o131yc9j@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile                          | 3 ---
 kernel/locking/Makefile                  | 4 ++++
 kernel/{ => locking}/spinlock.c          | 0
 {lib => kernel/locking}/spinlock_debug.c | 0
 lib/Makefile                             | 1 -
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 4fffd6ee..4bce165 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -43,9 +43,6 @@ obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
-obj-$(CONFIG_SMP) += spinlock.o
-obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
-obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificate.o
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index c103599..674d215 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -13,3 +13,7 @@ obj-$(CONFIG_LOCKDEP) += lockdep.o
 ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
+obj-$(CONFIG_SMP) += spinlock.o
+obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
+obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
+obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
diff --git a/kernel/spinlock.c b/kernel/locking/spinlock.c
similarity index 100%
rename from kernel/spinlock.c
rename to kernel/locking/spinlock.c
diff --git a/lib/spinlock_debug.c b/kernel/locking/spinlock_debug.c
similarity index 100%
rename from lib/spinlock_debug.c
rename to kernel/locking/spinlock_debug.c
diff --git a/lib/Makefile b/lib/Makefile
index f3bb2cb..bee27e1 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -42,7 +42,6 @@ obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
-obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
