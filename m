Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbaAaU1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:27:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55352 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/12] perf tools: Fix AAAAARGH64 memory barriers
Date: Fri, 31 Jan 2014 17:27:25 -0300
Message-Id: <1391200055-18250-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Someone got the load and store barriers mixed up for AAAAARGH64.  Turn
them the right side up.

Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Fixes: a94d342b9cb0 ("tools/perf: Add required memory barriers")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/20140124154002.GF31570@twins.programming.kicks-ass.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 7daa806d9050..e84fa26bc1be 100644
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
 
-- 
1.8.1.4

