Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab3KFLVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:21:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:21:45 -0500
Date: Wed, 6 Nov 2013 03:21:15 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-52bjmtty46we26hbfd9sc9iy@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move the percpu-rwsem code to kernel/
 locking/
Git-Commit-ID: 32cf7c3c94623514eb882addae307212c1507239
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:21:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32cf7c3c94623514eb882addae307212c1507239
Gitweb:     http://git.kernel.org/tip/32cf7c3c94623514eb882addae307212c1507239
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 4 Nov 2013 18:05:09 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 09:24:22 +0100

locking: Move the percpu-rwsem code to kernel/locking/

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-52bjmtty46we26hbfd9sc9iy@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/Makefile                | 3 ++-
 {lib => kernel/locking}/percpu-rwsem.c | 0
 lib/Makefile                           | 1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index bdd313a..baab8e5 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -21,4 +21,5 @@ obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
\ No newline at end of file
+obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
+obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
diff --git a/lib/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
similarity index 100%
rename from lib/percpu-rwsem.c
rename to kernel/locking/percpu-rwsem.c
diff --git a/lib/Makefile b/lib/Makefile
index ca8cadc..8d3c629 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -42,7 +42,6 @@ obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
-lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
