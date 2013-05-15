Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3EOF5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:57:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34952 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3EOF5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:57:21 -0400
Date: Tue, 14 May 2013 22:56:51 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        DavidAGilbert@uk.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Add --objdump option to perf top
Message-ID: <20130515055651.GA9985@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051505-7408-0000-0000-0000103140E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: Add objdump option to 'perf top'

Like with 'perf annotate' add the --objdump option to perf top so users
can specify an alternate path to the /usr/bin/objdump binary.

Reported-by: David A. Gilbert <DavidAGilbert@uk.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/builtin-top.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 67bdb9f..820caeb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -40,6 +40,7 @@
 #include "util/xyarray.h"
 #include "util/sort.h"
 #include "util/intlist.h"
+#include "arch/common.h"
 
 #include "util/debug.h"
 
@@ -942,6 +943,12 @@ static int __cmd_top(struct perf_top *top)
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
@@ -1107,6 +1114,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Interleave source code with assembly code (default)"),
 	OPT_BOOLEAN(0, "asm-raw", &symbol_conf.annotate_asm_raw,
 		    "Display raw encoding of assembly instructions (default)"),
+	OPT_STRING(0, "objdump", &objdump_path, "path",
+		    "objdump binary to use for disassembly and annotations"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
-- 
1.7.1

