Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3LMPMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:12:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3LMPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:12 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/20] perf tools: Fix inverted error verification bug in thread__fork
Date: Fri, 13 Dec 2013 12:11:52 -0300
Message-Id: <1386947526-7118-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Commit 1902efe7f for the new comm infra added the wrong check for return
code on thread__set_comm. err == 0 is normal, so don't return at that
point unless err != 0.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1386736538-23525-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 49eaf1d7d89d..e3948612543e 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -126,7 +126,7 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 		if (!comm)
 			return -ENOMEM;
 		err = thread__set_comm(thread, comm, timestamp);
-		if (!err)
+		if (err)
 			return err;
 		thread->comm_set = true;
 	}
-- 
1.8.1.4

