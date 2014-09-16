Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaIPAtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:49:15 -0400
Received: from ozlabs.org ([103.22.144.67]:37799 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaIPAtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:49:14 -0400
Date: Tue, 16 Sep 2014 10:49:14 +1000
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
        torvalds@linux-foundation.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] powerpc: Use CONFIG_ARCH_HAS_FAST_MULTIPLIER
Message-ID: <20140916104914.66abcca1@kryten>
In-Reply-To: <20140916104749.35b84da8@kryten>
References: <20140916104749.35b84da8@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran some tests to compare hash_64 using shifts and multiplies.
The results:

POWER6:	~2x slower
POWER7: ~2x faster
POWER8: ~2x faster

Now we have a proper config option, select
CONFIG_ARCH_HAS_FAST_MULTIPLIER on POWER7 and POWER8.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/arch/powerpc/platforms/Kconfig.cputype
===================================================================
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -116,10 +116,12 @@ config POWER6_CPU
 config POWER7_CPU
 	bool "POWER7"
 	depends on PPC_BOOK3S_64
+	select ARCH_HAS_FAST_MULTIPLIER
 
 config POWER8_CPU
 	bool "POWER8"
 	depends on PPC_BOOK3S_64
+	select ARCH_HAS_FAST_MULTIPLIER
 
 config E5500_CPU
 	bool "Freescale e5500"
