Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3CULTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:19:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3CULTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:19:00 -0400
Date: Thu, 21 Mar 2013 04:17:24 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-b1dd443296b4f8c6869eba790eec950f80392aea@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-6-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Add basic support to event group view
Git-Commit-ID: b1dd443296b4f8c6869eba790eec950f80392aea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:17:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1dd443296b4f8c6869eba790eec950f80392aea
Gitweb:     http://git.kernel.org/tip/b1dd443296b4f8c6869eba790eec950f80392aea
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 5 Mar 2013 14:53:25 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:05 -0300

perf annotate: Add basic support to event group view

Add --group option to enable event grouping.  When enabled, all the
group members information will be shown with the leader so skip
non-leader events.

It only supports --stdio output currently.  Later patches will extend
additional features.

 $ perf annotate --group --stdio
 ...
  Percent                 |      Source code & Disassembly of libpthread-2.15.so
 --------------------------------------------------------------------------------
                          :
                          :
                          :
                          :      Disassembly of section .text:
                          :
                          :      000000387dc0aa50 <__pthread_mutex_unlock_usercnt>:
     8.08    2.40    5.29 :        387dc0aa50:   mov    %rdi,%rdx
     0.00    0.00    0.00 :        387dc0aa53:   mov    0x10(%rdi),%edi
     0.00    0.00    0.00 :        387dc0aa56:   mov    %edi,%eax
     0.00    0.80    0.00 :        387dc0aa58:   and    $0x7f,%eax
     3.03    2.40    3.53 :        387dc0aa5b:   test   $0x7c,%dil
     0.00    0.00    0.00 :        387dc0aa5f:   jne    387dc0aaa9 <__pthread_mutex_unlock_use
     0.00    0.00    0.00 :        387dc0aa61:   test   %eax,%eax
     0.00    0.00    0.00 :        387dc0aa63:   jne    387dc0aa85 <__pthread_mutex_unlock_use
     0.00    0.00    0.00 :        387dc0aa65:   and    $0x80,%edi
     0.00    0.00    0.00 :        387dc0aa6b:   test   %esi,%esi
     3.03    5.60    7.06 :        387dc0aa6d:   movl   $0x0,0x8(%rdx)
     0.00    0.00    0.59 :        387dc0aa74:   je     387dc0aa7a <__pthread_mutex_unlock_use
     0.00    0.00    0.00 :        387dc0aa76:   subl   $0x1,0xc(%rdx)
     2.02    5.60    1.18 :        387dc0aa7a:   mov    %edi,%esi
     0.00    0.00    0.00 :        387dc0aa7c:   lock decl (%rdx)
    83.84   83.20   82.35 :        387dc0aa7f:   jne    387dc0aada <_L_unlock_586>
     0.00    0.00    0.00 :        387dc0aa81:   nop
     0.00    0.00    0.00 :        387dc0aa82:   xor    %eax,%eax
     0.00    0.00    0.00 :        387dc0aa84:   retq
 ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |  3 ++
 tools/perf/builtin-annotate.c              |  7 ++++
 tools/perf/util/annotate.c                 | 64 +++++++++++++++++++++++++-----
 3 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 5ad07ef..e9cd39a 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -93,6 +93,9 @@ OPTIONS
 --skip-missing::
 	Skip symbols that cannot be annotated.
 
+--group::
+	Show event group information together
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 2f015a9..ae36f3c 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -232,6 +232,11 @@ static int __cmd_annotate(struct perf_annotate *ann)
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
 			hists__output_resort(hists);
+
+			if (symbol_conf.event_group &&
+			    !perf_evsel__is_group_leader(pos))
+				continue;
+
 			hists__find_annotations(hists, pos, ann);
 		}
 	}
@@ -314,6 +319,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
+		    "Show event group information together"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index ae71325..0955cff 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -638,7 +638,9 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 	if (dl->offset != -1) {
 		const char *path = NULL;
-		double percent;
+		double percent, max_percent = 0.0;
+		double *ppercents = &percent;
+		int i, nr_percent = 1;
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
 		s64 offset = dl->offset;
@@ -647,10 +649,27 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 		next = disasm__get_next_ip_line(&notes->src->source, dl);
 
-		percent = disasm__calc_percent(notes, evsel->idx, offset,
-					       next ? next->offset : (s64) len,
-					       &path);
-		if (percent < min_pcnt)
+		if (symbol_conf.event_group &&
+		    perf_evsel__is_group_leader(evsel) &&
+		    evsel->nr_members > 1) {
+			nr_percent = evsel->nr_members;
+			ppercents = calloc(nr_percent, sizeof(double));
+			if (ppercents == NULL)
+				return -1;
+		}
+
+		for (i = 0; i < nr_percent; i++) {
+			percent = disasm__calc_percent(notes,
+						evsel->idx + i, offset,
+						next ? next->offset : (s64) len,
+						&path);
+
+			ppercents[i] = percent;
+			if (percent > max_percent)
+				max_percent = percent;
+		}
+
+		if (max_percent < min_pcnt)
 			return -1;
 
 		if (max_lines && printed >= max_lines)
@@ -665,7 +684,7 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 			}
 		}
 
-		color = get_percent_color(percent);
+		color = get_percent_color(max_percent);
 
 		/*
 		 * Also color the filename and line if needed, with
@@ -681,20 +700,35 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 			}
 		}
 
-		color_fprintf(stdout, color, " %7.2f", percent);
+		for (i = 0; i < nr_percent; i++) {
+			percent = ppercents[i];
+			color = get_percent_color(percent);
+			color_fprintf(stdout, color, " %7.2f", percent);
+		}
+
 		printf(" :	");
 		color_fprintf(stdout, PERF_COLOR_MAGENTA, "  %" PRIx64 ":", addr);
 		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", dl->line);
+
+		if (ppercents != &percent)
+			free(ppercents);
+
 	} else if (max_lines && printed >= max_lines)
 		return 1;
 	else {
+		int width = 8;
+
 		if (queue)
 			return -1;
 
+		if (symbol_conf.event_group &&
+		    perf_evsel__is_group_leader(evsel))
+			width *= evsel->nr_members;
+
 		if (!*dl->line)
-			printf("         :\n");
+			printf(" %*s:\n", width, " ");
 		else
-			printf("         :	%s\n", dl->line);
+			printf(" %*s:	%s\n", width, " ", dl->line);
 	}
 
 	return 0;
@@ -1077,6 +1111,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	int printed = 2, queue_len = 0;
 	int more = 0;
 	u64 len;
+	int width = 8;
+	int namelen;
 
 	filename = strdup(dso->long_name);
 	if (!filename)
@@ -1088,9 +1124,15 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 		d_filename = basename(filename);
 
 	len = symbol__size(sym);
+	namelen = strlen(d_filename);
+
+	if (symbol_conf.event_group && perf_evsel__is_group_leader(evsel))
+		width *= evsel->nr_members;
 
-	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
-	printf("------------------------------------------------\n");
+	printf(" %-*.*s|	Source code & Disassembly of %s\n",
+	       width, width, "Percent", d_filename);
+	printf("-%-*.*s-------------------------------------\n",
+	       width+namelen, width+namelen, graph_dotted_line);
 
 	if (verbose)
 		symbol__annotate_hits(sym, evsel);
