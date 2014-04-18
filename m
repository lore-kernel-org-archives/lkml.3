Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaDRNGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:06:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaDRNG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:06:29 -0400
Date: Fri, 18 Apr 2014 06:05:53 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-kl53k3pyj0rbd80jq8ralpf3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        msalter@redhat.com, paulmck@linux.vnet.ibm.com, a-jacquiot@ti.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        msalter@redhat.com, paulmck@linux.vnet.ibm.com, a-jacquiot@ti.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,c6x: Convert smp_mb__*()
Git-Commit-ID: a8ec1516a74554992605f230859936d5d79c27ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8ec1516a74554992605f230859936d5d79c27ed
Gitweb:     http://git.kernel.org/tip/a8ec1516a74554992605f230859936d5d79c27ed
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:34 +0200

arch,c6x: Convert smp_mb__*()

c6x doesn't have a barrier.h and completely relies on
asm-generic/barrier.h. Therefore its smp_mb() is barrier() and we can
use the default versions that are smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Mark Salter <msalter@redhat.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-kl53k3pyj0rbd80jq8ralpf3@git.kernel.org
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: linux-c6x-dev@linux-c6x.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/c6x/include/asm/bitops.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/c6x/include/asm/bitops.h b/arch/c6x/include/asm/bitops.h
index 0bec7e5..f0ab012 100644
--- a/arch/c6x/include/asm/bitops.h
+++ b/arch/c6x/include/asm/bitops.h
@@ -14,14 +14,8 @@
 #ifdef __KERNEL__
 
 #include <linux/bitops.h>
-
 #include <asm/byteorder.h>
-
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit() barrier()
-#define smp_mb__after_clear_bit()  barrier()
+#include <asm/barrier.h>
 
 /*
  * We are lucky, DSP is perfect for bitops: do it in 3 cycles
