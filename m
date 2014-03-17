Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaCQWav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:30:51 -0400
Received: from www84.your-server.de ([213.133.104.84]:39352 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaCQWau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:30:50 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        "H. Peter Anvin" <hpa@linux.intel.com>, stefani@seibold.net
Subject: [PATCH v23 12/13] x86, vdso32: Disable stack protector, adjust optimizations
Date: Mon, 17 Mar 2014 23:22:12 +0100
Message-Id: <1395094933-14252-13-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395094933-14252-1-git-send-email-stefani@seibold.net>
References: <1395094933-14252-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

For the 32-bit VDSO, match the 64-bit VDSO in:

1. Disable the stack protector.
2. Use -fno-omit-frame-pointer for user space debugging sanity.
3. Use -foptimize-sibling-calls like the 64-bit VDSO does.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 6cef7a1..55e76eb 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -151,6 +151,9 @@ KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
+KBUILD_CFLAGS_32 += $(call cc-option, -fno-stack-protector) 
+KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
+KBUILD_CFLAGS_32 += -fno-omit-frame-pointer
 $(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
-- 
1.9.0

