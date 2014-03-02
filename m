Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaCBNcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 08:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaCBNcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 08:32:32 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Albert Strasheim <albert@cloudflare.com>
Subject: [PATCH] perf tools: Fix crash in elf_section_by_name
Date: Sun,  2 Mar 2014 14:32:07 +0100
Message-Id: <1393767127-599-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing crash in elf_section_by_name function caused
by missing section name in elf binary.

Reported-by: Albert Strasheim <albert@cloudflare.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Albert Strasheim <albert@cloudflare.com>
---
 tools/perf/util/symbol-elf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 8ac4a4f..3b7dbf5 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -151,15 +151,15 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 
 		gelf_getshdr(sec, shp);
 		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str)) {
+		if (str && !strcmp(name, str)) {
 			if (idx)
 				*idx = cnt;
-			break;
+			return sec;
 		}
 		++cnt;
 	}
 
-	return sec;
+	return NULL;
 }
 
 #define elf_section__for_each_rel(reldata, pos, pos_mem, idx, nr_entries) \
-- 
1.8.3.1

