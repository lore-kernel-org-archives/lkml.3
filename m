Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaEHKm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:42:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaEHKm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:42:27 -0400
Date: Thu, 8 May 2014 03:41:34 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-6a7cd273dc4bc3246f37ebe874754a54ccb29141@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com,
        juri.lelli@gmail.com
In-Reply-To: <534F36CE.2000409@huawei.com>
References: <534F36CE.2000409@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Fix memory leak
Git-Commit-ID: 6a7cd273dc4bc3246f37ebe874754a54ccb29141
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

Commit-ID:  6a7cd273dc4bc3246f37ebe874754a54ccb29141
Gitweb:     http://git.kernel.org/tip/6a7cd273dc4bc3246f37ebe874754a54ccb29141
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Thu, 17 Apr 2014 10:05:02 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:51:32 +0200

sched/deadline: Fix memory leak

Free cpudl->free_cpus allocated in cpudl_init().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # 3.14+
Link: http://lkml.kernel.org/r/534F36CE.2000409@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpudeadline.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 5b9bb42..ab001b5 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -210,7 +210,5 @@ int cpudl_init(struct cpudl *cp)
  */
 void cpudl_cleanup(struct cpudl *cp)
 {
-	/*
-	 * nothing to do for the moment
-	 */
+	free_cpumask_var(cp->free_cpus);
 }
