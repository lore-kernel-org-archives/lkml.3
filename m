Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936835Ab3DIMd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:33:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15765 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935438Ab3DIMd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:33:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="37011008"
From: Christopher Covington <cov@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v2] arm64: Fix task tracing
Date: Tue,  9 Apr 2013 08:33:34 -0400
Message-Id: <1365510814-21343-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <20130408153132.GQ17476@mudshark.cambridge.arm.com>
References: <20130408153132.GQ17476@mudshark.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For accurate accounting pass contextidr_thread_switch the prev
task pointer, since cpu_switch_to has at that point changed the
the stack pointer.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm64/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 0337cdb..a49b25a 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -315,7 +315,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	/* the actual thread switch */
 	last = cpu_switch_to(prev, next);
 
-	contextidr_thread_switch(next);
+	contextidr_thread_switch(prev);
 	return last;
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

