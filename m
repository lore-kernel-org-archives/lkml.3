Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3AYP2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:28:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54079 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3AYP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:28:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH 4/5] ARM: w90x900: fix legacy assembly syntax
Date: Fri, 25 Jan 2013 15:28:30 +0000
Message-Id: <1359127711-19070-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359127711-19070-1-git-send-email-arnd@arndb.de>
References: <1359127711-19070-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:q23OpUV3hQM1oXKVfq+okTjAT0uD6RJoPtzENRECe0W
 8C9lVBBuHVxPoyPURSKYK1mLnD9uNetv0DivR5vpumVdgYeErf
 IB0N1V8gAO9s8+w8jMtT0fm0gNYBqNoBfkHixfsiwRg1Rx/u/d
 VpgS1RddBRBlnIQ+MY+tpU1GFNhCCrO3ExU27vMUbHLY43OJsI
 h0xoOxt+FJsNWIUzlYOuYrZwQxIMO77BUzygMeUMM9S5RjtIK1
 3xRskxHzO8UaWGyiUduTnSZ+NtjHUlqWWqJVuODrP4Nu1XjKzy
 zIxjcSjE9EAXxxCItmSBg2bimhQ8LheHNWteJbfdbkZwzTuBKv
 NM89IIoKl6NhR85CYb00jI/BcUDNu4TLF3HlP3UVW
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
1.8.0

