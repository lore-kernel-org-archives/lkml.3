Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaHNCWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:22:44 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40772 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaHNCWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:22:42 -0400
X-AuditID: 85900ec0-d312bb9000001514-b6-53ec1d6f3b9d
Subject: [PATCH 05/13] perf top: Use strerror_r instead of strerror
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:22:38 +0000
Message-ID: <20140814022238.3545.15569.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
References: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strerror_r instead of strerror in error message
for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-top.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 87a6615..a77ff6c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -899,7 +899,7 @@ try_again:
 
 	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
 		ui__error("Failed to mmap with %d (%s)\n",
-			    errno, strerror(errno));
+			    errno, strerror_r(errno, msg, sizeof(msg)));
 		goto out_err;
 	}
 

