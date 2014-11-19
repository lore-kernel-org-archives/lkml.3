Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbaKSQLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:11:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:51513 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbaKSQEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:38 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/16] perf hists: Fix up srcline histogram key formatting
Date: Wed, 19 Nov 2014 13:03:31 -0300
Message-Id: <1416413016-19110-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Problem introduced in:

  commit 5b5916696051 "perf report: Honor column width setting"

Where the left justification signal was after the width, which ended up,
when the width was, say, 11, always printing:

	%11.11-s

Instead of src:line left justified and limited to 11 chars.

Resulting in a like:

    70.93%  %11.11-s  [.] f2                     tcall

When it should instead be:

    70.93%  tcall.c:5    [.] f2                     tcall

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2xnt0vqkoox52etq2qhyetr0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9402885a77f3..82a5596241a7 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -309,7 +309,7 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
 					size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*.*-s", width, width, he->srcline);
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, he->srcline);
 }
 
 struct sort_entry sort_srcline = {
-- 
1.9.3

