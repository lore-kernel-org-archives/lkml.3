Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaAVT66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:58:58 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34678 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaAVT65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:58:57 -0500
From: Avi Kivity <avi@cloudius-systems.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Avi Kivity <avi@cloudius-systems.com>
Subject: [PATCH] perf tools: demangle kernel and kernel module symbols too
Date: Wed, 22 Jan 2014 21:58:46 +0200
Message-Id: <26f71bf5bf7ee1408e3f1a803556d5df18223ef1.1390420726.git.avi@cloudius-systems.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kernels contain C++ code, and thus their symbols need to be demangled.
This allows 'perf kvm top' to generate readable output.

Signed-off-by: Avi Kivity <avi@cloudius-systems.com>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 7594567..8f12f0f 100644
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
1.8.4.2

