Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab3LKEfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 23:35:44 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39966 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3LKEfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 23:35:43 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf tool: Fix bug in thread__fork
Date: Tue, 10 Dec 2013 21:35:38 -0700
Message-Id: <1386736538-23525-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1902efe7f for the new comm infra added the wrong check for return
code on thread__set_comm. err == 0 is normal, so don't return at that
point unless err != 0.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
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
1.8.3.4 (Apple Git-47)

