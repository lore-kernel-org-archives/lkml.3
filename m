Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3CULPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:15:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3CULPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:15:31 -0400
Date: Thu, 21 Mar 2013 04:13:56 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-3aec150af3de6c00570bdacf45bf5a999ab9cf1d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-3-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Add a comment on the symbol__parse_objdump_line()
Git-Commit-ID: 3aec150af3de6c00570bdacf45bf5a999ab9cf1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:14:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3aec150af3de6c00570bdacf45bf5a999ab9cf1d
Gitweb:     http://git.kernel.org/tip/3aec150af3de6c00570bdacf45bf5a999ab9cf1d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 5 Mar 2013 14:53:22 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:04 -0300

perf annotate: Add a comment on the symbol__parse_objdump_line()

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
 tools/perf/util/annotate.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

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
