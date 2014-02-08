Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaBHQTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:19:25 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58244 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaBHQTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:19:02 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 11/11] smp: Enhance and precise the role & requirements of __smp_call_function_single()
Date: Sat,  8 Feb 2014 17:18:40 +0100
Message-Id: <1391876320-25068-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be more specific on the description of __smp_call_function_single().
It's actually not that much about just being able to embed a csd
in an object.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/smp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index b767631..24cb936 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -238,13 +238,20 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 EXPORT_SYMBOL(smp_call_function_single);
 
 /**
- * __smp_call_function_single(): Run a function on a specific CPU
+ * __smp_call_function_single(): Run an asynchronous function on a
+ * 			         specific CPU.
  * @cpu: The CPU to run on.
  * @csd: Pre-allocated and setup data structure
  *
- * Like smp_call_function_single(), but allow caller to pass in a
- * pre-allocated data structure. Useful for embedding @data inside
- * other structures, for instance.
+ * Like smp_call_function_single(), but the call is asynchonous and
+ * can thus be done from contexts with disabled interrupts.
+ *
+ * The caller passes his own pre-allocated data structure
+ * (ie: embedded in an object) and is responsible for synchronizing it
+ * such that the IPIs performed on the @csd are strictly serialized.
+ *
+ * NOTE: Be careful, there is unfortunately no current debugging facility to
+ * validate the correctness of this serialization.
  */
 int __smp_call_function_single(int cpu, struct call_single_data *csd)
 {
-- 
1.8.3.1

