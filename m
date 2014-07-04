Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbaGDW5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:57:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378AbaGDWRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:17:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 45/66] powerpc: 64bit sendfile is capped at 2GB
Date: Fri,  4 Jul 2014 15:14:44 -0700
Message-Id: <20140704221424.860936698@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/systbl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


