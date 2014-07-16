Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbaGPPv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:51:57 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:45338 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170AbaGPPvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:51:51 -0400
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <ralf@linux-mips.org>, <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <m.szyprowski@samsung.com>, <mina86@mina86.com>
CC: <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linux-arch@vger.kernel.org>
Subject: [PATCH 3/4] x86: use generic dma-contiguous.h
Date: Wed, 16 Jul 2014 16:51:31 +0100
Message-ID: <1405525892-60383-4-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma-contiguous.h is now in asm-generic. Use that to avoid code
repetition in x86.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
---
 arch/x86/include/asm/Kbuild           |  1 +
 arch/x86/include/asm/dma-contiguous.h | 12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)
 delete mode 100644 arch/x86/include/asm/dma-contiguous.h

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 3bf000f..d55a210 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -6,6 +6,7 @@ genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
 generic-y += cputime.h
+generic-y += dma-contiguous.h
 generic-y += early_ioremap.h
 generic-y += mcs_spinlock.h
 generic-y += scatterlist.h
diff --git a/arch/x86/include/asm/dma-contiguous.h b/arch/x86/include/asm/dma-contiguous.h
deleted file mode 100644
index b4b38ba..0000000
--- a/arch/x86/include/asm/dma-contiguous.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef ASMX86_DMA_CONTIGUOUS_H
-#define ASMX86_DMA_CONTIGUOUS_H
-
-#ifdef __KERNEL__
-
-#include <linux/types.h>
-
-static inline void
-dma_contiguous_early_fixup(phys_addr_t base, unsigned long size) { }
-
-#endif
-#endif
-- 
1.9.1

