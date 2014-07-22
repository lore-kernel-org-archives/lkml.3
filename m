Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbaGVW0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:26:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494AbaGVW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 060/116] powerpc: 64bit sendfile is capped at 2GB
Date: Tue, 22 Jul 2014 15:21:11 -0700
Message-Id: <1406067727-19683-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 5d73320a96fcce80286f1447864c481b5f0b96fa upstream.

commit 8f9c0119d7ba (compat: fs: Generic compat_sys_sendfile
implementation) changed the PowerPC 64bit sendfile call from
sys_sendile64 to sys_sendfile.

Unfortunately this broke sendfile of lengths greater than 2G because
sys_sendfile caps at MAX_NON_LFS. Restore what we had previously which
fixes the bug.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ kamal: backport to 3.8: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/include/asm/systbl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 97909d3b..4ca7fca 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -189,7 +189,7 @@ SYSCALL_SPU(getcwd)
 SYSCALL_SPU(capget)
 SYSCALL_SPU(capset)
 COMPAT_SYS(sigaltstack)
-SYSX_SPU(sys_sendfile,compat_sys_sendfile_wrapper,sys_sendfile)
+SYSX_SPU(sys_sendfile64,compat_sys_sendfile,sys_sendfile)
 SYSCALL(ni_syscall)
 SYSCALL(ni_syscall)
 PPC_SYS(vfork)
-- 
1.9.1

