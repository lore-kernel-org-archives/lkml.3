Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaIVTxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:53:14 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:56307 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaIVTxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:53:12 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [RFC PATCH] x86: Use ACCESS_ONCE() for atomic_read()
Date: Mon, 22 Sep 2014 15:53:09 -0400
Message-Id: <1411415590-12193-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the much easier to read ACCESS_ONCE() which is basically the same thing as
the cast to volatile.

Please note the change in volatile cast: ACCESS_ONCE(v)->counter to
ACCESS_ONCE(v->counter).

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/x86/include/asm/atomic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index fa92e93..dea3434 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -24,7 +24,7 @@
  */
 static inline int atomic_read(const atomic_t *v)
 {
-	return (*(volatile int *)&(v)->counter);
+	return ACCESS_ONCE(v->counter);
 }
 
 /**
-- 
2.1.0

