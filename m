Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaFIWpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:45:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbaFIWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Juri Lelli <juri.lelli@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 02/78] sched/deadline: Fix memory leak
Date: Mon,  9 Jun 2014 15:47:42 -0700
Message-Id: <20140609224813.434767088@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 6a7cd273dc4bc3246f37ebe874754a54ccb29141 upstream.

Free cpudl->free_cpus allocated in cpudl_init().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/534F36CE.2000409@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/cpudeadline.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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


