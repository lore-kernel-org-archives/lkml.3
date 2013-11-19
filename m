Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3KSTTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:19:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3KSTTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:19:41 -0500
Date: Tue, 19 Nov 2013 11:19:06 -0800
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-0022cedd4a7d8a87841351e2b018bb6794cf2e67@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1311151236100.11932@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311151236100.11932@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/trace: Properly use u64 to hold event_id
Git-Commit-ID: 0022cedd4a7d8a87841351e2b018bb6794cf2e67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:19:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0022cedd4a7d8a87841351e2b018bb6794cf2e67
Gitweb:     http://git.kernel.org/tip/0022cedd4a7d8a87841351e2b018bb6794cf2e67
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 15 Nov 2013 12:39:45 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 16:57:44 +0100

perf/trace: Properly use u64 to hold event_id

The 64-bit attr.config value for perf trace events was being copied into
an "int" before doing a comparison, meaning the top 32 bits were
being truncated.

As far as I can tell this didn't cause any errors, but it did mean
it was possible to create valid aliases for all the tracepoint ids
which I don't think was intended.  (For example, 0xffffffff00000018
and 0x18 both enable the same tracepoint).

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1311151236100.11932@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/trace_event_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 630889f..e854f42 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -179,7 +179,7 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 int perf_trace_init(struct perf_event *p_event)
 {
 	struct ftrace_event_call *tp_event;
-	int event_id = p_event->attr.config;
+	u64 event_id = p_event->attr.config;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
