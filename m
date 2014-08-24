Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaHXPCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:02:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaHXPBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:01:34 -0400
Date: Sun, 24 Aug 2014 07:59:26 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0ywfthh4lh65swe15f6w2x2q@git.kernel.org>
Cc: acme@redhat.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jean.pihet@linaro.org,
        acme@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jean.pihet@linaro.org,
        acme@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, namhyung@kernel.org,
        adrian.hunter@intel.com
In-Reply-To: <20140811120102.GY9918@twins.programming.kicks-ass.net>
References: <20140811120102.GY9918@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Fix perf_poll to return proper POLLHUP value
Git-Commit-ID: 61b67684c4a4d04b30d9ed67aa2eadfa0089c590
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

Commit-ID:  61b67684c4a4d04b30d9ed67aa2eadfa0089c590
Gitweb:     http://git.kernel.org/tip/61b67684c4a4d04b30d9ed67aa2eadfa0089c590
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 13 Aug 2014 19:39:56 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 24 Aug 2014 08:10:55 -0300

perf: Fix perf_poll to return proper POLLHUP value

Currently perf_poll returns POLL_HUP in case of error, which is wrong,
because poll syscall expects POLLHUP.  The POLL_HUP is meant to be used
for SIGIO state.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140811120102.GY9918@twins.programming.kicks-ass.net
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-0ywfthh4lh65swe15f6w2x2q@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2d7363a..4575dd6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3627,7 +3627,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
 	struct ring_buffer *rb;
-	unsigned int events = POLL_HUP;
+	unsigned int events = POLLHUP;
 
 	poll_wait(file, &event->waitq, wait);
 	/*
