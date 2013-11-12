Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3KLUra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:47:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41956 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab3KLUqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:46:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/13] perf trace: Beautify fifth argument of mmap() as fd
Date: Tue, 12 Nov 2013 17:46:06 -0300
Message-Id: <1384289178-31374-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384289178-31374-1-git-send-email-acme@infradead.org>
References: <1384289178-31374-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The fifth argument of mmap syscall is fd and it often contains -1 as a
value for anon mappings.  Without this patch it doesn't show the file
name as well as it shows -1 as 4294967295.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1384237500-22991-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c3008b1c369c..aeb6296a76bd 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -951,7 +951,8 @@ static struct syscall_fmt {
 	{ .name	    = "mmap",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
 			     [2] = SCA_MMAP_PROT, /* prot */
-			     [3] = SCA_MMAP_FLAGS, /* flags */ }, },
+			     [3] = SCA_MMAP_FLAGS, /* flags */
+			     [4] = SCA_FD, 	  /* fd */ }, },
 	{ .name	    = "mprotect",   .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* start */
 			     [2] = SCA_MMAP_PROT, /* prot */ }, },
-- 
1.8.1.4

