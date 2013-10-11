Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3JKMXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:23:23 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49635 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3JKMXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:23:22 -0400
Subject: [PATCH -tip ] [BUGFIX] perf probe: fix to initialize fname always
 before use it
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 11 Oct 2013 12:23:17 +0000
Message-ID: <20131011122317.9662.29736.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix perf probe --list to initialize fname local var always before
use it. This may cause a SEGV if there is a probe which is in
the function body but not in any inline function.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-finder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c044052..e41b094 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1460,10 +1460,10 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 			goto post;
 		}
 
+		fname = dwarf_decl_file(&spdie);
 		if (addr == (unsigned long)baseaddr) {
 			/* Function entry - Relative line number is 0 */
 			lineno = baseline;
-			fname = dwarf_decl_file(&spdie);
 			goto post;
 		}
 


