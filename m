Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaDGSzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:55:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942AbaDGSzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:55:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, namhyung@gmail.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/4 v2] perf: Use cpu/possible instead of cpu/kernel_max
Date: Mon,  7 Apr 2014 14:55:22 -0400
Message-Id: <1396896924-129847-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1396896924-129847-1-git-send-email-dzickus@redhat.com>
References: <1396896924-129847-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system's max configuration is represented by cpu/possible and
cpu/kernel_max can be huge (4096 vs. 128), so save space by keeping
smaller structures.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 1b75434..22adfd0 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -365,7 +365,7 @@ static void set_max_cpu_num(void)
 		goto out;
 
 	/* get the highest possible cpu number for a sparse allocation */
-	snprintf(path, PATH_MAX, "%s/devices/system/cpu/kernel_max", mnt);
+	snprintf(path, PATH_MAX, "%s/devices/system/cpu/possible", mnt);
 
 	ret = get_max_num(path, &max_cpu_num);
 
-- 
1.7.11.7

