Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaEAGd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:33:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaEAGdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:33:54 -0400
Date: Wed, 30 Apr 2014 23:32:44 -0700
From: tip-bot for Xia Kaixu <tipbot@zytor.com>
Message-ID: <tip-603940b6b8b1347ec13a628165c00194ebc17ed2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, xiakaixu@huawei.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, xiakaixu@huawei.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <535B6660.2060001@huawei.com>
References: <535B6660.2060001@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove extra '/'
  character in events file path
Git-Commit-ID: 603940b6b8b1347ec13a628165c00194ebc17ed2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  603940b6b8b1347ec13a628165c00194ebc17ed2
Gitweb:     http://git.kernel.org/tip/603940b6b8b1347ec13a628165c00194ebc17ed2
Author:     Xia Kaixu <xiakaixu@huawei.com>
AuthorDate: Sat, 26 Apr 2014 15:55:12 +0800
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 30 Apr 2014 17:02:24 +0200

perf tools: Remove extra '/' character in events file path

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
 
