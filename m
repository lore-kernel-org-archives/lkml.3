Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaB0NeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:34:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaB0NeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:34:12 -0500
Date: Thu, 27 Feb 2014 05:33:26 -0800
From: tip-bot for Mark Rutland <tipbot@zytor.com>
Message-ID: <tip-9e3170411ed171a126f4dca1672012a33efe59e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, peterz@infradead.org, mark.rutland@arm.com,
        Dave.Martin@arm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, peterz@infradead.org, mark.rutland@arm.com,
        Dave.Martin@arm.com, tglx@linutronix.de
In-Reply-To: <1392054264-23570-2-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-2-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix prototype of find_pmu_context()
Git-Commit-ID: 9e3170411ed171a126f4dca1672012a33efe59e5
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

Commit-ID:  9e3170411ed171a126f4dca1672012a33efe59e5
Gitweb:     http://git.kernel.org/tip/9e3170411ed171a126f4dca1672012a33efe59e5
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Mon, 10 Feb 2014 17:44:18 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:43:21 +0100

perf: Fix prototype of find_pmu_context()

For some reason find_pmu_context() is defined as returning void * rather
than a __percpu struct perf_cpu_context *. As all the requisite types are
defined in advance there's no reason to keep it that way.

This patch modifies the prototype of pmu_find_context to return a
__percpu struct perf_cpu_context *.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/1392054264-23570-2-git-send-email-mark.rutland@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fa99006..4251598 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6313,7 +6313,7 @@ static int perf_event_idx_default(struct perf_event *event)
  * Ensures all contexts with the same task_ctx_nr have the same
  * pmu_cpu_context too.
  */
-static void *find_pmu_context(int ctxn)
+static struct perf_cpu_context __percpu *find_pmu_context(int ctxn)
 {
 	struct pmu *pmu;
 
