Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab3JTTbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 15:31:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3JTTbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 15:31:44 -0400
Date: Sun, 20 Oct 2013 12:31:01 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-1b286bdd5b7684c681b63d5e75cada037064c315@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20131011122317.9662.29736.stgit@kbuild-fedora.novalocal>
References: <20131011122317.9662.29736.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Fix to initialize fname always before use it
Git-Commit-ID: 1b286bdd5b7684c681b63d5e75cada037064c315
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 20 Oct 2013 12:31:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b286bdd5b7684c681b63d5e75cada037064c315
Gitweb:     http://git.kernel.org/tip/1b286bdd5b7684c681b63d5e75cada037064c315
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 11 Oct 2013 12:23:17 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 15 Oct 2013 14:37:38 -0300

perf probe: Fix to initialize fname always before use it

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
index c09e0a9..f069273 100644
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
 
