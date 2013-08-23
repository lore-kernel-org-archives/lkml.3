Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab3HWTuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:50:40 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:43259 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755196Ab3HWTuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:50:37 -0400
X-Greylist: delayed 3604 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 15:50:37 EDT
From: "werner" <w.landgraf@ru.ru>
Subject: 3.11-rc6 many problems,  wil6210 , snd-pcsp , ibmphp
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 23 Aug 2013 14:50:30 -0400
Message-ID: <web-25718928@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With compiling and using this, have too much problems



/   In wil6210  some problem with call arguments ; that 
messes the whole compilation of the kernel because gives 
an error condition

/  ibmphpd :    something run-time-wrong

/   in the second compilation stage, plenty modules or 
something else can't be found

/  The snd-pcsp  module don't work.    It don't load even 
with option snd-pcsp index=1 , it gives a message that the 
device is
ocupied.   Typing in   beep  , it's beeping, so I suppose 
my computer has a beeper.   Perhaps any default speaker 
module occupies
the speaker ?   It should be programmed correctly in the 
pcsp module, that loading it it desocupy the speaker. 
   The beeper
programming specialist should check this module, I tried 
it for several kernel versions and computers, it never 
works.
That facility is important because persons in poorer 
places have old computers without sound cards.

Of the first 3 problems, see below









======


cc1: warnings being treated as errors
drivers/net/wireless/ath/wil6210/txrx.c: In function 
'wil_vring_free':
drivers/net/wireless/ath/wil6210/txrx.c:147: warning: 
passing argument 3 of 'dma_free_attrs' discards qualifiers 
from pointer target type
make[5]: [drivers/net/wireless/ath/wil6210/txrx.o] Error 1 
(ignored)
====

ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at 
drivers/pci/hotplug/ibmphp_ebda.c:282 
ibmphp_access_ebda+0x7c9/0xcc0()
ibmphp_ebda: next read is beyond ebda_sz
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
3.11.0-rc6-i486-1sys #1
Hardware name: IBM 633972G/633972G, BIOS 21KT27AUS 
08/05/2002
  0000011a c2e0d469 cf847e4c c0e49b72 cf847e54 c0e49c3b 
cf847e84 c01977ae
  c2a882e4 cf847eb0 00000001 c2a88310 0000011a c2e0d469 
c2a88310 000003fc
  00000001 000903fe cf847e9c c0197928 00000009 cf847e94 
c2a882e4 cf847eb0
Call Trace:
  [<c2e0d469>] ? ibmphp_access_ebda+0x7c9/0xcc0
  [<c0e49b72>] __dump_stack+0x32/0x50
  [<c0e49c3b>] dump_stack+0xab/0x120
  [<c01977ae>] warn_slowpath_common+0xce/0x120
  [<c2e0d469>] ? ibmphp_access_ebda+0x7c9/0xcc0
  [<c0197928>] warn_slowpath_fmt+0x58/0x80
  [<c2e0d469>] ibmphp_access_ebda+0x7c9/0xcc0
  [<c0330330>] ? kmem_cache_alloc+0x160/0x260
  [<c2e0a430>] ? init_ops+0x980/0x980
  [<c2e0a598>] ibmphp_init+0x168/0x380
  [<c0100644>] do_one_initcall+0xf4/0x1a0
  [<c01cd8f2>] ? parse_one+0x122/0x1c0
  [<c01ce051>] ? parse_args+0x131/0x320
  [<c2da4ac0>] ? do_basic_setup+0xa0/0xa0
  [<c2da485c>] do_initcall_level+0x9c/0xd0
  [<c2da4ac0>] ? do_basic_setup+0xa0/0xa0
  [<c2da48d8>] do_initcalls+0x48/0x70
  [<c2da4aaa>] do_basic_setup+0x8a/0xa0
  [<c2da5232>] kernel_init_freeable+0x162/0x2a0
  [<c24c8d69>] kernel_init+0x19/0x240
  [<c24e7afb>] ret_from_kernel_thread+0x1b/0x30
  [<c24c8d50>] ? _GLOBAL__I_0_reciprocal_value+0x10/0x10
---[ end trace 5ba509cd4d822291 ]---
========


   CC      arch/x86/crypto/crc32c-intel.mod.o
   LD [M]  arch/x86/crypto/crc32c-intel.ko
   CC      arch/x86/crypto/salsa20-i586.mod.o
   LD [M]  arch/x86/crypto/salsa20-i586.ko
   CC      arch/x86/kvm/kvm-amd.mod.o
   LD [M]  arch/x86/kvm/kvm-amd.ko
   CC      arch/x86/kvm/kvm-intel.mod.o
   LD [M]  arch/x86/kvm/kvm-intel.ko
   CC      arch/x86/kvm/kvm.mod.o
   LD [M]  arch/x86/kvm/kvm.ko
   CC      crypto/ansi_cprng.mod.o
gcc: crypto/ansi_cprng.mod.c: No such file or directory
gcc: no input files
make[1]: [crypto/ansi_cprng.mod.o] Error 1 (ignored)
   LD [M]  crypto/ansi_cprng.ko
ld: crypto/ansi_cprng.mod.o: No such file: No such file or 
directory
make[1]: [crypto/ansi_cprng.ko] Error 1 (ignored)
   CC      crypto/ccm.mod.o
gcc: crypto/ccm.mod.c: No such file or directory
gcc: no input files
make[1]: [crypto/ccm.mod.o] Error 1 (ignored)
   LD [M]  crypto/ccm.ko
ld: crypto/ccm.mod.o: No such file: No such file or 
directory
make[1]: [crypto/ccm.ko] Error 1 (ignored)
   CC      crypto/cryptd.mod.o
gcc: crypto/cryptd.mod.c: No such file or directory
gcc: no input files
make[1]: [crypto/cryptd.mod.o] Error 1 (ignored)
   LD [M]  crypto/cryptd.ko
ld: crypto/cryptd.mod.o: No such file: No such file or 
directory
make[1]: [crypto/cryptd.ko] Error 1 (ignored)
   CC      crypto/ctr.mod.o
gcc: crypto/ctr.mod.c: No such file or directory
gcc: no input files
make[1]: [crypto/ctr.mod.o] Error 1 (ignored)
   LD [M]  crypto/ctr.ko
ld: crypto/ctr.mod.o: No such file: No such file or 
directory
make[1]: [crypto/ctr.ko] Error 1 (ignored)
   CC      crypto/cts.mod.o
gcc: crypto/cts.mod.c: No such file or directory
gcc: no input files
make[1]: [crypto/cts.mod.o] Error 1 (ignored)
   LD [M]  crypto/cts.ko
ld: crypto/cts.mod.o: No such file: No such file or 
directory
make[1]: [crypto/cts.ko] Error 1 (ignored)
   CC      crypto/gcm.mod.o
gcc: crypto/gcm.mod.c: No such file or directory
gcc: no input files
make[1]: [crypto/gcm.mod.o] Error 1 (ignored)
   LD [M]  crypto/gcm.ko
ld: crypto/gcm.mod.o: No such file: No such file or 
directory
make[1]: [crypto/gcm.ko] Error 1 (ignored)
   CC      crypto/ghash-generic.mod.o
gcc: crypto/ghash-generic.mod.c: No such file or directory
gcc: no input files
make[1]: [crypto/ghash-generic.mod.o] Error 1 (ignored)

   ::: and so on
   
---
Professional hosting for everyone - http://www.host.ru
