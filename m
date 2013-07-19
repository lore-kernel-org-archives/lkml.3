Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3GSHnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:43:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3GSHnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:43:07 -0400
Date: Fri, 19 Jul 2013 00:42:48 -0700
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-0d3942dbcf7f7e8955ba89deed4749b0ad64d721@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, DavidAGilbert@uk.ibm.com, mpjohn@us.ibm.com,
        jolsa@redhat.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, DavidAGilbert@uk.ibm.com, mpjohn@us.ibm.com,
        jolsa@redhat.com, sukadev@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20130515055651.GA9985@us.ibm.com>
References: <20130515055651.GA9985@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Add --objdump option
Git-Commit-ID: 0d3942dbcf7f7e8955ba89deed4749b0ad64d721
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:42:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d3942dbcf7f7e8955ba89deed4749b0ad64d721
Gitweb:     http://git.kernel.org/tip/0d3942dbcf7f7e8955ba89deed4749b0ad64d721
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Tue, 14 May 2013 22:56:51 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:45:46 -0300

perf top: Add --objdump option

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
