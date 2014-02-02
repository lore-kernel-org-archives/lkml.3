Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaBBIzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:55:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaBBIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:55:32 -0500
Date: Sun, 2 Feb 2014 00:54:43 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-f428ebd184c82a7914b2aa7e9f868918aaf7ea78@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, will.deacon@arm.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, will.deacon@arm.com, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20140124154002.GF31570@twins.programming.kicks-ass.net>
References: <20140124154002.GF31570@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix AAAAARGH64 memory barriers
Git-Commit-ID: f428ebd184c82a7914b2aa7e9f868918aaf7ea78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:54:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f428ebd184c82a7914b2aa7e9f868918aaf7ea78
Gitweb:     http://git.kernel.org/tip/f428ebd184c82a7914b2aa7e9f868918aaf7ea78
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 24 Jan 2014 16:40:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Jan 2014 15:50:57 -0300

perf tools: Fix AAAAARGH64 memory barriers

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
index 7daa806..e84fa26 100644
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
 
