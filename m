Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaHOI5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:57:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53332 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaHOI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:57:50 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, Roland McGrath <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: [PATCH] x86_32, entry: Clean up sysenter_badsys declaration
Date: Fri, 15 Aug 2014 10:57:46 +0200
Message-Id: <1408093066-31021-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 554086d85e "x86_32, entry: Do syscall exit work on badsys
(CVE-2014-4508)" introduced a new jump label (sysenter_badsys) but
somehow the END statements seem to have gone wrong (at least it
feels that way to me).
This does not seem to be a fatal problem, but just for the sake
of symmetry, change the second syscall_badsys to sysenter_badsys.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/kernel/entry_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 47c410d..4b0e1df 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -683,7 +683,7 @@ END(syscall_badsys)
 sysenter_badsys:
 	movl $-ENOSYS,%eax
 	jmp sysenter_after_call
-END(syscall_badsys)
+END(sysenter_badsys)
 	CFI_ENDPROC
 
 .macro FIXUP_ESPFIX_STACK
-- 
1.9.1

