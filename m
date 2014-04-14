Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaDNOxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:53:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46612 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaDNOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:53:42 -0400
Date: Mon, 14 Apr 2014 07:53:28 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-03d89412981a7681971bc77edba1669595763030@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1396854348-9296-1-git-send-email-namhyung@kernel.org>
References: <1396854348-9296-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Use dwarf_getcfi_elf()
  instead of dwarf_getcfi()
Git-Commit-ID: 03d89412981a7681971bc77edba1669595763030
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03d89412981a7681971bc77edba1669595763030
Gitweb:     http://git.kernel.org/tip/03d89412981a7681971bc77edba1669595763030
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 7 Apr 2014 16:05:48 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:40 +0200

perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()

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
