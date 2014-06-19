Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaFSNQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:16:04 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:58070 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaFSNQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:16:01 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] x86: Micro-optimization in nhmex_rbox_get_constraint
Date: Thu, 19 Jun 2014 15:15:31 +0200
Message-Id: <1403183731-15402-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flipping the LSB doesn't require four lines of code. This shaves a few
bytes of the generated code, including a branch.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
-- 
1.9.2

