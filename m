Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030649AbaGRNLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:11:10 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17534 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030610AbaGRNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 042/170] powerpc: 64bit sendfile is capped at 2GB
Date: Fri, 18 Jul 2014 14:10:47 +0200
Message-Id: <c3043360563dc5e2c10ba688ea5338e0696015a1.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5d73320a96fcce80286f1447864c481b5f0b96fa upstream.

commit 8f9c0119d7ba (compat: fs: Generic compat_sys_sendfile
implementation) changed the PowerPC 64bit sendfile call from
sys_sendile64 to sys_sendfile.

Unfortunately this broke sendfile of lengths greater than 2G because
sys_sendfile caps at MAX_NON_LFS. Restore what we had previously which
fixes the bug.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/include/asm/systbl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 43523fe0d8b4..05fcdd826829 100644
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
2.0.0

