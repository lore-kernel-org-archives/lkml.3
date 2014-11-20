Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbaKTHpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:45:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43954 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaKTHpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:45:10 -0500
Date: Wed, 19 Nov 2014 23:39:15 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-2xnt0vqkoox52etq2qhyetr0@git.kernel.org>
Cc: dzickus@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        peterz@infradead.org, hpa@zytor.com, efault@gmx.de, bp@suse.de,
        tglx@linutronix.de, dsahern@gmail.com, jolsa@redhat.com,
        mingo@kernel.org, acme@redhat.com, adrian.hunter@intel.com,
        andi@firstfloor.org, fweisbec@gmail.com, namhyung@kernel.org
Reply-To: mingo@kernel.org, tglx@linutronix.de, dsahern@gmail.com, bp@suse.de,
        jolsa@redhat.com, hpa@zytor.com, efault@gmx.de, peterz@infradead.org,
        eranian@google.com, linux-kernel@vger.kernel.org, dzickus@redhat.com,
        namhyung@kernel.org, fweisbec@gmail.com, andi@firstfloor.org,
        adrian.hunter@intel.com, acme@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Fix up srcline histogram key formatting
Git-Commit-ID: b2d53671cdb0cf5070d56359821eb812669bb1ad
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

Commit-ID:  b2d53671cdb0cf5070d56359821eb812669bb1ad
Gitweb:     http://git.kernel.org/tip/b2d53671cdb0cf5070d56359821eb812669bb1ad
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Nov 2014 18:02:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:48 -0300

perf hists: Fix up srcline histogram key formatting

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
index 9402885..82a5596 100644
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
