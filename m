Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3JGTCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:02:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44534 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3JGTCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:02:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] perf tools: Add default handler for mmap2 events
Date: Mon,  7 Oct 2013 16:02:24 -0300
Message-Id: <1381172549-3210-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381172549-3210-1-git-send-email-acme@infradead.org>
References: <1381172549-3210-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Commands that do not implement an mmap2 handler should at least not die
with a segfault when processing files with MMAP2 events.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1379900700-5186-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 70ffa41518f3..37c4718f6be1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -256,6 +256,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->sample = process_event_sample_stub;
 	if (tool->mmap == NULL)
 		tool->mmap = process_event_stub;
+	if (tool->mmap2 == NULL)
+		tool->mmap2 = process_event_stub;
 	if (tool->comm == NULL)
 		tool->comm = process_event_stub;
 	if (tool->fork == NULL)
-- 
1.8.1.4

