Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaGDGlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:41:01 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58760 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGDGk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:40:59 -0400
Message-ID: <53B64C5F.5090200@gmail.com>
Date: Fri, 04 Jul 2014 14:40:31 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        peterz@infradead.org, mingo@kernel.org, tim.c.chen@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, lauraa@codeaurora.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/include/asm/pci.h: Use generic 'pci.h' instead
 of the original one
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original 'pci.h' is empty, and some modules in allmodconfig may need
contents which can be found in generic 'pci.h', so use generic one
instead of original.

The related error (allmodconfig under score):

    CC [M]  drivers/scsi/scsi_lib.o
  drivers/scsi/scsi_lib.c: In function 'scsi_calculate_bounce_limit':
  drivers/scsi/scsi_lib.c:1615:7: error: 'PCI_DMA_BUS_IS_PHYS' undeclared (first use in this function)
    if (!PCI_DMA_BUS_IS_PHYS)
         ^
  drivers/scsi/scsi_lib.c:1615:7: note: each undeclared identifier is reported only once for each function it appears in
  make[2]: *** [drivers/scsi/scsi_lib.o] Error 1
  make[1]: *** [drivers/scsi] Error 2
  make: *** [drivers] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/include/asm/Kbuild | 1 +
 arch/score/include/asm/pci.h  | 4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)
 delete mode 100644 arch/score/include/asm/pci.h

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index aad2091..bfb31569 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -7,6 +7,7 @@ generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += hash.h
 generic-y += mcs_spinlock.h
+generic-y += pci.h
 generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += trace_clock.h
diff --git a/arch/score/include/asm/pci.h b/arch/score/include/asm/pci.h
deleted file mode 100644
index 3f3cfd8..0000000
--- a/arch/score/include/asm/pci.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef _ASM_SCORE_PCI_H
-#define _ASM_SCORE_PCI_H
-
-#endif /* _ASM_SCORE_PCI_H */
-- 
1.9.2.459.g68773ac
