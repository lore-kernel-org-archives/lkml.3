Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaAUUnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:43:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37245 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaAUUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/8] perf tools: Ensure sscanf does not overrun the "mem" field
Date: Tue, 21 Jan 2014 17:43:01 -0300
Message-Id: <1390336984-1553-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390336984-1553-1-git-send-email-acme@infradead.org>
References: <1390336984-1553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Make the parsing robust.

(perf has some other assumptions that BUFSIZE <= MAX_PATH which are
 not touched here)

Reported-by: Jackie Chang
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-g2uoiwbrpiimb63rx32qv8ne@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bb3e0ede6183..893f8e2df928 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -930,7 +930,7 @@ static int write_topo_node(int fd, int node)
 		/* skip over invalid lines */
 		if (!strchr(buf, ':'))
 			continue;
-		if (sscanf(buf, "%*s %*d %s %"PRIu64, field, &mem) != 2)
+		if (sscanf(buf, "%*s %*d %31s %"PRIu64, field, &mem) != 2)
 			goto done;
 		if (!strcmp(field, "MemTotal:"))
 			mem_total = mem;
-- 
1.8.1.4

