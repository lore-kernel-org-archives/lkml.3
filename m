Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaEVV4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:56:09 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53661 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaEVV4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:56:07 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: builtin-trace.c:  Cleaning up inconsistent NULL checks
Date: Thu, 22 May 2014 23:56:56 +0200
Message-Id: <1400795816-12483-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up inconsistent NULL checks.
There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/builtin-trace.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f954c26..130063a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1146,8 +1146,10 @@ static struct thread_trace *thread_trace__new(void)
 {
 	struct thread_trace *ttrace =  zalloc(sizeof(struct thread_trace));
 
-	if (ttrace)
-		ttrace->paths.max = -1;
+	if (!ttrace)
+		return NULL;
+
+	ttrace->paths.max = -1;
 
 	ttrace->syscall_stats = intlist__new(NULL);
 
-- 
1.7.10.4

