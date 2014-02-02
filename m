Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaBBI4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:56:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41413 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaBBI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:56:37 -0500
Date: Sun, 2 Feb 2014 00:56:16 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-c080f72753def150993144d755379941f8b14683@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1391004884-10334-8-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tests: No need to set up ref_reloc_sym
Git-Commit-ID: c080f72753def150993144d755379941f8b14683
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:56:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c080f72753def150993144d755379941f8b14683
Gitweb:     http://git.kernel.org/tip/c080f72753def150993144d755379941f8b14683
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:42 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:52 -0300

perf tests: No need to set up ref_reloc_sym

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
