Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965Ab3E2MW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:22:28 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35804 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860Ab3E2MW1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 29 May 2013 08:22:27 -0400
Message-Id: <51A60F1F02000078000D997C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 29 May 2013 13:22:23 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Marcelo Tosatti" <mtosatti@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: don't waste fixmap entries
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vsyscall related pvclock entries can only ever be used on x86-64,
and hence they shouldn't even get allocated for 32-bit kernels (the
more that it is there where address space is relatively precious).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>

---
 arch/x86/include/asm/fixmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.10-rc3/arch/x86/include/asm/fixmap.h
+++ 3.10-rc3-ix86-fixmap-no-pvclock/arch/x86/include/asm/fixmap.h
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



