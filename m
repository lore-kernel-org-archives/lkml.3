Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaLGWiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:38:07 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41554 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbaLGWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:38:04 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Shuah Khan <shuahkh@osg.samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Ellerman <mpe@ellerman.id.au>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: testing: selftests: powerpc: pmu: ebb: trace.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 23:40:42 +0100
Message-Id: <1417992042-20553-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
trace_log_outdent() trace_log_indent()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/testing/selftests/powerpc/pmu/ebb/trace.c |   26 -----------------------
 tools/testing/selftests/powerpc/pmu/ebb/trace.h |    2 --
 2 files changed, 28 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/ebb/trace.c b/tools/testing/selftests/powerpc/pmu/ebb/trace.c
index 251e66a..2b18b22 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/trace.c
+++ b/tools/testing/selftests/powerpc/pmu/ebb/trace.c
@@ -139,32 +139,6 @@ int trace_log_string(struct trace_buffer *tb, char *str)
 	return 0;
 }
 
-int trace_log_indent(struct trace_buffer *tb)
-{
-	struct trace_entry *e;
-
-	e = trace_alloc_entry(tb, 0);
-	if (!e)
-		return -ENOSPC;
-
-	e->type = TRACE_TYPE_INDENT;
-
-	return 0;
-}
-
-int trace_log_outdent(struct trace_buffer *tb)
-{
-	struct trace_entry *e;
-
-	e = trace_alloc_entry(tb, 0);
-	if (!e)
-		return -ENOSPC;
-
-	e->type = TRACE_TYPE_OUTDENT;
-
-	return 0;
-}
-
 static void trace_print_header(int seq, int prefix)
 {
 	printf("%*s[%d]: ", prefix, "", seq);
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/trace.h b/tools/testing/selftests/powerpc/pmu/ebb/trace.h
index 926458e..6c436d7 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/trace.h
+++ b/tools/testing/selftests/powerpc/pmu/ebb/trace.h
@@ -33,8 +33,6 @@ struct trace_buffer *trace_buffer_allocate(u64 size);
 int trace_log_reg(struct trace_buffer *tb, u64 reg, u64 value);
 int trace_log_counter(struct trace_buffer *tb, u64 value);
 int trace_log_string(struct trace_buffer *tb, char *str);
-int trace_log_indent(struct trace_buffer *tb);
-int trace_log_outdent(struct trace_buffer *tb);
 void trace_buffer_print(struct trace_buffer *tb);
 void trace_print_location(struct trace_buffer *tb);
 
-- 
1.7.10.4

