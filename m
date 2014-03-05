Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbaCEXfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:35:23 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49548 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaCEXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:35:21 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 18:35:21 EST
Date: Thu, 6 Mar 2014 10:29:27 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: linux-kernel <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: skip futex_atomic_cmpxchg_inatomic() test
In-Reply-To: <alpine.DEB.2.02.1403052254110.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.LNX.2.00.1403061006440.5525@nippy.intranet>
References: <alpine.LNX.2.00.1403041740580.17377@nippy.intranet> <CAMuHMdU-5dw9mzJTf-29FAo1NBOnUnqCDv9GPfYRTvuRCS+9Xw@mail.gmail.com> <alpine.DEB.2.02.1403052254110.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Skip the futex_atomic_cmpxchg_inatomic() test in futex_init(). It causes a 
fatal exception on 68030 (and presumably 68020 also).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Index: linux-m68k/arch/m68k/Kconfig
===================================================================
--- linux-m68k.orig/arch/m68k/Kconfig
+++ linux-m68k/arch/m68k/Kconfig
@@ -17,6 +17,7 @@ config M68K
 	select FPU if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select HAVE_FUTEX_CMPXCHG if MMU && FUTEX
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
