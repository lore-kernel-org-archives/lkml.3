Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaIVTjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:39:25 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:59025 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaIVTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:39:24 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [RFC PATCH] x86: Use volatile semantics for atomic_set()
Date: Mon, 22 Sep 2014 15:39:21 -0400
Message-Id: <1411414762-32366-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the atomic operations have volatile semantics to prevent compiler
reordering. Enforce the same semantics for atomic_set() too.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/x86/include/asm/atomic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index bf20c81..fa92e93 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -36,7 +36,7 @@ static inline int atomic_read(const atomic_t *v)
  */
 static inline void atomic_set(atomic_t *v, int i)
 {
-	v->counter = i;
+	ACCESS_ONCE(v->counter) = i;
 }
 
 /**
-- 
2.1.0

