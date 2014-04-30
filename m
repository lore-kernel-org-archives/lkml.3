Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbaD3Pdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759262AbaD3Pdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:33:37 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Xia Kaixu <xiakaixu@huawei.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5/7] perf tools: Remove extra '/' character in events file path
Date: Wed, 30 Apr 2014 17:32:49 +0200
Message-Id: <1398871971-381-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398871971-381-1-git-send-email-jolsa@kernel.org>
References: <1398871971-381-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xia Kaixu <xiakaixu@huawei.com>

The array debugfs_known_mountpoints[] will cause extra '/'
character output.
Remove it.

pre:
$ perf probe -l
/sys/kernel/debug//tracing/uprobe_events file does not exist -
please rebuild kernel with CONFIG_UPROBE_EVENTS.

post:
$ perf probe -l
/sys/kernel/debug/tracing/uprobe_events file does not exist -
please rebuild kernel with CONFIG_UPROBE_EVENTS.

Signed-off-by: Xia Kaixu <xiakaixu@huawei.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/535B6660.2060001@huawei.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/api/fs/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index 7c43479..a74fba6 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -12,8 +12,8 @@
 char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
 
 static const char * const debugfs_known_mountpoints[] = {
-	"/sys/kernel/debug/",
-	"/debug/",
+	"/sys/kernel/debug",
+	"/debug",
 	0,
 };
 
-- 
1.8.3.1

