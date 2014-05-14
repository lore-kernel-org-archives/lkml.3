Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaENIML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:12:11 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:57545 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbaENIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:12:09 -0400
Message-ID: <1400055127.31197.1.camel@x220>
Subject: [PATCH] ARM: remove check for CONFIG_DEBUG_LL_SER3
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 10:12:07 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2014 08:12:07.0996 (UTC) FILETIME=[32F21FC0:01CF6F4C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_DEBUG_LL_SER3 was added in v2.5.43. But the related
symbol DEBUG_LL_SER3 was already removed in v2.5.8. This check has
always evaluated to false. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/boot/compressed/head.S | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 066b03480b63..c16e8bf31e0b 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -54,11 +54,7 @@
 #if defined(CONFIG_ARCH_SA1100)
 		.macro	loadsp, rb, tmp
 		mov	\rb, #0x80000000	@ physical base address
-#ifdef CONFIG_DEBUG_LL_SER3
-		add	\rb, \rb, #0x00050000	@ Ser3
-#else
 		add	\rb, \rb, #0x00010000	@ Ser1
-#endif
 		.endm
 #elif defined(CONFIG_ARCH_S3C24XX)
 		.macro loadsp, rb, tmp
-- 
1.9.0

