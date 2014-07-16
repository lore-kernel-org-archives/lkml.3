Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbaGPPwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:52:54 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:6092 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965166AbaGPPvv (ORCPT
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
Subject: [PATCH 2/4] arm64: use generic dma-contiguous.h
Date: Wed, 16 Jul 2014 16:51:30 +0100
Message-ID: <1405525892-60383-3-git-send-email-Zubair.Kakakhel@imgtec.com>
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
repetition in arm64.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
---
 arch/arm64/include/asm/Kbuild           |  1 +
 arch/arm64/include/asm/dma-contiguous.h | 28 ----------------------------
 2 files changed, 1 insertion(+), 28 deletions(-)
 delete mode 100644 arch/arm64/include/asm/dma-contiguous.h

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 0b3fcf8..92bf7cb 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -9,6 +9,7 @@ generic-y += current.h
 generic-y += delay.h
 generic-y += div64.h
 generic-y += dma.h
+generic-y += dma-contiguous.h
 generic-y += emergency-restart.h
 generic-y += early_ioremap.h
 generic-y += errno.h
diff --git a/arch/arm64/include/asm/dma-contiguous.h b/arch/arm64/include/asm/dma-contiguous.h
deleted file mode 100644
index 14c4c0c..0000000
--- a/arch/arm64/include/asm/dma-contiguous.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (c) 2013, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef _ASM_DMA_CONTIGUOUS_H
-#define _ASM_DMA_CONTIGUOUS_H
-
-#ifdef __KERNEL__
-#ifdef CONFIG_DMA_CMA
-
-#include <linux/types.h>
-
-static inline void
-dma_contiguous_early_fixup(phys_addr_t base, unsigned long size) { }
-
-#endif
-#endif
-
-#endif
-- 
1.9.1

