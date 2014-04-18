Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaDRKdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaDRKcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:32:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/5] perf tools: Use cpu/possible instead of cpu/kernel_max
Date: Fri, 18 Apr 2014 12:31:57 +0200
Message-Id: <1397817119-15195-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397817119-15195-1-git-send-email-jolsa@redhat.com>
References: <1397817119-15195-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

The system's max configuration is represented by cpu/possible and
cpu/kernel_max can be huge (4096 vs. 128), so save space by keeping
smaller structures.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1396896924-129847-3-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 0a27732..3d124fb 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -365,7 +365,7 @@ static void set_max_cpu_num(void)
 		goto out;
 
 	/* get the highest possible cpu number for a sparse allocation */
-	snprintf(path, PATH_MAX, "%s/devices/system/cpu/kernel_max", mnt);
+	snprintf(path, PATH_MAX, "%s/devices/system/cpu/possible", mnt);
 
 	ret = get_max_num(path, &max_cpu_num);
 
-- 
1.8.3.1

