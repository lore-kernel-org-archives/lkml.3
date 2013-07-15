Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3GOTgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:36:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46399 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3GOTgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:36:17 -0400
From: Peter Wu <lekensteyn@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: OOT build fails on x86_64 due to missing asm/unisd_64.h
Date: Mon, 15 Jul 2013 21:36:12 +0200
Message-ID: <8992619.mp1cFCuObR@al>
User-Agent: KMail/4.10.5 (Linux/3.10.0-1-custom; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I tried to build v3.11-rc1-8-g47188d3 out-of-tree, I get an error about a
missing asm/unistd_64.h file. The full build output (`git clean -xfd` was ran
before baking the kernel):

/home/me/Linux-src/build$ make O=$PWD -C ../linux -j8
make: Entering directory `/home/me/Linux-src/linux'
/home/me/Linux-src/linux/arch/x86/Makefile:107: CONFIG_X86_X32 enabled but no binutils support
make[2]: Nothing to be done for `all'.
  GEN     /tmp/build/Makefile
  CHK     include/generated/uapi/linux/version.h
make[2]: Nothing to be done for `relocs'.
  Using /home/me/Linux-src/linux as source for kernel
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from /home/me/Linux-src/linux/include/uapi/linux/unistd.h:7:0,
                 from /home/me/Linux-src/linux/arch/x86/include/asm/seccomp_64.h:4,
                 from /home/me/Linux-src/linux/arch/x86/include/asm/seccomp.h:4,
                 from /home/me/Linux-src/linux/include/linux/seccomp.h:9,
                 from /home/me/Linux-src/linux/include/linux/sched.h:39,
                 from /home/me/Linux-src/linux/arch/x86/kernel/asm-offsets.c:9:
/home/me/Linux-src/linux/arch/x86/include/asm/unistd.h:23:29: fatal error: asm/unistd_64.h: No such file or directory
compilation terminated.
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [sub-make] Error 2
make: Leaving directory `/home/me/Linux-src/linux'



As a workaround, I rsync the files that are placed in the source tree:

~/Linux-src/linux/arch/x86/include/generated$ rsync -av . /tmp/build/arch/x86/include/generated/
sending incremental file list
./
asm/
asm/syscalls_32.h
uapi/
uapi/asm/
uapi/asm/unistd_32.h
uapi/asm/unistd_64.h                                                                                                                                                                                                             
uapi/asm/unistd_x32.h


I have encountered this error some releases back, and some others reported
this before[1]. If you need more details (.config?), please ask.

Regards,
Peter


 [1]: http://lkml.org/lkml/2012/3/19/680
