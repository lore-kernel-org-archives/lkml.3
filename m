Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3KLG0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:26:14 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52060 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3KLG0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:26:05 -0500
X-AuditID: 9c93016f-b7c75ae00000244e-32-5281c9fa429f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf trace: Beautify fifth argument of mmap() as fd
Date: Tue, 12 Nov 2013 15:24:59 +0900
Message-Id: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The fifth argument of mmap syscall is fd and it often contains -1 as a
value for anon mappings.  Without this patch it doesn't show the file
name as well as it shows -1 as 4294967295.

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

