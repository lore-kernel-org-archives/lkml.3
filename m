Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767Ab3CEF4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:56:25 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295Ab3CEFxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:43 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-c2-51358864c1e7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 02/12] perf annotate: Add a comment on the symbol__parse_objdump_line()
Date: Tue,  5 Mar 2013 14:53:22 +0900
Message-Id: <1362462812-30885-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The symbol__parse_objdump_line() parses result of the objdump run but
it's hard to follow if one doesn't know the output format of the
objdump.  Add a head comment on the function to help her.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7eac5f0895ee..fa347b169e27 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -689,6 +689,26 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 	return 0;
 }
 
+/*
+ * symbol__parse_objdump_line() parses objdump output (with -d --no-show-raw)
+ * which looks like following
+ *
+ *  0000000000415500 <_init>:
+ *    415500:       sub    $0x8,%rsp
+ *    415504:       mov    0x2f5ad5(%rip),%rax        # 70afe0 <_DYNAMIC+0x2f8>
+ *    41550b:       test   %rax,%rax
+ *    41550e:       je     415515 <_init+0x15>
+ *    415510:       callq  416e70 <__gmon_start__@plt>
+ *    415515:       add    $0x8,%rsp
+ *    415519:       retq
+ *
+ * it will be parsed and saved into struct disasm_line as
+ *  <offset>       <name>  <ops.raw>
+ *
+ * The offset will be a relative offset from the start of the symbol and -1
+ * means that it's not a disassembly line so should be treated differently.
+ * The ops.raw part will be parsed further according to type of the instruction.
+ */
 static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 				      FILE *file, size_t privsize)
 {
-- 
1.7.11.7

