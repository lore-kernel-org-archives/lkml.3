Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaB1ASe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:18:34 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41892 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaB1ASb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:18:31 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 1/4] x86: Use the default ABI for the 32-bit vDSO
Date: Thu, 27 Feb 2014 16:18:12 -0800
Message-Id: <2f5d45b67dcd2c4ba58ed7ff13cfcd7a4da977fa.1393545985.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1393545985.git.luto@amacapital.net>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
 <cover.1393545985.git.luto@amacapital.net>
In-Reply-To: <cover.1393545985.git.luto@amacapital.net>
References: <cover.1393545985.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason for the vDSO to use a special function call ABI.  Use
the platform defaults.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 92daaa6..80584f5 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -149,7 +149,7 @@ KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=3 -freg-struct-return -fpic
+KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
 $(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
-- 
1.8.5.3

