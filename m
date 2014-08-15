Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaHOMnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:43:55 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:48279 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaHOMnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:43:53 -0400
Date: Fri, 15 Aug 2014 15:42:47 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
In-Reply-To: <20140813.124611.767426770013677.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1408151534480.27263@math.ut.ee>
References: <alpine.SOC.1.00.1407310101550.2065@math.ut.ee> <20140730.150722.861254999466992321.davem@davemloft.net> <alpine.SOC.1.00.1408131327250.18696@math.ut.ee> <20140813.124611.767426770013677.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Did not test current git more.
> 
> Current git fails to boot without this fix which I posted the other
> day:

T2000 is OK with todays GIT, hugepages gcc 4.9.1.

V100 and Netra X1 now loop indefinitely on successful reboot in PROM 
recursive fault (3.16 had the fault once and continued).

Got this from one reboot of X1:
[info] Using makefile-style concurrent boot in runlevel 6.
[....] Stopping deferred execution scheduler: atd. ok
[....] Stopping MTA: exim4_listener. ok
[....] Asking all remaining processes to terminate...done.
[....] All processes ended within 4 seconds...done.
[  565.689832] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [rsyslogd:1715]
[  565.788276] Modules linked in: ipv6 loop ohci_pci ohci_hcd i2c_ali15x3 usbcore i2c_ali1535 i2ccorn
[  565.922072] CPU: 0 PID: 1715 Comm: rsyslogd Not tainted 3.16.0-10959-gf0094b2 #130
[  566.021635] task: ffffff006c772f00 ti: ffffff006c6b0000 task.ti: ffffff006c6b0000
[  566.120035] TSTATE: 0000004411001606 TPC: 00000000007895f0 TNPC: 00000000007895f4 Y: 00000000    d
[  566.249317] TPC: <put_compound_page.part.22+0x154/0x1c0>
[  566.319098] g0: 00000000004209d0 g1: 0000000000000000 g2: 0000000000000002 g3: 00000000004b0840
[  566.433415] g4: ffffff006c772f00 g5: 0000000000000008 g6: ffffff006c6b0000 g7: 0000000000000000
[  566.547817] o0: 0000000000000001 o1: 0000010000d5f818 o2: 00000000f77c2000 o3: 0000000000000001
[  566.662217] o4: ffffff006c6b3a98 o5: ffffff006c6b39dc sp: ffffff006c6b3131 ret_pc: 000000000078950
[  566.781197] RPC: <put_compound_page.part.22+0x134/0x1c0>
[  566.850994] l0: 00000000f77c2000 l1: fffffffe00000000 l2: 0000000200000000 l3: 00000000f77c1fff
[  566.965312] l4: 0000000000000000 l5: 0000000000000001 l6: 0000000000000000 l7: 0000000000000008
[  567.079714] i0: 0000010000d5f800 i1: 00000000f77c2000 i2: 0000000000000001 i3: 0000000000000000
[  567.194116] i4: 0000010000d5001c i5: 0000010000d50000 i6: ffffff006c6b31e1 i7: 000000000049aaa4
[  567.308527] I7: <get_futex_key+0x1c4/0x280>
[  567.363456] Call Trace:
[  567.395464]  [000000000049aaa4] get_futex_key+0x1c4/0x280
[  567.466332]  [000000000049ad7c] futex_wait_setup+0x1c/0xc0
[  567.538443]  [000000000049af14] futex_wait+0xf4/0x1c0
[  567.604738]  [000000000049c878] do_futex+0x138/0x240
[  567.669990]  [000000000049ce48] compat_SyS_futex+0x128/0x180
[  567.744394]  [0000000000406074] linux_sparc_syscall32+0x34/0x60

Otherwise V100 and X1 seems to survive looping git cloen well with 
transparent hugepages on and gcc 4.6.4.

U10 not tested yet so no test to CPI ROm changes yet (need to get to the 
machine). Similar for U5 and RED state exceptions on reboot.

V210 has a new problem - hans on boot during SCSI detection:
[   34.523440] f00aba6c: ttyS0 at MMIO 0x7fe010003f8 (irq = 15, base_baud = 115387) is a 16550A
[   34.523467] Console: ttyS0 (SU)
[   43.731627] console [ttyS0] enabled
[   43.777688] f00ad5ec: ttyS1 at MMIO 0x7fe010002e8 (irq = 15, base_baud = 115387) is a 16550A
[   43.889462] PCI: Enabling device: (0002:00:02.0), cmd 147
[   43.960956] sym0: <1010-66> rev 0x1 at pci 0002:00:02.0 irq 24
[   44.039849] sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
[   44.158317] sym0: SCSI BUS has been reset.
[   44.212124] scsi host0: sym-2.2.3

Retested with todays git, same.


I also solved my mysterious hangs of V100 - it was a simple user error 
with serial console and Break dropping me to OBP when the other end of 
the serial connection was rebooted with minicom open.

U1, U2, U5, U10, E220R, E420R later or some other day, whenever I get 
to them physically.

-- 
Meelis Roos (mroos@linux.ee)
