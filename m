Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3IWBpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:45:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60616 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3IWBpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:45:15 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/5] perf tool: Add default handler for mmap2 events
Date: Sun, 22 Sep 2013 19:44:59 -0600
Message-Id: <1379900700-5186-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
References: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commands that do not implement an mmap2 handler should at least
not die with a segfault when processing files with MMAP2 events.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/session.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 78646da..6c1d444 100644
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
1.7.10.1

