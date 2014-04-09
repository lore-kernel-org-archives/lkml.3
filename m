Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbaDIVZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:25:17 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36199 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaDIVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:25:14 -0400
Message-ID: <5345BAB7.5090108@converseincode.com>
Date: Wed, 09 Apr 2014 14:25:11 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Compiling the Linux Kernel with Clang/LLVM 
	<llvmlinux@lists.linuxfoundation.org>
Subject: [GIT PULL] LLVMLinux patches for v3.15
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

These are some initial updates to support compiling the kernel with clang.
These patches have been through the proper reviews to the best of my 
ability,
and have been soaking in linux-next for a few weeks. These patches by
themselves still do not completely allow clang to be used with the 
kernel code,
but lay the foundation for other patches which are still under review.

Several other of the LLVMLinux patches have been already added via 
Maintainer
trees.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com



The following changes since commit 39de65aa2c3eee901db020a4f1396998e09602a3:

   Merge branch 'i2c/for-next' of 
git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux (2014-04-09 
08:45:40 -0700)

are available in the git repository at:


   git://git.linuxfoundation.org/llvmlinux/kernel.git 
tags/llvmlinux-for-v3.15

for you to fetch changes up to c4586256f0c440bc2bdb29d2cbb915f0ca785d26:

   x86: LLVMLinux: Fix "incomplete type const struct x86cpu_device_id" 
(2014-04-09 13:44:35 -0700)

----------------------------------------------------------------
LLVMLinux Patches for v3.15

----------------------------------------------------------------
Behan Webster (4):
       kbuild: LLVMLinux: Add Kbuild support for building kernel with Clang
       LLVMLinux: Remove warning about returning an uninitialized variable
       x86, acpi: LLVMLinux: Remove nested functions from Thinkpad ACPI
       x86: LLVMLinux: Fix "incomplete type const struct x86cpu_device_id"

Jan-Simon Möller (4):
       kbuild: LLVMLinux: Adapt warnings for compilation with clang
       Documentation: LLVMLinux: Update Documentation/dontdiff
       kbuild: LLVMLinux: Fix LINUX_COMPILER definition script for 
compilation with clang
       x86 kbuild: LLVMLinux: More cc-options added for clang

Mark Charlebois (1):
       LLVMLinux: Add support for clang to compiler.h and new 
compiler-clang.h

  Documentation/dontdiff               |  3 ++
  Makefile                             | 30 ++++++++++++-
  arch/x86/Makefile                    |  2 +-
  drivers/platform/x86/thinkpad_acpi.c | 86 
+++++++++++++++++++-----------------
  include/asm-generic/cmpxchg-local.h  |  3 +-
  include/linux/compiler-clang.h       | 12 +++++
  include/linux/compiler.h             |  7 +++
  include/linux/mod_devicetable.h      |  5 +++
  scripts/Makefile.build               | 12 ++++-
  scripts/mkcompile_h                  |  2 +-
  10 files changed, 116 insertions(+), 46 deletions(-)
  create mode 100644 include/linux/compiler-clang.h

