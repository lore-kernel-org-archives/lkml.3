Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaAVX4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:56:39 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56041 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbaAVX4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:56:38 -0500
Date: Wed, 22 Jan 2014 15:56:15 -0800
From: Kees Cook <keescook@chromium.org>
To: crash-utility@redhat.com
Cc: linux-kernel@vger.kernel.org, Dave Anderson <anderson@redhat.com>,
        Andrew Honig <ahonig@google.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, kaslr: export offset in VMCOREINFO ELF notes
Message-ID: <20140122235615.GA21632@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include kASLR offset in VMCOREINFO ELF notes to assist in debugging.

Signed-off-by: Eugene Surovegin <surovegin@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/machine_kexec_64.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 4eabc160696f..679cef0791cd 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -279,5 +279,7 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_SYMBOL(node_data);
 	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
 #endif
+	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
+			      (unsigned long)&_text - __START_KERNEL);
 }
 
-- 
1.7.9.5

-- 
Kees Cook
Chrome OS Security
