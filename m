Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaIKJxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:53:06 -0400
Received: from setup.z80.it ([83.103.80.66]:44235 "EHLO setup.z80.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbaIKJxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:53:02 -0400
X-Greylist: delayed 841 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 05:53:01 EDT
From: AndreaML <andreaml@z80.it>
Reply-To: andreaml@z80.it
Organization: z80.it
To: linux-kernel@vger.kernel.org
Subject: IRQ problem with the AACRAID driver with debian wheezy kernel 3.2.60-1+deb7u3 x86_64
Date: Thu, 11 Sep 2014 11:38:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409111138.58874.andreaml@z80.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm writing here after a very long time spent trying to debug a problem i have
in an host i use for backup pourposes. My google-fu haven't helped in this case.
This problem is there *at least* from the start of the year (i don't remember 
when it started)

This is a pc I assembled in a 19" rack case and put in my small server farm 
to be connected to the tape libraries and to be used as a backup server 
with rsync and bacula

This server is equipped with an adaptec 2100S storage raid controller with
4 sata disks for storage and 2 sata disks directly connected to the motherboard 
in a md mirror configuration for the system to reside on. I plan to attach a 
second 2100S i have around to get more disk space.

The os i have installed is debian wheezy completely updated as of today, with
kernel version "Linux frodo 3.2.0-4-amd64 #1 SMP Debian 3.2.60-1+deb7u3 x86_64 GNU/Linux"

The problem i have is that at least one time every day the kernel complains that it 
receives an interrupt #18 with corresponds to the 2100S storage controller that wasn't 
serviced by a driver.... as it stands and confirmed by lspci -nnvv this is attached to 
aacraid (see below).

The problem is that when the kernel complains about irq #18, my system become 
sloooowww... to the point that even a sync on the command line becomes unresponsive 
and i need to recurse to the magic systreq trick (echo b > /proc/sysrc_trigger) 
or the physical reset button to regain access to the system.

and i'm really really out of ideas on how to resolve this. can you folks 
give me some hints?

and yes, i have tried the irqpoll option as suggested in kernel msg with no results.

following is the data i have, in compact form.

-- Andrea --


The motherboard bios and the 2100S bios are at the latest image available
from the manufacturers.

The kernel complains in this manner:
Sep 10 22:01:11 frodo kernel: [215125.931642] irq 18: nobody cared (try booting with the "irqpoll" option)
Sep 10 22:01:11 frodo kernel: [215125.931703] Pid: 0, comm: swapper/0 Not tainted 3.2.0-4-amd64 #1 Debian 3.2.60-1+deb7u3
Sep 10 22:01:11 frodo kernel: [215125.931706] Call Trace:
Sep 10 22:01:11 frodo kernel: [215125.931708]  <IRQ>  [<ffffffff81092bdd>] ? __report_bad_irq+0x2c/0xb5
Sep 10 22:01:11 frodo kernel: [215125.931720]  [<ffffffff81092f9a>] ? note_interrupt+0x170/0x1f2
Sep 10 22:01:11 frodo kernel: [215125.931725]  [<ffffffff8109135c>] ? handle_irq_event_percpu+0x15f/0x17d
Sep 10 22:01:11 frodo kernel: [215125.931729]  [<ffffffff810913ae>] ? handle_irq_event+0x34/0x52
Sep 10 22:01:11 frodo kernel: [215125.931734]  [<ffffffff8106c1ad>] ? arch_local_irq_save+0x11/0x17
Sep 10 22:01:11 frodo kernel: [215125.931738]  [<ffffffff81093711>] ? handle_fasteoi_irq+0x7c/0xaf
Sep 10 22:01:11 frodo kernel: [215125.931744]  [<ffffffff8100f9e1>] ? handle_irq+0x1d/0x21
Sep 10 22:01:11 frodo kernel: [215125.931748]  [<ffffffff8100f5ba>] ? do_IRQ+0x42/0x98
Sep 10 22:01:11 frodo kernel: [215125.931753]  [<ffffffff8135072e>] ? common_interrupt+0x6e/0x6e
Sep 10 22:01:11 frodo kernel: [215125.931755]  <EOI>  [<ffffffff81066875>] ? ktime_get+0x50/0x86
Sep 10 22:01:11 frodo kernel: [215125.931763]  [<ffffffff811ef371>] ? intel_idle+0xea/0x119
Sep 10 22:01:11 frodo kernel: [215125.931767]  [<ffffffff811ef350>] ? intel_idle+0xc9/0x119
Sep 10 22:01:11 frodo kernel: [215125.931771]  [<ffffffff8127112d>] ? cpuidle_idle_call+0xec/0x179
Sep 10 22:01:11 frodo kernel: [215125.931775]  [<ffffffff8100d242>] ? cpu_idle+0xa5/0xf2
Sep 10 22:01:11 frodo kernel: [215125.931780]  [<ffffffff816abb36>] ? start_kernel+0x3b8/0x3c3
Sep 10 22:01:11 frodo kernel: [215125.931785]  [<ffffffff816ab140>] ? early_idt_handlers+0x140/0x140
Sep 10 22:01:11 frodo kernel: [215125.931789]  [<ffffffff816ab3c4>] ? x86_64_start_kernel+0x104/0x111
Sep 10 22:01:11 frodo kernel: [215125.931792] handlers:
Sep 10 22:01:11 frodo kernel: [215125.931824] [<ffffffffa013689c>] aac_rx_intr_message
Sep 10 22:01:11 frodo kernel: [215125.931864] Disabling IRQ #18

and after a while (obviously)
Sep 11 00:44:13 frodo kernel: [224892.536925] INFO: task rsync:7383 blocked for more than 120 seconds.
Sep 11 00:44:13 frodo kernel: [224892.536971] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 11 00:44:13 frodo kernel: [224892.537023] rsync           D ffff88011ed93780     0  7383   7363 0x00000000
Sep 11 00:44:13 frodo kernel: [224892.537028]  ffff8801169150c0 0000000000000082 ffffffff00000000 ffff880119f55100
Sep 11 00:44:13 frodo kernel: [224892.537033]  0000000000013780 ffff88002d907fd8 ffff88002d907fd8 ffff8801169150c0
Sep 11 00:44:13 frodo kernel: [224892.537038]  ffff88002d907c74 0000000100000004 ffffffff8135049f ffff88010dca2210
Sep 11 00:44:13 frodo kernel: [224892.537042] Call Trace:
Sep 11 00:44:13 frodo kernel: [224892.537050]  [<ffffffff8135049f>] ? _raw_spin_unlock_irqrestore+0xe/0xf
Sep 11 00:44:13 frodo kernel: [224892.537055]  [<ffffffff8134fa44>] ? __mutex_lock_common.isra.5+0xff/0x164
Sep 11 00:44:13 frodo kernel: [224892.537059]  [<ffffffff8134f932>] ? mutex_lock+0x1a/0x2d
Sep 11 00:44:13 frodo kernel: [224892.537063]  [<ffffffff81103868>] ? walk_component+0x1f4/0x406
Sep 11 00:44:13 frodo kernel: [224892.537069]  [<ffffffff810b6949>] ? generic_file_aio_read+0x570/0x5cf
Sep 11 00:44:13 frodo kernel: [224892.537072]  [<ffffffff81104721>] ? path_lookupat+0x7c/0x2bd
Sep 11 00:44:13 frodo kernel: [224892.537076]  [<ffffffff81036628>] ? should_resched+0x5/0x23
Sep 11 00:44:13 frodo kernel: [224892.537079]  [<ffffffff8134f144>] ? _cond_resched+0x7/0x1c
Sep 11 00:44:13 frodo kernel: [224892.537083]  [<ffffffff8110497e>] ? do_path_lookup+0x1c/0x87
Sep 11 00:44:13 frodo kernel: [224892.537087]  [<ffffffff81106407>] ? user_path_at_empty+0x47/0x7b
Sep 11 00:44:13 frodo kernel: [224892.537091]  [<ffffffff810fa820>] ? do_sync_read+0xb4/0xec
Sep 11 00:44:13 frodo kernel: [224892.537095]  [<ffffffff810958f2>] ? force_quiescent_state+0x19/0x178
Sep 11 00:44:13 frodo kernel: [224892.537098]  [<ffffffff810fe45a>] ? vfs_fstatat+0x32/0x60
Sep 11 00:44:13 frodo kernel: [224892.537101]  [<ffffffff810fbc8a>] ? fput+0x17a/0x1a1
Sep 11 00:44:13 frodo kernel: [224892.537104]  [<ffffffff810fe5bb>] ? sys_newlstat+0x12/0x2b
Sep 11 00:44:13 frodo kernel: [224892.537107]  [<ffffffff81110b07>] ? mntput_no_expire+0x1e/0xc9
Sep 11 00:44:13 frodo kernel: [224892.537111]  [<ffffffff810f9934>] ? filp_close+0x62/0x6a
Sep 11 00:44:13 frodo kernel: [224892.537114]  [<ffffffff810f99ca>] ? sys_close+0x8e/0xcb
Sep 11 00:44:13 frodo kernel: [224892.537117]  [<ffffffff81355452>] ? system_call_fastpath+0x16/0x1b

--- kernel driver version
root@frodo:~# cat /sys/bus/pci/drivers/aacraid/module/version
1.1-7[28000]-ms

--- excerpt from hwinfo
       str1: "ASUSTeK COMPUTER INC."
       str2: "P8H61"
       str2: "Intel"
       str3: "Intel(R) Core(TM) i3-2100T CPU @ 2.50GHz"

--- excerpt from lspci -nnvv
05:02.0 RAID bus controller [0104]: Adaptec AAC-RAID [9005:0285] (rev 01)
        Subsystem: Adaptec AAR-2410SA PCI SATA 4ch (Jaguar II) [9005:0290]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (250ns min, 250ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=64M]
        Expansion ROM at f7d30000 [disabled] [size=32K]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: aacraid



