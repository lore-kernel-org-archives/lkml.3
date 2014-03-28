Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaC1Rl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:41:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaC1RbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3.13 24/46] perf tools: Fix AAAAARGH64 memory barriers
Date: Fri, 28 Mar 2014 10:32:08 -0700
Message-Id: <20140328173137.934898595@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit f428ebd184c82a7914b2aa7e9f868918aaf7ea78 upstream.

Someone got the load and store barriers mixed up for AAAAARGH64.  Turn
them the right side up.

Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Fixes: a94d342b9cb0 ("tools/perf: Add required memory barriers")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/20140124154002.GF31570@twins.programming.kicks-ass.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/perf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -100,8 +100,8 @@
 
 #ifdef __aarch64__
 #define mb()		asm volatile("dmb ish" ::: "memory")
-#define wmb()		asm volatile("dmb ishld" ::: "memory")
-#define rmb()		asm volatile("dmb ishst" ::: "memory")
+#define wmb()		asm volatile("dmb ishst" ::: "memory")
+#define rmb()		asm volatile("dmb ishld" ::: "memory")
 #define cpu_relax()	asm volatile("yield" ::: "memory")
 #endif
 


