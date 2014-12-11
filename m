Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965812AbaLKVfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:35:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:44334 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbaLKV1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:05 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/18] perf callchain: Fixup parameter handling error message
Date: Thu, 11 Dec 2014 18:25:57 -0300
Message-Id: <1418333166-15429-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Fix up parse_callchain_record_opt error message for 'fp', in the past using '-g
fp' was a valid alternative to '--call-graph fp', which is not the case since:

  commit 09b0fd45ff63413df94cbd832a765076b201edbb
  Author: Jiri Olsa <jolsa@redhat.com>
  Date:   Sat Oct 26 16:25:33 2013 +0200

  perf record: Split -g and --call-graph

I.e. -g means "use the configured unwind data collection method" which has as
default 'fp', while --call-graph requires passing the method to use.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1417532814-26208-2-git-send-email-kan.liang@intel.com
[ split this from a larger patch related to LBR based unwinding ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index cf524a35cc84..64b377e591e4 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -77,7 +77,7 @@ int parse_callchain_record_opt(const char *arg)
 				ret = 0;
 			} else
 				pr_err("callchain: No more arguments "
-				       "needed for -g fp\n");
+				       "needed for --call-graph fp\n");
 			break;
 
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.9.3

