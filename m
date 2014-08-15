Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaHOVTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:19:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaHOVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:19:40 -0400
Date: Fri, 15 Aug 2014 14:19:15 -0700
From: tip-bot for Stefan Bader <tipbot@zytor.com>
Message-ID: <tip-fb21b84e7f809ef04b1e5aed5d463cf0d4866638@git.kernel.org>
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefan.bader@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@amacapital.net, tglx@linutronix.de, stefan.bader@canonical.com,
        hpa@linux.intel.com
In-Reply-To: <1408093066-31021-1-git-send-email-stefan.bader@canonical.com>
References: <1408093066-31021-1-git-send-email-stefan.bader@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86_32, entry:
  Clean up sysenter_badsys declaration
Git-Commit-ID: fb21b84e7f809ef04b1e5aed5d463cf0d4866638
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb21b84e7f809ef04b1e5aed5d463cf0d4866638
Gitweb:     http://git.kernel.org/tip/fb21b84e7f809ef04b1e5aed5d463cf0d4866638
Author:     Stefan Bader <stefan.bader@canonical.com>
AuthorDate: Fri, 15 Aug 2014 10:57:46 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 15 Aug 2014 13:45:32 -0700

x86_32, entry: Clean up sysenter_badsys declaration

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
