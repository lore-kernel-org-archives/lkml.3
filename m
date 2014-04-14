Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaDNOSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:18:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaDNOSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/17] perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()
Date: Mon, 14 Apr 2014 16:17:33 +0200
Message-Id: <1397485061-17215-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The dwarf_getcfi() only checks .debug_frame section for CFI, but as
most binaries only have .eh_frame it'd return NULL and it makes
some variables inaccessible.

Using dwarf_getcfi_elf (along with dwarf_getelf()) allows to show and
add probe to more variables.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1396854348-9296-1-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/probe-finder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index fae274e..5627621 100644
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
1.8.3.1

