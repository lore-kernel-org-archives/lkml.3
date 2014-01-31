Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaAaU15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:27:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55384 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042AbaAaU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@cloudius-systems.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/12] perf tools: Demangle kernel and kernel module symbols too
Date: Fri, 31 Jan 2014 17:27:24 -0300
Message-Id: <1391200055-18250-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@cloudius-systems.com>

Some kernels contain C++ code, and thus their symbols need to be
demangled.  This allows 'perf kvm top' to generate readable output.

Signed-off-by: Avi Kivity <avi@cloudius-systems.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/26f71bf5bf7ee1408e3f1a803556d5df18223ef1.1390420726.git.avi@cloudius-systems.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 759456728703..8f12f0f5101d 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -922,6 +922,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 				  (u64)shdr.sh_offset);
 			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 		}
+new_symbol:
 		/*
 		 * We need to figure out if the object was created from C++ sources
 		 * DWARF DW_compile_unit has this, but we don't always have access
@@ -933,7 +934,6 @@ int dso__load_sym(struct dso *dso, struct map *map,
 			if (demangled != NULL)
 				elf_name = demangled;
 		}
-new_symbol:
 		f = symbol__new(sym.st_value, sym.st_size,
 				GELF_ST_BIND(sym.st_info), elf_name);
 		free(demangled);
-- 
1.8.1.4

