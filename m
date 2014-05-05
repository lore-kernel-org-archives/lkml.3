Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaEERt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:49:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbaEERtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:49:25 -0400
Date: Mon, 5 May 2014 10:48:23 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1b7ae1c941af21ec386ea7c7e812ba430652731c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1399293219-8732-4-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove min define from perf.h
Git-Commit-ID: 1b7ae1c941af21ec386ea7c7e812ba430652731c
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

Commit-ID:  1b7ae1c941af21ec386ea7c7e812ba430652731c
Gitweb:     http://git.kernel.org/tip/1b7ae1c941af21ec386ea7c7e812ba430652731c
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 12:34:12 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:46:41 +0200

perf tools: Remove min define from perf.h

It's defined in tools/perf/util/include/linux/kernel.h header.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1399293219-8732-4-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index a547f38..50aa88d 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -203,12 +203,6 @@ static inline unsigned long long rdclock(void)
  */
 #define asmlinkage
 
-#define min(x, y) ({				\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
-
 extern bool test_attr__enabled;
 void test_attr__init(void);
 void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
