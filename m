Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3CRQfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:35:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36438 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3CRQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/54] perf annotate: Add a comment on the symbol__parse_objdump_line()
Date: Mon, 18 Mar 2013 13:25:07 -0300
Message-Id: <1363623939-10748-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The symbol__parse_objdump_line() parses result of the objdump run but
it's hard to follow if one doesn't know the output format of the
objdump.  Add a head comment on the function to help her.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7eac5f0..fa347b1 100644
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
1.7.1

