Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaIXDoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 23:44:55 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40135 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaIXDox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 23:44:53 -0400
From: Behan Webster <behanw@converseincode.com>
To: linux@arm.linux.org.uk, linux@prisktech.co.nz
Cc: behanw@converseincode.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm, vt8500, LLVMLlinux: Use mcr instead of mcr% for mach-vt8500
Date: Tue, 23 Sep 2014 20:44:44 -0700
Message-Id: <1411530284-28807-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ASM below does not compile with clang and is not the way that the mcr
command is used in other parts of the kernel.

arch/arm/mach-vt8500/vt8500.c:72:11: error: invalid % escape in inline assembly string
        asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
            ~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.

There are other forms that are supported on different ARM instruction sets but
generally the kernel just uses mcr as it is supported in all ARM instruction
sets.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/mach-vt8500/vt8500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index 2da7be3..3bc0dc9 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -69,7 +69,7 @@ static void vt8500_power_off(void)
 {
 	local_irq_disable();
 	writew(5, pmc_base + VT8500_HCR_REG);
-	asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
+	asm("mcr p15, 0, %0, c7, c0, 4" : : "r" (0));
 }
 
 static void __init vt8500_init(void)
-- 
1.9.1

