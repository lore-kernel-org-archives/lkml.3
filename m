Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab3GRTuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:50:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41333 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256Ab3GRTuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        DavidAGilbert@uk.ibm.com, Jiri Olsa <jolsa@redhat.com>,
        Maynard Johnson <mpjohn@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/76] perf top: Add --objdump option
Date: Thu, 18 Jul 2013 16:48:49 -0300
Message-Id: <1374177003-3706-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

perf: Add objdump option to 'perf top'

Like with 'perf annotate' add the --objdump option to perf top so users
can specify an alternate path to the /usr/bin/objdump binary.

Reported-by: David A. Gilbert <DavidAGilbert@uk.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: DavidAGilbert@uk.ibm.com
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Maynard Johnson <mpjohn@us.ibm.com>
Link: http://lkml.kernel.org/r/20130515055651.GA9985@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e06c4f8..a237059 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -40,6 +40,7 @@
 #include "util/xyarray.h"
 #include "util/sort.h"
 #include "util/intlist.h"
+#include "arch/common.h"
 
 #include "util/debug.h"
 
@@ -939,6 +940,12 @@ static int __cmd_top(struct perf_top *top)
 	if (top->session == NULL)
 		return -ENOMEM;
 
+	if (!objdump_path) {
+		ret = perf_session_env__lookup_objdump(&top->session->header.env);
+		if (ret)
+			goto out_delete;
+	}
+
 	ret = perf_top__setup_sample_type(top);
 	if (ret)
 		goto out_delete;
@@ -1114,6 +1121,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Interleave source code with assembly code (default)"),
 	OPT_BOOLEAN(0, "asm-raw", &symbol_conf.annotate_asm_raw,
 		    "Display raw encoding of assembly instructions (default)"),
+	OPT_STRING(0, "objdump", &objdump_path, "path",
+		    "objdump binary to use for disassembly and annotations"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
-- 
1.8.1.4

