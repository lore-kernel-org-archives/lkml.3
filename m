Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3AURRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:17:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49184 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3AURRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH 04/15] ARM: w90x900: fix legacy assembly syntax
Date: Mon, 21 Jan 2013 17:15:57 +0000
Message-Id: <1358788568-11137-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hO+thD9h9WsqkZTu1CoT0ucmFr7140/A0RelCY5eAGu
 qiMxrjhP4mRziHkgHjkyYJurZd1DEYQkqlc/vPNaR+6Y+GN/uw
 kzSBL3k5Jxl0FKS/1TXiM7VECgB6EJMqpbVkN8wVpjirpcXAwW
 51qLClS8c8eAKBJWUrzbMhYlBrwc/+ETd5zs5/J/johHudujbp
 /qpZLhS/NGrnXwQzX7nAy9L6XE9c9ddqyt28iELt5NH+UCgDov
 +UFtsJG06A3ZhdYEZiEOjo+t0VfYeYpmHVxCm9EsddXNO+Sge+
 7V65269kYEnkX3bsORrkJooaGzGI5VOqcZY956fviDxIVBaYtV
 jfY1HqJw7omg1+nOOSXzo36D9SGjb7rAD2rE2KbeU
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
 arch/arm/mach-w90x900/include/mach/entry-macro.S |    4 ++--
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
1.7.10.4

