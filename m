Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaJENyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 09:54:49 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59969 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaJENys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 09:54:48 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH v2] cma: make default CMA area size zero for x86
Date: Sun,  5 Oct 2014 22:54:20 +0900
Message-Id: <1412517260-3832-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes CMA memory area size zero for x86 in default configuration
(doesn't change on the other architectures).  If default CMA size is
zero, DMA_CMA is disabled.  It can be enabled by passing cma= to the
kernel.

This makes less impact on x86.  Because there is no mainline driver that
requires it for x86, and Peter Hurley reported the performance
regression, as this is trying to drive _all_ dma mapping allocations
through a _very_ small window.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Cc: iommu@lists.linux-foundation.org
---
* v2
- Add information in help text, suggested by Chuck Ebbert

 drivers/base/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 4e7f0ff..115882f 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -240,18 +240,24 @@ comment "Default contiguous memory area size:"
 config CMA_SIZE_MBYTES
 	int "Size in Mega Bytes"
 	depends on !CMA_SIZE_SEL_PERCENTAGE
+	default 0 if X86
 	default 16
 	help
 	  Defines the size (in MiB) of the default memory area for Contiguous
-	  Memory Allocator.
+	  Memory Allocator.  If the size of 0 is selected, CMA is disabled by
+	  default, but it can be enabled by passing cma=size[MG] to the kernel.
+
 
 config CMA_SIZE_PERCENTAGE
 	int "Percentage of total memory"
 	depends on !CMA_SIZE_SEL_MBYTES
+	default 0 if X86
 	default 10
 	help
 	  Defines the size of the default memory area for Contiguous Memory
 	  Allocator as a percentage of the total memory in the system.
+	  If 0 percent is selected, CMA is disabled by default, but it can be
+	  enabled by passing cma=size[MG] to the kernel.
 
 choice
 	prompt "Selected region size"
-- 
1.9.1

