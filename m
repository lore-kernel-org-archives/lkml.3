Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaDVOYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:24:24 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:16542 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751165AbaDVOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:24:21 -0400
Date: Tue, 22 Apr 2014 07:24:20 -0700
From: Drew Richardson <drew.richardson@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Ben Greear <greearb@candelatech.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] Export irq tracepoints for use by kernel modules
Message-ID: <20140422142419.GD21121@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
Use struct pointer instead of name hash for reg/unreg tracepoints"),
any tracepoints used in a kernel module must be exported.

Signed-off-by: Drew Richardson <drew.richardson@arm.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
---
 kernel/softirq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b50990a5bea0..3a21a6c29406 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -30,6 +30,12 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(irq_handler_entry);
+EXPORT_TRACEPOINT_SYMBOL_GPL(irq_handler_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(softirq_entry);
+EXPORT_TRACEPOINT_SYMBOL_GPL(softirq_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(softirq_raise);
+
 /*
    - No shared variables, all the data are CPU local.
    - If a softirq needs serialization, let it serialize itself
-- 
1.8.3.2

