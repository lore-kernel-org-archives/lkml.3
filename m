Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3JTI1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 04:27:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3JTI1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 04:27:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf probe: Fix to initialize fname always before use it
Date: Sun, 20 Oct 2013 05:27:24 -0300
Message-Id: <1382257646-5808-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382257646-5808-1-git-send-email-acme@infradead.org>
References: <1382257646-5808-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix perf probe --list to initialize fname local var always before
use it. This may cause a SEGV if there is a probe which is in
the function body but not in any inline function.

Problem introduced in:

	commit e08cfd4bda76
	Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
	Date:   Mon Sep 30 18:21:44 2013 +0900

	    perf probe: Fix to find line information for probe list

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20131011122317.9662.29736.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c09e0a9fdf4c..f0692737ebf1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1357,10 +1357,10 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
 			goto post;
 		}
 
+		fname = dwarf_decl_file(&spdie);
 		if (addr == (unsigned long)baseaddr) {
 			/* Function entry - Relative line number is 0 */
 			lineno = baseline;
-			fname = dwarf_decl_file(&spdie);
 			goto post;
 		}
 
-- 
1.8.1.4

