Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaLCMAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:00:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbaLCL1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/101] xtensa: re-wire umount syscall to sys_oldumount
Date: Wed,  3 Dec 2014 12:25:49 +0100
Message-Id: <89e4b77675e4124a46ab3ee24da0558ee2639167.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2651cc6974d47fc43bef1cd8cd26966e4f5ba306 upstream.

Userspace actually passes single parameter (path name) to the umount
syscall, so new umount just fails. Fix it by requesting old umount
syscall implementation and re-wiring umount to it.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/xtensa/include/uapi/asm/unistd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/include/uapi/asm/unistd.h b/arch/xtensa/include/uapi/asm/unistd.h
index 51940fec6990..513effd48060 100644
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
2.1.3

