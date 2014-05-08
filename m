Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaEHKl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:41:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33066 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaEHKlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:41:51 -0400
Date: Thu, 8 May 2014 03:40:38 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ffb4ef21ac4308c2e738e6f83b6741bbc9b4fa3b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, peterz@infradead.org, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <20140505171428.GU26782@laptop.programming.kicks-ass.net>
References: <20140505171428.GU26782@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix perf_event_init_context()
Git-Commit-ID: ffb4ef21ac4308c2e738e6f83b6741bbc9b4fa3b
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

Commit-ID:  ffb4ef21ac4308c2e738e6f83b6741bbc9b4fa3b
Gitweb:     http://git.kernel.org/tip/ffb4ef21ac4308c2e738e6f83b6741bbc9b4fa3b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 May 2014 19:12:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:33:15 +0200

perf: Fix perf_event_init_context()

perf_pin_task_context() can return NULL but perf_event_init_context()
assumes it will not, correct this.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/20140505171428.GU26782@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ea899e2..7123284 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7729,6 +7729,8 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 	 * swapped under us.
 	 */
 	parent_ctx = perf_pin_task_context(parent, ctxn);
+	if (!parent_ctx)
+		return 0;
 
 	/*
 	 * No need to check if parent_ctx != NULL here; since we saw
