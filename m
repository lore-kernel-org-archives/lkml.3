Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaCJQCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:02:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaCJQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:02:33 -0400
Message-Id: <20140310155543.591055845@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Mar 2014 16:42:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 4/7] x86: Add atomic_test_and_set_bit()
References: <20140310154236.038181843@infradead.org>
Content-Disposition: inline; filename=peterz-atomic_set_and_test_bit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For use in qspinlock because unconditional atomic ops scale better
than cmpxchg loops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/atomic.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -218,6 +218,19 @@ static inline short int atomic_inc_short
 	return *v;
 }
 
+/**
+ * test_and_set_bit - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int atomic_test_and_set_bit(int nr, atomic_t *v)
+{
+	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", v->counter, "Ir", nr, "%0", "c");
+}
+
 #ifdef CONFIG_X86_64
 /**
  * atomic_or_long - OR of two long integers


