Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3LRKeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:34:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3LRKdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:33:19 -0500
Date: Wed, 18 Dec 2013 02:32:39 -0800
From: tip-bot for Will Deacon <tipbot@zytor.com>
Message-ID: <tip-9450d14fb959336803e5209119eb422b667b96aa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1385560479-11014-2-git-send-email-will.deacon@arm.com>
References: <1385560479-11014-2-git-send-email-will.deacon@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert "ARM: 7556/1: perf:
  fix updated event period in response to PERF_EVENT_IOC_PERIOD"
Git-Commit-ID: 9450d14fb959336803e5209119eb422b667b96aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:32:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9450d14fb959336803e5209119eb422b667b96aa
Gitweb:     http://git.kernel.org/tip/9450d14fb959336803e5209119eb422b667b96aa
Author:     Will Deacon <will.deacon@arm.com>
AuthorDate: Wed, 27 Nov 2013 13:54:39 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:21:35 +0100

Revert "ARM: 7556/1: perf: fix updated event period in response to PERF_EVENT_IOC_PERIOD"

This reverts commit 3581fe0ef37ce12ac7a4f74831168352ae848edc.

Fixes to the handling of PERF_EVENT_IOC_PERIOD in the core code mean
we no longer have to play this horrible game.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1385560479-11014-2-git-send-email-will.deacon@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/kernel/perf_event.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index bc3f2ef..789d846 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -99,10 +99,6 @@ int armpmu_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0;
 
-	/* The period may have been changed by PERF_EVENT_IOC_PERIOD */
-	if (unlikely(period != hwc->last_period))
-		left = period - (hwc->last_period - left);
-
 	if (unlikely(left <= -period)) {
 		left = period;
 		local64_set(&hwc->period_left, left);
