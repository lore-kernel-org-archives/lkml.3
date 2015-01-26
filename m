Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbbAZRue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:50:34 -0500
Received: from mail.kernel.org ([198.145.29.136]:53215 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870AbbAZRtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:49:12 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/26] perf tests: Fix typo in sample-parsing.c
Date: Mon, 26 Jan 2015 14:47:27 -0300
Message-Id: <1422294449-12735-25-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

It was testing the same buffer for differences:

   memcmp(s1->user_stack.data, s1->user_stack.data, s1->user_stack.size)

I'm pretty sure this wasn't supposed to be dead code.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1421946083-29863-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/sample-parsing.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 4908c648a597..30c02181e78b 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -110,7 +110,7 @@ static bool samples_same(const struct perf_sample *s1,
 
 	if (type & PERF_SAMPLE_STACK_USER) {
 		COMP(user_stack.size);
-		if (memcmp(s1->user_stack.data, s1->user_stack.data,
+		if (memcmp(s1->user_stack.data, s2->user_stack.data,
 			   s1->user_stack.size)) {
 			pr_debug("Samples differ at 'user_stack'\n");
 			return false;
-- 
1.9.3

