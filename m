Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3CRJ5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:57:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44575 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab3CRJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:57:19 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-64-5146e4fdbff3
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2] perf cgroup: Add __percpu annotation to perf_cgroup->info
Date: Mon, 18 Mar 2013 18:56:34 +0900
Message-Id: <1363600594-11453-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20130318093943.GA25045@gmail.com>
References: <20130318093943.GA25045@gmail.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's a per-cpu data structure but missed the __percpu annotation.

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5976a2a6b4ce..efb75b3a69ad 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -245,7 +245,7 @@ struct perf_cgroup_info {
 
 struct perf_cgroup {
 	struct cgroup_subsys_state	css;
-	struct perf_cgroup_info		*info;
+	struct perf_cgroup_info	__percpu *info;
 };
 
 /*
-- 
1.7.11.7

