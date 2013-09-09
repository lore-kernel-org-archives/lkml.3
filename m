Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3IIJQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:16:22 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:58895 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3IIJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:16:17 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-mm@kvack.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] sched: Remove ARCH specific fpu_counter from task_struct
Date: Mon, 9 Sep 2013 14:45:23 +0530
Message-ID: <1378718123-7372-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378718123-7372-1-git-send-email-vgupta@synopsys.com>
References: <1378718123-7372-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fpu_counter in task_struct was used only by sh/x86.
Both of these now carry it in ARCH specific thread_struct, hence this
can now be removed from generic task_struct, shrinking it slightly for
other arches.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 078066d..b560364 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1051,15 +1051,6 @@ struct task_struct {
 	struct hlist_head preempt_notifiers;
 #endif
 
-	/*
-	 * fpu_counter contains the number of consecutive context switches
-	 * that the FPU is used. If this is over a threshold, the lazy fpu
-	 * saving becomes unlazy to save the trap. This is an unsigned char
-	 * so that after 256 times the counter wraps and the behavior turns
-	 * lazy again; this to deal with bursty apps that only use FPU for
-	 * a short time
-	 */
-	unsigned char fpu_counter;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
-- 
1.8.1.2

