Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaAXPJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:09:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:53226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbaAXPJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:09:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="471901301"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/8] perf tools: test does not need to set up ref_reloc_sym
Date: Fri, 24 Jan 2014 17:10:17 +0200
Message-Id: <1390576218-1463-8-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
References: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ref_reloc_sym is set up by
machine__create_kernel_maps(), the
"vmlinux symtab matches kallsyms" test
does have to do it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/vmlinux-kallsyms.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
index 2bd13ed..3d90880 100644
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
1.7.11.7

