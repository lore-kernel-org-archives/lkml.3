Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaKPWMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:12:43 -0500
Received: from 1wt.eu ([62.212.114.60]:47875 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbaKPWAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:35 -0500
Message-Id: <20141116215328.775714187@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:31 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 03/48] x86_32, entry: Clean up sysenter_badsys declaration
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 554086d85e "x86_32, entry: Do syscall exit work on badsys
(CVE-2014-4508)" introduced a new jump label (sysenter_badsys) but
somehow the END statements seem to have gone wrong (at least it
feels that way to me).
This does not seem to be a fatal problem, but just for the sake
of symmetry, change the second syscall_badsys to sysenter_badsys.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Link: http://lkml.kernel.org/r/1408093066-31021-1-git-send-email-stefan.bader@canonical.com
Acked-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
(cherry picked from commit fb21b84e7f809ef04b1e5aed5d463cf0d4866638)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/entry_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 3188ca4..8b5370c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -710,7 +710,7 @@ END(syscall_badsys)
 sysenter_badsys:
 	movl $-ENOSYS,%eax
 	jmp sysenter_after_call
-END(syscall_badsys)
+END(sysenter_badsys)
 	CFI_ENDPROC
 
 /*
-- 
1.7.12.2.21.g234cd45.dirty



