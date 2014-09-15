Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaIOT1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:27:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbaIOT1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Smith <alex@alex-smith.me.uk>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.16 062/158] MIPS: ptrace: Test correct tasks flags in task_user_regset_view()
Date: Mon, 15 Sep 2014 12:25:01 -0700
Message-Id: <20140915192544.757856198@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Smith <alex@alex-smith.me.uk>

commit 65768a1a92cb12cbba87588927cf597a65d560aa upstream.

task_user_regset_view() should test for TIF_32BIT_REGS in the flags of
the specified task, not of the current task.

Signed-off-by: Alex Smith <alex@alex-smith.me.uk>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7450/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -398,7 +398,7 @@ const struct user_regset_view *task_user
 #endif
 
 #ifdef CONFIG_MIPS32_O32
-		if (test_thread_flag(TIF_32BIT_REGS))
+		if (test_tsk_thread_flag(task, TIF_32BIT_REGS))
 			return &user_mips_view;
 #endif
 


