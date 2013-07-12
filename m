Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965306Ab3GLSmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:42:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38410 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933171Ab3GLSmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:42:31 -0400
Date: Fri, 12 Jul 2013 11:42:13 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Fenghua Yu <fenghua.yu@intel.com>, PaX Team <pageexec@freemail.hu>
Subject: [PATCH v2] x86: make sure IDT is page aligned
Message-ID: <20130712184213.GA22604@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the IDT is referenced from a fixmap, make sure it is page aligned.
(32-bit already was, this is only needed on 64-bit.) This avoids the
risk of it ever being moved in the bss and having the mapping be offset,
resulting in calling incorrect handlers.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: PaX Team <pageexec@freemail.hu>
Cc: stable@vger.kernel.org
---
v2:
 - 32-bit was already aligned, noted by PaX Team
---
 arch/x86/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5e4d8a8..77e6d3e 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -513,7 +513,7 @@ ENTRY(phys_base)
 #include "../../x86/xen/xen-head.S"
 	
 	.section .bss, "aw", @nobits
-	.align L1_CACHE_BYTES
+	.align PAGE_SIZE
 ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
