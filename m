Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaDVDZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:25:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:43940 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaDVDZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:25:02 -0400
Message-ID: <5355E0D6.50704@huawei.com>
Date: Tue, 22 Apr 2014 11:24:06 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        <a.p.zijlstra@chello.nl>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Huxinwei <huxinwei@huawei.com>,
        Genghui <hui.geng@huawei.com>, <peifeiyue@huawei.com>,
        Xia Kaixu <xiakaixu@huawei.com>
Subject: [PATCH] perf tools: Remove extra '/' character in events file path
References: <5354E37E.9060700@huawei.com>
In-Reply-To: <5354E37E.9060700@huawei.com>
X-Forwarded-Message-Id: <5354E37E.9060700@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.8.5.5

.




.




_______________________________________________
kernel.openeuler mailing list
kernel.openeuler@huawei.com
http://rnd-openeuler.huawei.com/mailman/listinfo/kernel.openeuler




