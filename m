Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbaIOWU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51313 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbaIOWUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Smith <alex@alex-smith.me.uk>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 116/187] MIPS: ptrace: Test correct task's flags in task_user_regset_view()
Date: Mon, 15 Sep 2014 15:08:46 -0700
Message-Id: <1410818997-9432-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Smith <alex@alex-smith.me.uk>

commit 65768a1a92cb12cbba87588927cf597a65d560aa upstream.

task_user_regset_view() should test for TIF_32BIT_REGS in the flags of
the specified task, not of the current task.

Signed-off-by: Alex Smith <alex@alex-smith.me.uk>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7450/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index f6e6709..2b32dd4 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -384,7 +384,7 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 #endif
 
 #ifdef CONFIG_MIPS32_O32
-		if (test_thread_flag(TIF_32BIT_REGS))
+		if (test_tsk_thread_flag(task, TIF_32BIT_REGS))
 			return &user_mips_view;
 #endif
 
-- 
1.9.1

