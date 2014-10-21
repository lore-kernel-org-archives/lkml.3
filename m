Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbaJUMTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:19:35 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36485 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaJUMTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:19:33 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/kmemleak: Do not skip stack frames
Date: Tue, 21 Oct 2014 14:19:29 +0200
Message-Id: <1413893969-25798-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Trying to chase down memory leaks is much easier when the complete stack
trace is available.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
It seems like this was initially set to 1 when merged in commit
3c7b4e6b8be4 (kmemleak: Add the base support) and later increased to 2
in commit fd6789675ebf (kmemleak: Save the stack trace for early
allocations). Perhaps there was a reason to skip the first few frames,
but I've certainly found it difficult to find leaks when the stack trace
doesn't point at the proper location.
---
 mm/kmemleak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 3cda50c1e394..55d9ad0f40d4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -503,7 +503,7 @@ static int __save_stack_trace(unsigned long *trace)
 	stack_trace.max_entries = MAX_TRACE;
 	stack_trace.nr_entries = 0;
 	stack_trace.entries = trace;
-	stack_trace.skip = 2;
+	stack_trace.skip = 0;
 	save_stack_trace(&stack_trace);
 
 	return stack_trace.nr_entries;
-- 
2.1.2

