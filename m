Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3AaKBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:01:37 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:36244 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754057Ab3AaKBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:01:23 -0500
Message-ID: <510A40EF.1060707@fold.natur.cuni.cz>
Date: Thu, 31 Jan 2013 11:01:19 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Mate Soos <soos.mate@gmail.com>
CC: linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: Bug report on plug-in to USB3 port
References: <51094F76.2010404@gmail.com>
In-Reply-To: <51094F76.2010404@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+CC: linux-usb]

Mate Soos wrote:
> Hi All,
> 
> [1.] One line summary of the problem:
> Crashed when I resumed from suspend and at the same time plugged in a USB mouse into a USB 3.0 port
> 
> [2.] Full description of the problem/report:
> I had my ivy bridge laptop Vostro 3560 suspended. I opened the lid and either a second before or at
> the same time I plugged in my USB 2.0 Logitech  mouse. The result is the kernel panic as per below link
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> panic, USB 3.0
> 
> [4.] Kernel version (from /proc/version):
> Linux version 3.2.0-36-generic (buildd@allspice) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) )
> #57-Ubuntu SMP Tue Jan 8 21:44:52 UTC 2013
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
> 
> See picture at:  http://www.msoos.org/private/DSC_0188.jpg
> 
> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> 
> Sorry, I can't. But this has happened before, so should be partially reproducible. Also happens to
> my colleague with USB3 port + USB2 stick.
> 
> [7.] Environment
> soos@soos-Vostro-3560:~$ lspci
> 00:00.0 Host bridge: Intel Corporation Ivy Bridge DRAM Controller (rev 09)
> 00:01.0 PCI bridge: Intel Corporation Ivy Bridge PCI Express Root Port (rev 09)
> 00:02.0 VGA compatible controller: Intel Corporation Ivy Bridge Graphics Controller (rev 09)
> 00:14.0 USB controller: Intel Corporation Panther Point USB xHCI Host Controller (rev 04)
> 00:16.0 Communication controller: Intel Corporation Panther Point MEI Controller #1 (rev 04)
> 00:1a.0 USB controller: Intel Corporation Panther Point USB Enhanced Host Controller #2 (rev 04)
> 00:1b.0 Audio device: Intel Corporation Panther Point High Definition Audio Controller (rev 04)
> 00:1c.0 PCI bridge: Intel Corporation Panther Point PCI Express Root Port 1 (rev c4)
> 00:1c.1 PCI bridge: Intel Corporation Panther Point PCI Express Root Port 2 (rev c4)
> 00:1c.2 PCI bridge: Intel Corporation Panther Point PCI Express Root Port 3 (rev c4)
> 00:1d.0 USB controller: Intel Corporation Panther Point USB Enhanced Host Controller #1 (rev 04)
> 00:1f.0 ISA bridge: Intel Corporation Panther Point LPC Controller (rev 04)
> 00:1f.2 SATA controller: Intel Corporation Panther Point 6 port SATA Controller [AHCI mode] (rev 04)
> 00:1f.3 SMBus: Intel Corporation Panther Point SMBus Controller (rev 04)
> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Thames XT/GL [Radeon HD
> 7600M Series]
> 07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit
> Ethernet controller (rev 07)
> 08:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev c4)
> 
> (USB mouse plugged in so you can see exact number:)
> soos@soos-Vostro-3560:~$ lsusb
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 003 Device 002: ID 046d:c245 Logitech, Inc.
> Bus 001 Device 003: ID 138a:0011 Validity Sensors, Inc. VFS5011 Fingerprint Reader
> Bus 001 Device 004: ID 0bda:0129 Realtek Semiconductor Corp.
> Bus 001 Device 005: ID 0c45:648b Microdia
> Bus 002 Device 003: ID 8087:07da Intel Corp.
> 
> soos@soos-Vostro-3560:~$ lscpu
> Architecture:          x86_64
> CPU op-mode(s):        32-bit, 64-bit
> Byte Order:            Little Endian
> CPU(s):                8
> On-line CPU(s) list:   0-7
> Thread(s) per core:    2
> Core(s) per socket:    4
> Socket(s):             1
> NUMA node(s):          1
> Vendor ID:             GenuineIntel
> CPU family:            6
> Model:                 58
> Stepping:              9
> CPU MHz:               1200.000
> BogoMIPS:              4190.30
> Virtualization:        VT-x
> L1d cache:             32K
> L1i cache:             32K
> L2 cache:              256K
> L3 cache:              6144K
> NUMA node0 CPU(s):     0-7
> 
> soos@soos-Vostro-3560:~$ lsblk
> NAME             MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
> sda                8:0    0 698.7G  0 disk
> ├─sda1             8:1    0  39.2M  0 part
> ├─sda2             8:2    0     1K  0 part
> ├─sda3             8:3    0   624G  0 part
> │ └─crypt (dm-0) 252:0    0   624G  0 crypt /home
> ├─sda4             8:4    0  48.4G  0 part
> ├─sda5             8:5    0  16.9G  0 part  /
> └─sda6             8:6    0   9.3G  0 part
> sr0               11:0    1  46.6G  0 rom
> 
> soos@soos-Vostro-3560:~$ sudo lshw
> [sudo] password for soos:
> soos-vostro-3560
>     description: Portable Computer
>     product: Vostro 3560 (xxx123x#ABA)
>     vendor: Winbond Electronics
>     version: A07
>     serial: 4470DS1
>     width: 64 bits
>     capabilities: smbios-2.7 dmi-2.7 vsyscall32
>     configuration: boot=normal chassis=portable family=103C_5335KV sku=xxx123x#ABA
> uuid=44454C4C-3400-1037-8030-B4C04F445331
>   *-core
>        description: Motherboard
>        product: 0C05GV
>        vendor: Winbond Electronics
>        physical id: 0
>        version: A00
>        serial: .4470DS1.CN1296124T01A9.
>        slot: Type2 - Board Chassis Location
>      *-firmware
>           description: BIOS
>           vendor: Winbond Electronics
>           physical id: 0
>           version: A07
>           date: 05/17/2012
>           size: 128KiB
>           capacity: 4544KiB
>           capabilities: pci upgrade shadowing cdboot bootselect edd int13floppynec
> int13floppytoshiba int13floppy360 int13floppy1200 int13floppy720 int13floppy2880 int9keyboard
> int10video acpi usb biosbootspecification
>      *-cpu
>           description: CPU
>           product: Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>           vendor: Intel Corp.
>           physical id: 4
>           bus info: cpu@0
>           version: Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>           serial: To Be Filled By O.E.M.
>           slot: U3E1
>           size: 1200MHz
>           capacity: 4GHz
>           width: 64 bits
>           clock: 100MHz
>           capabilities: x86-64 fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp constant_tsc
> arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor
> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes
> xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept
> vpid fsgsbase smep erms cpufreq
>           configuration: cores=4 enabledcores=4 threads=8
>         *-cache:0
>              description: L1 cache
>              physical id: 9
>              slot: L1 Cache
>              size: 32KiB
>              capacity: 32KiB
>              capabilities: internal write-through instruction
>         *-cache:1
>              description: L2 cache
>              physical id: a
>              slot: L2 Cache
>              size: 256KiB
>              capacity: 256KiB
>              capabilities: internal write-through unified
>         *-cache:2
>              description: L3 cache
>              physical id: b
>              slot: L3 Cache
>              size: 6MiB
>              capacity: 6MiB
>              capabilities: internal write-back unified
>      *-cache
>           description: L1 cache
>           physical id: 8
>           slot: L1 Cache
>           size: 32KiB
>           capacity: 32KiB
>           capabilities: internal write-through data
>      *-memory
>           description: System Memory
>           physical id: 29
>           slot: System board or motherboard
>           size: 12GiB
>         *-bank:0
>              description: SODIMM DDR3 Synchronous 1600 MHz (0.6 ns)
>              product: CMSX8GX3M1A1600C10
>              vendor: Unknown
>              physical id: 0
>              serial: 00000000
>              slot: DIMM0
>              size: 8GiB
>              width: 64 bits
>              clock: 1600MHz (0.6ns)
>         *-bank:1
>              description: SODIMM DDR3 Synchronous 1600 MHz (0.6 ns)
>              product: 16JTF51264HZ-1G6M1
>              vendor: Micron Technology
>              physical id: 1
>              serial: FD6FABDB
>              slot: DIMM1
>              size: 4GiB
>              width: 64 bits
>              clock: 1600MHz (0.6ns)
>      *-pci
>           description: Host bridge
>           product: Ivy Bridge DRAM Controller
>           vendor: Intel Corporation
>           physical id: 100
>           bus info: pci@0000:00:00.0
>           version: 09
>           width: 32 bits
>           clock: 33MHz
>           configuration: driver=agpgart-intel
>           resources: irq:0
>         *-pci:0
>              description: PCI bridge
>              product: Ivy Bridge PCI Express Root Port
>              vendor: Intel Corporation
>              physical id: 1
>              bus info: pci@0000:00:01.0
>              version: 09
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pm msi pciexpress normal_decode bus_master cap_list
>              configuration: driver=pcieport
>              resources: irq:40 ioport:4000(size=4096) memory:c2000000-c2ffffff
> ioport:a0000000(size=268435456)
>            *-display
>                 description: VGA compatible controller
>                 product: Thames XT/GL [Radeon HD 7600M Series]
>                 vendor: Hynix Semiconductor (Hyundai Electronics)
>                 physical id: 0
>                 bus info: pci@0000:01:00.0
>                 version: 00
>                 width: 64 bits
>                 clock: 33MHz
>                 capabilities: pm pciexpress msi vga_controller bus_master cap_list rom
>                 configuration: driver=fglrx_pci latency=0
>                 resources: irq:48 memory:a0000000-afffffff memory:c2000000-c201ffff
> ioport:4000(size=256) memory:c2020000-c203ffff
>         *-display
>              description: VGA compatible controller
>              product: Ivy Bridge Graphics Controller
>              vendor: Intel Corporation
>              physical id: 2
>              bus info: pci@0000:00:02.0
>              version: 09
>              width: 64 bits
>              clock: 33MHz
>              capabilities: msi pm vga_controller bus_master cap_list rom
>              configuration: driver=i915 latency=0
>              resources: irq:44 memory:c3000000-c33fffff memory:b0000000-bfffffff ioport:5000(size=64)
>         *-usb:0
>              description: USB controller
>              product: Panther Point USB xHCI Host Controller
>              vendor: Intel Corporation
>              physical id: 14
>              bus info: pci@0000:00:14.0
>              version: 04
>              width: 64 bits
>              clock: 33MHz
>              capabilities: pm msi xhci bus_master cap_list
>              configuration: driver=xhci_hcd latency=0
>              resources: irq:42 memory:c3600000-c360ffff
>         *-communication
>              description: Communication controller
>              product: Panther Point MEI Controller #1
>              vendor: Intel Corporation
>              physical id: 16
>              bus info: pci@0000:00:16.0
>              version: 04
>              width: 64 bits
>              clock: 33MHz
>              capabilities: pm msi bus_master cap_list
>              configuration: driver=mei latency=0
>              resources: irq:45 memory:c3614000-c361400f
>         *-usb:1
>              description: USB controller
>              product: Panther Point USB Enhanced Host Controller #2
>              vendor: Intel Corporation
>              physical id: 1a
>              bus info: pci@0000:00:1a.0
>              version: 04
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pm debug ehci bus_master cap_list
>              configuration: driver=ehci_hcd latency=0
>              resources: irq:16 memory:c3619000-c36193ff
>         *-multimedia
>              description: Audio device
>              product: Panther Point High Definition Audio Controller
>              vendor: Intel Corporation
>              physical id: 1b
>              bus info: pci@0000:00:1b.0
>              version: 04
>              width: 64 bits
>              clock: 33MHz
>              capabilities: pm msi pciexpress bus_master cap_list
>              configuration: driver=snd_hda_intel latency=0
>              resources: irq:47 memory:c3610000-c3613fff
>         *-pci:1
>              description: PCI bridge
>              product: Panther Point PCI Express Root Port 1
>              vendor: Intel Corporation
>              physical id: 1c
>              bus info: pci@0000:00:1c.0
>              version: c4
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
>              configuration: driver=pcieport
>              resources: irq:17 ioport:3000(size=4096) ioport:c3400000(size=1048576)
>            *-network
>                 description: Ethernet interface
>                 product: RTL8111/8168B PCI Express Gigabit Ethernet controller
>                 vendor: Realtek Semiconductor Co., Ltd.
>                 physical id: 0
>                 bus info: pci@0000:07:00.0
>                 logical name: eth0
>                 version: 07
>                 serial: d4:be:d9:25:31:c5
>                 size: 100Mbit/s
>                 capacity: 1Gbit/s
>                 width: 64 bits
>                 clock: 33MHz
>                 capabilities: pm msi pciexpress msix vpd bus_master cap_list ethernet physical tp
> 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
>                 configuration: autonegotiation=on broadcast=yes driver=r8168
> driverversion=8.034.00-NAPI duplex=half latency=0 link=no multicast=yes port=twisted pair
> speed=100Mbit/s
>                 resources: irq:43 ioport:3000(size=256) memory:c3404000-c3404fff
> memory:c3400000-c3403fff
>         *-pci:2
>              description: PCI bridge
>              product: Panther Point PCI Express Root Port 2
>              vendor: Intel Corporation
>              physical id: 1c.1
>              bus info: pci@0000:00:1c.1
>              version: c4
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
>              configuration: driver=pcieport
>              resources: irq:16 memory:c3500000-c35fffff
>            *-network
>                 description: Wireless interface
>                 product: Centrino Wireless-N 2230
>                 vendor: Intel Corporation
>                 physical id: 0
>                 bus info: pci@0000:08:00.0
>                 logical name: wlan0
>                 version: c4
>                 serial: 68:5d:43:21:98:37
>                 width: 64 bits
>                 clock: 33MHz
>                 capabilities: pm msi pciexpress bus_master cap_list ethernet physical wireless
>                 configuration: broadcast=yes driver=iwlwifi driverversion=3.2.0-36-generic
> firmware=18.168.6.1 ip=192.168.203.158 latency=0 link=yes multicast=yes wireless=IEEE 802.11bgn
>                 resources: irq:46 memory:c3500000-c3501fff
>         *-pci:3
>              description: PCI bridge
>              product: Panther Point PCI Express Root Port 3
>              vendor: Intel Corporation
>              physical id: 1c.2
>              bus info: pci@0000:00:1c.2
>              version: c4
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
>              configuration: driver=pcieport
>              resources: irq:18 ioport:2000(size=4096) memory:c1000000-c1ffffff
> ioport:c0000000(size=16777216)
>         *-usb:2
>              description: USB controller
>              product: Panther Point USB Enhanced Host Controller #1
>              vendor: Intel Corporation
>              physical id: 1d
>              bus info: pci@0000:00:1d.0
>              version: 04
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pm debug ehci bus_master cap_list
>              configuration: driver=ehci_hcd latency=0
>              resources: irq:23 memory:c3618000-c36183ff
>         *-isa
>              description: ISA bridge
>              product: Panther Point LPC Controller
>              vendor: Intel Corporation
>              physical id: 1f
>              bus info: pci@0000:00:1f.0
>              version: 04
>              width: 32 bits
>              clock: 33MHz
>              capabilities: isa bus_master cap_list
>              configuration: latency=0
>         *-storage
>              description: SATA controller
>              product: Panther Point 6 port SATA Controller [AHCI mode]
>              vendor: Intel Corporation
>              physical id: 1f.2
>              bus info: pci@0000:00:1f.2
>              logical name: scsi0
>              logical name: scsi2
>              version: 04
>              width: 32 bits
>              clock: 66MHz
>              capabilities: storage msi pm ahci_1.0 bus_master cap_list emulated
>              configuration: driver=ahci latency=0
>              resources: irq:41 ioport:5088(size=8) ioport:5094(size=4) ioport:5080(size=8)
> ioport:5090(size=4) ioport:5060(size=32) memory:c3617000-c36177ff
>            *-disk
>                 description: ATA Disk
>                 product: ST9750420AS
>                 vendor: Seagate
>                 physical id: 0
>                 bus info: scsi@0:0.0.0
>                 logical name: /dev/sda
>                 version: 0002
>                 serial: 6WS1P6VW
>                 size: 698GiB (750GB)
>                 capabilities: partitioned partitioned:dos
>                 configuration: ansiversion=5 signature=3372e1fa
>               *-volume:0
>                    description: Windows FAT volume
>                    vendor: Winbond Electronics
>                    physical id: 1
>                    bus info: scsi@0:0.0.0,1
>                    logical name: /dev/sda1
>                    version: FAT16
>                    serial: 5450-4444
>                    size: 39MiB
>                    capacity: 39MiB
>                    capabilities: primary fat initialized
>                    configuration: FATs=2 filesystem=fat label=DellUtility
>               *-volume:1
>                    description: Extended partition
>                    physical id: 2
>                    bus info: scsi@0:0.0.0,2
>                    logical name: /dev/sda2
>                    size: 26GiB
>                    capacity: 26GiB
>                    capabilities: primary extended partitioned partitioned:extended
>                  *-logicalvolume:0
>                       description: Linux filesystem partition
>                       physical id: 5
>                       logical name: /dev/sda5
>                       logical name: /
>                       capacity: 16GiB
>                       configuration: mount.fstype=ext4
> mount.options=rw,relatime,errors=remount-ro,user_xattr,barrier=1,data=ordered state=mounted
>                  *-logicalvolume:1
>                       description: Linux swap / Solaris partition
>                       physical id: 6
>                       logical name: /dev/sda6
>                       capacity: 9536MiB
>                       capabilities: nofs
>               *-volume:2
>                    description: Linux filesystem partition
>                    physical id: 3
>                    bus info: scsi@0:0.0.0,3
>                    logical name: /dev/sda3
>                    capacity: 624GiB
>                    capabilities: primary
>               *-volume:3
>                    description: Windows NTFS volume
>                    physical id: 4
>                    bus info: scsi@0:0.0.0,4
>                    logical name: /dev/sda4
>                    version: 3.1
>                    serial: 3ec4e75f-a797-c14d-b061-fa86e818cec9
>                    size: 48GiB
>                    capacity: 48GiB
>                    capabilities: primary bootable ntfs initialized
>                    configuration: clustersize=4096 created=2012-08-26 04:05:01 filesystem=ntfs
> state=clean
>            *-cdrom
>                 description: DVD-RAM writer
>                 product: BD RW BD-5750H
>                 vendor: Optiarc
>                 physical id: 1
>                 bus info: scsi@2:0.0.0
>                 logical name: /dev/cdrom
>                 logical name: /dev/cdrw
>                 logical name: /dev/dvd
>                 logical name: /dev/dvdrw
>                 logical name: /dev/sr0
>                 version: 1.00
>                 capabilities: removable audio cd-r cd-rw dvd dvd-r dvd-ram
>                 configuration: ansiversion=5 status=ready
>               *-medium
>                    physical id: 0
>                    logical name: /dev/cdrom
>         *-serial UNCLAIMED
>              description: SMBus
>              product: Panther Point SMBus Controller
>              vendor: Intel Corporation
>              physical id: 1f.3
>              bus info: pci@0000:00:1f.3
>              version: 04
>              width: 64 bits
>              clock: 33MHz
>              configuration: latency=0
>              resources: memory:c3615000-c36150ff ioport:5040(size=32)
>      *-scsi
>           physical id: 1
>           bus info: usb@1:1.3
>           logical name: scsi6
>           capabilities: emulated scsi-host
>           configuration: driver=rts5139
>         *-disk
>              description: SCSI Disk
>              product: xD/SD/M.S.
>              vendor: Generic-
>              physical id: 0.0.0
>              bus info: scsi@6:0.0.0
>              logical name: /dev/sdb
>              version: 1.00
>              serial: 3
>              capabilities: removable
>            *-medium
>                 physical id: 0
>                 logical name: /dev/sdb
>   *-battery
>        description: Lithium Ion Battery
>        product: DELL P8TC723H
>        vendor: Simplo
>        physical id: 1
>        slot: Sys. Battery Bay
>        capacity: 48000mWh
>        configuration: voltage=11.1V
> 
> 
> [7.1.] Software (add the output of the ver_linux script here)
> 
> Ubuntu LTS 12.04
> 
> [7.2.] Processor information (from /proc/cpuinfo):
> soos@soos-Vostro-3560:~$ cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
> stepping        : 9
> microcode       : 0x12
> cpu MHz         : 1200.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 8
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
> dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
> ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips        : 4190.62
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
> stepping        : 9
> microcode       : 0x12
> cpu MHz         : 1200.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 8
> core id         : 0
> cpu cores       : 4
> apicid          : 1
> initial apicid  : 1
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
> dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
> ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips        : 4190.28
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 2
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
> stepping        : 9
> microcode       : 0x12
> cpu MHz         : 1200.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 8
> core id         : 1
> cpu cores       : 4
> apicid          : 2
> initial apicid  : 2
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
> dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
> ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips        : 4190.29
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 3
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
> stepping        : 9
> microcode       : 0x12
> cpu MHz         : 1200.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 8
> core id         : 1
> cpu cores       : 4
> apicid          : 3
> initial apicid  : 3
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
> dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
> ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips        : 4190.30
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 4
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
> stepping        : 9
> microcode       : 0x12
> cpu MHz         : 1200.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 8
> core id         : 2
> cpu cores       : 4
> apicid          : 4
> initial apicid  : 4
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
> dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
> ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips        : 4190.29
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 5
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
> stepping        : 9
> microcode       : 0x12
> cpu MHz         : 1200.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 8
> core id         : 2
> cpu cores       : 4
> apicid          : 5
> initial apicid  : 5
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
> dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
> ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips        : 4190.30
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 6
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
> stepping        : 9
> microcode       : 0x12
> cpu MHz         : 1200.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 8
> core id         : 3
> cpu cores       : 4
> apicid          : 6
> initial apicid  : 6
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
> dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
> ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips        : 4190.29
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 7
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 58
> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
> stepping        : 9
> microcode       : 0x12
> cpu MHz         : 1200.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 8
> core id         : 3
> cpu cores       : 4
> apicid          : 7
> initial apicid  : 7
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush
> dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
> ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
> bogomips        : 4190.30
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> 
> [7.3.] Module information (from /proc/modules):
> 
> soos@soos-Vostro-3560:~$ cat /proc/modules
> sit 21759 0 - Live 0x0000000000000000
> tunnel4 13213 1 sit, Live 0x0000000000000000
> pci_stub 12622 1 - Live 0x0000000000000000
> vboxpci 23237 0 - Live 0x0000000000000000 (O)
> vboxnetadp 25670 0 - Live 0x0000000000000000 (O)
> vboxnetflt 23478 0 - Live 0x0000000000000000 (O)
> vboxdrv 320210 3 vboxpci,vboxnetadp,vboxnetflt, Live 0x0000000000000000 (O)
> bnep 18281 2 - Live 0x0000000000000000
> rfcomm 47604 16 - Live 0x0000000000000000
> kvm_intel 137721 0 - Live 0x0000000000000000
> kvm 415550 1 kvm_intel, Live 0x0000000000000000
> parport_pc 32866 0 - Live 0x0000000000000000
> ppdev 17113 0 - Live 0x0000000000000000
> binfmt_misc 17540 1 - Live 0x0000000000000000
> snd_hda_codec_hdmi 32474 1 - Live 0x0000000000000000
> snd_hda_codec_conexant 62358 1 - Live 0x0000000000000000
> arc4 12529 2 - Live 0x0000000000000000
> snd_hda_intel 33773 3 - Live 0x0000000000000000
> snd_hda_codec 127706 3 snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel, Live 0x0000000000000000
> uvcvideo 72627 0 - Live 0x0000000000000000
> snd_hwdep 17764 1 snd_hda_codec, Live 0x0000000000000000
> fglrx 5198957 216 - Live 0x0000000000000000 (P)
> snd_pcm 97275 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0x0000000000000000
> videodev 98259 1 uvcvideo, Live 0x0000000000000000
> snd_seq_midi 13324 0 - Live 0x0000000000000000
> snd_rawmidi 30748 1 snd_seq_midi, Live 0x0000000000000000
> rts5139 351188 0 - Live 0x0000000000000000 (C)
> snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
> snd_seq 61929 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
> v4l2_compat_ioctl32 17128 1 videodev, Live 0x0000000000000000
> iwlwifi 397059 0 - Live 0x0000000000000000
> joydev 17693 0 - Live 0x0000000000000000
> snd_timer 29990 2 snd_pcm,snd_seq, Live 0x0000000000000000
> snd_seq_device 14540 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
> btusb 18332 2 - Live 0x0000000000000000
> i8k 14350 0 - Live 0x0000000000000000
> bluetooth 180153 23 bnep,rfcomm,btusb, Live 0x0000000000000000
> dm_crypt 23125 1 - Live 0x0000000000000000
> mac80211 506862 1 iwlwifi, Live 0x0000000000000000
> snd 79041 16
> snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
> Live 0x0000000000000000
> aesni_intel 55664 27 - Live 0x0000000000000000
> cryptd 20530 9 aesni_intel, Live 0x0000000000000000
> aes_x86_64 17255 1 aesni_intel, Live 0x0000000000000000
> psmouse 97485 0 - Live 0x0000000000000000
> dell_laptop 18119 0 - Live 0x0000000000000000
> soundcore 15091 1 snd, Live 0x0000000000000000
> mei 41616 0 - Live 0x0000000000000000 (C)
> snd_page_alloc 18529 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
> cfg80211 205774 2 iwlwifi,mac80211, Live 0x0000000000000000
> mac_hid 13253 0 - Live 0x0000000000000000
> dcdbas 14490 1 dell_laptop, Live 0x0000000000000000
> coretemp 13525 0 - Live 0x0000000000000000
> serio_raw 13211 0 - Live 0x0000000000000000
> dell_wmi 12681 0 - Live 0x0000000000000000
> sparse_keymap 13890 1 dell_wmi, Live 0x0000000000000000
> lp 17799 0 - Live 0x0000000000000000
> parport 46562 3 parport_pc,ppdev,lp, Live 0x0000000000000000
> usbhid 47238 0 - Live 0x0000000000000000
> hid 99636 1 usbhid, Live 0x0000000000000000
> i915 477602 2 - Live 0x0000000000000000
> drm_kms_helper 46978 1 i915, Live 0x0000000000000000
> r8168 244753 0 - Live 0x0000000000000000 (O)
> drm 241971 3 i915,drm_kms_helper, Live 0x0000000000000000
> i2c_algo_bit 13423 1 i915, Live 0x0000000000000000
> wmi 19256 1 dell_wmi, Live 0x0000000000000000
> video 19596 1 i915, Live 0x0000000000000000
> 
> 
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> 
> soos@soos-Vostro-3560:~$ cat /proc/ioports /proc/iomem
> 0000-0cf7 : PCI Bus 0000:00
>   0000-001f : dma1
>   0020-0021 : pic1
>   0040-0043 : timer0
>   0050-0053 : timer1
>   0060-0060 : keyboard
>   0062-0062 : EC data
>   0064-0064 : keyboard
>   0066-0066 : EC cmd
>   0070-0077 : rtc0
>   0080-008f : dma page reg
>   00a0-00a1 : pic2
>   00c0-00df : dma2
>   00f0-00ff : fpu
>   0400-0453 : pnp 00:05
>     0400-0403 : ACPI PM1a_EVT_BLK
>     0404-0405 : ACPI PM1a_CNT_BLK
>     0408-040b : ACPI PM_TMR
>     0410-0415 : ACPI CPU throttle
>     0420-042f : ACPI GPE0_BLK
>     0450-0450 : ACPI PM2_CNT_BLK
>   0454-0457 : pnp 00:07
>   0458-047f : pnp 00:05
>   0500-057f : pnp 00:05
>   0680-069f : pnp 00:05
> 0cf8-0cff : PCI conf1
> 0d00-ffff : PCI Bus 0000:00
>   1000-100f : pnp 00:05
>   164e-164f : pnp 00:05
>   2000-2fff : PCI Bus 0000:09
>   3000-3fff : PCI Bus 0000:07
>     3000-30ff : 0000:07:00.0
>       3000-30ff : r8168
>   4000-4fff : PCI Bus 0000:01
>     4000-40ff : 0000:01:00.0
>   5000-503f : 0000:00:02.0
>   5040-505f : 0000:00:1f.3
>   5060-507f : 0000:00:1f.2
>     5060-507f : ahci
>   5080-5087 : 0000:00:1f.2
>     5080-5087 : ahci
>   5088-508f : 0000:00:1f.2
>     5088-508f : ahci
>   5090-5093 : 0000:00:1f.2
>     5090-5093 : ahci
>   5094-5097 : 0000:00:1f.2
>     5094-5097 : ahci
>   fd60-fd63 : pnp 00:05
>   ffff-ffff : pnp 00:05
>     ffff-ffff : pnp 00:05
> 00000000-0000ffff : reserved
> 00010000-0009d7ff : System RAM
> 0009d800-0009ffff : reserved
> 000a0000-000bffff : PCI Bus 0000:00
> 000c0000-000cedff : Video ROM
> 000cf000-000cffff : Adapter ROM
> 000e0000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-1fffffff : System RAM
>   01000000-0166a94b : Kernel code
>   0166a94c-01ce51ff : Kernel data
>   01dd5000-01f29fff : Kernel bss
> 20000000-201fffff : reserved
>   20000000-201fffff : pnp 00:0c
> 20200000-40003fff : System RAM
> 40004000-40004fff : reserved
>   40004000-40004fff : pnp 00:0c
> 40005000-9aabefff : System RAM
> 9aabf000-9aebefff : reserved
> 9aebf000-9afbefff : ACPI Non-volatile Storage
> 9afbf000-9affefff : ACPI Tables
> 9afff000-9affffff : System RAM
> 9b000000-9f9fffff : reserved
> 9fa00000-feafffff : PCI Bus 0000:00
>   9fa00000-9fa00fff : pnp 00:0b
>   a0000000-afffffff : PCI Bus 0000:01
>     a0000000-afffffff : 0000:01:00.0
>   b0000000-bfffffff : 0000:00:02.0
>   c0000000-c0ffffff : PCI Bus 0000:09
>   c1000000-c1ffffff : PCI Bus 0000:09
>   c2000000-c2ffffff : PCI Bus 0000:01
>     c2000000-c201ffff : 0000:01:00.0
>     c2020000-c203ffff : 0000:01:00.0
>   c3000000-c33fffff : 0000:00:02.0
>   c3400000-c34fffff : PCI Bus 0000:07
>     c3400000-c3403fff : 0000:07:00.0
>       c3400000-c3403fff : r8168
>     c3404000-c3404fff : 0000:07:00.0
>       c3404000-c3404fff : r8168
>   c3500000-c35fffff : PCI Bus 0000:08
>     c3500000-c3501fff : 0000:08:00.0
>       c3500000-c3501fff : iwlwifi
>   c3600000-c360ffff : 0000:00:14.0
>     c3600000-c360ffff : xhci_hcd
>   c3610000-c3613fff : 0000:00:1b.0
>     c3610000-c3613fff : ICH HD audio
>   c3614000-c361400f : 0000:00:16.0
>     c3614000-c361400f : mei
>   c3615000-c36150ff : 0000:00:1f.3
>   c3617000-c36177ff : 0000:00:1f.2
>     c3617000-c36177ff : ahci
>   c3618000-c36183ff : 0000:00:1d.0
>     c3618000-c36183ff : ehci_hcd
>   c3619000-c36193ff : 0000:00:1a.0
>     c3619000-c36193ff : ehci_hcd
>   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>     e0000000-efffffff : reserved
>       e0000000-efffffff : pnp 00:0b
> feb00000-feb03fff : reserved
> fec00000-fec00fff : reserved
>   fec00000-fec003ff : IOAPIC 0
> fed00000-fed003ff : HPET 0
> fed10000-fed19fff : reserved
>   fed10000-fed17fff : pnp 00:0b
>   fed18000-fed18fff : pnp 00:0b
>   fed19000-fed19fff : pnp 00:0b
> fed1c000-fed1ffff : reserved
>   fed1c000-fed1ffff : pnp 00:0b
> fed20000-fed3ffff : pnp 00:0b
> fed90000-fed93fff : pnp 00:0b
> fee00000-fee00fff : Local APIC
>   fee00000-fee00fff : reserved
> ff000000-ff000fff : pnp 00:0b
> ffb80000-ffffffff : reserved
> 100000000-35f5fffff : System RAM
> 35f600000-35fffffff : RAM buffer
> 
> 
> [7.5.] PCI information ('lspci -vvv' as root)
> soos@soos-Vostro-3560:~$ sudo lspci -vvv
> 00:00.0 Host bridge: Intel Corporation Ivy Bridge DRAM Controller (rev 09)
>         Subsystem: Dell Device 056e
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR-
> <PERR- INTx-
>         Latency: 0
>         Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>         Kernel driver in use: agpgart-intel
> 
> 00:01.0 PCI bridge: Intel Corporation Ivy Bridge PCI Express Root Port (rev 09) (prog-if 00 [Normal
> decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=01, subordinate=06, sec-latency=0
>         I/O behind bridge: 00004000-00004fff
>         Memory behind bridge: c2000000-c2ffffff
>         Prefetchable memory behind bridge: 00000000a0000000-00000000afffffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [88] Subsystem: Dell Device 056e
>         Capabilities: [80] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                 Address: feeff00c  Data: 4169
>         Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 256 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>                 LnkCap: Port #2, Speed unknown, Width x8, ASPM L0s L1, Latency L0 <256ns, L1 <8us
>                         ClockPM- Surprise- LLActRep- BwNot+
>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt+
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
>                         Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>                         Changed: MRL- PresDet+ LinkState-
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                 DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>                 LnkCtl2: Target Link Speed: Unknown, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -3.5dB
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -3.5dB
>         Capabilities: [100 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                         Status: NegoPending- InProgress-
>         Capabilities: [140 v1] Root Complex Link
>                 Desc:   PortNumber=02 ComponentID=01 EltType=Config
>                 Link0:  Desc:   TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped
> LinkValid+
>                         Addr:   00000000fed19000
>         Capabilities: [d94 v1] #19
>         Kernel driver in use: pcieport
>         Kernel modules: shpchp
> 
> 00:02.0 VGA compatible controller: Intel Corporation Ivy Bridge Graphics Controller (rev 09)
> (prog-if 00 [VGA controller])
>         Subsystem: Dell Device 056e
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 44
>         Region 0: Memory at c3000000 (64-bit, non-prefetchable) [size=4M]
>         Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
>         Region 4: I/O ports at 5000 [size=64]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                 Address: fee3000c  Data: 4191
>         Capabilities: [d0] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [a4] PCI Advanced Features
>                 AFCap: TP+ FLR+
>                 AFCtrl: FLR-
>                 AFStatus: TP-
>         Kernel driver in use: i915
>         Kernel modules: i915
> 
> 00:14.0 USB controller: Intel Corporation Panther Point USB xHCI Host Controller (rev 04) (prog-if
> 30 [XHCI])
>         Subsystem: Dell Device 056e
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 42
>         Region 0: Memory at c3600000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [70] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
>                 Address: 00000000fee0100c  Data: 4181
>         Kernel driver in use: xhci_hcd
> 
> 00:16.0 Communication controller: Intel Corporation Panther Point MEI Controller #1 (rev 04)
>         Subsystem: Dell Device 056e
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 45
>         Region 0: Memory at c3614000 (64-bit, non-prefetchable) [size=16]
>         Capabilities: [50] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000feeff00c  Data: 4199
>         Kernel driver in use: mei
>         Kernel modules: mei
> 
> 00:1a.0 USB controller: Intel Corporation Panther Point USB Enhanced Host Controller #2 (rev 04)
> (prog-if 20 [EHCI])
>         Subsystem: Dell Device 056e
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at c3619000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Capabilities: [98] PCI Advanced Features
>                 AFCap: TP+ FLR+
>                 AFCtrl: FLR-
>                 AFStatus: TP+
>         Kernel driver in use: ehci_hcd
> 
> 00:1b.0 Audio device: Intel Corporation Panther Point High Definition Audio Controller (rev 04)
>         Subsystem: Dell Device 056e
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 47
>         Region 0: Memory at c3610000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000fee3000c  Data: 41b1
>         Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag- RBE- FLReset+
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
>                         ClockPM- Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [100 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>                         Status: NegoPending- InProgress-
>                 VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                         Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=22
>                         Status: NegoPending- InProgress-
>         Capabilities: [130 v1] Root Complex Link
>                 Desc:   PortNumber=0f ComponentID=00 EltType=Config
>                 Link0:  Desc:   TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped
> LinkValid+
>                         Addr:   00000000fed1c000
>         Kernel driver in use: snd_hda_intel
>         Kernel modules: snd-hda-intel
> 
> 00:1c.0 PCI bridge: Intel Corporation Panther Point PCI Express Root Port 1 (rev c4) (prog-if 00
> [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
>         I/O behind bridge: 00003000-00003fff
>         Memory behind bridge: fff00000-000fffff
>         Prefetchable memory behind bridge: 00000000c3400000-00000000c34fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>                 LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
>                         ClockPM- Surprise- LLActRep+ BwNot-
>                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
>                         Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>                         Changed: MRL- PresDet- LinkState+
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -6dB
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -3.5dB
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>                 Address: 00000000  Data: 0000
>         Capabilities: [90] Subsystem: Dell Device 056e
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: pcieport
>         Kernel modules: shpchp
> 
> 00:1c.1 PCI bridge: Intel Corporation Panther Point PCI Express Root Port 2 (rev c4) (prog-if 00
> [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
>         I/O behind bridge: 0000f000-00000fff
>         Memory behind bridge: c3500000-c35fffff
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>                 LnkCap: Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
>                         ClockPM- Surprise- LLActRep+ BwNot-
>                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
>                         Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>                         Changed: MRL- PresDet- LinkState+
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -6dB
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -3.5dB
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>                 Address: 00000000  Data: 0000
>         Capabilities: [90] Subsystem: Dell Device 056e
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: pcieport
>         Kernel modules: shpchp
> 
> 00:1c.2 PCI bridge: Intel Corporation Panther Point PCI Express Root Port 3 (rev c4) (prog-if 00
> [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=09, subordinate=0e, sec-latency=0
>         I/O behind bridge: 00002000-00002fff
>         Memory behind bridge: c1000000-c1ffffff
>         Prefetchable memory behind bridge: 00000000c0000000-00000000c0ffffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>                 LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
>                         ClockPM- Surprise- LLActRep+ BwNot-
>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
>                         Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
>                         Changed: MRL- PresDet- LinkState-
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -6dB
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -3.5dB
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>                 Address: 00000000  Data: 0000
>         Capabilities: [90] Subsystem: Dell Device 056e
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: pcieport
>         Kernel modules: shpchp
> 
> 00:1d.0 USB controller: Intel Corporation Panther Point USB Enhanced Host Controller #1 (rev 04)
> (prog-if 20 [EHCI])
>         Subsystem: Dell Device 056e
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 23
>         Region 0: Memory at c3618000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Capabilities: [98] PCI Advanced Features
>                 AFCap: TP+ FLR+
>                 AFCtrl: FLR-
>                 AFStatus: TP-
>         Kernel driver in use: ehci_hcd
> 
> 00:1f.0 ISA bridge: Intel Corporation Panther Point LPC Controller (rev 04)
>         Subsystem: Dell Device 056e
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0
>         Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>         Kernel modules: iTCO_wdt
> 
> 00:1f.2 SATA controller: Intel Corporation Panther Point 6 port SATA Controller [AHCI mode] (rev 04)
> (prog-if 01 [AHCI 1.0])
>         Subsystem: Dell Device 056e
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 41
>         Region 0: I/O ports at 5088 [size=8]
>         Region 1: I/O ports at 5094 [size=4]
>         Region 2: I/O ports at 5080 [size=8]
>         Region 3: I/O ports at 5090 [size=4]
>         Region 4: I/O ports at 5060 [size=32]
>         Region 5: Memory at c3617000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                 Address: fee0300c  Data: 4179
>         Capabilities: [70] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
>         Capabilities: [b0] PCI Advanced Features
>                 AFCap: TP+ FLR+
>                 AFCtrl: FLR-
>                 AFStatus: TP-
>         Kernel driver in use: ahci
> 
> 00:1f.3 SMBus: Intel Corporation Panther Point SMBus Controller (rev 04)
>         Subsystem: Dell Device 056e
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Interrupt: pin C routed to IRQ 10
>         Region 0: Memory at c3615000 (64-bit, non-prefetchable) [size=256]
>         Region 4: I/O ports at 5040 [size=32]
>         Kernel modules: i2c-i801
> 
> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Thames XT/GL [Radeon HD
> 7600M Series] (prog-if 00 [VGA controller])
>         Subsystem: Dell Device 056e
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 48
>         Region 0: Memory at a0000000 (64-bit, prefetchable) [size=256M]
>         Region 2: Memory at c2000000 (64-bit, non-prefetchable) [size=128K]
>         Region 4: I/O ports at 4000 [size=256]
>         Expansion ROM at c2020000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 3
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
>                         ClockPM- Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -6dB
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -3.5dB
>         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000feeff00c  Data: 41b9
>         Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
>         Capabilities: [150 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC-
> UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                 AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap+ ChkEn-
>         Kernel driver in use: fglrx_pci
>         Kernel modules: fglrx, radeon
> 
> 07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit
> Ethernet controller (rev 07)
>         Subsystem: Dell Device 056e
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 43
>         Region 0: I/O ports at 3000 [size=256]
>         Region 2: Memory at c3404000 (64-bit, prefetchable) [size=4K]
>         Region 4: Memory at c3400000 (64-bit, prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 3
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000feeff00c  Data: 4189
>         Capabilities: [70] Express (v2) Endpoint, MSI 01
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
>                         ClockPM+ Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -6dB
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -6dB
>         Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
>                 Vector table: BAR=4 offset=00000000
>                 PBA: BAR=4 offset=00000800
>         Capabilities: [d0] Vital Product Data
>                 No end tag found
>         Capabilities: [100 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC-
> UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>         Capabilities: [140 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                         Status: NegoPending- InProgress-
>         Capabilities: [160 v1] Device Serial Number 00-00-00-00-68-4c-e0-00
>         Kernel driver in use: r8168
>         Kernel modules: r8168
> 
> 08:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev c4)
>         Subsystem: Intel Corporation Centrino Wireless-N 2230 BGN
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 46
>         Region 0: Memory at c3500000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [c8] Power Management version 3
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000fee0100c  Data: 41a1
>         Capabilities: [e0] Express (v1) Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <32us
>                         ClockPM+ Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                         ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [100 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC-
> UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                 AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
>         Capabilities: [140 v1] Device Serial Number 68-5d-43-ff-ff-21-98-37
>         Kernel driver in use: iwlwifi
>         Kernel modules: iwlwifi
> 
> 
> [7.6.] SCSI information (from /proc/scsi/scsi)
> soos@soos-Vostro-3560:~$ cat  /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: ST9750420AS      Rev: 0002
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>   Vendor: Optiarc  Model: BD RW BD-5750H   Rev: 1.00
>   Type:   CD-ROM                           ANSI  SCSI revision: 05
> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>   Vendor: Generic- Model: xD/SD/M.S.       Rev: 1.00
>   Type:   Direct-Access                    ANSI  SCSI revision: 02
> 
> 
> [7.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):
> soos@soos-Vostro-3560:~$ lsmod
> Module                  Size  Used by
> sit                    21759  0
> tunnel4                13213  1 sit
> pci_stub               12622  1
> vboxpci                23237  0
> vboxnetadp             25670  0
> vboxnetflt             23478  0
> vboxdrv               320210  3 vboxpci,vboxnetadp,vboxnetflt
> bnep                   18281  2
> rfcomm                 47604  16
> kvm_intel             137721  0
> kvm                   415550  1 kvm_intel
> parport_pc             32866  0
> ppdev                  17113  0
> binfmt_misc            17540  1
> snd_hda_codec_hdmi     32474  1
> snd_hda_codec_conexant    62358  1
> arc4                   12529  2
> snd_hda_intel          33773  3
> snd_hda_codec         127706  3 snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel
> uvcvideo               72627  0
> snd_hwdep              17764  1 snd_hda_codec
> fglrx                5198957  218
> snd_pcm                97275  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
> videodev               98259  1 uvcvideo
> snd_seq_midi           13324  0
> snd_rawmidi            30748  1 snd_seq_midi
> rts5139               351188  0
> snd_seq_midi_event     14899  1 snd_seq_midi
> snd_seq                61929  2 snd_seq_midi,snd_seq_midi_event
> v4l2_compat_ioctl32    17128  1 videodev
> iwlwifi               397059  0
> joydev                 17693  0
> snd_timer              29990  2 snd_pcm,snd_seq
> snd_seq_device         14540  3 snd_seq_midi,snd_rawmidi,snd_seq
> btusb                  18332  2
> i8k                    14350  0
> bluetooth             180153  23 bnep,rfcomm,btusb
> dm_crypt               23125  1
> mac80211              506862  1 iwlwifi
> snd                    79041  16
> snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
> aesni_intel            55664  27
> cryptd                 20530  9 aesni_intel
> aes_x86_64             17255  1 aesni_intel
> psmouse                97485  0
> dell_laptop            18119  0
> soundcore              15091  1 snd
> mei                    41616  0
> snd_page_alloc         18529  2 snd_hda_intel,snd_pcm
> cfg80211              205774  2 iwlwifi,mac80211
> mac_hid                13253  0
> dcdbas                 14490  1 dell_laptop
> coretemp               13525  0
> serio_raw              13211  0
> dell_wmi               12681  0
> sparse_keymap          13890  1 dell_wmi
> lp                     17799  0
> parport                46562  3 parport_pc,ppdev,lp
> usbhid                 47238  0
> hid                    99636  1 usbhid
> i915                  477602  2
> drm_kms_helper         46978  1 i915
> r8168                 244753  0
> drm                   241971  3 i915,drm_kms_helper
> i2c_algo_bit           13423  1 i915
> wmi                    19256  1 dell_wmi
> video                  19596  1 i915
> 
> Using AMD driver 13.1 for my video card. But that seems to be entirely irrelevant.
> 
> [X.] Other notes, patches, fixes, workarounds:
> 
> I used to have this bug often before, but nowadays I am having it much less often. This I think was
> a bit particular because of the timing of the plug-in of the USB mouse.
> 
> I hope the above helps,
> 
> Mate
> 
