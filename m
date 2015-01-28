Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbbA1V0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:26:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762057AbbA1Utm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:42 -0500
Date: Wed, 28 Jan 2015 07:10:18 -0800
From: tip-bot for Rasmus Villemoes <tipbot@zytor.com>
Message-ID: <tip-605a3069161dd966d6cea795133c673fb6706e52@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        a.p.zijlstra@chello.nl, acme@redhat.com, linux@rasmusvillemoes.dk,
        mingo@kernel.org, paulus@samba.org
Reply-To: paulus@samba.org, mingo@kernel.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        acme@redhat.com, linux@rasmusvillemoes.dk
In-Reply-To: <1421946083-29863-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1421946083-29863-1-git-send-email-linux@rasmusvillemoes.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Fix typo in sample-parsing.c
Git-Commit-ID: 605a3069161dd966d6cea795133c673fb6706e52
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

Commit-ID:  605a3069161dd966d6cea795133c673fb6706e52
Gitweb:     http://git.kernel.org/tip/605a3069161dd966d6cea795133c673fb6706e52
Author:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
AuthorDate: Thu, 22 Jan 2015 18:01:23 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Jan 2015 17:03:01 -0300

perf tests: Fix typo in sample-parsing.c

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
index 4908c64..30c0218 100644
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
