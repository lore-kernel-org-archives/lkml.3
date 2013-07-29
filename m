Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3G2DyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 23:54:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:31248 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3G2DyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 23:54:10 -0400
Message-ID: <51F5E6F8.1000801@huawei.com>
Date: Mon, 29 Jul 2013 11:52:24 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sheng Yang <sheng@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jens Axboe <jens.axboe@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] generic-ipi: Fix misleading smp_call_function_any() description
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit:8969a5ede0f9e17da4b943712429aef2c9bcd82b
"generic-ipi: remove kmalloc()", wait = 0 can be guaranteed.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
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
-- 
1.8.2.1


