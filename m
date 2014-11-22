Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaKVJvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 04:51:10 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46851 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaKVJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 04:51:08 -0500
Message-ID: <54705C8E.1080400@googlemail.com>
Date: Sat, 22 Nov 2014 09:51:10 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]: cross-compiling x86_64 kernel on i386 user-space fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit e6023367d779060fddc9a52d1f474085b2b36298 broke building an x86_64 kernel in an i386. The change added a call to
objdump but neglected to cater for cross-compiling.

The patch below fixes the problem for me. I see the commit is now in 3.14 and 3.17 -stable, so the patch needs to go
there too.

CC: Junjie Mao <eternal.n08@gmail.com>
CC: Kees Cook <keescook@chromium.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Chris Clayton <chris2553@googlemail.com>
---
--- linux/arch/x86/boot/compressed/Makefile~    2014-11-22 08:56:50.359706324 +0000
+++ linux/arch/x86/boot/compressed/Makefile     2014-11-22 09:04:06.615693435 +0000
@@ -76,7 +76,7 @@ suffix-$(CONFIG_KERNEL_XZ)    := xz
 suffix-$(CONFIG_KERNEL_LZO)    := lzo
 suffix-$(CONFIG_KERNEL_LZ4)    := lz4

-RUN_SIZE = $(shell objdump -h vmlinux | \
+RUN_SIZE = $(shell ${CROSS_COMPILE}objdump -h vmlinux | \
             perl $(srctree)/arch/x86/tools/calc_run_size.pl)
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )

