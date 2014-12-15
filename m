Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaLOOjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:39:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38880 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaLOO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Clayton <chris2553@googlemail.com>,
        Junjie Mao <eternal.n08@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 131/168] x86: Use $(OBJDUMP) instead of plain objdump
Date: Mon, 15 Dec 2014 14:26:25 +0000
Message-Id: <1418653622-21105-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Clayton <chris2553@googlemail.com>

commit e2e68ae688b0a3766cd75aedf4ed4e39be402009 upstream.

commit e6023367d779 'x86, kaslr: Prevent .bss from overlaping initrd'
broke the cross compile of x86. It added a objdump invocation, which
invokes the host native objdump and ignores an active cross tool
chain.

Use $(OBJDUMP) instead which takes the CROSS_COMPILE prefix into
account.

[ tglx: Massage changelog and use $(OBJDUMP) ]

Fixes: e6023367d779 'x86, kaslr: Prevent .bss from overlaping initrd'
Signed-off-by: Chris Clayton <chris2553@googlemail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Junjie Mao <eternal.n08@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/54705C8E.1080400@googlemail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/boot/compressed/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 14fe7cba21d1..b5bb49866bcc 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -75,7 +75,7 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
-RUN_SIZE = $(shell objdump -h vmlinux | \
+RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
 	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
-- 
2.1.3

