Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3CDD4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:56:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33030 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756767Ab3CDDoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:20 -0500
Message-Id: <20130304033713.560293807@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
        Wan ZongShun <mcuos.com@gmail.com>
Subject: [ 060/153] ARM: w90x900: fix legacy assembly syntax
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit fa5ce5f94c0f2bfa41ba68d2d2524298e1fc405e upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-w90x900/include/mach/entry-macro.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-w90x900/include/mach/entry-macro.S
+++ b/arch/arm/mach-w90x900/include/mach/entry-macro.S
@@ -22,8 +22,8 @@
 
 		mov	\base, #AIC_BA
 
-		ldr	\irqnr, [ \base, #AIC_IPER]
-		ldr	\irqnr, [ \base, #AIC_ISNR]
+		ldr	\irqnr, [\base, #AIC_IPER]
+		ldr	\irqnr, [\base, #AIC_ISNR]
 		cmp	\irqnr, #0
 
 	.endm


