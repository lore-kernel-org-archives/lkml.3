Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965492Ab3BNNvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:51:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934595Ab3BNNtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH 03/11] ARM: w90x900: fix legacy assembly syntax
Date: Thu, 14 Feb 2013 14:49:19 +0100
Message-Id: <1360849767-1463135-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8rnLeL5nWp1IARjF6XTfZX52bm/3pKMvwRBgbQi3lKH
 xL/yGapSP2xPV+N6kMT9coyttiw9SbAYYCVPkuZRr6RITRcsoh
 cuGBV/xyg2tYkHRyyt5AjBI+Bzcyoep10LLInHGDgXoHi+o/51
 iwZd8EDx1h/yx4rGPMr8+V3RX2+2D5PXJanVx6c2TRxnaUqhzN
 7x3JpRjz5fe9oU38/0Q4QGIBmnW0eB2eArqv8zjzOZ/gBEf5xa
 z6zlG0SPNt//9Q9kl3s7KvY0g3xOEEqx9SUpKxL/3FG+bQPShQ
 2m/9JpYyJqH5+fgI+gs/D77lgepBg8z4O+Aua0d+FtRUok3sfp
 cAwhHnBcDAYOWNA7zW/Du+Dqgls3rDDJXYheOeq5i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New ARM binutils don't allow extraneous whitespace inside
of brackets, which causes this error on all mach-w90x900
defconfigs:

arch/arm/kernel/entry-armv.S: Assembler messages:
arch/arm/kernel/entry-armv.S:214: Error: ARM register expected -- `ldr r0,[ r6,#(0x10C)]'
arch/arm/kernel/entry-armv.S:214: Error: ARM register expected -- `ldr r0,[ r6,#(0x110)]'
arch/arm/kernel/entry-armv.S:430: Error: ARM register expected -- `ldr r0,[ r6,#(0x10C)]'
arch/arm/kernel/entry-armv.S:430: Error: ARM register expected -- `ldr r0,[ r6,#(0x110)]'

This removes the whitespace in order to build the kernel
again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Wan ZongShun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/include/mach/entry-macro.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-w90x900/include/mach/entry-macro.S b/arch/arm/mach-w90x900/include/mach/entry-macro.S
index e286dac..0ff612a 100644
--- a/arch/arm/mach-w90x900/include/mach/entry-macro.S
+++ b/arch/arm/mach-w90x900/include/mach/entry-macro.S
@@ -19,8 +19,8 @@
 
 		mov	\base, #AIC_BA
 
-		ldr	\irqnr, [ \base, #AIC_IPER]
-		ldr	\irqnr, [ \base, #AIC_ISNR]
+		ldr	\irqnr, [\base, #AIC_IPER]
+		ldr	\irqnr, [\base, #AIC_ISNR]
 		cmp	\irqnr, #0
 
 	.endm
-- 
1.8.1.2

