Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaLPCOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:14:25 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:2097 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLPCOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:14:24 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <ak@linux.intel.com>, <namhyung@kernel.org>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: fix building warning on ARM 32.
Date: Tue, 16 Dec 2014 10:10:10 +0800
Message-ID: <1418695810-74455-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A010203.548F957D.002B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: a4c6ece33da92d5645b7d1b30c6a9e05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 85c116a6c introduces asprintf() call and matches '%ld' to a u64
argument, which is incorrect on ARM.

   CC       /home/wn/util/srcline.o
 util/srcline.c: In function 'get_srcline':
 util/srcline.c:297:6: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Werror=format]
 cc1: all warnings being treated as errors
 make[1]: *** [/home/wn/util/srcline.o] Error 1

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/util/srcline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index e73b6a5..42cb642 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -294,7 +294,7 @@ out:
 	}
 	if (sym) {
 		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
-					addr - sym->start) < 0)
+					(long int)(addr - sym->start)) < 0)
 			return SRCLINE_UNKNOWN;
 	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
 		return SRCLINE_UNKNOWN;
-- 
1.8.4

