Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaEHKpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:45:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33334 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaEHKpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:45:46 -0400
Date: Thu, 8 May 2014 03:45:09 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-sybq1publ9xt5no77cwvi0eo@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, vincent.weaver@maine.edu,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Validate locking assumption
Git-Commit-ID: 63342411efd2d9350ad405205da036cd45ed1640
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

Commit-ID:  63342411efd2d9350ad405205da036cd45ed1640
Gitweb:     http://git.kernel.org/tip/63342411efd2d9350ad405205da036cd45ed1640
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 May 2014 11:49:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:44:18 +0200

perf: Validate locking assumption

Document and validate the locking assumption of event_sched_in().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-sybq1publ9xt5no77cwvi0eo@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 819ffc0..0de1997 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1678,6 +1678,8 @@ event_sched_in(struct perf_event *event,
 	u64 tstamp = perf_event_time(event);
 	int ret = 0;
 
+	lockdep_assert_held(&ctx->lock);
+
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
