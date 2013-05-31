Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3EaMsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:48:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3EaMrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:47:52 -0400
Date: Fri, 31 May 2013 05:47:38 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-cbdce7b251de89deef79ec9e37b6cfa7d5595894@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mtosatti@redhat.com, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, mtosatti@redhat.com,
        tglx@linutronix.de
In-Reply-To: <51A60F1F02000078000D997C@nat28.tlf.novell.com>
References: <51A60F1F02000078000D997C@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] ix86: Don't waste fixmap entries
Git-Commit-ID: cbdce7b251de89deef79ec9e37b6cfa7d5595894
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

Commit-ID:  cbdce7b251de89deef79ec9e37b6cfa7d5595894
Gitweb:     http://git.kernel.org/tip/cbdce7b251de89deef79ec9e37b6cfa7d5595894
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 29 May 2013 13:22:23 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 31 May 2013 13:08:18 +0200

ix86: Don't waste fixmap entries

The vsyscall related pvclock entries can only ever be used on
x86-64, and hence they shouldn't even get allocated for 32-bit
kernels (the more that it is there where address space is
relatively precious).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Link: http://lkml.kernel.org/r/51A60F1F02000078000D997C@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/fixmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 0dc7d9e..e846225 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -81,11 +81,11 @@ enum fixed_addresses {
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VVAR_PAGE,
 	VSYSCALL_HPET,
-#endif
 #ifdef CONFIG_PARAVIRT_CLOCK
 	PVCLOCK_FIXMAP_BEGIN,
 	PVCLOCK_FIXMAP_END = PVCLOCK_FIXMAP_BEGIN+PVCLOCK_VSYSCALL_NR_PAGES-1,
 #endif
+#endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
