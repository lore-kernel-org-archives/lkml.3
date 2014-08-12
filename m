Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaHLGoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:44:09 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41193 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaHLGkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:40:49 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 02/13] perf tools: Fix a memory leak in vmlinux_path__init()
Date: Tue, 12 Aug 2014 15:40:34 +0900
Message-Id: <1407825645-24586-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When uname() failed, it should free vmlinux_path.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 581c56836567..009a9d064f11 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1772,7 +1772,7 @@ static int vmlinux_path__init(void)
 		return 0;
 
 	if (uname(&uts) < 0)
-		return -1;
+		goto out_fail;
 
 	snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
 	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
-- 
2.0.0

