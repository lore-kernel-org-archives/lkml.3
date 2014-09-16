Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaIPW0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:26:54 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:41716 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIPW0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:26:53 -0400
MIME-Version: 1.0
Date: Tue, 16 Sep 2014 18:26:51 -0400
Message-ID: <CABr5XP2w_oJj8=fOnxBW2oymNp0Eci-z-FvsWxL4eXEPcXHdNA@mail.gmail.com>
Subject: PROBLEM: sata_sil driver broken
From: Steve Volumetric <volumetricsteve@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the sata_sil driver for silicon image sata controllers isn't working
in kernel 3.16.1

upon boot, the driver loads and tries to access hardware, but runs
into error -16 and then boot proceeds.  checking /dev/ for any
attached sata devices is unsuccessful.

Sep 15 13:25:57 archiso kernel: sata_sil 0000:02:0c.0: version 2.4
Sep 15 13:25:57 archiso kernel: genirq: Flags mismatch irq 6. 00000080
(sata_sil) vs. 00000000 (floppy)
Sep 15 13:25:57 archiso kernel: sata_sil: probe of 0000:02:0c.0 failed
with error -16

Kernel full name: 3.16.1-1-ARCH

Booting the system on any machine containing an Adaptec 1210sa ( a
fancy silicon image Sata Link Sil 3112 controller)

possible workarounds seem to only be doable by using older kernels not
impacted by the issue.

cpuinfo:
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 8
model name : Pentium III (Coppermine)
stepping : 3
microcode : 0x14
cpu MHz : 930.942
cache size : 256 KB
physical id : 0
siblings : 1
core id : 0
cpu cores : 1
apicid : 0
initial apicid : 0
fdiv_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 2
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pse36
mmx fxsr sse
bogomips : 1862.46
clflush size : 32
cache_alignment : 32
address sizes : 36 bits physical, 32 bits virtual
power management:

iomem:
00000000-00000fff : reserved
00001000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ce5ff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-1ffbffff : System RAM
  01000000-01468439 : Kernel code
  0146843a-0162ec7f : Kernel data
  016c2000-0178ffff : Kernel bss
1ffc0000-1fff7fff : ACPI Tables
1fff8000-1fffffff : ACPI Non-volatile Storage
d6900000-f69fffff : PCI Bus 0000:01
  e0000000-efffffff : 0000:01:00.0
f6a00000-f6afffff : PCI Bus 0000:02
f8000000-fbffffff : 0000:00:00.0
ff700000-ff7fffff : PCI Bus 0000:01
  ff7c0000-ff7dffff : 0000:01:00.0
  ff7e0000-ff7effff : 0000:01:00.1
  ff7f0000-ff7fffff : 0000:01:00.0
ff800000-ff9fffff : PCI Bus 0000:02
  ff900000-ff97ffff : 0000:02:0c.0
  ff980000-ff99ffff : 0000:02:09.0
  ff9a0000-ff9bffff : 0000:02:09.0
    ff9a0000-ff9bffff : e1000
  ff9c0000-ff9dffff : 0000:02:09.0
    ff9c0000-ff9dffff : e1000
  ff9ffc00-ff9ffdff : 0000:02:0c.0
ffb00000-ffbfffff : INT0800:00
  ffb80000-ffbfffff : reserved
fff00000-ffffffff : reserved
  fff00000-ffffffff : INT0800:00

ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0061-0061 : PNP0800:00
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : PNP0C04:00
  00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
02f8-02ff : serial
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
03f8-03ff : serial
0400-0403 : ACPI PM1a_EVT_BLK
0404-0405 : ACPI PM1a_CNT_BLK
0408-040b : ACPI PM_TMR
0410-0415 : ACPI CPU throttle
0428-042b : ACPI GPE0_BLK
042c-042f : ACPI GPE1_BLK
0430-0433 : iTCO_wdt
  0430-0433 : iTCO_wdt
0460-047f : iTCO_wdt
  0460-047f : iTCO_wdt
0500-053f : 0000:00:1f.0
0cf8-0cff : PCI conf1
c000-cfff : PCI Bus 0000:01
  c800-c8ff : 0000:01:00.0
d000-dfff : PCI Bus 0000:02
  df00-df3f : 0000:02:09.0
    df00-df3f : e1000
  df90-df9f : 0000:02:0c.0
  dfa8-dfaf : 0000:02:0c.0
  dfe0-dfe3 : 0000:02:0c.0
  dfe4-dfe7 : 0000:02:0c.0
  dff0-dff7 : 0000:02:0c.0
ef80-ef9f : 0000:00:1f.2
  ef80-ef9f : uhci_hcd
efa0-efaf : 0000:00:1f.3
  efa0-efaf : i801_smbus
ffa0-ffaf : 0000:00:1f.1
  ffa0-ffaf : ata_piix

lspci:
00:00.0 Host bridge: Intel Corporation 82820 820 (Camino) Chipset Host
Bridge (MCH) (rev 03)
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
Latency: 0
Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
Capabilities: [a0] AGP version 2.0
Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW- AGP3- Rate=x1,x2,x4
Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
Kernel driver in use: agpgart-intel
Kernel modules: intel_agp

00:01.0 PCI bridge: Intel Corporation 82820 820 (Camino) Chipset AGP
Bridge (rev 03) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64
Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
I/O behind bridge: 0000c000-0000cfff
Memory behind bridge: ff700000-ff7fffff
Prefetchable memory behind bridge: d6900000-f69fffff
Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Kernel modules: shpchp

00:1e.0 PCI bridge: Intel Corporation 82801AA PCI Bridge (rev 02)
(prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: ff800000-ff9fffff
Prefetchable memory behind bridge: f6a00000-f6afffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Kernel modules: shpchp

00:1f.0 ISA bridge: Intel Corporation 82801AA ISA Bridge (LPC) (rev 02)
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Kernel driver in use: lpc_ich
Kernel modules: intel_rng, lpc_ich

00:1f.1 IDE interface: Intel Corporation 82801AA IDE Controller (rev
02) (prog-if 80 [Master])
Subsystem: Intel Corporation 82801AA IDE Controller
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
Region 4: I/O ports at ffa0 [size=16]
Kernel driver in use: ata_piix
Kernel modules: ata_piix, pata_acpi, ata_generic

00:1f.2 USB controller: Intel Corporation 82801AA USB Controller (rev
02) (prog-if 00 [UHCI])
Subsystem: Intel Corporation 82801AA USB Controller
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin D routed to IRQ 9
Region 4: I/O ports at ef80 [size=32]
Kernel driver in use: uhci_hcd
Kernel modules: uhci_hcd

00:1f.3 SMBus: Intel Corporation 82801AA SMBus Controller (rev 02)
Subsystem: Intel Corporation 82801AA SMBus Controller
Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin B routed to IRQ 15
Region 4: I/O ports at efa0 [size=16]
Kernel driver in use: i801_smbus
Kernel modules: i2c_i801

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] R430 [Radeon X800 XL] (prog-if 00 [VGA controller])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0302
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (2000ns min), Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 11
Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
Region 1: I/O ports at c800 [size=256]
Region 2: Memory at ff7f0000 (32-bit, non-prefetchable) [size=64K]
Expansion ROM at ff7c0000 [disabled] [size=128K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] AGP version 2.0
Status: RQ=80 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW+ AGP3- Rate=x1,x2,x4
Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Kernel driver in use: radeon
Kernel modules: radeon

01:00.1 Display controller: Advanced Micro Devices, Inc. [AMD/ATI]
R430 [Radeon X800 XL] (Secondary)
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0303
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (2000ns min), Cache Line Size: 32 bytes
Region 0: Memory at ff7e0000 (32-bit, non-prefetchable) [size=64K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

02:09.0 Ethernet controller: Intel Corporation 82541PI Gigabit
Ethernet Controller (rev 05)
Subsystem: Intel Corporation PRO/1000 GT Desktop Adapter
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (63750ns min), Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 15
Region 0: Memory at ff9c0000 (32-bit, non-prefetchable) [size=128K]
Region 1: Memory at ff9a0000 (32-bit, non-prefetchable) [size=128K]
Region 2: I/O ports at df00 [size=64]
Expansion ROM at ff980000 [disabled] [size=128K]
Capabilities: [dc] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
Capabilities: [e4] PCI-X non-bridge device
Command: DPERE- ERO+ RBC=512 OST=1
Status: Dev=00:00.0 64bit- 133MHz- SCD- USC- DC=simple DMMRBC=2048
DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
Kernel driver in use: e1000
Kernel modules: e1000

02:0c.0 RAID bus controller: Silicon Image, Inc. Adaptec AAR-1210SA
SATA HostRAID Controller (rev 02) (prog-if 01)
Subsystem: Adaptec Device 0240
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin A routed to IRQ 6
Region 0: I/O ports at dff0 [size=8]
Region 1: I/O ports at dfe4 [size=4]
Region 2: I/O ports at dfa8 [size=8]
Region 3: I/O ports at dfe0 [size=4]
Region 4: I/O ports at df90 [size=16]
Region 5: Memory at ff9ffc00 (32-bit, non-prefetchable) [size=512]
Expansion ROM at ff900000 [disabled] [size=512K]
Capabilities: [60] Power Management version 2
Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
Kernel modules: sata_sil

modules:
nls_iso8859_1 12421 1 - Live 0xe14c1000
nls_cp437 12417 1 - Live 0xe1484000
vfat 16967 1 - Live 0xe14bb000
fat 56741 1 vfat, Live 0xe149f000
sd_mod 43684 2 - Live 0xe14af000
crc_t10dif 12399 1 sd_mod, Live 0xe147f000
crct10dif_generic 12517 1 - Live 0xe1455000
crct10dif_common 12340 2 crc_t10dif,crct10dif_generic, Live 0xe0c11000
usb_storage 43391 1 - Live 0xe1555000
snd_wavefront 34598 0 - Live 0xe146d000
snd_cs4236 26360 0 - Live 0xe1445000
snd_wss_lib 26533 2 snd_wavefront,snd_cs4236, Live 0xe1477000
snd_opl3_lib 17206 2 snd_wavefront,snd_cs4236, Live 0xe1437000
snd_hwdep 12906 2 snd_wavefront,snd_opl3_lib, Live 0xe0ef6000
snd_pcm 73796 2 snd_cs4236,snd_wss_lib, Live 0xe148b000
snd_timer 22010 3 snd_wss_lib,snd_opl3_lib,snd_pcm, Live 0xe144e000
microcode 17661 0 - Live 0xe143f000
iTCO_wdt 12727 0 - Live 0xe0efb000
iTCO_vendor_support 12585 1 iTCO_wdt, Live 0xe0aa0000
ppdev 16686 0 - Live 0xe0aa5000
snd_mpu401_uart 13299 2 snd_wavefront,snd_cs4236, Live 0xe0a9b000
pcspkr 12531 0 - Live 0xe0a92000
serio_raw 12737 0 - Live 0xe0ef1000
snd_rawmidi 22285 2 snd_wavefront,snd_mpu401_uart, Live 0xe0c21000
ns558 12395 0 - Live 0xe0af2000
snd_seq_device 12980 2 snd_opl3_lib,snd_rawmidi, Live 0xe08fa000
gameport 13270 1 ns558, Live 0xe0af8000
snd 55101 10 snd_wavefront,snd_cs4236,snd_wss_lib,snd_opl3_lib,snd_hwdep,snd_pcm,snd_timer,snd_mpu401_uart,snd_rawmidi,snd_seq_device,
Live 0xe145e000
parport_pc 26047 0 - Live 0xe0c01000
evdev 17136 2 - Live 0xe0aec000
lpc_ich 16616 0 - Live 0xe0c0b000
shpchp 30666 0 - Live 0xe09ef000
parport 35213 2 ppdev,parport_pc, Live 0xe0c17000
soundcore 12895 1 snd, Live 0xe0a62000
i2c_i801 16845 0 - Live 0xe09f9000
mac_hid 12569 0 - Live 0xe09ce000
rng_core 12645 0 - Live 0xe08f5000
processor 27273 0 - Live 0xe0d76000
nfs 175960 0 - Live 0xe0ac0000
lockd 73308 1 nfs, Live 0xe0aad000
sunrpc 210914 2 nfs,lockd, Live 0xe1402000
fscache 48933 1 nfs, Live 0xe0c29000
ext4 454310 1 - Live 0xe0e81000
crc16 12327 1 ext4, Live 0xe08f0000
mbcache 17027 1 ext4, Live 0xe09d4000
jbd2 81029 1 ext4, Live 0xe09b9000
dm_snapshot 36014 2 - Live 0xe082b000
dm_bufio 22195 1 dm_snapshot, Live 0xe089d000
dm_mod 78948 4 dm_snapshot,dm_bufio, Live 0xe09da000
squashfs 43619 1 - Live 0xe098c000
loop 21927 6 - Live 0xe07f4000
isofs 38528 1 - Live 0xe095f000
sr_mod 21568 1 - Live 0xe0911000
cdrom 46828 1 sr_mod, Live 0xe08d7000
ata_generic 12450 0 - Live 0xe0859000
pata_acpi 12675 0 - Live 0xe0854000
atkbd 21926 0 - Live 0xe085e000
libps2 12643 1 atkbd, Live 0xe084f000
radeon 1297495 1 - Live 0xe0c38000
hwmon 12818 1 radeon, Live 0xe084a000
i2c_algo_bit 12640 1 radeon, Live 0xe0839000
uhci_hcd 38956 0 - Live 0xe08e5000
drm_kms_helper 44494 1 radeon, Live 0xe0875000
ata_piix 29371 1 - Live 0xe0881000
sata_sil 12799 0 - Live 0xe083e000
ehci_hcd 65019 0 - Live 0xe088c000
ttm 59810 1 radeon, Live 0xe0865000
libata 161816 4 ata_generic,pata_acpi,ata_piix,sata_sil, Live 0xe0936000
usbcore 170936 3 usb_storage,uhci_hcd,ehci_hcd, Live 0xe0a67000
usb_common 12484 1 usbcore, Live 0xe0845000
drm 203437 4 radeon,drm_kms_helper,ttm, Live 0xe08a4000
scsi_mod 123706 4 sd_mod,usb_storage,sr_mod,libata, Live 0xe096c000
e1000 116613 0 - Live 0xe0918000
i2c_core 41134 5 i2c_i801,radeon,i2c_algo_bit,drm_kms_helper,drm, Live
0xe0813000
intel_agp 17232 1 - Live 0xe07fc000
intel_gtt 17584 1 intel_agp, Live 0xe07ee000
agpgart 31307 4 ttm,drm,intel_agp,intel_gtt, Live 0xe080a000
i8042 17690 1 libps2, Live 0xe07d7000
serio 17914 4 serio_raw,atkbd,i8042, Live 0xe07e1000
button 12797 0 - Live 0xe07d2000

scsi:
Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: HP       Model: CD-Writer+ 8100  Rev: 1.0g
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: Corsair  Model: Flash Voyager    Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00

version:
Linux version 3.16.1-1-ARCH
(nobody@var-lib-archbuild-testing-i686-tobias) (gcc version 4.9.1
(GCC) ) #1 SMP PREEMPT Thu Aug 14 07:48:39 CEST 2014
