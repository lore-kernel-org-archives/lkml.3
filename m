Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbaAaU2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:28:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55428 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbaAaU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/12] perf tests: No need to set up ref_reloc_sym
Date: Fri, 31 Jan 2014 17:27:33 -0300
Message-Id: <1391200055-18250-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Now that ref_reloc_sym is set up by machine__create_kernel_maps(), the
"vmlinux symtab matches kallsyms" test does have to do it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1391004884-10334-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/vmlinux-kallsyms.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
index 2bd13edcbc17..3d9088003a5b 100644
--- a/tools/perf/tests/vmlinux-kallsyms.c
+++ b/tools/perf/tests/vmlinux-kallsyms.c
@@ -26,7 +26,6 @@ int test__vmlinux_matches_kallsyms(void)
 	struct map *kallsyms_map, *vmlinux_map;
 	struct machine kallsyms, vmlinux;
 	enum map_type type = MAP__FUNCTION;
-	struct ref_reloc_sym ref_reloc_sym = { .name = "_stext", };
 	u64 mem_start, mem_end;
 
 	/*
@@ -70,14 +69,6 @@ int test__vmlinux_matches_kallsyms(void)
 	 */
 	kallsyms_map = machine__kernel_map(&kallsyms, type);
 
-	sym = map__find_symbol_by_name(kallsyms_map, ref_reloc_sym.name, NULL);
-	if (sym == NULL) {
-		pr_debug("dso__find_symbol_by_name ");
-		goto out;
-	}
-
-	ref_reloc_sym.addr = UM(sym->start);
-
 	/*
 	 * Step 5:
 	 *
@@ -89,7 +80,6 @@ int test__vmlinux_matches_kallsyms(void)
 	}
 
 	vmlinux_map = machine__kernel_map(&vmlinux, type);
-	map__kmap(vmlinux_map)->ref_reloc_sym = &ref_reloc_sym;
 
 	/*
 	 * Step 6:
-- 
1.8.1.4

