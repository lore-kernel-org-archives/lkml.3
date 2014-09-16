Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbaIPArw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:47:52 -0400
Received: from ozlabs.org ([103.22.144.67]:57973 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbaIPAru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:47:50 -0400
Date: Tue, 16 Sep 2014 10:47:49 +1000
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
        torvalds@linux-foundation.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] powerpc: Add POWER8 CPU selection
Message-ID: <20140916104749.35b84da8@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the user to build a kernel targeted at POWER8
(ie gcc -mcpu=power8).

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/arch/powerpc/Makefile
===================================================================
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -135,6 +135,7 @@ CFLAGS-$(CONFIG_POWER4_CPU) += $(call cc
 CFLAGS-$(CONFIG_POWER5_CPU) += $(call cc-option,-mcpu=power5)
 CFLAGS-$(CONFIG_POWER6_CPU) += $(call cc-option,-mcpu=power6)
 CFLAGS-$(CONFIG_POWER7_CPU) += $(call cc-option,-mcpu=power7)
+CFLAGS-$(CONFIG_POWER8_CPU) += $(call cc-option,-mcpu=power8)
 
 # Altivec option not allowed with e500mc64 in GCC.
 ifeq ($(CONFIG_ALTIVEC),y)
Index: b/arch/powerpc/platforms/Kconfig.cputype
===================================================================
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -117,6 +117,10 @@ config POWER7_CPU
 	bool "POWER7"
 	depends on PPC_BOOK3S_64
 
+config POWER8_CPU
+	bool "POWER8"
+	depends on PPC_BOOK3S_64
+
 config E5500_CPU
 	bool "Freescale e5500"
 	depends on E500
