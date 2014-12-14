Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaLNUbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:31:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaLNUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Clayton <chris2553@googlemail.com>,
        Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>,
        Junjie Mao <eternal.n08@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.17 20/47] x86: Use $(OBJDUMP) instead of plain objdump
Date: Sun, 14 Dec 2014 12:20:55 -0800
Message-Id: <20141214201819.265645679@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


