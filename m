Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaDGHF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 03:05:58 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:59355 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaDGHF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 03:05:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()
Date: Mon,  7 Apr 2014 16:05:48 +0900
Message-Id: <1396854348-9296-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dwarf_getcfi() only checks .debug_frame section for CFI, but as
most binaries only have .eh_frame it'd return NULL and it makes
some variables inaccessible.

Using dwarf_getcfi_elf (along with dwarf_getelf()) allows to show and
add probe to more variables.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-finder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3bf0c8cdccb7..d58da0672736 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -985,7 +985,7 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
 
 #if _ELFUTILS_PREREQ(0, 142)
 	/* Get the call frame information from this dwarf */
-	pf->cfi = dwarf_getcfi(dbg->dbg);
+	pf->cfi = dwarf_getcfi_elf(dwarf_getelf(dbg->dbg));
 #endif
 
 	off = 0;
-- 
1.7.11.7

