Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaJEGDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 02:03:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55939 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaJEGDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 02:03:33 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH] cma: make default CMA area size zero for x86
Date: Sun,  5 Oct 2014 15:02:56 +0900
Message-Id: <1412488976-3885-1-git-send-email-akinobu.mita@gmail.com>
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
 drivers/base/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 4e7f0ff..92a5987e 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -240,6 +240,7 @@ comment "Default contiguous memory area size:"
 config CMA_SIZE_MBYTES
 	int "Size in Mega Bytes"
 	depends on !CMA_SIZE_SEL_PERCENTAGE
+	default 0 if X86
 	default 16
 	help
 	  Defines the size (in MiB) of the default memory area for Contiguous
@@ -248,6 +249,7 @@ config CMA_SIZE_MBYTES
 config CMA_SIZE_PERCENTAGE
 	int "Percentage of total memory"
 	depends on !CMA_SIZE_SEL_MBYTES
+	default 0 if X86
 	default 10
 	help
 	  Defines the size of the default memory area for Contiguous Memory
-- 
1.9.1

