Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaJEXL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:11:57 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40647 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaJEXLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:11:52 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <542EC3A3.1060605@gmail.com>
Date: Mon, 6 Oct 2014 01:11:54 +0200
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <-7443282711873112734@unknownmsgid> <20141003141102.GJ3895@titan.lakedaemon.net> <542EBB93.108@gmail.com> <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com> <542EC3A3.1060605@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 3 oct. 2014 à 17:41, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :

> On 10/03/2014 05:29 PM, Benoit Masson wrote:
>> Le 3 oct. 2014 à 17:06, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
>>> On 10/03/2014 04:11 PM, Jason Cooper wrote:
>>>> On Sun, Sep 21, 2014 at 04:11:23PM +0200, Benoit Masson wrote:
>>>>>> Le 19 sept. 2014 à 22:14, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
> [...]
>>>>>> Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
>>>>>> a hurry. I only compile tested this, so a formal Tested-by from Benoit
>>>>>> for the ix4 and any other Armada XP board would be great.
>>>>> 
>>>>> I'm not sure what to test since I only receive some patch from the
>>>>> series of 8. Should I get all 8 or only those you sent me. I'll be
>>>>> able to test during next week.
>>>> 
>>>> Did you ever get a chance to test this series?
>>> 
>>> Uhm, I never prepared a branch for Benoit to test. I have pushed the
>>> patches with Thomas Acked-by's and renamed eeprom node based on
>>> v3.17-rc1 to
>>> 
>>> https://github.com/shesselba/linux-dove.git devel/mvebu-ix4
>>> 
> [...]
>> Also I've noted you did some other patch for Armada XP not related to ix-4-300d,
> > are they included here or should I get them too ?
> 
> No, they are neither included nor is there any need to test. They are
> about pcie-lanes property but it is more or less unused on Linux.
> 
> It is too late for v3.18 anyway, so I'll resend them once v3.18-rc1
> drops.
> 
>> I'll test those over Sunday night.
> 
> Ok, great!
Hi,

No so great, so far what I've done:
 - use my working config this config has worked over mainline 3.16 for weeks
 - compil you branch with it using you dts file
 - boot KO it get stuck on i2C pcf8563 init (at least it is the last message dsplayed.

then I turn on DEBUG_LL but I get nothing more on the serial that could help

 - I've tried removing the eeprom section you added to the dts -> same results

Maybe I missed something ? is this branch you sent me a bare fork from mainline 3.17 ? does it includes the armada XP step A0 patch ?

dump of the serial output:
Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x0
Linux version 3.17.0-rc1-42264-gb065757 (benoitm@aaaa) (gcc version 4.6.3 (Debian 4.6.3-14) ) #3 SMP Mon Oct 6 00:42:59 CEST 2014
CPU: ARMv7 Processor [562f5842] revision 2 (ARMv7), cr=10c5387d
CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
Machine model: Lenovo Iomega ix4-300d
Memory policy: Data cache writealloc
PERCPU: Embedded 7 pages/cpu @dfbd9000 s6784 r8192 d13696 u32768
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: console=ttyS0,115200 earlyprintk=ttyS0,115200 root=/dev/md0 rw mem=512M
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 512868K/524288K available (4787K kernel code, 254K rwdata, 1324K rodata, 254K init, 131K bss, 11420K reserved, 0K highmem)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xe0800000 - 0xff000000   ( 488 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
    pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
    modules : 0xbf000000 - 0xbfe00000   (  14 MB)
      .text : 0xc0008000 - 0xc05fffac   (6112 kB)
      .init : 0xc0600000 - 0xc063fa80   ( 255 kB)
      .data : 0xc0640000 - 0xc067fa60   ( 255 kB)
       .bss : 0xc067fa60 - 0xc06a098c   ( 132 kB)
Hierarchical RCU implementation.
NR_IRQS:16 nr_irqs:16 16
L2C: device tree omits to specify unified cache
L2C: DT/platform modifies aux control register: 0x1a696b10 -> 0x1a696b12
Aurora cache controller enabled, 16 ways, 1024 kB
Aurora: CACHE_ID 0x00000100, AUX_CTRL 0x1a696b12
sched_clock: 32 bits at 25MHz, resolution 40ns, wraps every 171798691800ns
Console: colour dummy device 80x30
Calibrating delay loop... 1332.01 BogoMIPS (lpj=6660096)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
CPU: Testing write buffer coherency: ok
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Setting up static identity map for 0x4b2b70 - 0x4b2bc8
mvebu-soc-id: MVEBU SoC ID=0x7823, Rev=0x1
mvebu-pmsu: Initializing Power Management Service Unit
Booting CPU 1
CPU1: Booted secondary processor
CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
Brought up 2 CPUs
SMP: Total of 2 processors activated.
CPU: All CPU(s) started in SVC mode.
VFP support v0.3: implementor 56 architecture 2 part 20 variant 9 rev 6
xor: measuring software checksum speed
   arm4regs  :  1093.200 MB/sec
   8regs     :  1092.000 MB/sec
   32regs    :  1011.200 MB/sec
xor: using function: arm4regs (1093.200 MB/sec)
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
raid6: int32x1    123 MB/s
raid6: int32x2    188 MB/s
raid6: int32x4    264 MB/s
raid6: int32x8    307 MB/s
raid6: using algorithm int32x8 (307 MB/s)
raid6: using intx1 recovery algorithm
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Initialized.
Switched to clocksource armada_370_xp_clocksource
NET: Registered protocol family 2
TCP established hash table entries: 4096 (order: 2, 16384 bytes)
TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP: reno registered
UDP hash table entries: 256 (order: 1, 8192 bytes)
UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
futex hash table entries: 512 (order: 3, 32768 bytes)
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 1001
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
armada-xp-pinctrl d0018000.pin-ctrl: registered pinctrl driver
irq: Cannot allocate irq_descs @ IRQ37, assuming pre-allocated
irq: Cannot allocate irq_descs @ IRQ69, assuming pre-allocated
mvebu-pcie soc:pcie-controller: PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x1000-0xfffff]
pci_bus 0000:00: root bus resource [mem 0xf8000000-0xffdfffff]
pci_bus 0000:00: root bus resource [bus 00-ff]
PCI: bus0: Fast back to back transfers disabled
pci 0000:00:01.0: bridge configuration invalid ([bus 00-00]), reconfiguring
pci 0000:00:05.0: bridge configuration invalid ([bus 00-00]), reconfiguring
PCI: bus1: Fast back to back transfers disabled
PCI: bus2: Fast back to back transfers disabled
pci 0000:00:01.0: BAR 8: assigned [mem 0xf8000000-0xf80fffff]
pci 0000:00:05.0: BAR 8: assigned [mem 0xf8100000-0xf81fffff]
pci 0000:00:01.0: BAR 7: assigned [io  0x10000-0x10fff]
pci 0000:01:00.0: BAR 0: assigned [mem 0xf8000000-0xf80fffff 64bit]
pci 0000:01:00.0: BAR 2: assigned [io  0x10000-0x100ff]
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0x10000-0x10fff]
pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xf80fffff]
pci 0000:02:00.0: BAR 0: assigned [mem 0xf8100000-0xf8101fff 64bit]
pci 0000:00:05.0: PCI bridge to [bus 02]
pci 0000:00:05.0:   bridge window [mem 0xf8100000-0xf81fffff]
pci 0000:00:05.0: enabling device (0140 -> 0142)
mv_xor d0060900.xor: Marvell shared XOR driver
mv_xor d0060900.xor: Marvell XOR: ( xor cpy )
mv_xor d0060900.xor: Marvell XOR: ( xor cpy )
mv_xor d00f0900.xor: Marvell shared XOR driver
mv_xor d00f0900.xor: Marvell XOR: ( xor cpy )
mv_xor d00f0900.xor: Marvell XOR: ( xor cpy )
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
console [ttyS0] disabled
d0012000.serial: ttyS0 at MMIO 0xd0012000 (irq = 19, base_baud = 15625000) is a 16550A
console [ttyS0] enabled
zram: Created 1 device(s) ...
pci 0000:00:01.0: enabling device (0140 -> 0143)
sata_mv 0000:01:00.0: Gen-IIE 32 slots 4 ports SCSI mode IRQ via INTx
scsi host0: sata_mv
scsi host1: sata_mv
scsi host2: sata_mv
scsi host3: sata_mv
ata1: SATA max UDMA/133 mmio m1048576@0xf8000000 port 0xf8022000 irq 86
ata2: SATA max UDMA/133 mmio m1048576@0xf8000000 port 0xf8024000 irq 86
ata3: SATA max UDMA/133 mmio m1048576@0xf8000000 port 0xf8026000 irq 86
ata4: SATA max UDMA/133 mmio m1048576@0xf8000000 port 0xf8028000 irq 86
pxa3xx-nand d00d0000.nand: This platform can't do DMA on this device
nand: device found, Manufacturer ID: 0xec, Chip ID: 0xd3
nand: Samsung NAND 1GiB 3,3V 8-bit
nand: 1024MiB, SLC, page size: 2048, OOB size: 64
pxa3xx-nand d00d0000.nand: ECC strength 1, ECC step size 512
Bad block table found at page 524224, version 0x01
Bad block table found at page 524160, version 0x01
nand_read_bbt: bad block at 0x00003ca60000
7 ofpart partitions found on MTD device pxa3xx_nand-0
Creating 7 MTD partitions on "pxa3xx_nand-0":
0x000000000000-0x0000000e0000 : "u-boot"
0x0000000e0000-0x000000100000 : "u-boot-env"
0x000000100000-0x000000120000 : "u-boot-env2"
0x000000120000-0x000000520000 : "zImage"
0x000000520000-0x000000920000 : "initrd"
0x000000e00000-0x000040000000 : "boot"
0x000000000000-0x000040000000 : "flash"
spi_gpio spi3: gpio-miso property not found, switching to no-rx mode
libphy: orion_mdio_bus: probed
mvneta d0070000.ethernet eth0: Using hardware mac address 00:d0:b8:25:38:4d
mvneta d0074000.ethernet eth1: Using random mac address 12:93:5b:2b:44:6e
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-orion: EHCI orion driver
orion-ehci d0050000.usb: EHCI Host Controller
orion-ehci d0050000.usb: new USB bus registered, assigned bus number 1
orion-ehci d0050000.usb: irq 25, io mem 0xd0050000
orion-ehci d0050000.usb: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 1 port detected
orion-ehci d0051000.usb: EHCI Host Controller
orion-ehci d0051000.usb: new USB bus registered, assigned bus number 2
orion-ehci d0051000.usb: irq 26, io mem 0xd0051000
orion-ehci d0051000.usb: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 1 port detected
xhci_hcd 0000:02:00.0: xHCI Host Controller
xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
xhci_hcd 0000:02:00.0: xHCI Host Controller
xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 4
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usbcore: registered new interface driver usb-storage
rtc-mv d0010300.rtc: rtc core: registered d0010300.rtc as rtc0
i2c /dev entries driver
rtc-pcf8563 0-0051: chip found, driver version 0.4.3
 
> 
> Sebastian

