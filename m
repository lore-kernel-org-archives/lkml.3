Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaJODaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 23:30:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:34523 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbaJODaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 23:30:18 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zhangzhiqiang.zhang@huawei.com>,
        <peifeiyue@huawei.com>, <wangnan0@huawei.com>
Subject: [PATCH] perf tools: fix incorrect header string
Date: Wed, 15 Oct 2014 11:28:53 +0800
Message-ID: <1413343733-7973-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.543DEA47.016B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 07fc0b3cf2c96426d9dd023fbf0869a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fbe96f29 (perf tools: Make perf.data more self-descriptive)
read '/proc/cpuinfo' to form cpu descriptor. For ARM, it finds
'Processor' field. It is correct when the patch merged, but due to
commit b4b8f770 (ARM: kernel: update cpuinfo to print all online CPUs
features), the corresponding information becomes 'model name' field.

This patch simply corrects it.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/perf-sys.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 937e432..4293970 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -113,7 +113,7 @@
 #define mb()		((void(*)(void))0xffff0fa0)()
 #define wmb()		((void(*)(void))0xffff0fa0)()
 #define rmb()		((void(*)(void))0xffff0fa0)()
-#define CPUINFO_PROC	"Processor"
+#define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __aarch64__
-- 
1.8.4

