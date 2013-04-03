Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762942Ab3DCSBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:01:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25744 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759491Ab3DCSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:01:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,402,1363158000"; 
   d="scan'208";a="35467822"
From: Christopher Covington <cov@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH] arm64: Fix task tracing
Date: Wed,  3 Apr 2013 14:01:01 -0400
Message-Id: <1365012061-31660-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For accurate accounting call contextidr_thread_switch before a
task is scheduled, rather than after.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm64/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 0337cdb..c2cc249 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -311,11 +311,11 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	fpsimd_thread_switch(next);
 	tls_thread_switch(next);
 	hw_breakpoint_thread_switch(next);
+	contextidr_thread_switch(next);
 
 	/* the actual thread switch */
 	last = cpu_switch_to(prev, next);
 
-	contextidr_thread_switch(next);
 	return last;
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

