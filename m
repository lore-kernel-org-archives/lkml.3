Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab3KUFd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:33:58 -0500
Received: from ozlabs.org ([203.10.76.45]:36579 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3KUFd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:33:56 -0500
Date: Thu, 21 Nov 2013 16:33:55 +1100
From: Anton Blanchard <anton@samba.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org,
        fengguang.wu@intel.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        imunsie@au1.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: allyesconfig should not select
 CONFIG_CPU_LITTLE_ENDIAN
Message-ID: <20131121163355.7b7d42a5@kryten>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen reported a failure in an allyesconfig build.  
CONFIG_CPU_LITTLE_ENDIAN=y gets set but his toolchain is not
new enough to support little endian. We really want to
default to a big endian build; Ben suggested using a choice
which defaults to CPU_BIG_ENDIAN.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/arch/powerpc/platforms/Kconfig.cputype
===================================================================
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -404,13 +404,27 @@ config PPC_DOORBELL
 
 endmenu
 
-config CPU_LITTLE_ENDIAN
-	bool "Build little endian kernel"
-	default n
+choice
+	prompt "Endianness selection"
+	default CPU_BIG_ENDIAN
 	help
 	  This option selects whether a big endian or little endian kernel will
 	  be built.
 
+config CPU_BIG_ENDIAN
+	bool "Build big endian kernel"
+	help
+	  Build a big endian kernel.
+
+	  If unsure, select this option.
+
+config CPU_LITTLE_ENDIAN
+	bool "Build little endian kernel"
+	help
+	  Build a little endian kernel.
+
 	  Note that if cross compiling a little endian kernel,
 	  CROSS_COMPILE must point to a toolchain capable of targeting
 	  little endian powerpc.
+
+endchoice
