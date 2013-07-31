Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3GaHF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:05:58 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60602 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3GaHF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:05:56 -0400
Date: Wed, 31 Jul 2013 16:05:52 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, koba@kmckk.co.jp, linux-sh@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: emev2: add PMU information to emev2.dtsi
Message-ID: <20130731070550.GA28921@verge.net.au>
References: <20130724034240.30596.52917.sendpatchset@w520>
 <20130731063900.GA5090@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731063900.GA5090@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 03:39:04PM +0900, Simon Horman wrote:
> On Wed, Jul 24, 2013 at 12:42:40PM +0900, Magnus Damm wrote:
> > From: Magnus Damm <damm@opensource.se>
> > 
> > Add PMU information to emev2.dtsi. With this
> > included KZM9D DT reference may use the PMU.
> 
> Thanks, I will queue this up for v3.12 in the dt2 branch.

When booting a debian armel userspace with this patch applied on top of
renesas-devel-20130731 I see the following.

I do not observe this problem with the sh73a0 or r8a7740 versions
of this patch applied, though I assume that in the case of the r8a7740
that is because it is UP.


Linux version 3.11.0-rc3-00001-g0f32f2a (horms@ayumi.isobedori.kobe.vergenet.net) (gcc version 4.7.2 (Debian 4.7.2-4) ) #244 SMP Wed Jul 31 15:54:40 JST 2013
CPU: ARMv7 Processor [411fc093] revision 3 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: kzm9d, model: EMEV2 KZM9D Board
debug: ignoring loglevel setting.
Memory policy: ECC disabled, Data cache writealloc
On node 0 totalpages: 32768
free_area_init_node: node 0, pgdat c02e6940, node_mem_map c030d000
  Normal zone: 256 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 32768 pages, LIFO batch:7
PERCPU: Embedded 5 pages/cpu @c0411000 s7616 r0 d12864 u32768
pcpu-alloc: s7616 r0 d12864 u32768 alloc=8*4096
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: console=ttyS1,115200n81 ignore_loglevel root=/dev/nfs ip=dhcp nfsroot=,rsize=4096,wsize=4096
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 126768K/131072K available (2258K kernel code, 116K rwdata, 416K rodata, 139K init, 151K bss, 4304K reserved)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc8800000 - 0xff000000   ( 872 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
      .text : 0xc0008000 - 0xc02a5b04   (2679 kB)
      .init : 0xc02a6000 - 0xc02c8dc0   ( 140 kB)
      .data : 0xc02ca000 - 0xc02e7160   ( 117 kB)
       .bss : 0xc02e7160 - 0xc030cdd8   ( 152 kB)
Hierarchical RCU implementation.
NR_IRQS:16 nr_irqs:16 16
sched_clock: 32 bits at 128 Hz, resolution 7812500ns, wraps every 3489660920ms
Console: colour dummy device 80x30
Calibrating delay loop (skipped) preset value.. 355.88 BogoMIPS (lpj=1387932)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Setting up static identity map for 0xc0223a80 - 0xc0223ad8
CPU1: Booted secondary processor
CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
Brought up 2 CPUs
SMP: Total of 2 processors activated (710.76 BogoMIPS).
CPU: All CPU(s) started in SVC mode.
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
hw-breakpoint: maximum watchpoint size is 4 bytes.
bio: create slab <bio-0> at 0
em_sti em_sti.0: used for clock events
em_sti em_sti.0: used for oneshot clock events
em_sti em_sti.0: used as clock source
Switched to clocksource em_sti.0
NET: Registered protocol family 2
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP: reno registered
UDP hash table entries: 256 (order: 1, 8192 bytes)
UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
CPU PMU: probing PMU on CPU 1
hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
msgmni has been set to 247
io scheduler noop registered (default)
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250-em.0: ttyS0 at MMIO 0xe1020000 (irq = 40) is a 16550A
serial8250-em.1: ttyS1 at MMIO 0xe1030000 (irq = 41) is a 16550A
console [ttyS1] enabled
serial8250-em.2: ttyS2 at MMIO 0xe1040000 (irq = 42) is a 16550A
serial8250-em.3: ttyS3 at MMIO 0xe1050000 (irq = 43) is a 16550A
smsc911x: Driver version 2008-10-21
smsc911x smsc911x (unregistered net_device): couldn't get clock -2
libphy: smsc911x-mdio: probed
smsc911x smsc911x eth0: attached PHY driver [Generic PHY] (mii_bus:phy_addr=smsc911x-fffffff:01, irq=-1)
smsc911x smsc911x eth0: MAC Address: 00:01:9b:04:03:cf
TCP: cubic registered
NET: Registered protocol family 17
VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 1
smsc911x smsc911x eth0: SMSC911x/921x identified at 0xc8880000, IRQ: 201
Sending DHCP requests ..., OK
IP-Config: Got DHCP answer from 10.3.5.146, my address is 10.3.5.154
IP-Config: Complete:
     device=eth0, hwaddr=00:01:9b:04:03:cf, ipaddr=10.3.5.154, mask=255.255.255.0, gw=10.3.5.254
     host=10.3.5.154, domain=isobedori.kobe.vergenet.net, nis-domain=(none)
     bootserver=10.3.5.146, rootserver=10.3.5.146, rootpath=/srv/nfs/kzm9d-armel
     nameserver0=10.3.4.254
VFS: Mounted root (nfs filesystem) readonly on device 0:9.
Freeing unused kernel memory: 136K (c02a6000 - c02c8000)
INIT: version 2.88 booting
Using makefile-style concurrent boot in runlevel S.
.udev/ already exists on the static /dev! ... (warning).
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...udevd-work[307]: error changing net interface name eth0 to eth1: Device or resource busy

done.
Waiting for /dev to be fully populated...done.
Activating swap...done.
Cleaning up ifupdown....
Setting up networking....
Activating lvm and md swap...done.
Checking file systems...fsck from util-linux-ng 2.17.2
done.
Mounting local filesystems...done.
Activating swapfile swap...done.
Cleaning up temporary files....
Configuring network interfaces...done.
Cleaning up temporary files....
Setting kernel variables ...done.
INIT: Entering runlevel: 2
Using makefile-style concurrent boot in runlevel 2.
Starting enhanced syslogd: rsyslogd.
Starting periodic command scheduler: cron.
Starting system message bus: dbus.
INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=2690 jiffies, g=4294967121, c=4294967120, q=8097)
Task dump for CPU 1:
swapper/1       R running      0     0      1 0x00000000
[<c0222364>] (__schedule+0x384/0x508) from [<c02e73b8>] (0xc02e73b8)
