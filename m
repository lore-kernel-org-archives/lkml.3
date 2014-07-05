Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbaGEKsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:48:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760844AbaGEKsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:48:05 -0400
Date: Sat, 5 Jul 2014 03:47:08 -0700
From: tip-bot for Rasmus Villemoes <tipbot@zytor.com>
Message-ID: <tip-2172c1f5aa58310784f358ca20fdddfcdc2a0d7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux@rasmusvillemoes.dk, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux@rasmusvillemoes.dk,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1403183731-15402-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403183731-15402-1-git-send-email-linux@rasmusvillemoes.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Micro-optimize nhmex_rbox_get_constraint()
Git-Commit-ID: 2172c1f5aa58310784f358ca20fdddfcdc2a0d7b
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

Commit-ID:  2172c1f5aa58310784f358ca20fdddfcdc2a0d7b
Gitweb:     http://git.kernel.org/tip/2172c1f5aa58310784f358ca20fdddfcdc2a0d7b
Author:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
AuthorDate: Thu, 19 Jun 2014 15:15:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:21:52 +0200

perf/x86: Micro-optimize nhmex_rbox_get_constraint()

Flipping the LSB doesn't require four lines of code. This shaves a few
bytes of the generated code, including a branch.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403183731-15402-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 65bbbea..e009f3c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2946,10 +2946,7 @@ again:
 		 * extra registers. If we failed to take an extra
 		 * register, try the alternative.
 		 */
-		if (idx % 2)
-			idx--;
-		else
-			idx++;
+		idx ^= 1;
 		if (idx != reg1->idx % 6) {
 			if (idx == 2)
 				config1 >>= 8;
