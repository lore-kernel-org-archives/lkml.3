Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaLVTl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:41:57 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:42819 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaLVTlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:41:55 -0500
Message-ID: <1419277314.8696.9.camel@haakon3.risingtidesystems.com>
Subject: Re: Linux 3.19-rc1 - merge window closed
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>
Date: Mon, 22 Dec 2014 11:41:54 -0800
In-Reply-To: <20141221121122.GA16310@roeck-us.net>
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
	 <1419145899.8696.5.camel@haakon3.risingtidesystems.com>
	 <20141221121122.GA16310@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-21 at 04:11 -0800, Guenter Roeck wrote:
> On Sat, Dec 20, 2014 at 11:11:39PM -0800, Nicholas A. Bellinger wrote:
> > Hi Linus,
> > 
> > On Sat, 2014-12-20 at 17:43 -0800, Linus Torvalds wrote:
> > > So it's been a day less than two weeks, and the merge window is closed.
> > > 
> ... 
> > 
> > Just hit the following build failure with CONFIG_AUDIT=y:
> > 
> > arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
> > arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
> > arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
> > make[2]: *** [arch/x86/ia32/audit.o] Error 1
> > make[1]: *** [arch/x86/ia32] Error 2
> > make: *** [arch/x86] Error 2
> > make: *** Waiting for unfinished jobs....
> > 
> 
> I tried your configuration. For some reason it builds for me, so I guess
> I must be missing something. What is your build command line ?
> 

Nothing fancy or out of the ordinary:

root@scsi-mq:/usr/src/target-pending.git# time make -j 4
scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
<stdin>:1226:2: warning: #warning syscall finit_module not implemented [-Wcpp]
<stdin>:1229:2: warning: #warning syscall sched_setattr not implemented [-Wcpp]
<stdin>:1232:2: warning: #warning syscall sched_getattr not implemented [-Wcpp]
<stdin>:1235:2: warning: #warning syscall renameat2 not implemented [-Wcpp]
<stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcpp]
<stdin>:1241:2: warning: #warning syscall getrandom not implemented [-Wcpp]
<stdin>:1244:2: warning: #warning syscall memfd_create not implemented [-Wcpp]
<stdin>:1247:2: warning: #warning syscall bpf not implemented [-Wcpp]
<stdin>:1250:2: warning: #warning syscall execveat not implemented [-Wcpp]
  CC      init/main.o
  AS [M]  arch/x86/crypto/aes-x86_64-asm_64.o
  AS      arch/x86/ia32/ia32entry.o
  CC [M]  arch/x86/crypto/crc32c-intel_glue.o
  CC      arch/x86/ia32/sys_ia32.o
  CC      kernel/fork.o
  LD [M]  arch/x86/crypto/aes-x86_64.o
  LD [M]  arch/x86/crypto/crc32c-intel.o
  CC      arch/x86/ia32/ia32_signal.o
  CHK     include/generated/compile.h
  CC      init/do_mounts.o
  CC      arch/x86/kernel/process_64.o
  CC      arch/x86/ia32/syscall_ia32.o
  CC      arch/x86/ia32/audit.o
arch/x86/ia32/audit.c: In function ‘ia32_classify_syscall’:
arch/x86/ia32/audit.c:38:7: error: ‘__NR_execveat’ undeclared (first use in this function)
arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [arch/x86/ia32/audit.o] Error 1
make[1]: *** [arch/x86/ia32] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC      arch/x86/kernel/signal.o
  AS      arch/x86/kernel/entry_64.o
  CC      arch/x86/kernel/traps.o
  CC      init/do_mounts_initrd.o
  CC      kernel/exec_domain.o
^Cmake[1]: *** [init/do_mounts_initrd.o] Interrupt
make: *** [init] Interrupt
make[2]: *** [arch/x86/kernel/process_64.o] Interrupt
make[2]: *** [arch/x86/kernel/traps.o] Interrupt
make[1]: *** [kernel/exec_domain.o] Interrupt
make[1]: *** [arch/x86/kernel] Interrupt
make: *** [kernel] Interrupt
make: *** [arch/x86] Interrupt

