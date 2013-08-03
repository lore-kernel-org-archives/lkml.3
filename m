Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3HCXeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 19:34:11 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:47057 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3HCXeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 19:34:10 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Aug 2013 19:34:10 EDT
Date: Sat, 03 Aug 2013 15:33:49 -0700
From: Vern Clark <vmclark@verizon.net>
To: linux-kernel@vger.kernel.org
Subject: Kernel causes excessive delay mounting USB device
Message-id: <20130803153349.63acfab2@u>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Plugging in any USB flash stick takes 5-6 minutes before its mounted.

===
Using the current kernel-3.8.0-28-generic, the USB fails to load in proper time.
I found this message in syslog: timeout: killing '/sbin/blkid -o udev -p /dev/sdb'. Right after which, the USB device was mounted.

Using an earlier kernel-3.2.37-030237-generic, fixed the problem.

Kernel version (from /proc/version):
Linux version 3.8.0-28-generic (buildd@roseapple) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #41~precise1-Ubuntu SMP Sun Jul 28 21:37:49 UTC 2013
===
Environment
===
Release 12.04 (precise) 64-bit
GNOME 3.4.2
Memory: 3.6 GiB
Processor: AMD Athlon(tm) II X2 250 Processor × 2
Available disk space: 10.6 GiB
===
Software (add the output of the ver_linux script here)
===
ver_linux
===
 
Linux u 3.8.0-28-generic #41~precise1-Ubuntu SMP Sun Jul 28 21:37:49 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.13
wireless-tools         30
Modules Loaded         parport_pc ppdev snd_hda_codec_realtek snd_hda_intel snd_hda_codec nouveau snd_hwdep snd_pcm ttm snd_seq_midi snd_rawmidi kvm snd_seq_midi_event drm_kms_helper snd_seq drm snd_timer snd_seq_device snd i2c_algo_bit soundcore psmouse edac_core snd_page_alloc mxm_wmi microcode mac_hid i2c_nforce2 k10temp edac_mce_amd video serio_raw wmi lp parport hid_generic usbhid hid ums_cypress usb_storage pata_acpi sata_nv forcedeth

Processor information (from /proc/cpuinfo):
===================================================
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 6
model name	: AMD Athlon(tm) II X2 250 Processor
stepping	: 2
microcode	: 0x10000c7
cpu MHz		: 800.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips	: 6026.90
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 6
model name	: AMD Athlon(tm) II X2 250 Processor
stepping	: 2
microcode	: 0x10000c7
cpu MHz		: 800.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips	: 6026.90
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

Module information (from /proc/modules):
====
parport_pc 28284 0 - Live 0x0000000000000000 (F)
ppdev 17113 0 - Live 0x0000000000000000 (F)
snd_hda_codec_realtek 79916 1 - Live 0x0000000000000000 (F)
snd_hda_intel 44339 3 - Live 0x0000000000000000 (F)
snd_hda_codec 141716 2 snd_hda_codec_realtek,snd_hda_intel, Live 0x0000000000000000 (F)
nouveau 958580 3 - Live 0x0000000000000000 (F)
snd_hwdep 13668 1 snd_hda_codec, Live 0x0000000000000000 (F)
snd_pcm 102477 2 snd_hda_intel,snd_hda_codec, Live 0x0000000000000000 (F)
ttm 84051 1 nouveau, Live 0x0000000000000000 (F)
snd_seq_midi 13324 0 - Live 0x0000000000000000 (F)
snd_rawmidi 30417 1 snd_seq_midi, Live 0x0000000000000000 (F)
kvm 455932 0 - Live 0x0000000000000000 (F)
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000 (F)
drm_kms_helper 49597 1 nouveau, Live 0x0000000000000000 (F)
snd_seq 61930 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000 (F)
drm 287564 5 nouveau,ttm,drm_kms_helper, Live 0x0000000000000000 (F)
snd_timer 29989 2 snd_pcm,snd_seq, Live 0x0000000000000000 (F)
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000 (F)
snd 69533 15 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0x0000000000000000 (F)
i2c_algo_bit 13564 1 nouveau, Live 0x0000000000000000 (F)
soundcore 12680 1 snd, Live 0x0000000000000000 (F)
psmouse 97873 0 - Live 0x0000000000000000 (F)
edac_core 62724 0 - Live 0x0000000000000000 (F)
snd_page_alloc 18798 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000 (F)
mxm_wmi 13021 1 nouveau, Live 0x0000000000000000 (F)
microcode 23017 0 - Live 0x0000000000000000 (F)
mac_hid 13253 0 - Live 0x0000000000000000 (F)
i2c_nforce2 13065 0 - Live 0x0000000000000000 (F)
k10temp 13173 0 - Live 0x0000000000000000 (F)
edac_mce_amd 23343 0 - Live 0x0000000000000000 (F)
video 19652 1 nouveau, Live 0x0000000000000000 (F)
serio_raw 13215 0 - Live 0x0000000000000000 (F)
wmi 19256 2 nouveau,mxm_wmi, Live 0x0000000000000000 (F)
lp 17799 0 - Live 0x0000000000000000 (F)
parport 46562 3 parport_pc,ppdev,lp, Live 0x0000000000000000 (F)
hid_generic 12540 0 - Live 0x0000000000000000 (F)
usbhid 47346 0 - Live 0x0000000000000000 (F)
hid 105549 2 hid_generic,usbhid, Live 0x0000000000000000 (F)
ums_cypress 12754 0 - Live 0x0000000000000000 (F)
usb_storage 61749 1 ums_cypress, Live 0x0000000000000000 (F)
pata_acpi 13038 0 - Live 0x0000000000000000 (F)
sata_nv 32267 2 - Live 0x0000000000000000 (F)
forcedeth 67595 0 - Live 0x0000000000000000 (F)

Loaded driver and hardware information (/proc/ioports, /proc/iomem)
====
iomem:
00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cebff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
  000d0000-000d3fff : pnp 00:05
  000d4000-000d7fff : pnp 00:05
  000de000-000dffff : pnp 00:05
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cffaffff : System RAM
  01000000-01700a30 : Kernel code
  01700a31-01ceee3f : Kernel data
  01df4000-01f2afff : Kernel bss
  c4000000-c7ffffff : GART
cffb0000-cffbdfff : ACPI Tables
cffbe000-cffeffff : ACPI Non-volatile Storage
cfff0000-cfffffff : reserved
e0000000-fbffffff : PCI Bus 0000:00
  e0000000-efffffff : 0000:00:0d.0
  f9000000-f9ffffff : 0000:00:0d.0
  fa000000-faffffff : 0000:00:0d.0
  fbfc0000-fbfdffff : 0000:00:0d.0
  fbff7000-fbff7fff : 0000:00:08.1
    fbff7000-fbff7fff : sata_nv
  fbff8000-fbffbfff : 0000:00:05.0
    fbff8000-fbffbfff : ICH HD audio
  fbffc000-fbffcfff : 0000:00:08.0
    fbffc000-fbffcfff : sata_nv
  fbffd000-fbffdfff : 0000:00:07.0
    fbffd000-fbffdfff : forcedeth
  fbffec00-fbffecff : 0000:00:02.1
    fbffec00-fbffecff : ehci_hcd
  fbfff000-fbffffff : 0000:00:02.0
    fbfff000-fbffffff : ohci_hcd
fc000000-fdffffff : PCI MMCONFIG 0000 [bus 00-1f]
  fc000000-fdffffff : pnp 00:08
fe000000-febfffff : PCI Bus 0000:00
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fee00000-feefffff : reserved
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:07
  fee01000-feefffff : pnp 00:05
fefe0000-fefe01ff : pnp 00:05
fefe1000-fefe1fff : pnp 00:05
feff0000-feff03ff : HPET 0
fff00000-ffffffff : reserved
100000000-11fffffff : System RAM

ioports:
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vga+
  04d0-04d1 : pnp 00:05
  0800-080f : pnp 00:05
  0a00-0adf : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  4000-407f : pnp 00:05
    4000-4003 : ACPI PM1a_EVT_BLK
    4004-4005 : ACPI PM1a_CNT_BLK
    4008-400b : ACPI PM_TMR
    4010-4015 : ACPI CPU throttle
    4020-4027 : ACPI GPE0_BLK
  4080-40ff : pnp 00:05
  4400-447f : pnp 00:05
  4480-44ff : pnp 00:05
    44a0-44af : ACPI GPE1_BLK
  4800-487f : pnp 00:05
  4880-48ff : pnp 00:05
  4900-493f : 0000:00:01.1
  4c00-4c7f : pnp 00:05
  4c80-4cff : pnp 00:05
  4d00-4d3f : 0000:00:01.1
    4d00-4d3f : nForce2_smbus
  4e00-4e3f : 0000:00:01.1
    4e00-4e3f : nForce2_smbus
  4f00-4fff : 0000:00:01.0
  d000-d00f : 0000:00:08.1
    d000-d00f : sata_nv
  d080-d083 : 0000:00:08.1
    d080-d083 : sata_nv
  d400-d407 : 0000:00:08.1
    d400-d407 : sata_nv
  d480-d483 : 0000:00:08.1
    d480-d483 : sata_nv
  d800-d807 : 0000:00:08.1
    d800-d807 : sata_nv
  d880-d88f : 0000:00:08.0
    d880-d88f : sata_nv
  dc00-dc03 : 0000:00:08.0
    dc00-dc03 : sata_nv
  e000-e007 : 0000:00:08.0
    e000-e007 : sata_nv
  e080-e083 : 0000:00:08.0
    e080-e083 : sata_nv
  e400-e407 : 0000:00:08.0
    e400-e407 : sata_nv
  e480-e487 : 0000:00:07.0
    e480-e487 : forcedeth

PCI information ('lspci -vvv' as root)
===
00:00.0 RAM memory: NVIDIA Corporation MCP61 Memory Controller (rev a1)
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=17 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:01.0 ISA bridge: NVIDIA Corporation MCP61 LPC Bridge (rev a2)
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: I/O ports at 4f00 [size=256]

00:01.1 SMBus: NVIDIA Corporation MCP61 SMBus (rev a2)
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 4900 [size=64]
	Region 4: I/O ports at 4d00 [size=64]
	Region 5: I/O ports at 4e00 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2

00:01.2 RAM memory: NVIDIA Corporation MCP61 Memory Controller (rev a2)
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 USB controller: NVIDIA Corporation MCP61 USB 1.1 Controller (rev a3) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbfff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd

00:02.1 USB controller: NVIDIA Corporation MCP61 USB 2.0 Controller (rev a3) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 22
	Region 0: Memory at fbffec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci-pci

00:04.0 PCI bridge: NVIDIA Corporation MCP61 PCI bridge (rev a1) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b8] Subsystem: Hewlett-Packard Company Device 2a99
	Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000

00:05.0 Audio device: NVIDIA Corporation MCP61 High Definition Audio (rev a2)
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at fbff8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:07.0 Bridge: NVIDIA Corporation MCP61 Ethernet (rev a2)
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at fbffd000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at e480 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/8 Maskable+ 64bit+
		Address: 00000000fee0100c  Data: 41b1
		Masking: 000000fe  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: forcedeth
	Kernel modules: forcedeth

00:08.0 IDE interface: NVIDIA Corporation MCP61 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at e400 [size=8]
	Region 1: I/O ports at e080 [size=4]
	Region 2: I/O ports at e000 [size=8]
	Region 3: I/O ports at dc00 [size=4]
	Region 4: I/O ports at d880 [size=16]
	Region 5: Memory at fbffc000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: sata_nv
	Kernel modules: pata_acpi, sata_nv

00:08.1 IDE interface: NVIDIA Corporation MCP61 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 20
	Region 0: I/O ports at d800 [size=8]
	Region 1: I/O ports at d480 [size=4]
	Region 2: I/O ports at d400 [size=8]
	Region 3: I/O ports at d080 [size=4]
	Region 4: I/O ports at d000 [size=16]
	Region 5: Memory at fbff7000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: sata_nv
	Kernel modules: pata_acpi, sata_nv

00:09.0 PCI bridge: NVIDIA Corporation MCP61 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Hewlett-Packard Company Device 2a99
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4161
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=WRR32
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:0b.0 PCI bridge: NVIDIA Corporation MCP61 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Hewlett-Packard Company Device 2a99
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4171
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #2, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=WRR32
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:0c.0 PCI bridge: NVIDIA Corporation MCP61 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Hewlett-Packard Company Device 2a99
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4181
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #3, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=WRR32
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:0d.0 VGA compatible controller: NVIDIA Corporation C61 [GeForce 6150SE nForce 430] (rev a2) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 2a99
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f9000000 (64-bit, non-prefetchable) [size=16M]
	Expansion ROM at fbfc0000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: nouveau
	Kernel modules: nouveau, nvidiafb

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: 1.0GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp
	Kernel modules: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

SCSI information (from /proc/scsi/scsi)
==
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Hitachi HDT72106 Rev: STDO
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: Multi    Model: Flash Reader     Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00
===
Other notes, patches, fixes, workarounds:
devices:
Character devices:
  1 mem
  4 /dev/vc/0
  4 tty
  4 ttyS
  5 /dev/tty
  5 /dev/console
  5 /dev/ptmx
  5 ttyprintk
  6 lp
  7 vcs
 10 misc
 13 input
 21 sg
 29 fb
 99 ppdev
108 ppp
116 alsa
128 ptm
136 pts
180 usb
189 usb_device
226 drm
251 hidraw
252 bsg
253 watchdog
254 rtc

Block devices:
  1 ramdisk
259 blkext
  7 loop
  8 sd
  9 md
 11 sr
 65 sd
 66 sd
 67 sd
 68 sd
 69 sd
 70 sd
 71 sd
128 sd
129 sd
130 sd
131 sd
132 sd
133 sd
134 sd
135 sd
252 device-mapper
253 virtblk
254 mdp

diskstats:
   1       0 ram0 0 0 0 0 0 0 0 0 0 0 0
   1       1 ram1 0 0 0 0 0 0 0 0 0 0 0
   1       2 ram2 0 0 0 0 0 0 0 0 0 0 0
   1       3 ram3 0 0 0 0 0 0 0 0 0 0 0
   1       4 ram4 0 0 0 0 0 0 0 0 0 0 0
   1       5 ram5 0 0 0 0 0 0 0 0 0 0 0
   1       6 ram6 0 0 0 0 0 0 0 0 0 0 0
   1       7 ram7 0 0 0 0 0 0 0 0 0 0 0
   1       8 ram8 0 0 0 0 0 0 0 0 0 0 0
   1       9 ram9 0 0 0 0 0 0 0 0 0 0 0
   1      10 ram10 0 0 0 0 0 0 0 0 0 0 0
   1      11 ram11 0 0 0 0 0 0 0 0 0 0 0
   1      12 ram12 0 0 0 0 0 0 0 0 0 0 0
   1      13 ram13 0 0 0 0 0 0 0 0 0 0 0
   1      14 ram14 0 0 0 0 0 0 0 0 0 0 0
   1      15 ram15 0 0 0 0 0 0 0 0 0 0 0
   7       0 loop0 0 0 0 0 0 0 0 0 0 0 0
   7       1 loop1 0 0 0 0 0 0 0 0 0 0 0
   7       2 loop2 0 0 0 0 0 0 0 0 0 0 0
   7       3 loop3 0 0 0 0 0 0 0 0 0 0 0
   7       4 loop4 0 0 0 0 0 0 0 0 0 0 0
   7       5 loop5 0 0 0 0 0 0 0 0 0 0 0
   7       6 loop6 0 0 0 0 0 0 0 0 0 0 0
   7       7 loop7 0 0 0 0 0 0 0 0 0 0 0
   8       0 sda 26235 10442 1004198 188256 12517 15054 391744 161724 0 108836 349976
   8       1 sda1 304 1134 2418 6348 0 0 0 0 0 6348 6348
   8       2 sda2 162 0 1296 4400 0 0 0 0 0 4400 4400
   8       3 sda3 2 0 4 248 0 0 0 0 0 248 248
   8       5 sda5 162 31 1544 1496 0 0 0 0 0 1452 1496
   8       6 sda6 162 160 1288 4328 0 0 0 0 0 4328 4328
   8       7 sda7 25248 8633 996092 166184 11156 15054 391744 144544 0 94976 310724
   8       8 sda8 162 484 1292 4244 0 0 0 0 0 4244 4244
   8      32 sdc 0 0 0 0 0 0 0 0 0 0 0

SYSLOG info

Aug  2 09:39:15 u kernel: [ 2268.769492] usb 1-8: new high-speed USB device number 11 using ehci-pci
Aug  2 09:39:15 u kernel: [ 2268.904602] usb 1-8: New USB device found, idVendor=090c, idProduct=1000
Aug  2 09:39:15 u kernel: [ 2268.904613] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  2 09:39:15 u kernel: [ 2268.904621] usb 1-8: Product: Flash Disk
Aug  2 09:39:15 u kernel: [ 2268.904627] usb 1-8: Manufacturer: USB 2.0
Aug  2 09:39:15 u kernel: [ 2268.904632] usb 1-8: SerialNumber: A126000000000042
Aug  2 09:39:15 u kernel: [ 2268.905487] scsi11 : usb-storage 1-8:1.0
Aug  2 09:39:15 u mtp-probe: checking bus 1, device 11: "/sys/devices/pci0000:00/0000:00:02.1/usb1/1-8"
Aug  2 09:39:15 u mtp-probe: bus: 1, device: 11 was not an MTP device
Aug  2 09:39:16 u kernel: [ 2269.904496] scsi 11:0:0:0: Direct-Access     USB 2.0  Flash Disk       1100 PQ: 0 ANSI: 0 CCS
Aug  2 09:39:16 u kernel: [ 2269.906740] sd 11:0:0:0: Attached scsi generic sg2 type 0
Aug  2 09:39:16 u kernel: [ 2269.912266] sd 11:0:0:0: [sdb] 15858688 512-byte logical blocks: (8.11 GB/7.56 GiB)
Aug  2 09:39:16 u kernel: [ 2269.913383] sd 11:0:0:0: [sdb] Write Protect is off
Aug  2 09:39:16 u kernel: [ 2269.913392] sd 11:0:0:0: [sdb] Mode Sense: 43 00 00 00
Aug  2 09:39:16 u kernel: [ 2269.914556] sd 11:0:0:0: [sdb] No Caching mode page present
Aug  2 09:39:16 u kernel: [ 2269.914570] sd 11:0:0:0: [sdb] Assuming drive cache: write through
Aug  2 09:39:47 u kernel: [ 2300.739825] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:40:18 u kernel: [ 2331.708468] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:40:49 u kernel: [ 2362.613256] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:41:20 u kernel: [ 2393.581897] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:41:20 u kernel: [ 2393.724348] sd 11:0:0:0: [sdb] No Caching mode page present
Aug  2 09:41:20 u kernel: [ 2393.724362] sd 11:0:0:0: [sdb] Assuming drive cache: write through
Aug  2 09:41:51 u kernel: [ 2424.486645] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:42:22 u kernel: [ 2455.455330] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:42:53 u kernel: [ 2486.360117] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:43:24 u kernel: [ 2517.264905] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:43:24 u kernel: [ 2517.449684]  sdb: sdb1
Aug  2 09:43:24 u kernel: [ 2517.454773] sd 11:0:0:0: [sdb] No Caching mode page present
Aug  2 09:43:24 u kernel: [ 2517.454787] sd 11:0:0:0: [sdb] Assuming drive cache: write through
Aug  2 09:43:55 u kernel: [ 2548.169695] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:44:25 u udevd[3606]: timeout '/sbin/blkid -o udev -p /dev/sdb'
Aug  2 09:44:26 u kernel: [ 2579.202191] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:44:26 u udevd[3606]: timeout: killing '/sbin/blkid -o udev -p /dev/sdb' [3717]
Aug  2 09:44:57  udevd[3606]: last message repeated 30 times
Aug  2 09:44:57 u kernel: [ 2610.106976] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:44:57 u udevd[3606]: timeout: killing '/sbin/blkid -o udev -p /dev/sdb' [3717]
Aug  2 09:45:28  udevd[3606]: last message repeated 30 times
Aug  2 09:45:28 u kernel: [ 2641.011767] usb 1-8: reset high-speed USB device number 11 using ehci-pci
Aug  2 09:45:28 u kernel: [ 2641.146199] sd 11:0:0:0: [sdb] Attached SCSI removable disk
Aug  2 09:45:28 u udevd[3606]: '/sbin/blkid -o udev -p /dev/sdb' [3717] terminated by signal 9 (Killed)
Aug  2 09:45:28 u udevd[3606]: timeout 'udisks-part-id /dev/sdb'
Aug  2 09:45:29 u ntfs-3g[3767]: Version 2012.1.15AR.1 external FUSE 28
Aug  2 09:45:29 u ntfs-3g[3767]: Mounted /dev/sdb1 (Read-Write, label "MUSIC", NTFS 3.1)
Aug  2 09:45:29 u ntfs-3g[3767]: Cmdline options: rw,nosuid,nodev,uhelper=udisks,uid=1000,gid=1000,dmask=0077,fmask=0177
Aug  2 09:45:29 u ntfs-3g[3767]: Mount options: rw,nosuid,nodev,uhelper=udisks,allow_other,nonempty,relatime,default_permissions,fsname=/dev/sdb1,blkdev,blksize=4096
Aug  2 09:45:29 u ntfs-3g[3767]: Global ownership and permissions enforced, configuration type 7
===
sudo udevadm monitor --udev
====
UDEV  [771.107707] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8 (usb)
UDEV  [771.110347] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0 (usb)
UDEV  [771.112861] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6 (scsi)
UDEV  [771.114607] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/scsi_host/host6 (scsi_host)
UDEV  [772.104601] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/target6:0:0 (scsi)
UDEV  [772.105294] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/target6:0:0/6:0:0:0 (scsi)
UDEV  [772.107030] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/target6:0:0/6:0:0:0/scsi_device/6:0:0:0 (scsi_device)
UDEV  [772.107933] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/target6:0:0/6:0:0:0/scsi_disk/6:0:0:0 (scsi_disk)
UDEV  [772.110696] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/target6:0:0/6:0:0:0/bsg/6:0:0:0 (bsg)
UDEV  [772.113030] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/target6:0:0/6:0:0:0/scsi_generic/sg2 (scsi_generic)
UDEV  [896.088284] add      /devices/virtual/bdi/8:32 (bdi)
UDEV  [1144.173131] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/target6:0:0/6:0:0:0/block/sdc (block)
UDEV  [1144.275535] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host6/target6:0:0/6:0:0:0/block/sdc/sdc1 (block)
UDEV  [1144.389155] add      /module/nls_iso8859_1 (module)
===
 sudo udevadm monitor --kernel
monitor will print the received events for:
KERNEL - the kernel uevent

KERNEL[1264.335892] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8 (usb)
KERNEL[1264.336911] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0 (usb)
KERNEL[1264.337282] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7 (scsi)
KERNEL[1264.337348] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/scsi_host/host7 (scsi_host)
KERNEL[1265.339251] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/target7:0:0 (scsi)
KERNEL[1265.339323] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/target7:0:0/7:0:0:0 (scsi)
KERNEL[1265.339355] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/target7:0:0/7:0:0:0/scsi_disk/7:0:0:0 (scsi_disk)
KERNEL[1265.340505] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/target7:0:0/7:0:0:0/scsi_device/7:0:0:0 (scsi_device)
KERNEL[1265.340551] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/target7:0:0/7:0:0:0/scsi_generic/sg2 (scsi_generic)
KERNEL[1265.340587] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/target7:0:0/7:0:0:0/bsg/7:0:0:0 (bsg)
KERNEL[1389.143428] add      /devices/virtual/bdi/8:32 (bdi)
KERNEL[1513.161775] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/target7:0:0/7:0:0:0/block/sdc (block)
KERNEL[1513.161850] add      /devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host7/target7:0:0/7:0:0:0/block/sdc/sdc1 (block)
===
Showing information for /org/freedesktop/UDisks/devices/sda
  native-path:                 /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda
  device:                      8:0
  device-file:                 /dev/sda
    presentation:              /dev/sda
    by-id:                     /dev/disk/by-id/ata-Hitachi_HDT721064SLA360_STHDD7MG1Z06BY
    by-id:                     /dev/disk/by-id/scsi-SATA_Hitachi_HDT7210_STHDD7MG1Z06BY
    by-id:                     /dev/disk/by-id/wwn-0x5000cca348dbbb68
    by-path:                   /dev/disk/by-path/pci-0000:00:08.0-scsi-0:0:0:0
  detected at:                 Fri 02 Aug 2013 04:58:51 PM PDT
  system internal:             1
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:58:51 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        640135028736
  block size:                  512
  job underway:                no
  usage:                       
  type:                        
  version:                     
  uuid:                        
  label:                       
  partition table:
    scheme:                    mbr
    count:                     7
  drive:
    vendor:                    ATA
    model:                     Hitachi HDT721064SLA360
    revision:                  STDOA3D9
    serial:                    STHDD7MG1Z06BY
    WWN:                       5000cca348dbbb68
    detachable:                0
    can spindown:              1
    rotational media:          Yes, at 7200 RPM
    write-cache:               enabled
    ejectable:                 0
    adapter:                   /org/freedesktop/UDisks/adapters/0000_3a00_3a08_2e0
    ports:
      /org/freedesktop/UDisks/adapters/0000_3a00_3a08_2e0/host0
    similar devices:
    media:                     
      compat:                 
    interface:                 ata
    if speed:                  (unknown)
    ATA SMART:                 Updated at Fri 02 Aug 2013 04:59:22 PM PDT
      overall assessment:      Good
===============================================================================
 Attribute       Current|Worst|Threshold  Status   Value       Type     Updates
===============================================================================
 raw-read-error-rate         100| 97| 16   good    0           Pre-fail Online 
 throughput-performance      131|100| 54   good    0           Pre-fail Offline
 spin-up-time                128|100| 24   good    362 msec    Pre-fail Online 
 start-stop-count             99| 99|  0    n/a    7195        Old-age  Online 
 reallocated-sector-count    100|100|  5   good    0 sectors   Pre-fail Online 
 seek-error-rate             100|100| 67   good    0           Pre-fail Online 
 seek-time-performance       125|100| 20   good    0           Pre-fail Offline
 power-on-hours              100|100|  0    n/a    255.1 days  Old-age  Online 
 spin-retry-count            100|100| 60   good    0           Pre-fail Online 
 power-cycle-count            99| 99|  0    n/a    7192        Old-age  Online 
 power-off-retract-count      95| 95|  0    n/a    7195        Old-age  Online 
 load-cycle-count             95| 95|  0    n/a    7195        Old-age  Online 
 temperature-celsius-2       181|150|  0    n/a    33C / 91.4F Old-age  Online 
 reallocated-event-count     100|100|  0    n/a    0           Old-age  Online 
 current-pending-sector      100|100|  0    n/a    0 sectors   Old-age  Online 
 offline-uncorrectable       100|100|  0    n/a    0 sectors   Old-age  Offline
 udma-crc-error-count        200|200|  0    n/a    0           Old-age  Online 

========================================================================
Showing information for /org/freedesktop/UDisks/devices/sda1
  native-path:                 /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda/sda1
  device:                      8:1
  device-file:                 /dev/sda1
    presentation:              /dev/sda1
    by-id:                     /dev/disk/by-id/ata-Hitachi_HDT721064SLA360_STHDD7MG1Z06BY-part1
    by-id:                     /dev/disk/by-id/scsi-SATA_Hitachi_HDT7210_STHDD7MG1Z06BY-part1
    by-id:                     /dev/disk/by-id/wwn-0x5000cca348dbbb68-part1
    by-id:                     /dev/disk/by-uuid/3464AFFC64AFBF4C
    by-path:                   /dev/disk/by-path/pci-0000:00:08.0-scsi-0:0:0:0-part1
  detected at:                 Fri 02 Aug 2013 04:58:51 PM PDT
  system internal:             1
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:58:51 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        113245622784
  block size:                  512
  job underway:                no
  usage:                       filesystem
  type:                        ntfs
  version:                     
  uuid:                        3464AFFC64AFBF4C
  label:                       HP
  partition:
    part of:                   /org/freedesktop/UDisks/devices/sda
    scheme:                    mbr
    number:                    1
    type:                      0x07
    flags:                     boot
    offset:                    32256
    alignment offset:          0
    size:                      113245622784
    label:                     
    uuid:                      

========================================================================
Showing information for /org/freedesktop/UDisks/devices/sda2
  native-path:                 /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda/sda2
  device:                      8:2
  device-file:                 /dev/sda2
    presentation:              /dev/sda2
    by-id:                     /dev/disk/by-id/ata-Hitachi_HDT721064SLA360_STHDD7MG1Z06BY-part2
    by-id:                     /dev/disk/by-id/scsi-SATA_Hitachi_HDT7210_STHDD7MG1Z06BY-part2
    by-id:                     /dev/disk/by-id/wwn-0x5000cca348dbbb68-part2
    by-id:                     /dev/disk/by-uuid/C8C08EAFC08EA374
    by-path:                   /dev/disk/by-path/pci-0000:00:08.0-scsi-0:0:0:0-part2
  detected at:                 Fri 02 Aug 2013 04:58:51 PM PDT
  system internal:             1
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:58:51 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        422029819904
  block size:                  512
  job underway:                no
  usage:                       filesystem
  type:                        ntfs
  version:                     
  uuid:                        C8C08EAFC08EA374
  label:                       NTFS
  partition:
    part of:                   /org/freedesktop/UDisks/devices/sda
    scheme:                    mbr
    number:                    2
    type:                      0x07
    flags:                    
    offset:                    113246208000
    alignment offset:          0
    size:                      422029819904
    label:                     
    uuid:                      

===
Showing information for /org/freedesktop/UDisks/devices/sda3
  native-path:                 /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda/sda3
  device:                      8:3
  device-file:                 /dev/sda3
    presentation:              /dev/sda3
    by-id:                     /dev/disk/by-id/ata-Hitachi_HDT721064SLA360_STHDD7MG1Z06BY-part3
    by-id:                     /dev/disk/by-id/scsi-SATA_Hitachi_HDT7210_STHDD7MG1Z06BY-part3
    by-id:                     /dev/disk/by-id/wwn-0x5000cca348dbbb68-part3
    by-path:                   /dev/disk/by-path/pci-0000:00:08.0-scsi-0:0:0:0-part3
  detected at:                 Fri 02 Aug 2013 04:58:51 PM PDT
  system internal:             1
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:58:51 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        1024
  block size:                  512
  job underway:                no
  usage:                       
  type:                        
  version:                     
  uuid:                        
  label:                       
  partition:
    part of:                   /org/freedesktop/UDisks/devices/sda
    scheme:                    mbr
    number:                    3
    type:                      0x0f
    flags:                    
    offset:                    535276577792
    alignment offset:          0
    size:                      104858098688
    label:                     
    uuid:                      

===
Showing information for /org/freedesktop/UDisks/devices/sda5
  native-path:                 /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda/sda5
  device:                      8:5
  device-file:                 /dev/sda5
    presentation:              /dev/sda5
    by-id:                     /dev/disk/by-id/ata-Hitachi_HDT721064SLA360_STHDD7MG1Z06BY-part5
    by-id:                     /dev/disk/by-id/scsi-SATA_Hitachi_HDT7210_STHDD7MG1Z06BY-part5
    by-id:                     /dev/disk/by-id/wwn-0x5000cca348dbbb68-part5
    by-id:                     /dev/disk/by-uuid/ef49d6c0-b094-4deb-9805-52707a9cd12b
    by-path:                   /dev/disk/by-path/pci-0000:00:08.0-scsi-0:0:0:0-part5
  detected at:                 Fri 02 Aug 2013 04:58:51 PM PDT
  system internal:             1
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:58:51 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        2097414144
  block size:                  512
  job underway:                no
  usage:                       other
  type:                        swap
  version:                     2
  uuid:                        ef49d6c0-b094-4deb-9805-52707a9cd12b
  label:                       
  partition:
    part of:                   /org/freedesktop/UDisks/devices/sda
    scheme:                    mbr
    number:                    5
    type:                      0x82
    flags:                    
    offset:                    535276578816
    alignment offset:          0
    size:                      2097414144
    label:                     
    uuid:                      

===
Showing information for /org/freedesktop/UDisks/devices/sda6
  native-path:                 /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda/sda6
  device:                      8:6
  device-file:                 /dev/sda6
    presentation:              /dev/sda6
    by-id:                     /dev/disk/by-id/ata-Hitachi_HDT721064SLA360_STHDD7MG1Z06BY-part6
    by-id:                     /dev/disk/by-id/scsi-SATA_Hitachi_HDT7210_STHDD7MG1Z06BY-part6
    by-id:                     /dev/disk/by-id/wwn-0x5000cca348dbbb68-part6
    by-id:                     /dev/disk/by-uuid/e906c234-f832-4df8-ae13-ae31305fdd83
    by-path:                   /dev/disk/by-path/pci-0000:00:08.0-scsi-0:0:0:0-part6
  detected at:                 Fri 02 Aug 2013 04:58:51 PM PDT
  system internal:             1
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:58:51 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        20974000128
  block size:                  512
  job underway:                no
  usage:                       filesystem
  type:                        ext4
  version:                     1.0
  uuid:                        e906c234-f832-4df8-ae13-ae31305fdd83
  label:                       KDE
  partition:
    part of:                   /org/freedesktop/UDisks/devices/sda
    scheme:                    mbr
    number:                    6
    type:                      0x83
    flags:                    
    offset:                    537374228480
    alignment offset:          0
    size:                      20974000128
    label:                     
    uuid:                      

===
Showing information for /org/freedesktop/UDisks/devices/sda7
  native-path:                 /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda/sda7
  device:                      8:7
  device-file:                 /dev/sda7
    presentation:              /dev/sda7
    by-id:                     /dev/disk/by-id/ata-Hitachi_HDT721064SLA360_STHDD7MG1Z06BY-part7
    by-id:                     /dev/disk/by-id/scsi-SATA_Hitachi_HDT7210_STHDD7MG1Z06BY-part7
    by-id:                     /dev/disk/by-id/wwn-0x5000cca348dbbb68-part7
    by-id:                     /dev/disk/by-uuid/f7d95a61-d83f-4db8-b47e-87478fe2fdc1
    by-path:                   /dev/disk/by-path/pci-0000:00:08.0-scsi-0:0:0:0-part7
  detected at:                 Fri 02 Aug 2013 04:58:51 PM PDT
  system internal:             1
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:58:51 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  1
  mount paths:             /
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        15332000256
  block size:                  512
  job underway:                no
  usage:                       filesystem
  type:                        ext4
  version:                     1.0
  uuid:                        f7d95a61-d83f-4db8-b47e-87478fe2fdc1
  label:                       
  partition:
    part of:                   /org/freedesktop/UDisks/devices/sda
    scheme:                    mbr
    number:                    7
    type:                      0x83
    flags:                    
    offset:                    558348489216
    alignment offset:          0
    size:                      15332000256
    label:                     
    uuid:                      

====
Showing information for /org/freedesktop/UDisks/devices/sda8
  native-path:                 /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda/sda8
  device:                      8:8
  device-file:                 /dev/sda8
    presentation:              /dev/sda8
    by-id:                     /dev/disk/by-id/ata-Hitachi_HDT721064SLA360_STHDD7MG1Z06BY-part8
    by-id:                     /dev/disk/by-id/scsi-SATA_Hitachi_HDT7210_STHDD7MG1Z06BY-part8
    by-id:                     /dev/disk/by-id/wwn-0x5000cca348dbbb68-part8
    by-id:                     /dev/disk/by-uuid/1219b933-24ae-4b15-8edb-c0e015b78a3a
    by-path:                   /dev/disk/by-path/pci-0000:00:08.0-scsi-0:0:0:0-part8
  detected at:                 Fri 02 Aug 2013 04:58:52 PM PDT
  system internal:             1
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:58:52 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        66453249024
  block size:                  512
  job underway:                no
  usage:                       filesystem
  type:                        ext4
  version:                     1.0
  uuid:                        1219b933-24ae-4b15-8edb-c0e015b78a3a
  label:                       ext4
  partition:
    part of:                   /org/freedesktop/UDisks/devices/sda
    scheme:                    mbr
    number:                    8
    type:                      0x83
    flags:                    
    offset:                    573681427456
    alignment offset:          0
    size:                      66453249024
    label:                     
    uuid:                      

===
Showing information for /org/freedesktop/UDisks/devices/sdb
  native-path:                 /sys/devices/pci0000:00/0000:00:02.1/usb1/1-9/1-9:1.0/host4/target4:0:0/4:0:0:0/block/sdb
  device:                      8:16
  device-file:                 /dev/sdb
    presentation:              /dev/sdb
    by-id:                     /dev/disk/by-id/usb-Multi_Flash_Reader_058F63666471-0:0
    by-path:                   /dev/disk/by-path/pci-0000:00:02.1-usb-0:9:1.0-scsi-0:0:0:0
  detected at:                 Fri 02 Aug 2013 04:58:51 PM PDT
  system internal:             0
  removable:                   1
  has media:                   0
    detects change:            1
    detection by polling:      1
    detection inhibitable:     1
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        0
  block size:                  0
  job underway:                no
  usage:                       
  type:                        
  version:                     
  uuid:                        
  label:                       
  drive:
    vendor:                    Multi
    model:                     Flash Reader
    revision:                  1.00
    serial:                    058F63666471
    WWN:                       
    detachable:                1
    can spindown:              0
    rotational media:          Yes, unknown rate
    write-cache:               unknown
    ejectable:                 0
    adapter:                   Unknown
    ports:
    similar devices:
    media:                     
      compat:                 
    interface:                 usb
    if speed:                  480000000 bits/s
    ATA SMART:                 not available

===
Showing information for /org/freedesktop/UDisks/devices/sdc
  native-path:                 /sys/devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host5/target5:0:0/5:0:0:0/block/sdc
  device:                      8:32
  device-file:                 /dev/sdc
    presentation:              /dev/sdc
    by-id:                     /dev/disk/by-id/usb-USB_2.0_Flash_Disk_A123000000002321-0:0
    by-path:                   /dev/disk/by-path/pci-0000:00:02.1-usb-0:8:1.0-scsi-0:0:0:0
  detected at:                 Fri 02 Aug 2013 04:59:02 PM PDT
  system internal:             0
  removable:                   1
  has media:                   1 (detected at Fri 02 Aug 2013 04:59:02 PM PDT)
    detects change:            1
    detection by polling:      1
    detection inhibitable:     1
    detection inhibited:       0
  is read only:                0
  is mounted:                  0
  mount paths:             
  mounted by uid:              0
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        8119648256
  block size:                  512
  job underway:                no
  usage:                       
  type:                        
  version:                     
  uuid:                        
  label:                       
  partition table:
    scheme:                    mbr
    count:                     1
  drive:
    vendor:                    USB 2.0
    model:                     Flash Disk
    revision:                  1100
    serial:                    A123000000002321
    WWN:                       
    detachable:                1
    can spindown:              0
    rotational media:          Yes, unknown rate
    write-cache:               unknown
    ejectable:                 0
    adapter:                   Unknown
    ports:
    similar devices:
    media:                     
      compat:                 
    interface:                 usb
    if speed:                  480000000 bits/s
    ATA SMART:                 not available

==
Showing information for /org/freedesktop/UDisks/devices/sdc1
  native-path:                 /sys/devices/pci0000:00/0000:00:02.1/usb1/1-8/1-8:1.0/host5/target5:0:0/5:0:0:0/block/sdc/sdc1
  device:                      8:33
  device-file:                 /dev/sdc1
    presentation:              /dev/sdc1
    by-id:                     /dev/disk/by-id/usb-USB_2.0_Flash_Disk_A123000000002321-0:0-part1
    by-id:                     /dev/disk/by-uuid/30da994a-5a8b-4c58-8ce5-029427d3dab1
    by-path:                   /dev/disk/by-path/pci-0000:00:02.1-usb-0:8:1.0-scsi-0:0:0:0-part1
  detected at:                 Fri 02 Aug 2013 04:59:02 PM PDT
  system internal:             0
  removable:                   0
  has media:                   1 (detected at Fri 02 Aug 2013 04:59:02 PM PDT)
    detects change:            0
    detection by polling:      0
    detection inhibitable:     0
    detection inhibited:       0
  is read only:                0
  is mounted:                  1
  mount paths:             /media/8GIG
  mounted by uid:              1000
  presentation hide:           0
  presentation nopolicy:       0
  presentation name:           
  presentation icon:           
  automount hint:              
  size:                        8118496256
  block size:                  512
  job underway:                no
  usage:                       filesystem
  type:                        ext4
  version:                     1.0
  uuid:                        30da994a-5a8b-4c58-8ce5-029427d3dab1
  label:                       8GIG
  partition:
    part of:                   /org/freedesktop/UDisks/devices/sdc
    scheme:                    mbr
    number:                    1
    type:                      0x83
    flags:                    
    offset:                    31744
    alignment offset:          0
    size:                      8118496256
    label:                     
    uuid:                      
