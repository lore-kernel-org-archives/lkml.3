Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbaGOWXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:23:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbaGOVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:32:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 098/198] powerpc: 64bit sendfile is capped at 2GB
Date: Tue, 15 Jul 2014 14:29:28 -0700
Message-Id: <1405459868-15089-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/include/asm/systbl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 43523fe..05fcdd8 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -190,7 +190,7 @@ SYSCALL_SPU(getcwd)
 SYSCALL_SPU(capget)
 SYSCALL_SPU(capset)
 COMPAT_SYS(sigaltstack)
-COMPAT_SYS_SPU(sendfile)
+SYSX_SPU(sys_sendfile64,compat_sys_sendfile,sys_sendfile)
 SYSCALL(ni_syscall)
 SYSCALL(ni_syscall)
 PPC_SYS(vfork)
-- 
1.9.1

