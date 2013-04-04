Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab3DDADX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:03:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4834 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab3DDADT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:03:19 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="35720039"
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: Richard Kuo <rkuo@codeaurora.org>
Subject: [PATCH 5/6] Hexagon: break up user fn/arg register setting
Date: Wed,  3 Apr 2013 19:02:55 -0500
Message-Id: <1365033776-21804-6-git-send-email-rkuo@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
References: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/kernel/process.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 8e90b0c..2009377 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -113,7 +113,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		/* r24 <- fn, r25 <- arg */
-		ss->r2524 = usp | ((u64)arg << 32);
+		ss->r24 = usp;
+		ss->r25 = arg;
 		pt_set_kmode(childregs);
 		return 0;
 	}
-- 
1.7.9.5

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
