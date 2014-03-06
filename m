Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaCFR6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:58:52 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:64419 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaCFR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:56:48 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/6] cputime: Fix nsecs_to_cputime() return type cast
Date: Thu,  6 Mar 2014 18:56:36 +0100
Message-Id: <1394128601-26034-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though nsec based cputime_t maps to u64, nsecs_to_cputime() must
return a cputime_t value. We want to enforce this kind of cast in order
to track down buggy manipulations of cputime_t such as direct access
of its values under wrong assumptions on its backend type (nsecs,
jiffies, etc...) by core code.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/asm-generic/cputime_nsecs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index 2c9e62c..768294f 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -44,7 +44,8 @@ typedef u64 __nocast cputime64_t;
 /*
  * Convert cputime <-> nanoseconds
  */
-#define nsecs_to_cputime(__nsecs)	((__force u64)(__nsecs))
+#define nsecs_to_cputime(__nsecs)	\
+	(__force cputime_t)(__nsecs)
 
 
 /*
-- 
1.8.3.1

