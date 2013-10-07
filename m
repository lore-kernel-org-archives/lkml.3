Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3JGGsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:48:43 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64509 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3JGGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:48:41 -0400
From: Chia-I Wu <olvaffe@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] perf timechart: remove lock_depth from trace_entry
Date: Mon,  7 Oct 2013 14:48:34 +0800
Message-Id: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct trace_entry went out-of-sync with the kernel since

 commit b000c8065 "tracing: Remove the extra 4 bytes of padding in events"

causing "perf timechart" to be broken.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
---
 tools/perf/builtin-timechart.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c2e0231..f9cbc18 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -303,7 +303,6 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			lock_depth;
 };
 
 #ifdef SUPPORT_OLD_POWER_EVENTS
-- 
1.8.3.1

