Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaISIxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:53:25 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:14020 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaISIxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:53:22 -0400
Message-ID: <541BEEFA.1020800@huawei.com>
Date: Fri, 19 Sep 2014 16:53:14 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] perf/cgroup: Remove perf_put_cgroup()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.541BEEFF.011D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 583546156a516b67d751179408aafd63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5a17f543ed68 ("cgroup: improve css_from_dir() into css_tryget_from_dir()")
removed perf_tryget_cgroup(), so let's also remove perf_put_cgroup().

Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/events/core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f9c1ed0..2af1cc5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -392,14 +392,9 @@ perf_cgroup_match(struct perf_event *event)
 				    event->cgrp->css.cgroup);
 }
 
-static inline void perf_put_cgroup(struct perf_event *event)
-{
-	css_put(&event->cgrp->css);
-}
-
 static inline void perf_detach_cgroup(struct perf_event *event)
 {
-	perf_put_cgroup(event);
+	css_put(&event->cgrp->css);
 	event->cgrp = NULL;
 }
 
-- 
1.8.0.2

