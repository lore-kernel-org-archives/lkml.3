Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaDCJK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:10:26 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53654 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbaDCJKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:10:22 -0400
Message-ID: <1396516220.31985.16.camel@x220>
Subject: [PATCH] MIPS: Loongson: No need to select
 GENERIC_HARDIRQS_NO__DO_IRQ
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2014 11:10:20 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2014 09:10:20.0627 (UTC) FILETIME=[89C79230:01CF4F1C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0e476d91244e ("MIPS: Loongson: Add Loongson-3 Kconfig options")
added "select GENERIC_HARDIRQS_NO__DO_IRQ". But the Kconfig symbol
GENERIC_HARDIRQS_NO__DO_IRQ was already removed in v2.6.38, so that
select is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep only.

 arch/mips/loongson/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
index 7397be2..603d79a 100644
--- a/arch/mips/loongson/Kconfig
+++ b/arch/mips/loongson/Kconfig
@@ -64,7 +64,6 @@ config LEMOTE_MACH3A
 	bool "Lemote Loongson 3A family machines"
 	select ARCH_SPARSEMEM_ENABLE
 	select GENERIC_ISA_DMA_SUPPORT_BROKEN
-	select GENERIC_HARDIRQS_NO__DO_IRQ
 	select BOOT_ELF32
 	select BOARD_SCACHE
 	select CSRC_R4K
-- 
1.9.0

