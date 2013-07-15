Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3GOSwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:52:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49594 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab3GOSwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:52:10 -0400
Date: Mon, 15 Jul 2013 11:50:45 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Fenghua Yu <fenghua.yu@intel.com>, PaX Team <pageexec@gmail.com>
Subject: [PATCH stable] x86: make sure IDT is page aligned
Message-ID: <20130715185045.GA24133@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the IDT is referenced from a fixmap, make sure it is page aligned.
This avoids the risk of the IDT ever being moved in the bss and having
the mapping be offset, resulting in calling incorrect handlers. In the
current upstream kernel this is not a manifested bug, but heavily patched
kernels (such as those using the PaX patch series) did encounter this bug.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: PaX Team <pageexec@gmail.com>
---
Note: this is the minimal change for 3.10/stable and 3.11/stable only
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
