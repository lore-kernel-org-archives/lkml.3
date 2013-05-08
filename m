Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3EHNaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:30:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:43631 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab3EHNaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:30:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/9] ARM: ux500: Fix incorrect DEBUG UART virtual addresses
Date: Wed,  8 May 2013 14:29:05 +0100
Message-Id: <1368019749-19455-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent move to rid header files which were hindering multiplatform
support forced address allocations out of the headers and into the
files which were using them. We also lost some useful macros such as
IO_ADDRESS(), so physical -> virtual addressing has been carried out
manually in this case. Unfortunately the incorrect value was converted.
This patch rectifies the error and ensures earlyprintk works again.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/include/debug/ux500.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/debug/ux500.S b/arch/arm/include/debug/ux500.S
index 2848857..fbd24be 100644
--- a/arch/arm/include/debug/ux500.S
+++ b/arch/arm/include/debug/ux500.S
@@ -24,9 +24,9 @@
 #define U8500_UART0_PHYS_BASE	(0x80120000)
 #define U8500_UART1_PHYS_BASE	(0x80121000)
 #define U8500_UART2_PHYS_BASE	(0x80007000)
-#define U8500_UART0_VIRT_BASE	(0xa8120000)
-#define U8500_UART1_VIRT_BASE	(0xa8121000)
-#define U8500_UART2_VIRT_BASE	(0xa8007000)
+#define U8500_UART0_VIRT_BASE	(0xf8120000)
+#define U8500_UART1_VIRT_BASE	(0xf8121000)
+#define U8500_UART2_VIRT_BASE	(0xf8007000)
 #define __UX500_PHYS_UART(n)	U8500_UART##n##_PHYS_BASE
 #define __UX500_VIRT_UART(n)	U8500_UART##n##_VIRT_BASE
 #endif
-- 
1.7.10.4

