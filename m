Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3GAJ0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:26:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57061 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3GAJ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:26:51 -0400
Date: Mon, 1 Jul 2013 18:26:47 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH v2] clocksource: sh_cmt: Use devm_* managed helpers
Message-ID: <20130701092644.GA14567@verge.net.au>
References: <1371558978-10870-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <CANqRtoQUadXd+RGbW3S1S4vxvz+iQJVoAVXY-JL-2G-DJTT6WQ@mail.gmail.com>
 <20130627073156.GA13927@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627073156.GA13927@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 04:31:57PM +0900, Simon Horman wrote:
> On Tue, Jun 18, 2013 at 10:29:38PM +0900, Magnus Damm wrote:
> > On Tue, Jun 18, 2013 at 9:36 PM, Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com> wrote:
> > > This simplifies the main error path by getting rid of it.
> > >
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > Looking good, thanks!
> > 
> > Acked-by: Magnus Damm <damm@opensource.se>
> 
> Thanks, queued up for v3.12 in the clocksource branch.

I have dropped this patch as it seems to cause the armadillo800eva
to fail to boot:


Booting Linux on physical CPU 0x0
Linux version 3.10.0-rc2-00001-g4903eae (horms@ayumi.isobedori.kobe.vergenet.net) (gcc version 4.4.5 (Debian 4.4.5-8) ) #7390 Mon Jul 1 18:11:53 JST 2013
CPU: ARMv7 Processor [412fc093] revision 3 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: armadillo800eva, model: armadillo 800 eva
debug: ignoring loglevel setting.
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 131072
free_area_init_node: node 0, pgdat c046854c, node_mem_map c0694000
  Normal zone: 1024 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 131072 pages, LIFO batch:31
CPU: All CPU(s) started in SVC mode.
bootconsole [early_ttySC1] enabled
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: console=tty0 console=ttySC1,115200 earlyprintk=sh-sci.1,115200 ignore_loglevel root=/dev/nfs ip=dhcp nfsroot=,rsize=4096,wsize=4096 rw
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 512MB = 512MB total
Memory: 515056k/515056k available, 9232k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xe0800000 - 0xff000000   ( 488 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc0414034   (4145 kB)
      .init : 0xc0415000 - 0xc0438578   ( 142 kB)
      .data : 0xc043a000 - 0xc0468d80   ( 188 kB)
       .bss : 0xc0468d80 - 0xc04924a0   ( 166 kB)
NR_IRQS:16 nr_irqs:16 16
GIC CPU mask not found - kernel will fail to boot.
GIC CPU mask not found - kernel will fail to boot.
sched_clock: 32 bits at 128 Hz, resolution 7812500ns, wraps every 3489660920ms
Console: colour dummy device 80x30
console [tty0] enabled
 sh_cmt.10: used for clock events
 sh_cmt.10: used for periodic clock events
 sh_cmt.10: used as clock source
Unable to handle kernel paging request at virtual address fffffffc
pgd = c0004000
[fffffffc] *pgd=5fffe821, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] ARM
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.10.0-rc2-00001-g4903eae #7390
task: c04441b8 ti: c043a000 task.ti: c043a000
PC is at strcmp+0x10/0x40
LR is at platform_match+0x84/0x90
pc : [<c0167a08>]    lr : [<c01bdcc0>]    psr: 60000153
sp : c043bf30  ip : c043bf40  fp : c043bf3c
r10: 00000000  r9 : 00000001  r8 : 00000000
r7 : de0030e0  r6 : de0030f0  r5 : c0462798  r4 : 00000000
r3 : 00000000  r2 : 0000002d  r1 : c03c0126  r0 : fffffffc
Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c53c7d  Table: 40004059  DAC: 00000015
Process swapper (pid: 0, stack limit = 0xc043a230)
Stack: (0xc043bf30 to 0xc043c000)
bf20:                                     c043bf5c c043bf40 c01bdcc0 c0167a04
bf40: de0030e0 c043716c c0436640 0000000b c043bfa4 c043bf60 c042687c c01bdc48
bf60: 412fc093 00000000 00000001 00000001 00000002 c03c004c 00000000 c03c004c
bf80: c0468d80 c0431bb4 7fffffff 40004059 412fc093 00000000 c043bfbc c043bfa8
bfa0: c041a7b0 c0426800 ffffffff c0468d80 c043bff4 c043bfc0 c0415834 c041a794
bfc0: ffffffff ffffffff c0415458 00000000 00000000 c0431bb4 10c53c7d c0442028
bfe0: c0431bb0 c0444f34 00000000 c043bff8 40008070 c041564c 00000000 00000000
Backtrace: 
[<c01679f8>] (strcmp+0x0/0x40) from [<c01bdcc0>] (platform_match+0x84/0x90)
[<c01bdc3c>] (platform_match+0x0/0x90) from [<c042687c>] (early_platform_driver_probe+0x88/0x254)
 r7:0000000b r6:c0436640 r5:c043716c r4:de0030e0
[<c04267f4>] (early_platform_driver_probe+0x0/0x254) from [<c041a7b0>] (shmobile_late_time_init+0x28/0x30)
[<c041a788>] (shmobile_late_time_init+0x0/0x30) from [<c0415834>] (start_kernel+0x1f4/0x284)
 r5:c0468d80 r4:ffffffff
[<c0415640>] (start_kernel+0x0/0x284) from [<40008070>] (0x40008070)
 r7:c0444f34 r6:c0431bb0 r5:c0442028 r4:10c53c7d
Code: e1a0c00d e92dd800 e24cb004 e3a03000 (e7d02003) 
---[ end trace 1b75b31a2719ed1c ]---
