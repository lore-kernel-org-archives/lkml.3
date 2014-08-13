Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaHMWu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:50:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:55560 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbaHMWu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:56 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/41] perf symbols: Fix missing label symbols
Date: Wed, 13 Aug 2014 19:48:18 -0300
Message-Id: <1407970107-24540-33-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Label symbols are missing because elf_sec__is_a() fails to find the
section because the section strings do not match the section headers
because the sections headers are from the 'runtime' object and the
sections strings are from the 'symbol source' object.

Fix by getting the section strings from the 'runtime' object so that
they match the section headers.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index ec5ec1c9d9b5..9fb5e9e9f161 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -736,7 +736,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	if (symstrs == NULL)
 		goto out_elf_end;
 
-	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
+	sec_strndx = elf_getscn(runtime_ss->elf, runtime_ss->ehdr.e_shstrndx);
 	if (sec_strndx == NULL)
 		goto out_elf_end;
 
-- 
1.9.3

