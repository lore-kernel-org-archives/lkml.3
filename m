Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3LPJEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:04:39 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46223 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3LPJEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:04:36 -0500
Date: Mon, 16 Dec 2013 01:04:13 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: mm: ptl is not bloated if it fits in pointer
Message-ID: <alpine.LNX.2.00.1312160053530.3066@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's silly to force the 64-bit CONFIG_GENERIC_LOCKBREAK architectures
to kmalloc eight bytes for an indirect page table lock: the lock needs
to fit in the space that a pointer to it would occupy, not into an int.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 kernel/bounds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.13-rc4/kernel/bounds.c	2013-11-22 15:40:37.452192638 -0800
+++ linux/kernel/bounds.c	2013-12-15 14:34:36.304485959 -0800
@@ -22,6 +22,6 @@ void foo(void)
 #ifdef CONFIG_SMP
 	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
 #endif
-	DEFINE(BLOATED_SPINLOCKS, sizeof(spinlock_t) > sizeof(int));
+	DEFINE(BLOATED_SPINLOCKS, sizeof(spinlock_t) > sizeof(spinlock_t *));
 	/* End of constants */
 }
