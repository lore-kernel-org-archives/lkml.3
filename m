Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946Ab3DDADw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:03:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22864 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab3DDADV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:03:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="35558410"
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: Richard Kuo <rkuo@codeaurora.org>
Subject: [PATCH 3/6] Hexagon: use correct work mask when checking for more work
Date: Wed,  3 Apr 2013 19:02:53 -0500
Message-Id: <1365033776-21804-4-git-send-email-rkuo@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
References: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index dc72ed5..8e90b0c 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -215,7 +215,7 @@ int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
 
 int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 {
-	if (!(thread_info_flags & _TIF_ALLWORK_MASK)) {
+	if (!(thread_info_flags & _TIF_WORK_MASK)) {
 		return 0;
 	}  /* shortcut -- no work to be done */
 
-- 
1.7.9.5

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
