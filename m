Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3KXPaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 10:30:16 -0500
Received: from mail-ve0-f193.google.com ([209.85.128.193]:48518 "EHLO
	mail-ve0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3KXPaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 10:30:13 -0500
MIME-Version: 1.0
Date: Sun, 24 Nov 2013 16:30:12 +0100
Message-ID: <CAO-tThZhsgswGcZC17j62zuiyE9gvFjOTkXpbCh3Df8S_pj1HA@mail.gmail.com>
Subject: PROBLEM: Kernel 3.12.1 broke samba/SCP
From: AsD ACE <0x2766@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:
Linux kernel 3.12.1-1 breaks SCP and samba file transfers,
specifically reading access.

[2.] Full description of the problem/report:
My computer is hosting SCP and samba which serves media files (movies)
for my LAN. everything was working fine until I upgraded my system:

    [2013-11-16 10:18] [PACMAN] upgraded linux (3.11.6-1 -> 3.12-1)

and later on

On the upgrade I noticed that SCP and samba was no longer to read
files, if they managed to read files they did it at a painfully slow
rate, a 10mb movie would take more than 60minutes, the usual rate
would let me stream big files flawlessly.

I did also notice that SSH became slower, whenever a program would
fill the screen with new text it would take 2-6 seconds while normally
it would be done instantly. I even noticed that if I ran for example
'man make' it would take 6+ seconds to render the document and I could
see it slowly scroll in place, the RAM,CPU,network or disks were not
strained during any of these tests.

I did also see that when I would download torrents it would seem like
the problem disappeared, but it was a little inconsistent.

Later on I did also upgrade into:

    [2013-11-23 12:59] [PACMAN] upgraded linux (3.12-1 -> 3.12.1-1)

but the problems persisted. I decided to downgrade to

    [2013-11-24 10:49] [PACMAN] downgraded linux (3.12.1-1 -> 3.11.6-1)

and all problems disappeared. I've tried switching back and forth and
switching kernel to 3.12 is like a on and off switch for the problem.

It should be worth mentioning that 2 of my disks are external drives
mounted through USB, but the problem occurs on all disks.

[3.] Keywords (i.e., modules, networking, kernel):
kernel 3.11.6-1 vs kernel 3.12.1-1

[4.] Kernel version (from /proc/version):
Im currently running on:

Linux version 3.11.6-1-ARCH
(nobody@var-lib-archbuild-extra-i686-thomas) (gcc version 4.8.1
20130725 (prerelease) (GCC) ) #1 SMP PREEMPT Sat Oct 19 00:29:46 CEST
2013

but the problem has been seen on:
Linux arch 3.12.1-1-ARCH #1 SMP PREEMPT Thu Nov 21 09:01:05 CET 2013
i686 GNU/Linux

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)

[6.] A small shell script or example program which triggers the
     problem (if possible)
Not sure, but I tried to copy files with SCP from the external drive
but it wouldn't work.

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Sempron(tm)   2600+
stepping        : 1
cpu MHz         : 1835.955
cache size      : 256 KB
fdiv_bug        : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips        : 3673.90
clflush size    : 32
cache_alignment : 32
address sizes   : 34 bits physical, 32 bits virtual
power management: ts

[7.3.] Module information (from /proc/modules):
fuse 65975 4 - Live 0xf81b0000
snd_intel8x0 23721 0 - Live 0xf8188000
snd_ac97_codec 89336 1 snd_intel8x0, Live 0xf815d000
evdev 8208 5 - Live 0xf810b000
ppdev 5998 0 - Live 0xf80c7000
pcspkr 1487 0 - Live 0xf80be000
sis900 18235 0 - Live 0xf80b2000
serio_raw 3969 0 - Live 0xf8095000
ac97_bus 906 1 snd_ac97_codec, Live 0xf805a000
snd_pcm 63876 2 snd_intel8x0,snd_ac97_codec, Live 0xf807c000
snd_page_alloc 5942 2 snd_intel8x0,snd_pcm, Live 0xf802e000
mperf 959 0 - Live 0xf8017000
i2c_sis630 6208 0 - Live 0xf800f000
sis_agp 3461 1 - Live 0xf866a000
agpgart 22047 1 sis_agp, Live 0xf8659000
shpchp 21973 0 - Live 0xf8642000
mii 3375 1 sis900, Live 0xf8633000
parport_pc 16611 0 - Live 0xf8626000
parport 25369 2 ppdev,parport_pc, Live 0xf8610000
snd_timer 14942 1 snd_pcm, Live 0xf85fb000
i2c_core 19967 1 i2c_sis630, Live 0xf85e7000
processor 22169 0 - Live 0xf85cf000
snd 44566 4 snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer, Live 0xf85ae000
button 3685 0 - Live 0xf858c000
soundcore 4386 1 snd, Live 0xf8582000
ext4 425668 2 - Live 0xf84e4000
crc16 1091 1 ext4, Live 0xf8442000
mbcache 4290 1 ext4, Live 0xf843b000
jbd2 70221 1 ext4, Live 0xf841a000
usb_storage 37687 2 - Live 0xf83e7000
sd_mod 28311 7 - Live 0xf83ba000
sr_mod 13055 0 - Live 0xf83a4000
cdrom 29900 1 sr_mod, Live 0xf8390000
ata_generic 2434 0 - Live 0xf837f000
pata_acpi 2367 0 - Live 0xf8377000
pata_sis 7722 2 - Live 0xf836a000
libata 149201 3 ata_generic,pata_acpi,pata_sis, Live 0xf8329000
ohci_pci 3228 0 - Live 0xf82d5000
ohci_hcd 21553 1 ohci_pci, Live 0xf82c7000
ehci_pci 3404 0 - Live 0xf82b6000
ehci_hcd 42788 1 ehci_pci, Live 0xf82a2000
usbcore 152939 5 usb_storage,ohci_pci,ohci_hcd,ehci_pci,ehci_hcd, Live
0xf80e4000
usb_common 1399 1 usbcore, Live 0xf808f000
scsi_mod 108590 4 usb_storage,sd_mod,sr_mod,libata, Live 0xf8060000
floppy 48486 0 - Live 0xf801a000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:02.5
  0170-0177 : pata_sis
01f0-01f7 : 0000:00:02.5
  01f0-01f7 : pata_sis
0290-029f : pnp 00:01
02f8-02ff : serial
0376-0376 : 0000:00:02.5
  0376-0376 : pata_sis
0378-037a : parport0
03c0-03df : vga+
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:02.5
  03f6-03f6 : pata_sis
03f7-03f7 : floppy
03f8-03ff : serial
04d0-04d1 : pnp 00:01
0800-0805 : pnp 00:01
0cf8-0cff : PCI conf1
1000-1003 : ACPI PM1a_EVT_BLK
1004-1005 : ACPI PM1a_CNT_BLK
1008-100b : ACPI PM_TMR
1016-1016 : ACPI PM2_CNT_BLK
1020-1023 : ACPI GPE0_BLK
1030-1033 : ACPI GPE1_BLK
d000-dfff : PCI Bus 0000:01
  d000-d07f : 0000:01:00.0
e000-e0ff : 0000:00:02.7
  e000-e0ff : SiS SI7012
e400-e47f : 0000:00:02.7
  e400-e47f : SiS SI7012
e800-e8ff : 0000:00:04.0
  e800-e8ff : sis900
ec00-ec07 : 0000:00:0b.0
f000-f00f : 0000:00:02.5
  f000-f00f : pata_sis


00000000-00000fff : reserved
00001000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000d0000-000d9fff : Adapter ROM
000da000-000dbfff : pnp 00:00
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7dfeffff : System RAM
  00100000-00529d5d : Kernel code
  00529d5e-006e89ff : Kernel data
  00786000-00872fff : Kernel bss
7dff0000-7dff2fff : ACPI Non-volatile Storage
7dff3000-7dffffff : ACPI Tables
7e000000-7fffffff : RAM buffer
80000000-8001ffff : 0000:00:04.0
e0000000-e7ffffff : PCI Bus 0000:01
  e0000000-e7ffffff : 0000:01:00.0
e8000000-ebffffff : 0000:00:00.0
ed000000-ed0fffff : PCI Bus 0000:01
  ed000000-ed01ffff : 0000:01:00.0
ed100000-ed10ffff : 0000:00:0b.0
ed110000-ed110fff : 0000:00:03.2
  ed110000-ed110fff : ohci_hcd
ed111000-ed111fff : 0000:00:03.3
  ed111000-ed111fff : ehci_hcd
ed112000-ed112fff : 0000:00:04.0
  ed112000-ed112fff : sis900
ed113000-ed113fff : 0000:00:03.0
  ed113000-ed113fff : ohci_hcd
ed114000-ed114fff : 0000:00:03.1
  ed114000-ed114fff : ohci_hcd
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ffee0000-ffefffff : pnp 00:00
fffe0000-fffeffff : pnp 00:00
ffff0000-ffffffff : reserved
  ffff0000-ffffffff : pnp 00:00


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Silicon Integrated Systems [SiS] 741/741GX/M741
Host (rev 03)
Subsystem: Gigabyte Technology Co., Ltd Device 5000
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
Latency: 32
Region 0: Memory at e8000000 (32-bit, non-prefetchable) [size=64M]
Capabilities: [c0] AGP version 3.5
Status: RQ=32 Iso- ArqSz=2 Cal=3 SBA+ ITACoh- GART64- HTrans- 64bit-
FW- AGP3+ Rate=x4,x8
Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
Kernel driver in use: agpgart-sis
Kernel modules: sis_agp

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] AGP Port (virtual
PCI-to-PCI bridge) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 99
Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: ed000000-ed0fffff
Prefetchable memory behind bridge: e0000000-e7ffffff
Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Kernel modules: shpchp

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL
Media IO] LPC Controller (rev 36)
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Kernel modules: i2c_sis630

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 IDE
Controller (rev 01) (prog-if 80 [Master])
Subsystem: Gigabyte Technology Co., Ltd Device 5002
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 128
Interrupt: pin ? routed to IRQ 16
Region 0: I/O ports at 01f0 [size=8]
Region 1: I/O ports at 03f4
Region 2: I/O ports at 0170 [size=8]
Region 3: I/O ports at 0374
Region 4: I/O ports at f000 [size=16]
Kernel driver in use: pata_sis
Kernel modules: pata_sis, pata_acpi, ata_generic

00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS]
SiS7012 AC'97 Sound Controller (rev a0)
Subsystem: Gigabyte Technology Co., Ltd Device a002
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32 (13000ns min, 2750ns max)
Interrupt: pin C routed to IRQ 18
Region 0: I/O ports at e000 [size=256]
Region 1: I/O ports at e400 [size=128]
Capabilities: [48] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: snd_intel8x0
Kernel modules: snd_intel8x0

00:03.0 USB controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
Subsystem: Gigabyte Technology Co., Ltd Device 5004
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32 (20000ns max), Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 20
Region 0: Memory at ed113000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:03.1 USB controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
Subsystem: Gigabyte Technology Co., Ltd Device 5004
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32 (20000ns max), Cache Line Size: 32 bytes
Interrupt: pin B routed to IRQ 21
Region 0: Memory at ed114000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:03.2 USB controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
Subsystem: Gigabyte Technology Co., Ltd Device 5004
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32 (20000ns max), Cache Line Size: 32 bytes
Interrupt: pin C routed to IRQ 22
Region 0: Memory at ed110000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:03.3 USB controller: Silicon Integrated Systems [SiS] USB 2.0
Controller (prog-if 20 [EHCI])
Subsystem: Gigabyte Technology Co., Ltd Device 5004
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32 (20000ns max), Cache Line Size: 32 bytes
Interrupt: pin D routed to IRQ 23
Region 0: Memory at ed111000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ehci-pci
Kernel modules: ehci_pci

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900
PCI Fast Ethernet (rev 90)
Subsystem: Gigabyte Technology Co., Ltd Device e000
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32 (13000ns min, 2750ns max)
Interrupt: pin A routed to IRQ 19
Region 0: I/O ports at e800 [size=256]
Region 1: Memory at ed112000 (32-bit, non-prefetchable) [size=4K]
[virtual] Expansion ROM at 80000000 [disabled] [size=128K]
Capabilities: [40] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: sis900
Kernel modules: sis900

00:0b.0 Communication controller: Conexant Systems, Inc. HSF 56k HSFi
Modem (rev 01)
Subsystem: GVC Corporation Device 8d89
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32
Interrupt: pin A routed to IRQ 11
Region 0: Memory at ed100000 (32-bit, non-prefetchable) [size=64K]
Region 1: I/O ports at ec00 [size=8]
Capabilities: [40] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
661/741/760 PCI/AGP or 662/761Gx PCIE VGA Display Adapter (prog-if 00
[VGA controller])
Subsystem: Gigabyte Technology Co., Ltd SiS661FX GUI 2D/3D Accelerator
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin A routed to IRQ 10
BIST result: 00
Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
Region 1: Memory at ed000000 (32-bit, non-prefetchable) [size=128K]
Region 2: I/O ports at d000 [size=128]
Expansion ROM at <unassigned> [disabled]
Capabilities: [40] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] AGP version 3.0
Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW- AGP3+ Rate=x4,x8
Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>



[7.6.] SCSI information (from /proc/scsi/scsi)


Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD400BB-00JH Rev: 05.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: CD-RW    Model: 52X32-L0         Rev: QRS5
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ST1000LM Model: 010-9YH146       Rev: CC9F
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: Hitachi  Model: HTS545050B9A300  Rev: PB4O
  Type:   Direct-Access                    ANSI  SCSI revision: 02


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
not sure

[X.] Other notes, patches, fixes, workarounds:
Downloading files with torrent seem to make the problem disappear on
kernel 3.12.1, but it's inconsistent.
