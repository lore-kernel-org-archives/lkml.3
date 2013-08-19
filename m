Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab3HSJ4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:56:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3HSJ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:56:45 -0400
Date: Mon, 19 Aug 2013 02:55:43 -0700
From: tip-bot for Xie XiuQi <tipbot@zytor.com>
Message-ID: <tip-15e71911fcc655508e02f767a3d9b8b138051d2b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
        xiexiuqi@huawei.com, tglx@linutronix.de, sheng@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au, jens.axboe@oracle.com,
        xiexiuqi@huawei.com, sheng@linux.intel.com, tglx@linutronix.de
In-Reply-To: <51F5E6F8.1000801@huawei.com>
References: <51F5E6F8.1000801@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] generic-ipi/locking:
  Fix misleading smp_call_function_any() description
Git-Commit-ID: 15e71911fcc655508e02f767a3d9b8b138051d2b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 19 Aug 2013 02:55:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15e71911fcc655508e02f767a3d9b8b138051d2b
Gitweb:     http://git.kernel.org/tip/15e71911fcc655508e02f767a3d9b8b138051d2b
Author:     Xie XiuQi <xiexiuqi@huawei.com>
AuthorDate: Mon, 29 Jul 2013 11:52:24 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 19 Aug 2013 09:03:50 +0200

generic-ipi/locking: Fix misleading smp_call_function_any() description

Fix locking description: after commit 8969a5ede0f9e17da4b9437
("generic-ipi: remove kmalloc()"), wait = 0 can be guaranteed
because we don't kmalloc() anymore.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Link: http://lkml.kernel.org/r/51F5E6F8.1000801@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/smp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index fe9f773..b1c9034 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -278,8 +278,6 @@ EXPORT_SYMBOL(smp_call_function_single);
  * @wait: If true, wait until function has completed.
  *
  * Returns 0 on success, else a negative status code (if no cpus were online).
- * Note that @wait will be implicitly turned on in case of allocation failures,
- * since we fall back to on-stack allocation.
  *
  * Selection preference:
  *	1) current cpu if in @mask
