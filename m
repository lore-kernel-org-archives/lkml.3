Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaBZBHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:07:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaBZBHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:07:02 -0500
Date: Tue, 25 Feb 2014 17:06:46 -0800
From: tip-bot for Eugene Surovegin <tipbot@zytor.com>
Message-ID: <tip-b6085a865762236bb84934161273cdac6dd11c2d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, surovegin@google.com, hpa@zytor.com,
        mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, surovegin@google.com,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20140123173120.GA25474@www.outflux.net>
References: <20140123173120.GA25474@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, kaslr:
  export offset in VMCOREINFO ELF notes
Git-Commit-ID: b6085a865762236bb84934161273cdac6dd11c2d
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

Commit-ID:  b6085a865762236bb84934161273cdac6dd11c2d
Gitweb:     http://git.kernel.org/tip/b6085a865762236bb84934161273cdac6dd11c2d
Author:     Eugene Surovegin <surovegin@google.com>
AuthorDate: Thu, 23 Jan 2014 09:31:20 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Feb 2014 16:57:47 -0800

x86, kaslr: export offset in VMCOREINFO ELF notes

Include kASLR offset in VMCOREINFO ELF notes to assist in debugging.

[ hpa: pushing this for v3.14 to avoid having a kernel version with
  kASLR where we can't debug output. ]

Signed-off-by: Eugene Surovegin <surovegin@google.com>
Link: http://lkml.kernel.org/r/20140123173120.GA25474@www.outflux.net
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/machine_kexec_64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 4eabc16..679cef0 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -279,5 +279,7 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
+	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
+			      (unsigned long)&_text - __START_KERNEL);
 }
 
