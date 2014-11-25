Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaKYLRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:17:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58751 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbaKYKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 149/254] xtensa: re-wire umount syscall to sys_oldumount
Date: Tue, 25 Nov 2014 10:38:19 +0000
Message-Id: <1416912004-5928-150-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 2651cc6974d47fc43bef1cd8cd26966e4f5ba306 upstream.

Userspace actually passes single parameter (path name) to the umount
syscall, so new umount just fails. Fix it by requesting old umount
syscall implementation and re-wiring umount to it.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/xtensa/include/uapi/asm/unistd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/include/uapi/asm/unistd.h b/arch/xtensa/include/uapi/asm/unistd.h
index b9395529f02d..50084f7c01c8 100644
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
2.1.0

