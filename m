Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3CRLPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:15:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3CRLPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:15:19 -0400
Date: Mon, 18 Mar 2013 04:13:55 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-86e213e1d901fbeaf6e57d13c5edd925fadddcbe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, tj@kernel.org, tglx@linutronix.de,
        lizefan@huawei.com
In-Reply-To: <1363600594-11453-1-git-send-email-namhyung@kernel.org>
References: <1363600594-11453-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/cgroup:
  Add __percpu annotation to perf_cgroup->info
Git-Commit-ID: 86e213e1d901fbeaf6e57d13c5edd925fadddcbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:14:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86e213e1d901fbeaf6e57d13c5edd925fadddcbe
Gitweb:     http://git.kernel.org/tip/86e213e1d901fbeaf6e57d13c5edd925fadddcbe
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 18 Mar 2013 18:56:34 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Mar 2013 11:02:06 +0100

perf/cgroup: Add __percpu annotation to perf_cgroup->info

It's a per-cpu data structure but missed the __percpu annotation.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/1363600594-11453-1-git-send-email-namhyung@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5976a2a..efb75b3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -245,7 +245,7 @@ struct perf_cgroup_info {
 
 struct perf_cgroup {
 	struct cgroup_subsys_state	css;
-	struct perf_cgroup_info		*info;
+	struct perf_cgroup_info	__percpu *info;
 };
 
 /*
