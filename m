Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797AbaLBT0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46989 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765AbaLBT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 046/121] xtensa: re-wire umount syscall to sys_oldumount
Date: Tue,  2 Dec 2014 11:18:45 -0800
Message-Id: <1417548000-1794-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 2651cc6974d47fc43bef1cd8cd26966e4f5ba306 upstream.

Userspace actually passes single parameter (path name) to the umount
syscall, so new umount just fails. Fix it by requesting old umount
syscall implementation and re-wiring umount to it.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/xtensa/include/uapi/asm/unistd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/include/uapi/asm/unistd.h b/arch/xtensa/include/uapi/asm/unistd.h
index 51940fe..513effd 100644
--- a/arch/xtensa/include/uapi/asm/unistd.h
+++ b/arch/xtensa/include/uapi/asm/unistd.h
@@ -384,7 +384,8 @@ __SYSCALL(174, sys_chroot, 1)
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

