Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3FPVGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 17:06:08 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:43991 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3FPVGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 17:06:06 -0400
Date: Mon, 17 Jun 2013 00:06:00 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
Message-ID: <alpine.SOC.1.00.1306162346340.23595@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this in 3.10-rc6 whil testing debian unstable upgrade with aptitude. 
3.10-rc5 did not exhibit this (nor any other kernel recently tried, 
including most -rc's). Does not seem to be reproducible.

[  568.834221] ------------[ cut here ]------------
[  568.894907] WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
[  568.971594] Modules linked in: ipv6 tg3 ptp pps_core hwmon
[  569.043635] CPU: 1 PID: 2952 Comm: aptitude Not tainted 3.10.0-rc6 #85
[  569.129412] Call Trace:
[  569.161440]  [00000000004d811c] exit_mmap+0x13c/0x160
[  569.227785]  [000000000045680c] mmput.part.62+0xc/0xc0
[  569.295258]  [000000000045c25c] exit_mm+0x11c/0x180
[  569.359301]  [000000000045dc24] do_exit+0x244/0x340
[  569.423354]  [000000000045dea8] do_group_exit+0x28/0xc0
[  569.491982]  [0000000000469a08] get_signal_to_deliver+0x1c8/0x3a0
[  569.572039]  [0000000000447874] do_signal32+0x14/0x220
[  569.639526]  [000000000042c8e0] do_signal+0x2c0/0x520
[  569.705854]  [000000000042d340] do_notify_resume+0x40/0x60
[  569.777907]  [0000000000404b04] __handle_signal+0xc/0x2c
[  569.847671] ---[ end trace 4acf84f71c8b5f1b ]---
[  569.908406] BUG: Bad rss-counter state mm:fffff8000dcb6700 idx:1 val:1

Full dmesg:

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.30.4.a 2010/01/06 14:48'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.10.0-rc6 (mroos@v210) (gcc version 4.6.4 (Debian 4.6.4-2) ) #85 SMP Sun Jun 16 16:02:21 EEST 2013
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 00:03:ba:0a:f3:85
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /pci@1e,600000/isa@7/serial@0,3f8
[    0.000000] PROM: Built device tree with 77761 bytes of memory.
[    0.000000] Top of RAM: 0x10000000, Total RAM: 0x10000000
[    0.000000] Memory hole size: 0MB
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0x0fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0x0fffffff]
[    0.000000] On node 0 totalpages: 32768
[    0.000000]   Normal zone: 256 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 32768 pages, LIFO batch:7
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,ultra3,mul32,div32]
[    0.000000] CPU CAPS: [v8plus,vis,vis2]
[    0.000000] PERCPU: Embedded 6 pages/cpu @fffff8000f000000 s13440 r8192 d27520 u2097152
[    0.000000] pcpu-alloc: s13440 r8192 d27520 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
[    0.000000] Kernel command line: root=/dev/sda2 ro mem=256M debug ignore_loglevel
[    0.000000] PID hash table entries: 1024 (order: 0, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 131072 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 253216k available (3248k kernel code, 1032k data, 152k init) [fffff80000000000,0000000010000000]
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:255
[    0.000000] clocksource: mult[53555555] shift[24]
[    0.000000] clockevent: mult[3126e98] shift[32]
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[   33.851595] Calibrating delay using timer specific routine.. 24.00 BogoMIPS (lpj=120048)
[   33.851610] pid_max: default: 32768 minimum: 301
[   33.851772] Mount-cache hash table entries: 512
[   33.854162] CPU 0: synchronized TICK with master CPU (last diff 0 cycles, maxerr 6 cycles)
[   33.854242] Brought up 2 CPUs
[   33.854269] Testing NMI watchdog ... OK.
[   34.055163] NET: Registered protocol family 16
[   34.063864] /pci@1f,700000: TOMATILLO PCI Bus Module ver[4:0]
[   34.063883] /pci@1f,700000: PCI IO[7f601000000] MEM[7f700000000]
[   34.065866] PCI: Scanning PBM /pci@1f,700000
[   34.066071] schizo f0069c00: PCI host bridge to bus 0000:00
[   34.066093] pci_bus 0000:00: root bus resource [io  0x7f601000000-0x7f601ffffff] (bus address [0x0000-0xffffff])
[   34.066111] pci_bus 0000:00: root bus resource [mem 0x7f700000000-0x7f7ffffffff] (bus address [0x00000000-0xffffffff])
[   34.066127] pci_bus 0000:00: root bus resource [bus 00]
[   34.066228] pci 0000:00:02.0: PME# supported from D3hot
[   34.066453] pci 0000:00:02.1: PME# supported from D3hot
[   34.066764] /pci@1e,600000: TOMATILLO PCI Bus Module ver[4:0]
[   34.066778] /pci@1e,600000: PCI IO[7fe01000000] MEM[7ff00000000]
[   34.068753] PCI: Scanning PBM /pci@1e,600000
[   34.068943] schizo f00732d0: PCI host bridge to bus 0001:00
[   34.068969] pci_bus 0001:00: root bus resource [io  0x7fe01000000-0x7fe01ffffff] (bus address [0x0000-0xffffff])
[   34.068996] pci_bus 0001:00: root bus resource [mem 0x7ff00000000-0x7ffffffffff] (bus address [0x00000000-0xffffffff])
[   34.069022] pci_bus 0001:00: root bus resource [bus 00]
[   34.069281] pci 0001:00:06.0: quirk: [io  0x7fe01000800-0x7fe0100083f] claimed by ali7101 ACPI
[   34.069310] pci 0001:00:06.0: quirk: [io  0x7fe01000600-0x7fe0100061f] claimed by ali7101 SMB
[   34.069518] pci 0001:00:0a.0: PME# supported from D3cold
[   34.070045] /pci@1c,600000: TOMATILLO PCI Bus Module ver[4:0]
[   34.070065] /pci@1c,600000: PCI IO[7ce01000000] MEM[7cf00000000]
[   34.072083] PCI: Scanning PBM /pci@1c,600000
[   34.072281] schizo f007c6ac: PCI host bridge to bus 0002:00
[   34.072306] pci_bus 0002:00: root bus resource [io  0x7ce01000000-0x7ce01ffffff] (bus address [0x0000-0xffffff])
[   34.072332] pci_bus 0002:00: root bus resource [mem 0x7cf00000000-0x7cfffffffff] (bus address [0x00000000-0xffffffff])
[   34.072358] pci_bus 0002:00: root bus resource [bus 00]
[   34.072452] pci 0002:00:02.0: supports D1 D2
[   34.072674] pci 0002:00:02.1: supports D1 D2
[   34.072990] /pci@1d,700000: TOMATILLO PCI Bus Module ver[4:0]
[   34.073010] /pci@1d,700000: PCI IO[7c601000000] MEM[7c700000000]
[   34.075005] PCI: Scanning PBM /pci@1d,700000
[   34.075213] schizo f00859d4: PCI host bridge to bus 0003:00
[   34.075239] pci_bus 0003:00: root bus resource [io  0x7c601000000-0x7c601ffffff] (bus address [0x0000-0xffffff])
[   34.075266] pci_bus 0003:00: root bus resource [mem 0x7c700000000-0x7c7ffffffff] (bus address [0x00000000-0xffffffff])
[   34.075292] pci_bus 0003:00: root bus resource [bus 00]
[   34.075413] pci 0003:00:02.0: PME# supported from D3hot
[   34.075676] pci 0003:00:02.1: PME# supported from D3hot
[   34.081421] bio: create slab <bio-0> at 0
[   34.081959] vgaarb: loaded
[   34.082430] SCSI subsystem initialized
[   34.083594] /pci@1e,600000/isa@7/rtc@0,70: RTC regs at 0x7fe01000070
[   34.084869] Switching to clocksource stick
[   34.092652] NET: Registered protocol family 2
[   34.093064] TCP established hash table entries: 2048 (order: 2, 32768 bytes)
[   34.093187] TCP bind hash table entries: 2048 (order: 2, 32768 bytes)
[   34.093303] TCP: Hash tables configured (established 2048 bind 2048)
[   34.093390] TCP: reno registered
[   34.093407] UDP hash table entries: 256 (order: 0, 8192 bytes)
[   34.093451] UDP-Lite hash table entries: 256 (order: 0, 8192 bytes)
[   34.093698] NET: Registered protocol family 1
[   34.093757] pci 0001:00:07.0: Activating ISA DMA hang workarounds
[   34.093789] PCI: Enabling device: (0001:00:0a.0), cmd 2
[   34.154948] PCI: CLS 64 bytes, default 64
[   34.155142] power: Control reg at 7fe01000800
[   34.155530] chmc: UltraSPARC-IIIi memory controller at /memory-controller@0,0
[   34.155563] chmc: UltraSPARC-IIIi memory controller at /memory-controller@1,0
[   34.165715] msgmni has been set to 494
[   34.166349] io scheduler noop registered
[   34.166523] io scheduler cfq registered (default)
[   34.167195] f00aba6c: ttyS0 at MMIO 0x7fe010003f8 (irq = 15) is a 16550A
[   34.167215] Console: ttyS0 (SU)
[   42.374594] console [ttyS0] enabled
[   42.420665] f00ad5ec: ttyS1 at MMIO 0x7fe010002e8 (irq = 15) is a 16550A
[   42.509515] PCI: Enabling device: (0002:00:02.0), cmd 147
[   42.581037] sym0: <1010-66> rev 0x1 at pci 0002:00:02.0 irq 24
[   42.659821] sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
[   42.778199] sym0: SCSI BUS has been reset.
[   42.831989] scsi0 : sym-2.2.3
[   45.866159] scsi 0:0:0:0: Direct-Access     FUJITSU  MAW3073NCSUN72G  1703 PQ: 0 ANSI: 4
[   45.972582] scsi target0:0:0: tagged command queuing enabled, command queue depth 16.
[   46.075599] scsi target0:0:0: Beginning Domain Validation
[   46.152355] scsi target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
[   46.358085] scsi target0:0:0: Ending Domain Validation
[   50.552347] PCI: Enabling device: (0002:00:02.1), cmd 147
[   50.623892] sym1: <1010-66> rev 0x1 at pci 0002:00:02.1 irq 25
[   50.702671] sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking
[   50.821133] sym1: SCSI BUS has been reset.
[   50.874938] scsi1 : sym-2.2.3
[   58.301097] mousedev: PS/2 mouse device common for all mice
[   58.301843] sd 0:0:0:0: [sda] 143374738 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   58.304753] sd 0:0:0:0: [sda] Write Protect is off
[   58.304759] sd 0:0:0:0: [sda] Mode Sense: c7 00 00 08
[   58.305897] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   58.317159]  sda: sda1 sda2 sda3 sda4
[   58.321798] sd 0:0:0:0: [sda] Attached SCSI disk
[   58.833788] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[   58.917383] rtc_cmos rtc_cmos: no alarms, 114 bytes nvram
[   58.989328] TCP: cubic registered
[   59.032880] NET: Registered protocol family 17
[   59.091956] rtc_cmos rtc_cmos: setting system clock to 2013-06-16 13:05:00 UTC (1371387900)
[   59.204672] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[   59.306482] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[   59.429442] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   59.530217] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[   61.113258] pps_core: LinuxPPS API ver. 1 registered
[   61.178571] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   61.299855] PTP clock support registered
[   61.378830] tg3.c:v3.132 (May 21, 2013)
[   61.429280] PCI: Enabling device: (0000:00:02.0), cmd 2
[   61.679664] tg3 0000:00:02.0 (unregistered net_device): Cannot get nvram lock, tg3_nvram_init failed
[   62.136797] tg3 0000:00:02.0 eth0: Tigon3 [partno(none) rev 2003] (PCI:66MHz:64-bit) MAC address 00:03:ba:0a:f3:85
[   62.272986] tg3 0000:00:02.0 eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   62.401073] tg3 0000:00:02.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   62.504008] tg3 0000:00:02.0 eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   62.592101] PCI: Enabling device: (0000:00:02.1), cmd 2
[   62.839311] tg3 0000:00:02.1 (unregistered net_device): Cannot get nvram lock, tg3_nvram_init failed
[   63.295874] tg3 0000:00:02.1 eth1: Tigon3 [partno(none) rev 2003] (PCI:66MHz:64-bit) MAC address 00:03:ba:0a:f3:86
[   63.431987] tg3 0000:00:02.1 eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   63.560078] tg3 0000:00:02.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   63.663011] tg3 0000:00:02.1 eth1: dma_rwctrl[763f0000] dma_mask[32-bit]
[   63.751109] PCI: Enabling device: (0003:00:02.0), cmd 2
[   63.999292] tg3 0003:00:02.0 (unregistered net_device): Cannot get nvram lock, tg3_nvram_init failed
[   64.455848] tg3 0003:00:02.0 eth2: Tigon3 [partno(none) rev 2003] (PCI:66MHz:64-bit) MAC address 00:03:ba:0a:f3:87
[   64.592030] tg3 0003:00:02.0 eth2: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   64.720118] tg3 0003:00:02.0 eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   64.823056] tg3 0003:00:02.0 eth2: dma_rwctrl[763f0000] dma_mask[32-bit]
[   64.911140] PCI: Enabling device: (0003:00:02.1), cmd 2
[   65.159296] tg3 0003:00:02.1 (unregistered net_device): Cannot get nvram lock, tg3_nvram_init failed
[   65.615808] tg3 0003:00:02.1 eth3: Tigon3 [partno(none) rev 2003] (PCI:66MHz:64-bit) MAC address 00:03:ba:0a:f3:88
[   65.751967] tg3 0003:00:02.1 eth3: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   65.880064] tg3 0003:00:02.1 eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   65.982991] tg3 0003:00:02.1 eth3: dma_rwctrl[763f0000] dma_mask[32-bit]
[   66.549023] Adding 3084472k swap on /dev/sda4.  Priority:-1 extents:1 across:3084472k 
[   66.690487] EXT4-fs (sda2): re-mounted. Opts: (null)
[   66.944966] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[   68.324377] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[   68.447686] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[   69.338117] NET: Registered protocol family 10
[   70.842065] tg3 0000:00:02.0 eth0: No firmware running
[   71.285041] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   72.946419] tg3 0000:00:02.0 eth0: Link is up at 100 Mbps, full duplex
[   73.039237] tg3 0000:00:02.0 eth0: Flow control is on for TX and on for RX
[   73.146397] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  568.834221] ------------[ cut here ]------------
[  568.894907] WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
[  568.971594] Modules linked in: ipv6 tg3 ptp pps_core hwmon
[  569.043635] CPU: 1 PID: 2952 Comm: aptitude Not tainted 3.10.0-rc6 #85
[  569.129412] Call Trace:
[  569.161440]  [00000000004d811c] exit_mmap+0x13c/0x160
[  569.227785]  [000000000045680c] mmput.part.62+0xc/0xc0
[  569.295258]  [000000000045c25c] exit_mm+0x11c/0x180
[  569.359301]  [000000000045dc24] do_exit+0x244/0x340
[  569.423354]  [000000000045dea8] do_group_exit+0x28/0xc0
[  569.491982]  [0000000000469a08] get_signal_to_deliver+0x1c8/0x3a0
[  569.572039]  [0000000000447874] do_signal32+0x14/0x220
[  569.639526]  [000000000042c8e0] do_signal+0x2c0/0x520
[  569.705854]  [000000000042d340] do_notify_resume+0x40/0x60
[  569.777907]  [0000000000404b04] __handle_signal+0xc/0x2c
[  569.847671] ---[ end trace 4acf84f71c8b5f1b ]---
[  569.908406] BUG: Bad rss-counter state mm:fffff8000dcb6700 idx:1 val:1
[  569.994271] [sched_delayed] sched: RT throttling activated


-- 
Meelis Roos (mroos@linux.ee)
