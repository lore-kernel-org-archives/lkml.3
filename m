Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbbA1EgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:36:22 -0500
Received: from mail.kernel.org ([198.145.29.136]:40968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934540AbbA1EZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:11 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 145/177] xtensa: re-wire umount syscall to sys_oldumount
Date: Wed, 28 Jan 2015 12:10:03 +0800
Message-Id: <1422418236-12852-236-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 2651cc6974d47fc43bef1cd8cd26966e4f5ba306 upstream.

Userspace actually passes single parameter (path name) to the umount
syscall, so new umount just fails. Fix it by requesting old umount
syscall implementation and re-wiring umount to it.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
[lizf: Backported to 3.4: adjust filename]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/xtensa/include/asm/unistd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index 798ee6d..7ab1f52 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -394,7 +394,8 @@ __SYSCALL(174, sys_chroot, 1)
 #define __NR_pivot_root 			175
 __SYSCALL(175, sys_pivot_root, 2)
 #define __NR_umount 				176
-__SYSCALL(176, sys_umount, 2)
+__SYSCALL(176, sys_oldumount, 1)
+#define __ARCH_WANT_SYS_OLDUMOUNT
 #define __NR_swapoff 				177
 __SYSCALL(177, sys_swapoff, 1)
 #define __NR_sync 				178
-- 
1.9.1

