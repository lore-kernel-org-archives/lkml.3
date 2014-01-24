Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaAXPkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:40:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42435 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaAXPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:40:21 -0500
Date: Fri, 24 Jan 2014 16:40:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: tools/perf: Fix AAAAARGH64 memory barriers
Message-ID: <20140124154002.GF31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone got the load and store barriers mixed up for AAAAARGH64.
Turn them the right side up.

Fixes: a94d342b9cb0 ("tools/perf: Add required memory barriers")
Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/perf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 3c2f213e979d..dd4c0d32fbae 100644
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
 
