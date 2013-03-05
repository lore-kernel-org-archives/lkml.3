Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3CEPKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:10:49 -0500
Received: from bolligen.cirrax.com ([217.197.128.7]:59120 "EHLO
	mail.cirrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3CEPKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:10:45 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 10:10:43 EST
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: jyli@marvell.com, iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Shun Fu <fushun@marvell.com>
Subject: Marvell 88NV9143 in mini-PCIe not working with intel_iommu=on
User-Agent: Notmuch/0.15.1 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 05 Mar 2013 16:03:14 +0100
Message-ID: <874ngpj3d9.fsf@meteor.durcheinandertal.bofh>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


[ Sending this to the MVUMI driver authors and the IOMMU list as I can't
tell which part is at fault. ]

Hi

I have a Super Talent CoreStore MV 64GB mini-PCIe SSD in my ThinkPad
X200. The SSD works fine when booting with intel_iommu=off, but not if I
enable the IOMMU. This is a real PCI device with a Marvel 88NV9143
controller on it (mvumi kernel module), not one of the newer mSATA
devices in a mini-PCI form factor.

If I boot with the IOMMU enabled, early in the boot the system blocks for
a few seconds and then the mvumi driver reports a "failed handshake"
(see below). In this case no scsi device for the SSD is available. With
the IOMMU disabled everything works as expected.

The logs below are for version 3.9.0-rc1. Just to be sure that the
problem is still present in the latest kernel. I'm usually running a
Debian 3.2.35 kernel, which has the same problem.

Here are the relevant bits of dmesg output for the two cases. Just in
case I missed something relevant I also attached the full dmesg output
to this mail. The lspci information is further down. Please tell me if
you need additional information or if you have something else I should
try.

dmesg mit intel_iommu=on (non-working):
[    0.000000] Linux version 3.9.0-rc1 (gaudenz@meteor) (gcc version 4.7.2 (Debian 4.7.2-5) ) #7 SMP Tue Mar 5 12:31:37 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.9.0-rc1 root=/dev/mapper/main-root ro resume=/dev/main/swap video=i915:modeset=1 acpi_osi=Linux intel_iommu=on splash quiet
[ ... ]
[    0.000000] Intel-IOMMU: enabled
[ ... ]
[    0.024087] dmar: Host address width 36
[    0.024090] dmar: DRHD base: 0x000000feb03000 flags: 0x0
[    0.024098] dmar: IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
[    0.024099] dmar: DRHD base: 0x000000feb01000 flags: 0x0
[    0.024105] dmar: IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020630260 ecap 1000
[    0.024106] dmar: DRHD base: 0x000000feb00000 flags: 0x0
[    0.024111] dmar: IOMMU 2: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
[    0.024113] dmar: DRHD base: 0x000000feb02000 flags: 0x1
[    0.024118] dmar: IOMMU 3: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
[    0.024120] dmar: RMRR base: 0x000000f2925c00 end: 0x000000f29263ff
[    0.024122] dmar: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[ ... ]
[    0.148516] DMAR: Forcing write-buffer flush capability
[    0.148517] DMAR: Disabling IOMMU for graphics on this chipset
[ ... ]
[    4.017463] DMAR: No ATSR found
[    4.017527] IOMMU 2 0xfeb00000: using Register based invalidation
[    4.017529] IOMMU 0 0xfeb03000: using Register based invalidation
[    4.017530] IOMMU 3 0xfeb02000: using Register based invalidation
[    4.017533] IOMMU: Setting RMRR:
[    4.017549] IOMMU: Setting identity map for device 0000:00:1d.0 [0xf2925c00 - 0xf29263ff]
[    4.017575] IOMMU: Setting identity map for device 0000:00:1d.1 [0xf2925c00 - 0xf29263ff]
[    4.017596] IOMMU: Setting identity map for device 0000:00:1d.2 [0xf2925c00 - 0xf29263ff]
[    4.017618] IOMMU: Setting identity map for device 0000:00:1d.7 [0xf2925c00 - 0xf29263ff]
[    4.017638] IOMMU: Setting identity map for device 0000:00:1a.0 [0xf2925c00 - 0xf29263ff]
[    4.017657] IOMMU: Setting identity map for device 0000:00:1a.1 [0xf2925c00 - 0xf29263ff]
[    4.017677] IOMMU: Setting identity map for device 0000:00:1a.2 [0xf2925c00 - 0xf29263ff]
[    4.017697] IOMMU: Setting identity map for device 0000:00:1a.7 [0xf2925c00 - 0xf29263ff]
[    4.017710] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    4.017719] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[ ... ]
[    4.342079] dmar: DRHD: handling fault status reg 2
[    4.342132] dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr fffff000 
[    4.342132] DMAR:[fault reason 02] Present bit in context entry is clear
[ ... ]
[   34.344078] mvumi 0000:02:00.1: no handshake response at state 0x2.
[   34.344115] mvumi 0000:02:00.1: isr : global=0x0,status=0x0.
[   34.344146] mvumi 0000:02:00.1: handshake failed at state 0x2.
[   34.344266] mvumi: probe of 0000:02:00.1 failed with error -22

dmesg mit intel_iommu=off (working):
[    0.000000] Linux version 3.9.0-rc1 (gaudenz@meteor) (gcc version 4.7.2 (Debian 4.7.2-5) ) #7 SMP Tue Mar 5 12:31:37 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.9.0-rc1 root=/dev/mapper/main-root ro resume=/dev/main/swap video=i915:modeset=1 acpi_osi=Linux intel_iommu=off splash quiet
[ ... ]
[    0.024088] dmar: Host address width 36
[    0.024091] dmar: DRHD base: 0x000000feb03000 flags: 0x0
[    0.024099] dmar: IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
[    0.024101] dmar: DRHD base: 0x000000feb01000 flags: 0x0
[    0.024106] dmar: IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020630260 ecap 1000
[    0.024107] dmar: DRHD base: 0x000000feb00000 flags: 0x0
[    0.024113] dmar: IOMMU 2: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
[    0.024114] dmar: DRHD base: 0x000000feb02000 flags: 0x1
[    0.024119] dmar: IOMMU 3: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
[    0.024121] dmar: RMRR base: 0x000000f2925c00 end: 0x000000f29263ff
[    0.024123] dmar: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[ ... ]
[    7.680038] scsi 0:0:0:0: Processor         SR64C8MM Flash Console    2037 PQ: 0 ANSI: 3
[    7.680192] scsi 0:0:0:0: Attached scsi generic sg1 type 3
[    7.880035] scsi 0:0:1:0: Direct-Access     SR64C8MM Flash Disk       2037 PQ: 0 ANSI: 3
[    7.880203] sd 0:0:1:0: Attached scsi generic sg2 type 0
[    8.080029] sd 0:0:1:0: [sdb] 104857600 512-byte logical blocks: (53.6 GB/50.0 GiB)
[    8.180025] sd 0:0:1:0: [sdb] Write Protect is off
[    8.180028] sd 0:0:1:0: [sdb] Mode Sense: 17 00 00 00
[    8.380023] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.980085]  sdb: sdb1
[    9.480031] sd 0:0:1:0: [sdb] Attached SCSI disk

And the full lspic output for this device:

gaudenz@meteor:~$ sudo lspci -vv -nnq -s 02:
02:00.0 Mass storage controller [01ff]: Marvell Technology Group Ltd. Device [1b4b:91f3]
	Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
	Physical Slot: 0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 2020 [size=8]
	Region 1: I/O ports at 2014 [size=4]
	Region 2: I/O ports at 2018 [size=8]
	Region 3: I/O ports at 2010 [size=4]
	Region 4: I/O ports at 2000 [size=16]
	Region 5: Memory at f2500000 (32-bit, non-prefetchable) [size=8K]
	[virtual] Expansion ROM at f2510000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-

02:00.1 Mass storage controller [0180]: Marvell Technology Group Ltd. Device [1b4b:9143] (rev 10)
	Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
	Physical Slot: 0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f2a00000 (32-bit, prefetchable) [size=1M]
	[virtual] Expansion ROM at f2520000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Kernel driver in use: mvumi

02:00.2 Non-Volatile memory controller [0108]: Marvell Technology Group Ltd. Device [1b4b:91e3] (prog-if 01)
	Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
	Physical Slot: 0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f2502000 (64-bit, non-prefetchable) [size=8K]
	Region 2: I/O ports at 2028 [size=8]
	[virtual] Expansion ROM at f2530000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-


Thanks for your help!

Gaudenz


--=-=-=
Content-Disposition: inline; filename=dmesg_iommu_on.txt

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc1 (gaudenz@meteor) (gcc version 4.7.2 (Debian 4.7.2-5) ) #7 SMP Tue Mar 5 12:31:37 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.9.0-rc1 root=/dev/mapper/main-root ro resume=/dev/main/swap video=i915:modeset=1 acpi_osi=Linux intel_iommu=on splash quiet
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bd4a0fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd4a1000-0x00000000bd4a6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd4a7000-0x00000000bd5b7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd5b8000-0x00000000bd60efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd60f000-0x00000000bd6c5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd6c6000-0x00000000bd6d0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd6d1000-0x00000000bd6d3fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd6d4000-0x00000000bd6d7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd6d8000-0x00000000bd6dbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd6dc000-0x00000000bd6defff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd6df000-0x00000000bd705fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd706000-0x00000000bd707fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd708000-0x00000000bd90efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd90f000-0x00000000bd99efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd99f000-0x00000000bd9fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd9ff000-0x00000000bd9fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bdc00000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: LENOVO 7458E46/7458E46, BIOS 7XET72WW (3.22 ) 11/22/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 23C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FC0000000 write-back
[    0.000000]   6 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbde00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbda00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f7320-0x000f732f] mapped at [ffff8800000f7320]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01862000, 0x01862fff] PGTABLE
[    0.000000] BRK [0x01863000, 0x01863fff] PGTABLE
[    0.000000] BRK [0x01864000, 0x01864fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23be00000-0x23bffffff]
[    0.000000]  [mem 0x23be00000-0x23bffffff] page 2M
[    0.000000] BRK [0x01865000, 0x01865fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x238000000-0x23bdfffff]
[    0.000000]  [mem 0x238000000-0x23bdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x237ffffff]
[    0.000000]  [mem 0x200000000-0x237ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbd4a0fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbd3fffff] page 2M
[    0.000000]  [mem 0xbd400000-0xbd4a0fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbd4a7000-0xbd5b7fff]
[    0.000000]  [mem 0xbd4a7000-0xbd5b7fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbd60f000-0xbd6c5fff]
[    0.000000]  [mem 0xbd60f000-0xbd6c5fff] page 4k
[    0.000000] BRK [0x01866000, 0x01866fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbd9ff000-0xbd9fffff]
[    0.000000]  [mem 0xbd9ff000-0xbd9fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x233ec000-0x2d9edfff]
[    0.000000] ACPI: RSDP 00000000000f72e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd95b8a6 00094 (v01 LENOVO TP-7X    00003220  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd95ba00 000F4 (v03 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd95bdf4 0DF2D (v01 LENOVO TP-7X    00003220 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd95bbb4 00240 (v01 LENOVO TP-7X    00003220 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd969d21 00052 (v01 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd969d73 00078 (v01 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd969deb 0003C (v01 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd969e27 00038 (v01 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: BOOT 00000000bd969f38 00028 (v01 LENOVO TP-7X    00003220  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd969f60 000A0 (v16 LENOVO TP-7X    00003220 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d1ea 00578 (v01 LENOVO TP-7X    00003220 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00110 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023bffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23bffffff]
[    0.000000]   NODE_DATA [mem 0x23bff4000-0x23bff7fff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880233600000-ffff88023a5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xbd4a0fff]
[    0.000000]   node   0: [mem 0xbd4a7000-0xbd5b7fff]
[    0.000000]   node   0: [mem 0xbd60f000-0xbd6c5fff]
[    0.000000]   node   0: [mem 0xbd9ff000-0xbd9fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23bffffff]
[    0.000000] On node 0 totalpages: 2070022
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10551 pages used for memmap
[    0.000000]   DMA32 zone: 771690 pages, LIFO batch:31
[    0.000000]   Normal zone: 17696 pages used for memmap
[    0.000000]   Normal zone: 1294336 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b8000 - 00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88023bc00000 s84672 r8192 d21824 u524288
[    0.000000] pcpu-alloc: s84672 r8192 d21824 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2041698
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.9.0-rc1 root=/dev/mapper/main-root ro resume=/dev/main/swap video=i915:modeset=1 acpi_osi=Linux intel_iommu=on splash quiet
[    0.000000] Intel-IOMMU: enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7919920k/9371648k available (3641k kernel code, 1091560k absent, 360168k reserved, 3107k data, 880k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2526.985 MHz processor
[    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.97 BogoMIPS (lpj=10107940)
[    0.004006] pid_max: default: 32768 minimum: 301
[    0.004043] Security Framework initialized
[    0.004048] AppArmor: AppArmor disabled by boot time parameter
[    0.004661] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.011705] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.013609] Mount-cache hash table entries: 256
[    0.013882] Initializing cgroup subsys cpuacct
[    0.013885] Initializing cgroup subsys devices
[    0.013887] Initializing cgroup subsys freezer
[    0.013888] Initializing cgroup subsys net_cls
[    0.013890] Initializing cgroup subsys blkio
[    0.013893] Initializing cgroup subsys perf_event
[    0.013928] Disabled fast string operations
[    0.013934] CPU: Physical Processor ID: 0
[    0.013935] CPU: Processor Core ID: 0
[    0.013937] mce: CPU supports 6 MCE banks
[    0.013946] CPU0: Thermal monitoring enabled (TM2)
[    0.013955] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.013955] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.013955] tlb_flushall_shift: -1
[    0.014005] Freeing SMP alternatives: 8k freed
[    0.014401] ACPI: Core revision 20130117
[    0.021544] ACPI: All ACPI Tables successfully acquired
[    0.024087] dmar: Host address width 36
[    0.024090] dmar: DRHD base: 0x000000feb03000 flags: 0x0
[    0.024098] dmar: IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
[    0.024099] dmar: DRHD base: 0x000000feb01000 flags: 0x0
[    0.024105] dmar: IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020630260 ecap 1000
[    0.024106] dmar: DRHD base: 0x000000feb00000 flags: 0x0
[    0.024111] dmar: IOMMU 2: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
[    0.024113] dmar: DRHD base: 0x000000feb02000 flags: 0x1
[    0.024118] dmar: IOMMU 3: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
[    0.024120] dmar: RMRR base: 0x000000f2925c00 end: 0x000000f29263ff
[    0.024122] dmar: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[    0.024638] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.065711] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz (fam: 06, model: 17, stepping: 0a)
[    0.068000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.068000] ... version:                2
[    0.068000] ... bit width:              40
[    0.068000] ... generic registers:      2
[    0.068000] ... value mask:             000000ffffffffff
[    0.068000] ... max period:             000000007fffffff
[    0.068000] ... fixed-purpose events:   3
[    0.068000] ... event mask:             0000000700000003
[    0.008000] Disabled fast string operations
[    0.068000] smpboot: Booting Node   0, Processors  #1
[    0.076029] Brought up 2 CPUs
[    0.076033] smpboot: Total of 2 processors activated (10107.94 BogoMIPS)
[    0.076227] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.077911] devtmpfs: initialized
[    0.081676] PM: Registering ACPI NVS region [mem 0xbd6c6000-0xbd6d0fff] (45056 bytes)
[    0.081676] PM: Registering ACPI NVS region [mem 0xbd6d8000-0xbd6dbfff] (16384 bytes)
[    0.081676] PM: Registering ACPI NVS region [mem 0xbd6df000-0xbd705fff] (159744 bytes)
[    0.081676] PM: Registering ACPI NVS region [mem 0xbd90f000-0xbd99efff] (589824 bytes)
[    0.081676] regulator-dummy: no parameters
[    0.081676] NET: Registered protocol family 16
[    0.081676] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.081676] ACPI: bus type pci registered
[    0.081676] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.081676] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.089292] PCI: Using configuration type 1 for base access
[    0.090168] bio: create slab <bio-0> at 0
[    0.090168] ACPI: Added _OSI(Module Device)
[    0.090168] ACPI: Added _OSI(Processor Device)
[    0.090168] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.090168] ACPI: Added _OSI(Processor Aggregator Device)
[    0.090168] ACPI: Added _OSI(Linux)
[    0.090168] ACPI: EC: EC description table is found, configuring boot EC
[    0.096366] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[    0.108394] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.108774] ACPI: Dynamic OEM Table Load:
[    0.108776] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.108893] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.109313] ACPI: Dynamic OEM Table Load:
[    0.109316] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.109329] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.109329] ACPI: Dynamic OEM Table Load:
[    0.109329] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.112071] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.112448] ACPI: Dynamic OEM Table Load:
[    0.112450] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.112461] ACPI: Interpreter enabled
[    0.112461] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.112461] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.112461]  S3 S4 S5)
[    0.112461] ACPI: Using IOAPIC for interrupt routing
[    0.112461] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.140194] ACPI: Power Resource [PUBS] (on)
[    0.145061] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.145181] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.145298] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.145415] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.145532] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.145650] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.145767] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.145885] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.145938] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.148055] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.148406] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
[    0.148437] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.148471] PCI host bridge to bus 0000:00
[    0.148474] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.148477] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.148480] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.148483] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.148485] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.148487] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.148498] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
[    0.148516] DMAR: Forcing write-buffer flush capability
[    0.148517] DMAR: Disabling IOMMU for graphics on this chipset
[    0.148603] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
[    0.148615] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.148623] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.148628] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.148698] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
[    0.148708] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.148814] pci 0000:00:03.0: [8086:2a44] type 00 class 0x078000
[    0.148830] pci 0000:00:03.0: reg 10: [mem 0xf2925800-0xf292580f 64bit]
[    0.148878] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.149014] pci 0000:00:19.0: [8086:10bf] type 00 class 0x020000
[    0.149039] pci 0000:00:19.0: reg 10: [mem 0xf2700000-0xf271ffff]
[    0.149050] pci 0000:00:19.0: reg 14: [mem 0xf2924000-0xf2924fff]
[    0.149062] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    0.149149] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.149179] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.149226] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
[    0.149282] pci 0000:00:1a.0: reg 20: [io  0x1840-0x185f]
[    0.149381] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.149428] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
[    0.149484] pci 0000:00:1a.1: reg 20: [io  0x1860-0x187f]
[    0.149604] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
[    0.149660] pci 0000:00:1a.2: reg 20: [io  0x1880-0x189f]
[    0.149762] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.149821] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
[    0.149846] pci 0000:00:1a.7: reg 10: [mem 0xf2925c00-0xf2925fff]
[    0.149953] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.150005] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.150058] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.150078] pci 0000:00:1b.0: reg 10: [mem 0xf2920000-0xf2923fff 64bit]
[    0.150173] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.150234] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.150285] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
[    0.150385] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.150423] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.150472] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
[    0.150571] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.150611] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.150660] pci 0000:00:1c.3: [8086:2946] type 01 class 0x060400
[    0.150759] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.150801] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.150854] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.150909] pci 0000:00:1d.0: reg 20: [io  0x18a0-0x18bf]
[    0.151003] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.151051] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.151107] pci 0000:00:1d.1: reg 20: [io  0x18c0-0x18df]
[    0.151224] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.151280] pci 0000:00:1d.2: reg 20: [io  0x18e0-0x18ff]
[    0.151409] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.151434] pci 0000:00:1d.7: reg 10: [mem 0xf2926000-0xf29263ff]
[    0.151542] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.151591] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.151639] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.151788] pci 0000:00:1f.0: [8086:2919] type 00 class 0x060100
[    0.151985] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
[    0.152017] pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
[    0.152029] pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
[    0.152040] pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
[    0.152051] pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
[    0.152062] pci 0000:00:1f.2: reg 20: [io  0x1c00-0x1c1f]
[    0.152074] pci 0000:00:1f.2: reg 24: [mem 0xf2925000-0xf29257ff]
[    0.152142] pci 0000:00:1f.2: PME# supported from D3hot
[    0.152219] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
[    0.152240] pci 0000:00:1f.3: reg 10: [mem 0xf2926400-0xf29264ff 64bit]
[    0.152269] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
[    0.152456] pci 0000:02:00.0: [1b4b:91f3] type 00 class 0x01ff00
[    0.152481] pci 0000:02:00.0: reg 10: [io  0x2020-0x2027]
[    0.152499] pci 0000:02:00.0: reg 14: [io  0x2014-0x2017]
[    0.152517] pci 0000:02:00.0: reg 18: [io  0x2018-0x201f]
[    0.152535] pci 0000:02:00.0: reg 1c: [io  0x2010-0x2013]
[    0.152553] pci 0000:02:00.0: reg 20: [io  0x2000-0x200f]
[    0.152571] pci 0000:02:00.0: reg 24: [mem 0xf2500000-0xf2501fff]
[    0.152589] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.152673] pci 0000:02:00.0: PME# supported from D3hot
[    0.152773] pci 0000:02:00.1: [1b4b:9143] type 00 class 0x018000
[    0.152798] pci 0000:02:00.1: reg 10: [mem 0xf2a00000-0xf2afffff pref]
[    0.152894] pci 0000:02:00.1: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.152978] pci 0000:02:00.1: PME# supported from D3hot
[    0.153071] pci 0000:02:00.2: [1b4b:91e3] type 00 class 0x010801
[    0.153105] pci 0000:02:00.2: reg 10: [mem 0xf2502000-0xf2503fff 64bit]
[    0.153123] pci 0000:02:00.2: reg 18: [io  0x2028-0x202f]
[    0.153187] pci 0000:02:00.2: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.160023] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.160028] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.160033] pci 0000:00:1c.0:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.160041] pci 0000:00:1c.0:   bridge window [mem 0xf2a00000-0xf2afffff 64bit pref]
[    0.160151] pci 0000:03:00.0: [8086:4236] type 00 class 0x028000
[    0.160191] pci 0000:03:00.0: reg 10: [mem 0xf2600000-0xf2601fff 64bit]
[    0.160384] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.168021] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.168029] pci 0000:00:1c.1:   bridge window [mem 0xf2600000-0xf26fffff]
[    0.168110] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.168115] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.168120] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.168127] pci 0000:00:1c.3:   bridge window [mem 0xf2b00000-0xf2bfffff 64bit pref]
[    0.168236] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
[    0.168249] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.168252] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.168255] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.168257] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.168260] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.172607] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.172618] acpi root: \_SB_.PCI0 notify handler is installed
[    0.172663] Found 1 acpi root devices
[    0.172737] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.172782] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.172834] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.172834] vgaarb: loaded
[    0.172834] vgaarb: bridge control possible 0000:00:02.0
[    0.172834] PCI: Using ACPI for IRQ routing
[    0.177011] PCI: pci_cache_line_size set to 64 bytes
[    0.177093] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.177095] e820: reserve RAM buffer [mem 0xbd4a1000-0xbfffffff]
[    0.177098] e820: reserve RAM buffer [mem 0xbd5b8000-0xbfffffff]
[    0.177100] e820: reserve RAM buffer [mem 0xbd6c6000-0xbfffffff]
[    0.177103] e820: reserve RAM buffer [mem 0xbda00000-0xbfffffff]
[    0.177272] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.177278] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.177283] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.179299] Switching to clocksource hpet
[    0.179299] pnp: PnP ACPI init
[    0.179299] ACPI: bus type pnp registered
[    0.198659] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.198663] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.198666] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.198669] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.198671] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.198674] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.198677] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.198680] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.198683] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.198686] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.198689] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.198692] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.198694] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.198697] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.198701] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.198704] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.198707] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.218758] system 00:01: [io  0x1000-0x107f] has been reserved
[    0.218761] system 00:01: [io  0x1180-0x11ff] has been reserved
[    0.218764] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.218767] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.218769] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.218772] system 00:01: [io  0x1680-0x169f] has been reserved
[    0.218775] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.218778] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.218781] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.218784] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.218787] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.218790] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.218793] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.218856] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.218867] pnp 00:03: [dma 4]
[    0.218892] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.218923] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.218964] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.219003] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.219039] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.219078] pnp 00:08: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    0.239095] pnp 00:09: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.239618] pnp: PnP ACPI: found 10 devices
[    0.239620] ACPI: ACPI bus type pnp unregistered
[    0.246703] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.246707] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.246731] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.246734] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.246739] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.246743] pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
[    0.246748] pci 0000:02:00.0: BAR 6: assigned [mem 0xf2510000-0xf251ffff pref]
[    0.246752] pci 0000:02:00.1: BAR 6: assigned [mem 0xf2520000-0xf252ffff pref]
[    0.246755] pci 0000:02:00.2: BAR 6: assigned [mem 0xf2530000-0xf253ffff pref]
[    0.246757] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.246761] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.246767] pci 0000:00:1c.0:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.246773] pci 0000:00:1c.0:   bridge window [mem 0xf2a00000-0xf2afffff 64bit pref]
[    0.246780] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.246784] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.246790] pci 0000:00:1c.1:   bridge window [mem 0xf2600000-0xf26fffff]
[    0.246795] pci 0000:00:1c.1:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.246803] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.246806] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.246813] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.246818] pci 0000:00:1c.3:   bridge window [mem 0xf2b00000-0xf2bfffff 64bit pref]
[    0.246825] pci 0000:00:1e.0: PCI bridge to [bus 0d]
[    0.246997] pci 0000:00:1e.0: setting latency timer to 64
[    0.247002] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.247004] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.247007] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.247009] pci_bus 0000:00: resource 7 [mem 0x000d8000-0x000dbfff]
[    0.247011] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xfebfffff]
[    0.247014] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.247016] pci_bus 0000:02: resource 1 [mem 0xf2500000-0xf25fffff]
[    0.247019] pci_bus 0000:02: resource 2 [mem 0xf2a00000-0xf2afffff 64bit pref]
[    0.247021] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    0.247023] pci_bus 0000:03: resource 1 [mem 0xf2600000-0xf26fffff]
[    0.247026] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.247028] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    0.247031] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.247033] pci_bus 0000:05: resource 2 [mem 0xf2b00000-0xf2bfffff 64bit pref]
[    0.247036] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    0.247038] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    0.247040] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    0.247042] pci_bus 0000:0d: resource 7 [mem 0x000d8000-0x000dbfff]
[    0.247045] pci_bus 0000:0d: resource 8 [mem 0xc0000000-0xfebfffff]
[    0.247093] NET: Registered protocol family 2
[    0.247366] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.247803] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.248164] TCP: Hash tables configured (established 65536 bind 65536)
[    0.248239] TCP: reno registered
[    0.248255] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.248314] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.248456] NET: Registered protocol family 1
[    0.248474] pci 0000:00:02.0: Boot video device
[    0.248491] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.248716] pci 0000:00:1a.2: power state changed by ACPI to D0
[    0.248955] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.249389] PCI: CLS 64 bytes, default 64
[    0.249433] Unpacking initramfs...
[    3.921226] Freeing initrd memory: 169992k freed
[    4.017418] DMA-API: preallocated 65536 debug entries
[    4.017421] DMA-API: debugging enabled by kernel config
[    4.017463] DMAR: No ATSR found
[    4.017527] IOMMU 2 0xfeb00000: using Register based invalidation
[    4.017529] IOMMU 0 0xfeb03000: using Register based invalidation
[    4.017530] IOMMU 3 0xfeb02000: using Register based invalidation
[    4.017533] IOMMU: Setting RMRR:
[    4.017549] IOMMU: Setting identity map for device 0000:00:1d.0 [0xf2925c00 - 0xf29263ff]
[    4.017575] IOMMU: Setting identity map for device 0000:00:1d.1 [0xf2925c00 - 0xf29263ff]
[    4.017596] IOMMU: Setting identity map for device 0000:00:1d.2 [0xf2925c00 - 0xf29263ff]
[    4.017618] IOMMU: Setting identity map for device 0000:00:1d.7 [0xf2925c00 - 0xf29263ff]
[    4.017638] IOMMU: Setting identity map for device 0000:00:1a.0 [0xf2925c00 - 0xf29263ff]
[    4.017657] IOMMU: Setting identity map for device 0000:00:1a.1 [0xf2925c00 - 0xf29263ff]
[    4.017677] IOMMU: Setting identity map for device 0000:00:1a.2 [0xf2925c00 - 0xf29263ff]
[    4.017697] IOMMU: Setting identity map for device 0000:00:1a.7 [0xf2925c00 - 0xf29263ff]
[    4.017710] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    4.017719] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    4.017896] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    4.021262] Simple Boot Flag at 0x35 set to 0x1
[    4.021602] audit: initializing netlink socket (disabled)
[    4.021617] type=2000 audit(1362492440.016:1): initialized
[    4.034949] bounce pool size: 64 pages
[    4.034955] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.035707] VFS: Disk quotas dquot_6.5.2
[    4.035730] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.035838] msgmni has been set to 15929
[    4.036081] alg: No test for stdrng (krng)
[    4.036103] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    4.036106] io scheduler noop registered
[    4.036107] io scheduler deadline registered
[    4.036121] io scheduler cfq registered (default)
[    4.036290] pcieport 0000:00:1c.0: irq 43 for MSI/MSI-X
[    4.036452] pcieport 0000:00:1c.1: irq 44 for MSI/MSI-X
[    4.036609] pcieport 0000:00:1c.3: irq 45 for MSI/MSI-X
[    4.036754] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    4.036756] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    4.036759] pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
[    4.036761] pci 0000:02:00.2: Signaling PME through PCIe PME interrupt
[    4.036766] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    4.036796] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    4.036799] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    4.036804] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    4.036832] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    4.036837] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    4.036844] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.036916] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
[    4.036944] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    4.036957] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
[    4.036981] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    4.036994] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
[    4.037018] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    4.037025] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.037027] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.037239] intel_idle: does not run on family 6 model 23
[    4.037287] GHES: HEST is not enabled!
[    4.037353] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.037865] Linux agpgart interface v0.103
[    4.037947] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    4.038021] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    4.038973] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    4.039105] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    4.039229] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    4.049826] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.049833] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.049971] mousedev: PS/2 mouse device common for all mice
[    4.050023] rtc_cmos 00:06: RTC can wake from S4
[    4.050171] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    4.050204] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.050214] cpuidle: using governor ladder
[    4.050215] cpuidle: using governor menu
[    4.050244] drop_monitor: Initializing network drop monitor service
[    4.050321] TCP: cubic registered
[    4.050355] NET: Registered protocol family 10
[    4.050568] mip6: Mobile IPv6
[    4.050570] NET: Registered protocol family 17
[    4.050582] Key type dns_resolver registered
[    4.050848] PM: Checking hibernation image partition /dev/main/swap
[    4.056419] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.069310] PM: Hibernation image not present or could not be loaded.
[    4.069319] registered taskstats version 1
[    4.071287] Freeing unused kernel memory: 880k freed
[    4.071511] Write protecting the kernel read-only data: 6144k
[    4.072742] Freeing unused kernel memory: 444k freed
[    4.074231] Freeing unused kernel memory: 548k freed
[    4.136110] udevd[57]: starting version 175
[    4.161768] pps_core: LinuxPPS API ver. 1 registered
[    4.161771] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    4.162365] PTP clock support registered
[    4.195646] ACPI: bus type usb registered
[    4.195686] usbcore: registered new interface driver usbfs
[    4.195701] usbcore: registered new interface driver hub
[    4.208623] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    4.214084] e1000e: Intel(R) PRO/1000 Network Driver - 2.2.14-k
[    4.214088] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    4.214218] e1000e 0000:00:19.0: setting latency timer to 64
[    4.214304] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.214353] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    4.214501] ACPI: Lid Switch [LID]
[    4.214579] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    4.214584] ACPI: Sleep Button [SLPB]
[    4.214670] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.214673] ACPI: Power Button [PWRF]
[    4.217157] SCSI subsystem initialized
[    4.223826] ACPI: bus type scsi registered
[    4.229315] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa0c
[    4.229379] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa0c
[    4.230506] usbcore: registered new device driver usb
[    4.234303] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.235316] uhci_hcd: USB Universal Host Controller Interface driver
[    4.237262] libata version 3.00 loaded.
[    4.244597] wmi: Mapper loaded
[    4.248577] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.252859] thermal LNXTHERM:00: registered as thermal_zone0
[    4.252863] ACPI: Thermal Zone [THM0] (52 C)
[    4.254325] thermal LNXTHERM:01: registered as thermal_zone1
[    4.254328] ACPI: Thermal Zone [THM1] (54 C)
[    4.256785] [drm] Initialized drm 1.1.0 20060810
[    4.342079] dmar: DRHD: handling fault status reg 2
[    4.342132] dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr fffff000 
[    4.342132] DMAR:[fault reason 02] Present bit in context entry is clear
[    4.436059] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:1f:16:27:99:3d
[    4.436062] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.436089] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    4.436200] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.436204] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.436211] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.436263] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001840
[    4.436342] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.436344] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.436347] usb usb1: Product: UHCI Host Controller
[    4.436349] usb usb1: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.436351] usb usb1: SerialNumber: 0000:00:1a.0
[    4.436609] hub 1-0:1.0: USB hub found
[    4.436614] hub 1-0:1.0: 2 ports detected
[    4.436898] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.436902] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.436907] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.436950] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001860
[    4.437016] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.437019] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.437021] usb usb2: Product: UHCI Host Controller
[    4.437023] usb usb2: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.437025] usb usb2: SerialNumber: 0000:00:1a.1
[    4.437170] hub 2-0:1.0: USB hub found
[    4.437175] hub 2-0:1.0: 2 ports detected
[    4.437334] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.437338] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.437343] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.437385] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00001880
[    4.437448] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.437451] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.437453] usb usb3: Product: UHCI Host Controller
[    4.437455] usb usb3: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.437457] usb usb3: SerialNumber: 0000:00:1a.2
[    4.437601] hub 3-0:1.0: USB hub found
[    4.437606] hub 3-0:1.0: 2 ports detected
[    4.437781] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.437784] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.437790] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    4.437832] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
[    4.437896] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.437899] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.437901] usb usb4: Product: UHCI Host Controller
[    4.437903] usb usb4: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.437905] usb usb4: SerialNumber: 0000:00:1d.0
[    4.438019] hub 4-0:1.0: USB hub found
[    4.438024] hub 4-0:1.0: 2 ports detected
[    4.438183] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.438186] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.438192] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    4.438234] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
[    4.438298] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.438300] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.438303] usb usb5: Product: UHCI Host Controller
[    4.438305] usb usb5: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.438307] usb usb5: SerialNumber: 0000:00:1d.1
[    4.438416] hub 5-0:1.0: USB hub found
[    4.438421] hub 5-0:1.0: 2 ports detected
[    4.438537] ahci 0000:00:1f.2: version 3.0
[    4.438673] ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
[    4.438731] ahci: SSS flag set, parallel bus scan disabled
[    4.438758] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    4.438762] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    4.438767] ahci 0000:00:1f.2: setting latency timer to 64
[    4.439421] scsi1 : ahci
[    4.439511] scsi2 : ahci
[    4.439584] scsi3 : ahci
[    4.439657] scsi4 : ahci
[    4.439723] ata1: SATA max UDMA/133 abar m2048@0xf2925000 port 0xf2925100 irq 47
[    4.439726] ata2: SATA max UDMA/133 abar m2048@0xf2925000 port 0xf2925180 irq 47
[    4.439728] ata3: DUMMY
[    4.439729] ata4: DUMMY
[    4.440102] [drm] Memory usable by graphics device = 2048M
[    4.440107] i915 0000:00:02.0: setting latency timer to 64
[    4.468249] i915 0000:00:02.0: irq 48 for MSI/MSI-X
[    4.468258] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.468259] [drm] Driver supports precise vblank timestamp query.
[    4.468314] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.715691] fbcon: inteldrmfb (fb0) is primary device
[    4.748029] usb 2-1: new full-speed USB device number 2 using uhci_hcd
[    4.756041] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.758536] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    4.758540] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    4.758542] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    4.761812] ata1.00: ATA-8: ST93205620AS, SD28, max UDMA/133
[    4.761813] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.763302] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    4.763306] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    4.763308] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    4.765439] ata1.00: configured for UDMA/133
[    4.765584] scsi 1:0:0:0: Direct-Access     ATA      ST93205620AS     SD28 PQ: 0 ANSI: 5
[    4.916027] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    4.916029] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    4.916031] usb 2-1: Product: Fingerprint Sensor
[    5.020027] tsc: Refined TSC clocksource calibration: 2527.005 MHz
[    5.020029] Switching to clocksource tsc
[    5.028009] usb 2-2: new full-speed USB device number 3 using uhci_hcd
[    5.041120] irq 16: nobody cared (try booting with the "irqpoll" option)
[    5.041122] Pid: 0, comm: swapper/1 Not tainted 3.9.0-rc1 #7
[    5.041123] Call Trace:
[    5.041129]  <IRQ>  [<ffffffff8109d24b>] ? __report_bad_irq+0x21/0xc1
[    5.041131]  [<ffffffff8109d62d>] ? note_interrupt+0x16e/0x201
[    5.041133]  [<ffffffff8109b8d4>] ? handle_irq_event_percpu+0x163/0x1ad
[    5.041135]  [<ffffffff81074c38>] ? ktime_get+0x5f/0x6b
[    5.041137]  [<ffffffff8109b953>] ? handle_irq_event+0x35/0x56
[    5.041140]  [<ffffffff81065768>] ? sched_clock_idle_wakeup_event+0xf/0x17
[    5.041142]  [<ffffffff8109df1f>] ? handle_fasteoi_irq+0x80/0xb6
[    5.041144]  [<ffffffff8100f974>] ? handle_irq+0x18/0x20
[    5.041145]  [<ffffffff8100f6c1>] ? do_IRQ+0x41/0x97
[    5.041148]  [<ffffffff8138592d>] ? common_interrupt+0x6d/0x6d
[    5.041152]  <EOI>  [<ffffffff8102f48b>] ? native_safe_halt+0x2/0x3
[    5.041154]  [<ffffffff8101458b>] ? default_idle+0x34/0x5e
[    5.041156]  [<ffffffff81014c83>] ? cpu_idle+0xa6/0xe6
[    5.041158]  [<ffffffff81376cd6>] ? start_secondary+0x1e0/0x1e6
[    5.041159] handlers:
[    5.041165] [<ffffffffa0059fba>] usb_hcd_irq [usbcore]
[    5.041166] Disabling IRQ #16
[    5.084018] ata2: SATA link down (SStatus 0 SControl 300)
[    5.088625] sd 1:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.088675] sd 1:0:0:0: [sda] Write Protect is off
[    5.088677] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.088701] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.089157]  sda: sda1 sda2
[    5.089418] sd 1:0:0:0: [sda] Attached SCSI disk
[    5.091536] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    5.195020] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
[    5.195022] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.195023] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    5.195025] usb 2-2: Manufacturer: Lenovo Computer Corp
[    5.279247] Console: switching to colour frame buffer device 160x50
[    5.282553] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    5.282555] i915 0000:00:02.0: registered panic notifier
[    5.285730] acpi device:01: registered as cooling_device0
[    5.285899] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    5.285951] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    5.286004] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    5.286097] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.286101] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.286109] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    5.286160] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
[    5.286235] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.286238] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.286240] usb usb6: Product: UHCI Host Controller
[    5.286242] usb usb6: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    5.286245] usb usb6: SerialNumber: 0000:00:1d.2
[    5.286755] hub 6-0:1.0: USB hub found
[    5.286761] hub 6-0:1.0: 2 ports detected
[    5.308018] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[    5.451453] usb 3-1: New USB device found, idVendor=17ef, idProduct=1005
[    5.451456] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.454484] hub 3-1:1.0: USB hub found
[    5.456454] hub 3-1:1.0: 4 ports detected
[    5.572008] usb 3-2: new full-speed USB device number 3 using uhci_hcd
[    5.728451] usb 3-2: New USB device found, idVendor=17ef, idProduct=480c
[    5.728454] usb 3-2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    5.728457] usb 3-2: Manufacturer: Chicony Electronics Co., Ltd.
[    5.809452] usb 3-1.2: new low-speed USB device number 4 using uhci_hcd
[    5.953450] usb 3-1.2: New USB device found, idVendor=04b3, idProduct=3025
[    5.953453] usb 3-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.953455] usb 3-1.2: Product: USB NetVista Full Width Keyboard.
[    5.953457] usb 3-1.2: Manufacturer: LITE-ON Technology
[    5.975314] hidraw: raw HID events driver (C) Jiri Kosina
[    5.991512] usbcore: registered new interface driver usbhid
[    5.991515] usbhid: USB HID core driver
[    5.993570] input: LITE-ON Technology USB NetVista Full Width Keyboard. as /devices/pci0000:00/0000:00:1a.2/usb3/3-1/3-1.2/3-1.2:1.0/input/input5
[    5.993630] hid-generic 0003:04B3:3025.0001: input,hidraw0: USB HID v1.10 Keyboard [LITE-ON Technology USB NetVista Full Width Keyboard.] on usb-0000:00:1a.2-1.2/input0
[    6.061450] usb 3-1.3: new full-speed USB device number 5 using uhci_hcd
[    6.167451] usb 3-1.3: New USB device found, idVendor=0424, idProduct=2514
[    6.167454] usb 3-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.170486] hub 3-1.3:1.0: USB hub found
[    6.172452] hub 3-1.3:1.0: 2 ports detected
[   34.344078] mvumi 0000:02:00.1: no handshake response at state 0x2.
[   34.344115] mvumi 0000:02:00.1: isr : global=0x0,status=0x0.
[   34.344146] mvumi 0000:02:00.1: handshake failed at state 0x2.
[   34.344266] mvumi: probe of 0000:02:00.1 failed with error -22
[   35.118903] device-mapper: uevent: version 1.0.3
[   35.118964] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[   42.457909] bio: create slab <bio-1> at 1
[   42.643284] bio: create slab <bio-1> at 1
[   43.608017] raid6: sse2x1    4123 MB/s
[   43.676006] raid6: sse2x2    4275 MB/s
[   43.744008] raid6: sse2x4    7423 MB/s
[   43.744010] raid6: using algorithm sse2x4 (7423 MB/s)
[   43.744011] raid6: using ssse3x2 recovery algorithm
[   43.744968] xor: measuring software checksum speed
[   43.784003]    prefetch64-sse: 11018.000 MB/sec
[   43.824002]    generic_sse:  9659.000 MB/sec
[   43.824004] xor: using function: prefetch64-sse (11018.000 MB/sec)
[   43.851508] Btrfs loaded
[   43.927221] PM: Starting manual resume from disk
[   43.927225] PM: Hibernation image partition 254:4 present
[   43.927226] PM: Looking for hibernation image.
[   43.927710] PM: Image not found (code -22)
[   43.927711] PM: Hibernation image not present or could not be loaded.
[   43.965482] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   43.970125] XFS (dm-1): Mounting Filesystem
[   44.086680] XFS (dm-1): Ending clean mount
[   44.647596] udevd[543]: starting version 175
[   44.915231] ACPI: AC Adapter [AC] (on-line)
[   44.942108] ACPI: Battery Slot [BAT0] (battery present)
[   45.021843] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   45.027788] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   45.043812] ehci-pci: EHCI PCI platform driver
[   45.043974] ehci-pci 0000:00:1a.7: setting latency timer to 64
[   45.043978] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   45.043987] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 7
[   45.044017] ehci-pci 0000:00:1a.7: debug port 1
[   45.048015] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   45.048398] ehci-pci 0000:00:1a.7: irq 23, io mem 0xf2925c00
[   45.060152] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   45.060201] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[   45.060204] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   45.060207] usb usb7: Product: EHCI Host Controller
[   45.060209] usb usb7: Manufacturer: Linux 3.9.0-rc1 ehci_hcd
[   45.060211] usb usb7: SerialNumber: 0000:00:1a.7
[   45.060352] hub 7-0:1.0: USB hub found
[   45.060358] hub 7-0:1.0: 6 ports detected
[   45.061528] ehci-pci 0000:00:1d.7: setting latency timer to 64
[   45.061532] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   45.061540] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 8
[   45.061556] ehci-pci 0000:00:1d.7: debug port 1
[   45.065490] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   45.065520] ehci-pci 0000:00:1d.7: irq 19, io mem 0xf2926000
[   45.076020] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   45.076050] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[   45.076053] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   45.076056] usb usb8: Product: EHCI Host Controller
[   45.076058] usb usb8: Manufacturer: Linux 3.9.0-rc1 ehci_hcd
[   45.076060] usb usb8: SerialNumber: 0000:00:1d.7
[   45.076209] hub 8-0:1.0: USB hub found
[   45.076216] hub 8-0:1.0: 6 ports detected
[   45.100320] ACPI Warning: 0x0000000000001028-0x000000000000102f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20130117/utaddress-251)
[   45.100327] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   45.100332] ACPI Warning: 0x00000000000011b0-0x00000000000011bf SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130117/utaddress-251)
[   45.100335] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   45.100337] ACPI Warning: 0x0000000000001180-0x00000000000011af SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130117/utaddress-251)
[   45.100341] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   45.100342] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   45.120016] tpm_tis 00:09: 1.2 TPM (device-id 0x1020, rev-id 6)
[   45.120021] tpm_tis 00:09: Intel iTPM workaround enabled
[   45.256645] ACPI: Requesting acpi_cpufreq
[   45.259340] Monitor-Mwait will be used to enter C-1 state
[   45.259351] Monitor-Mwait will be used to enter C-2 state
[   45.259447] Monitor-Mwait will be used to enter C-3 state
[   45.259555] tsc: Marking TSC unstable due to TSC halts in idle
[   45.259570] ACPI: acpi_idle registered with cpuidle
[   45.282103] Switching to clocksource hpet
[   45.438654] iTCO_vendor_support: vendor-support=0
[   45.497012] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   45.497112] iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x1060)
[   45.497823] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   45.625503] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[   45.892064] usb 7-5: new high-speed USB device number 4 using ehci-pci
[   45.981211] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   45.998560] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input7
[   46.024458] usb 7-5: New USB device found, idVendor=17ef, idProduct=1005
[   46.024465] usb 7-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   46.024757] hub 7-5:1.0: USB hub found
[   46.024950] hub 7-5:1.0: 4 ports detected
[   46.136114] usb 7-6: new high-speed USB device number 5 using ehci-pci
[   46.241650] cfg80211: Calling CRDA to update world regulatory domain
[   46.273975] usb 7-6: New USB device found, idVendor=17ef, idProduct=480c
[   46.273987] usb 7-6: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[   46.273995] usb 7-6: Manufacturer: Chicony Electronics Co., Ltd.
[   46.275217] usb 2-1: USB disconnect, device number 2
[   46.369151] Non-volatile memory driver v1.3
[   46.529065] usb 2-1: new full-speed USB device number 4 using uhci_hcd
[   46.532185] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   46.532188] thinkpad_acpi: http://ibm-acpi.sf.net/
[   46.532191] thinkpad_acpi: ThinkPad BIOS 7XET72WW (3.22 ), EC 7XHT24WW-1.06
[   46.532193] thinkpad_acpi: Lenovo ThinkPad X200, model 7458E46
[   46.556189] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   46.557221] thinkpad_acpi: radio switch found; radios are enabled
[   46.557241] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   46.557243] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   46.559658] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   46.562447] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   46.562807] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   46.564241] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[   46.723973] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[   46.723986] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   46.723994] usb 2-1: Product: Fingerprint Sensor
[   46.726125] usb 2-2: USB disconnect, device number 3
[   46.810172] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   46.810175] Copyright(c) 2003-2013 Intel Corporation
[   46.810396] iwlwifi 0000:03:00.0: irq 49 for MSI/MSI-X
[   46.964067] usb 2-2: new full-speed USB device number 5 using uhci_hcd
[   47.133976] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
[   47.133989] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   47.133997] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[   47.134003] usb 2-2: Manufacturer: Lenovo Computer Corp
[   47.137704] usb 3-1: USB disconnect, device number 2
[   47.137715] usb 3-1.2: USB disconnect, device number 4
[   47.155148] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
[   47.180149] usb 3-1.3: USB disconnect, device number 5
[   47.209934] cfg80211: World regulatory domain updated:
[   47.209939] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   47.209943] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   47.209946] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   47.209949] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   47.209952] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   47.209955] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   47.308081] usb 3-2: USB disconnect, device number 3
[   47.517305] Bluetooth: Core ver 2.16
[   47.517330] NET: Registered protocol family 31
[   47.517331] Bluetooth: HCI device and connection manager initialized
[   47.517344] Bluetooth: HCI socket layer initialized
[   47.517347] Bluetooth: L2CAP socket layer initialized
[   47.517355] Bluetooth: SCO socket layer initialized
[   47.544242] usbcore: registered new interface driver btusb
[   47.764205] usb 7-5.2: new low-speed USB device number 6 using ehci-pci
[   47.879097] usb 7-5.2: New USB device found, idVendor=04b3, idProduct=3025
[   47.879109] usb 7-5.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   47.879116] usb 7-5.2: Product: USB NetVista Full Width Keyboard.
[   47.879123] usb 7-5.2: Manufacturer: LITE-ON Technology
[   47.886778] input: LITE-ON Technology USB NetVista Full Width Keyboard. as /devices/pci0000:00/0000:00:1a.7/usb7/7-5/7-5.2/7-5.2:1.0/input/input9
[   47.887074] hid-generic 0003:04B3:3025.0002: input,hidraw0: USB HID v1.10 Keyboard [LITE-ON Technology USB NetVista Full Width Keyboard.] on usb-0000:00:1a.7-5.2/input0
[   47.972248] usb 7-5.3: new high-speed USB device number 7 using ehci-pci
[   48.064863] usb 7-5.3: New USB device found, idVendor=0424, idProduct=2514
[   48.064876] usb 7-5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   48.065445] hub 7-5.3:1.0: USB hub found
[   48.065903] hub 7-5.3:1.0: 2 ports detected
[   48.100804] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
[   48.185091] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
[   48.187156] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
[   48.194757] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   48.195056] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   48.195287] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   48.195513] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   48.336599] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   48.336602] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   48.336605] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   48.336607] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   48.336609] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
[   48.336612] iwlwifi 0000:03:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
[   48.336639] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   48.358400] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[   48.373300] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   49.772998] loop: module loaded
[   50.103438] Adding 4251644k swap on /dev/mapper/main-swap.  Priority:-1 extents:1 across:4251644k 
[   51.141359] kjournald starting.  Commit interval 5 seconds
[   51.143144] EXT3-fs (sda1): using internal journal
[   51.143154] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   51.145144] XFS (dm-3): Mounting Filesystem
[   51.663862] XFS (dm-3): Ending clean mount
[   51.666395] XFS (dm-2): Mounting Filesystem
[   52.011212] XFS (dm-2): Ending clean mount
[   52.065710] XFS (dm-5): Mounting Filesystem
[   52.272310] XFS (dm-5): Ending clean mount
[   52.903959] EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: (null)
[   53.779467] sit: IPv6 over IPv4 tunneling driver
[   53.807415] tun: Universal TUN/TAP device driver, 1.6
[   53.807418] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   54.624630] RPC: Registered named UNIX socket transport module.
[   54.624634] RPC: Registered udp transport module.
[   54.624635] RPC: Registered tcp transport module.
[   54.624637] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   54.714426] FS-Cache: Loaded
[   55.071489] FS-Cache: Netfs 'nfs' registered for caching
[   55.459485] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   55.777170] fuse init (API version 7.21)
[   56.361241] NET: Registered protocol family 15
[   56.371457] alg: No test for cipher_null (cipher_null-generic)
[   56.371502] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[   56.371529] alg: No test for compress_null (compress_null-generic)
[   56.371554] alg: No test for digest_null (digest_null-generic)
[   56.410008] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[   56.503322] zfs-fuse (2931): /proc/3006/oom_adj is deprecated, please use /proc/3006/oom_score_adj instead.
[   58.133651] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input15
[   58.355173] Bluetooth: RFCOMM TTY layer initialized
[   58.355210] Bluetooth: RFCOMM socket layer initialized
[   58.355215] Bluetooth: RFCOMM ver 1.11
[   58.378785] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   58.378793] Bluetooth: BNEP filters: protocol multicast
[   58.378821] Bluetooth: BNEP socket layer initialized
[   58.842330] lp: driver loaded but no devices found
[   59.070492] ppdev: user-space parallel port driver
[   59.290827] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   59.392185] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   59.392407] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   61.028974] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[   61.029097] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[   61.029166] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   61.323121] Bridge firewalling registered
[   61.392867] device virbr0-nic entered promiscuous mode
[   61.611030] ip_tables: (C) 2000-2006 Netfilter Core Team
[   62.074203] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   62.609224] device virbr0-nic left promiscuous mode
[   62.609229] virbr0: port 1(virbr0-nic) entered disabled state
[   62.719264] device virbr1-nic entered promiscuous mode
[   62.800422] IPv6: ADDRCONF(NETDEV_UP): virbr1: link is not ready
[   63.412413] Ebtables v2.0 registered
[   63.612277] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  178.515882] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[  178.515900] Bluetooth: HIDP socket layer initialized
[  178.516651] hid-generic 0005:17EF:6002.0003: unknown main item tag 0x0
[  178.516740] input: ThinkPad Bluetooth Laser Mouse as /devices/pci0000:00/0000:00:1a.1/usb2/2-2/2-2:1.0/bluetooth/hci0/hci0:11/input16
[  178.517742] hid-generic 0005:17EF:6002.0003: input,hidraw1: BLUETOOTH HID v2.45 Mouse [ThinkPad Bluetooth Laser Mouse] on 00:25:56:cf:81:19

--=-=-=
Content-Disposition: inline; filename=dmesg_iommu_off.txt

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc1 (gaudenz@meteor) (gcc version 4.7.2 (Debian 4.7.2-5) ) #7 SMP Tue Mar 5 12:31:37 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.9.0-rc1 root=/dev/mapper/main-root ro resume=/dev/main/swap video=i915:modeset=1 acpi_osi=Linux intel_iommu=off splash quiet
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bd4a0fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd4a1000-0x00000000bd4a6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd4a7000-0x00000000bd5b7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd5b8000-0x00000000bd60efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd60f000-0x00000000bd6c5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd6c6000-0x00000000bd6d0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd6d1000-0x00000000bd6d3fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd6d4000-0x00000000bd6d7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd6d8000-0x00000000bd6dbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd6dc000-0x00000000bd6defff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd6df000-0x00000000bd705fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd706000-0x00000000bd707fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd708000-0x00000000bd90efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd90f000-0x00000000bd99efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bd99f000-0x00000000bd9fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bd9ff000-0x00000000bd9fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bdc00000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: LENOVO 7458E46/7458E46, BIOS 7XET72WW (3.22 ) 11/22/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 23C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FC0000000 write-back
[    0.000000]   6 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbde00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbda00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f7320-0x000f732f] mapped at [ffff8800000f7320]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01862000, 0x01862fff] PGTABLE
[    0.000000] BRK [0x01863000, 0x01863fff] PGTABLE
[    0.000000] BRK [0x01864000, 0x01864fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23be00000-0x23bffffff]
[    0.000000]  [mem 0x23be00000-0x23bffffff] page 2M
[    0.000000] BRK [0x01865000, 0x01865fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x238000000-0x23bdfffff]
[    0.000000]  [mem 0x238000000-0x23bdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x237ffffff]
[    0.000000]  [mem 0x200000000-0x237ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbd4a0fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbd3fffff] page 2M
[    0.000000]  [mem 0xbd400000-0xbd4a0fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbd4a7000-0xbd5b7fff]
[    0.000000]  [mem 0xbd4a7000-0xbd5b7fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbd60f000-0xbd6c5fff]
[    0.000000]  [mem 0xbd60f000-0xbd6c5fff] page 4k
[    0.000000] BRK [0x01866000, 0x01866fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbd9ff000-0xbd9fffff]
[    0.000000]  [mem 0xbd9ff000-0xbd9fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x233ec000-0x2d9edfff]
[    0.000000] ACPI: RSDP 00000000000f72e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd95b8a6 00094 (v01 LENOVO TP-7X    00003220  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd95ba00 000F4 (v03 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd95bdf4 0DF2D (v01 LENOVO TP-7X    00003220 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd95bbb4 00240 (v01 LENOVO TP-7X    00003220 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd969d21 00052 (v01 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd969d73 00078 (v01 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd969deb 0003C (v01 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd969e27 00038 (v01 LENOVO TP-7X    00003220 LNVO 00000001)
[    0.000000] ACPI: BOOT 00000000bd969f38 00028 (v01 LENOVO TP-7X    00003220  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd969f60 000A0 (v16 LENOVO TP-7X    00003220 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d1ea 00578 (v01 LENOVO TP-7X    00003220 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00110 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023bffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23bffffff]
[    0.000000]   NODE_DATA [mem 0x23bff4000-0x23bff7fff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880233600000-ffff88023a5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xbd4a0fff]
[    0.000000]   node   0: [mem 0xbd4a7000-0xbd5b7fff]
[    0.000000]   node   0: [mem 0xbd60f000-0xbd6c5fff]
[    0.000000]   node   0: [mem 0xbd9ff000-0xbd9fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23bffffff]
[    0.000000] On node 0 totalpages: 2070022
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10551 pages used for memmap
[    0.000000]   DMA32 zone: 771690 pages, LIFO batch:31
[    0.000000]   Normal zone: 17696 pages used for memmap
[    0.000000]   Normal zone: 1294336 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b8000 - 00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88023bc00000 s84672 r8192 d21824 u524288
[    0.000000] pcpu-alloc: s84672 r8192 d21824 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2041698
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.9.0-rc1 root=/dev/mapper/main-root ro resume=/dev/main/swap video=i915:modeset=1 acpi_osi=Linux intel_iommu=off splash quiet
[    0.000000] Intel-IOMMU: disabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7919920k/9371648k available (3641k kernel code, 1091560k absent, 360168k reserved, 3107k data, 880k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2527.115 MHz processor
[    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5054.23 BogoMIPS (lpj=10108460)
[    0.004007] pid_max: default: 32768 minimum: 301
[    0.004043] Security Framework initialized
[    0.004049] AppArmor: AppArmor disabled by boot time parameter
[    0.008531] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.012578] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.014460] Mount-cache hash table entries: 256
[    0.014735] Initializing cgroup subsys cpuacct
[    0.014739] Initializing cgroup subsys devices
[    0.014741] Initializing cgroup subsys freezer
[    0.014743] Initializing cgroup subsys net_cls
[    0.014745] Initializing cgroup subsys blkio
[    0.014747] Initializing cgroup subsys perf_event
[    0.014783] Disabled fast string operations
[    0.014789] CPU: Physical Processor ID: 0
[    0.014791] CPU: Processor Core ID: 0
[    0.014793] mce: CPU supports 6 MCE banks
[    0.014802] CPU0: Thermal monitoring enabled (TM2)
[    0.014811] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.014811] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.014811] tlb_flushall_shift: -1
[    0.014861] Freeing SMP alternatives: 8k freed
[    0.015260] ACPI: Core revision 20130117
[    0.022407] ACPI: All ACPI Tables successfully acquired
[    0.024088] dmar: Host address width 36
[    0.024091] dmar: DRHD base: 0x000000feb03000 flags: 0x0
[    0.024099] dmar: IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
[    0.024101] dmar: DRHD base: 0x000000feb01000 flags: 0x0
[    0.024106] dmar: IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020630260 ecap 1000
[    0.024107] dmar: DRHD base: 0x000000feb00000 flags: 0x0
[    0.024113] dmar: IOMMU 2: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
[    0.024114] dmar: DRHD base: 0x000000feb02000 flags: 0x1
[    0.024119] dmar: IOMMU 3: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
[    0.024121] dmar: RMRR base: 0x000000f2925c00 end: 0x000000f29263ff
[    0.024123] dmar: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[    0.024639] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066123] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz (fam: 06, model: 17, stepping: 0a)
[    0.068000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.068000] ... version:                2
[    0.068000] ... bit width:              40
[    0.068000] ... generic registers:      2
[    0.068000] ... value mask:             000000ffffffffff
[    0.068000] ... max period:             000000007fffffff
[    0.068000] ... fixed-purpose events:   3
[    0.068000] ... event mask:             0000000700000003
[    0.008000] Disabled fast string operations
[    0.068000] smpboot: Booting Node   0, Processors  #1
[    0.076027] Brought up 2 CPUs
[    0.076031] smpboot: Total of 2 processors activated (10108.46 BogoMIPS)
[    0.076223] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.077905] devtmpfs: initialized
[    0.081673] PM: Registering ACPI NVS region [mem 0xbd6c6000-0xbd6d0fff] (45056 bytes)
[    0.081673] PM: Registering ACPI NVS region [mem 0xbd6d8000-0xbd6dbfff] (16384 bytes)
[    0.081673] PM: Registering ACPI NVS region [mem 0xbd6df000-0xbd705fff] (159744 bytes)
[    0.081673] PM: Registering ACPI NVS region [mem 0xbd90f000-0xbd99efff] (589824 bytes)
[    0.081673] regulator-dummy: no parameters
[    0.081673] NET: Registered protocol family 16
[    0.081673] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.081673] ACPI: bus type pci registered
[    0.081673] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.081673] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.089298] PCI: Using configuration type 1 for base access
[    0.090176] bio: create slab <bio-0> at 0
[    0.090176] ACPI: Added _OSI(Module Device)
[    0.090176] ACPI: Added _OSI(Processor Device)
[    0.090176] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.090176] ACPI: Added _OSI(Processor Aggregator Device)
[    0.090176] ACPI: Added _OSI(Linux)
[    0.090176] ACPI: EC: EC description table is found, configuring boot EC
[    0.096375] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[    0.608389] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.608769] ACPI: Dynamic OEM Table Load:
[    0.608771] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.608889] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.608889] ACPI: Dynamic OEM Table Load:
[    0.608889] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.608889] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.608889] ACPI: Dynamic OEM Table Load:
[    0.608889] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.612071] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.612448] ACPI: Dynamic OEM Table Load:
[    0.612450] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.616168] ACPI: Interpreter enabled
[    0.616173] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.616180] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.616186]  S3 S4 S5)
[    0.616194] ACPI: Using IOAPIC for interrupt routing
[    0.616222] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.640039] ACPI: Power Resource [PUBS] (on)
[    0.645062] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.645180] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.645298] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.645415] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.645532] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.645649] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.645766] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.645883] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.645937] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.646315] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.648346] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
[    0.648377] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.648412] PCI host bridge to bus 0000:00
[    0.648415] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.648418] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.648420] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.648423] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.648425] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.648428] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.648439] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
[    0.648457] DMAR: Forcing write-buffer flush capability
[    0.648458] DMAR: Disabling IOMMU for graphics on this chipset
[    0.648544] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
[    0.648556] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.648563] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.648569] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.648639] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
[    0.648649] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.648756] pci 0000:00:03.0: [8086:2a44] type 00 class 0x078000
[    0.648771] pci 0000:00:03.0: reg 10: [mem 0xf2925800-0xf292580f 64bit]
[    0.648819] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.648954] pci 0000:00:19.0: [8086:10bf] type 00 class 0x020000
[    0.648979] pci 0000:00:19.0: reg 10: [mem 0xf2700000-0xf271ffff]
[    0.648990] pci 0000:00:19.0: reg 14: [mem 0xf2924000-0xf2924fff]
[    0.649002] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    0.649089] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.649119] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.649168] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
[    0.649224] pci 0000:00:1a.0: reg 20: [io  0x1840-0x185f]
[    0.649323] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.649371] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
[    0.649426] pci 0000:00:1a.1: reg 20: [io  0x1860-0x187f]
[    0.649547] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
[    0.649603] pci 0000:00:1a.2: reg 20: [io  0x1880-0x189f]
[    0.649705] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.649763] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
[    0.649788] pci 0000:00:1a.7: reg 10: [mem 0xf2925c00-0xf2925fff]
[    0.649896] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.649948] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.650000] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.650021] pci 0000:00:1b.0: reg 10: [mem 0xf2920000-0xf2923fff 64bit]
[    0.650116] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.650175] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.650224] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
[    0.650324] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.650359] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.650407] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
[    0.650506] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.650542] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.650592] pci 0000:00:1c.3: [8086:2946] type 01 class 0x060400
[    0.650691] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.650731] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.650784] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.650840] pci 0000:00:1d.0: reg 20: [io  0x18a0-0x18bf]
[    0.650935] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.650983] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.651038] pci 0000:00:1d.1: reg 20: [io  0x18c0-0x18df]
[    0.651155] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.651210] pci 0000:00:1d.2: reg 20: [io  0x18e0-0x18ff]
[    0.651341] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.651366] pci 0000:00:1d.7: reg 10: [mem 0xf2926000-0xf29263ff]
[    0.651474] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.651525] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.651571] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.651722] pci 0000:00:1f.0: [8086:2919] type 00 class 0x060100
[    0.651919] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
[    0.651946] pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
[    0.651958] pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
[    0.651969] pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
[    0.651980] pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
[    0.651991] pci 0000:00:1f.2: reg 20: [io  0x1c00-0x1c1f]
[    0.652008] pci 0000:00:1f.2: reg 24: [mem 0xf2925000-0xf29257ff]
[    0.652076] pci 0000:00:1f.2: PME# supported from D3hot
[    0.652153] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
[    0.652175] pci 0000:00:1f.3: reg 10: [mem 0xf2926400-0xf29264ff 64bit]
[    0.652204] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
[    0.652390] pci 0000:02:00.0: [1b4b:91f3] type 00 class 0x01ff00
[    0.652415] pci 0000:02:00.0: reg 10: [io  0x2020-0x2027]
[    0.652433] pci 0000:02:00.0: reg 14: [io  0x2014-0x2017]
[    0.652450] pci 0000:02:00.0: reg 18: [io  0x2018-0x201f]
[    0.652468] pci 0000:02:00.0: reg 1c: [io  0x2010-0x2013]
[    0.652486] pci 0000:02:00.0: reg 20: [io  0x2000-0x200f]
[    0.652504] pci 0000:02:00.0: reg 24: [mem 0xf2500000-0xf2501fff]
[    0.652522] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.652605] pci 0000:02:00.0: PME# supported from D3hot
[    0.652699] pci 0000:02:00.1: [1b4b:9143] type 00 class 0x018000
[    0.652724] pci 0000:02:00.1: reg 10: [mem 0xf2a00000-0xf2afffff pref]
[    0.652819] pci 0000:02:00.1: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.652903] pci 0000:02:00.1: PME# supported from D3hot
[    0.652994] pci 0000:02:00.2: [1b4b:91e3] type 00 class 0x010801
[    0.653028] pci 0000:02:00.2: reg 10: [mem 0xf2502000-0xf2503fff 64bit]
[    0.653045] pci 0000:02:00.2: reg 18: [io  0x2028-0x202f]
[    0.653110] pci 0000:02:00.2: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.660023] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.660028] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.660033] pci 0000:00:1c.0:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.660041] pci 0000:00:1c.0:   bridge window [mem 0xf2a00000-0xf2afffff 64bit pref]
[    0.660150] pci 0000:03:00.0: [8086:4236] type 00 class 0x028000
[    0.660190] pci 0000:03:00.0: reg 10: [mem 0xf2600000-0xf2601fff 64bit]
[    0.660382] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.668021] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.668029] pci 0000:00:1c.1:   bridge window [mem 0xf2600000-0xf26fffff]
[    0.668110] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.668115] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.668120] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.668128] pci 0000:00:1c.3:   bridge window [mem 0xf2b00000-0xf2bfffff 64bit pref]
[    0.668234] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
[    0.668247] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.668250] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.668252] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.668255] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.668257] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.672607] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.672619] acpi root: \_SB_.PCI0 notify handler is installed
[    0.672664] Found 1 acpi root devices
[    0.672738] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.672781] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.676018] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.676024] vgaarb: loaded
[    0.676026] vgaarb: bridge control possible 0000:00:02.0
[    0.676077] PCI: Using ACPI for IRQ routing
[    0.678390] PCI: pci_cache_line_size set to 64 bytes
[    0.678472] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.678474] e820: reserve RAM buffer [mem 0xbd4a1000-0xbfffffff]
[    0.678477] e820: reserve RAM buffer [mem 0xbd5b8000-0xbfffffff]
[    0.678479] e820: reserve RAM buffer [mem 0xbd6c6000-0xbfffffff]
[    0.678482] e820: reserve RAM buffer [mem 0xbda00000-0xbfffffff]
[    0.678649] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.678655] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.678659] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.680016] Switching to clocksource hpet
[    0.682132] pnp: PnP ACPI init
[    0.682146] ACPI: bus type pnp registered
[    0.702604] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.702607] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.702610] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.702613] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.702616] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.702619] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.702622] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.702624] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.702627] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.702630] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.702633] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.702636] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.702639] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.702642] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.702645] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.702648] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.702651] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.722742] system 00:01: [io  0x1000-0x107f] has been reserved
[    0.722745] system 00:01: [io  0x1180-0x11ff] has been reserved
[    0.722748] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.722751] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.722754] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.722757] system 00:01: [io  0x1680-0x169f] has been reserved
[    0.722760] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.722763] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.722766] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.722769] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.722772] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.722774] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.722778] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.722839] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.722851] pnp 00:03: [dma 4]
[    0.722877] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.722907] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.722948] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.722987] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.723023] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.723061] pnp 00:08: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    0.743118] pnp 00:09: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.743652] pnp: PnP ACPI: found 10 devices
[    0.743654] ACPI: ACPI bus type pnp unregistered
[    0.750730] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.750734] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.750758] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.750761] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.750766] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.750770] pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
[    0.750775] pci 0000:02:00.0: BAR 6: assigned [mem 0xf2510000-0xf251ffff pref]
[    0.750779] pci 0000:02:00.1: BAR 6: assigned [mem 0xf2520000-0xf252ffff pref]
[    0.750782] pci 0000:02:00.2: BAR 6: assigned [mem 0xf2530000-0xf253ffff pref]
[    0.750785] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.750789] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.750795] pci 0000:00:1c.0:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.750800] pci 0000:00:1c.0:   bridge window [mem 0xf2a00000-0xf2afffff 64bit pref]
[    0.750807] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.750811] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.750817] pci 0000:00:1c.1:   bridge window [mem 0xf2600000-0xf26fffff]
[    0.750822] pci 0000:00:1c.1:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.750830] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.750834] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.750840] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.750845] pci 0000:00:1c.3:   bridge window [mem 0xf2b00000-0xf2bfffff 64bit pref]
[    0.750852] pci 0000:00:1e.0: PCI bridge to [bus 0d]
[    0.751024] pci 0000:00:1e.0: setting latency timer to 64
[    0.751028] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.751031] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.751033] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.751035] pci_bus 0000:00: resource 7 [mem 0x000d8000-0x000dbfff]
[    0.751038] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xfebfffff]
[    0.751040] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.751043] pci_bus 0000:02: resource 1 [mem 0xf2500000-0xf25fffff]
[    0.751045] pci_bus 0000:02: resource 2 [mem 0xf2a00000-0xf2afffff 64bit pref]
[    0.751048] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    0.751050] pci_bus 0000:03: resource 1 [mem 0xf2600000-0xf26fffff]
[    0.751052] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.751055] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    0.751057] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.751060] pci_bus 0000:05: resource 2 [mem 0xf2b00000-0xf2bfffff 64bit pref]
[    0.751062] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    0.751064] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    0.751067] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    0.751069] pci_bus 0000:0d: resource 7 [mem 0x000d8000-0x000dbfff]
[    0.751071] pci_bus 0000:0d: resource 8 [mem 0xc0000000-0xfebfffff]
[    0.751121] NET: Registered protocol family 2
[    0.751400] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.751843] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.752206] TCP: Hash tables configured (established 65536 bind 65536)
[    0.752282] TCP: reno registered
[    0.752297] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.752355] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.752497] NET: Registered protocol family 1
[    0.752515] pci 0000:00:02.0: Boot video device
[    0.752532] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.752756] pci 0000:00:1a.2: power state changed by ACPI to D0
[    0.752992] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.753430] PCI: CLS 64 bytes, default 64
[    0.753477] Unpacking initramfs...
[    4.425628] Freeing initrd memory: 169992k freed
[    4.521814] DMA-API: preallocated 65536 debug entries
[    4.521817] DMA-API: debugging enabled by kernel config
[    4.521833] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.521836] software IO TLB [mem 0xb94a1000-0xbd4a1000] (64MB) mapped at [ffff8800b94a1000-ffff8800bd4a0fff]
[    4.521903] Simple Boot Flag at 0x35 set to 0x1
[    4.522281] audit: initializing netlink socket (disabled)
[    4.522297] type=2000 audit(1362491682.516:1): initialized
[    4.535659] bounce pool size: 64 pages
[    4.535665] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.536436] VFS: Disk quotas dquot_6.5.2
[    4.536462] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.536571] msgmni has been set to 15800
[    4.536816] alg: No test for stdrng (krng)
[    4.536839] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    4.536842] io scheduler noop registered
[    4.536843] io scheduler deadline registered
[    4.536856] io scheduler cfq registered (default)
[    4.537027] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    4.537188] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    4.537346] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    4.537491] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    4.537494] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    4.537496] pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
[    4.537499] pci 0000:02:00.2: Signaling PME through PCIe PME interrupt
[    4.537504] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    4.537534] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    4.537536] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    4.537541] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    4.537569] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    4.537574] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    4.537581] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.537657] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
[    4.537684] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    4.537697] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
[    4.537720] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    4.537733] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
[    4.537758] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    4.537765] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.537766] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.537977] intel_idle: does not run on family 6 model 23
[    4.538027] GHES: HEST is not enabled!
[    4.538093] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.538610] Linux agpgart interface v0.103
[    4.538690] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    4.538764] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    4.539726] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    4.539857] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    4.539979] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    4.551192] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.551200] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.551341] mousedev: PS/2 mouse device common for all mice
[    4.551391] rtc_cmos 00:06: RTC can wake from S4
[    4.551539] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    4.551571] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.551580] cpuidle: using governor ladder
[    4.551582] cpuidle: using governor menu
[    4.551611] drop_monitor: Initializing network drop monitor service
[    4.551691] TCP: cubic registered
[    4.551724] NET: Registered protocol family 10
[    4.551936] mip6: Mobile IPv6
[    4.551939] NET: Registered protocol family 17
[    4.551954] Key type dns_resolver registered
[    4.552245] PM: Checking hibernation image partition /dev/main/swap
[    4.560418] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.571690] PM: Hibernation image not present or could not be loaded.
[    4.571705] registered taskstats version 1
[    4.573680] Freeing unused kernel memory: 880k freed
[    4.573906] Write protecting the kernel read-only data: 6144k
[    4.575123] Freeing unused kernel memory: 444k freed
[    4.577049] Freeing unused kernel memory: 548k freed
[    4.639178] udevd[57]: starting version 175
[    4.667759] pps_core: LinuxPPS API ver. 1 registered
[    4.667763] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    4.691182] PTP clock support registered
[    4.709212] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    4.712284] ACPI: Lid Switch [LID]
[    4.712361] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    4.712366] ACPI: Sleep Button [SLPB]
[    4.712448] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.712451] ACPI: Power Button [PWRF]
[    4.714934] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa0c
[    4.715036] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa0c
[    4.721579] SCSI subsystem initialized
[    4.722873] e1000e: Intel(R) PRO/1000 Network Driver - 2.2.14-k
[    4.722877] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    4.723009] e1000e 0000:00:19.0: setting latency timer to 64
[    4.723104] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.723157] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.728064] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.728703] ACPI: bus type usb registered
[    4.728737] usbcore: registered new interface driver usbfs
[    4.728751] usbcore: registered new interface driver hub
[    4.735591] usbcore: registered new device driver usb
[    4.736953] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.737639] uhci_hcd: USB Universal Host Controller Interface driver
[    4.744045] [drm] Initialized drm 1.1.0 20060810
[    4.752667] wmi: Mapper loaded
[    4.755290] thermal LNXTHERM:00: registered as thermal_zone0
[    4.755293] ACPI: Thermal Zone [THM0] (59 C)
[    4.757471] ACPI: bus type scsi registered
[    4.759705] thermal LNXTHERM:01: registered as thermal_zone1
[    4.759708] ACPI: Thermal Zone [THM1] (59 C)
[    4.777284] libata version 3.00 loaded.
[    4.892336] scsi0 : Marvell Storage Controller
[    4.936051] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:1f:16:27:99:3d
[    4.936054] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.936081] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    4.936185] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.936190] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.936198] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.936245] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001840
[    4.936309] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.936312] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.936314] usb usb1: Product: UHCI Host Controller
[    4.936316] usb usb1: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.936318] usb usb1: SerialNumber: 0000:00:1a.0
[    4.936479] hub 1-0:1.0: USB hub found
[    4.936485] hub 1-0:1.0: 2 ports detected
[    4.936953] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.936957] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.936963] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.937005] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001860
[    4.937059] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.937062] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.937064] usb usb2: Product: UHCI Host Controller
[    4.937066] usb usb2: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.937069] usb usb2: SerialNumber: 0000:00:1a.1
[    4.937183] hub 2-0:1.0: USB hub found
[    4.937189] hub 2-0:1.0: 2 ports detected
[    4.937350] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.937353] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.937359] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.937400] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00001880
[    4.937458] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.937460] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.937463] usb usb3: Product: UHCI Host Controller
[    4.937465] usb usb3: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.937467] usb usb3: SerialNumber: 0000:00:1a.2
[    4.937577] hub 3-0:1.0: USB hub found
[    4.937581] hub 3-0:1.0: 2 ports detected
[    4.937752] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.937756] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.937761] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    4.937789] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
[    4.937842] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.937845] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.937847] usb usb4: Product: UHCI Host Controller
[    4.937849] usb usb4: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.937851] usb usb4: SerialNumber: 0000:00:1d.0
[    4.937959] hub 4-0:1.0: USB hub found
[    4.937964] hub 4-0:1.0: 2 ports detected
[    4.938121] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.938125] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.938131] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    4.938172] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
[    4.938225] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.938227] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.938230] usb usb5: Product: UHCI Host Controller
[    4.938232] usb usb5: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.938234] usb usb5: SerialNumber: 0000:00:1d.1
[    4.938338] hub 5-0:1.0: USB hub found
[    4.938343] hub 5-0:1.0: 2 ports detected
[    4.938499] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.938503] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.938509] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    4.938550] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
[    4.938603] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.938605] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.938608] usb usb6: Product: UHCI Host Controller
[    4.938610] usb usb6: Manufacturer: Linux 3.9.0-rc1 uhci_hcd
[    4.938612] usb usb6: SerialNumber: 0000:00:1d.2
[    4.938718] hub 6-0:1.0: USB hub found
[    4.938723] hub 6-0:1.0: 2 ports detected
[    4.938839] ahci 0000:00:1f.2: version 3.0
[    4.938965] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    4.939021] ahci: SSS flag set, parallel bus scan disabled
[    4.939048] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    4.939052] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    4.939057] ahci 0000:00:1f.2: setting latency timer to 64
[    4.940746] scsi1 : ahci
[    4.940963] scsi2 : ahci
[    4.942502] scsi3 : ahci
[    4.942599] scsi4 : ahci
[    4.942655] ata1: SATA max UDMA/133 abar m2048@0xf2925000 port 0xf2925100 irq 44
[    4.942659] ata2: SATA max UDMA/133 abar m2048@0xf2925000 port 0xf2925180 irq 44
[    4.942661] ata3: DUMMY
[    4.942662] ata4: DUMMY
[    4.943139] [drm] Memory usable by graphics device = 2048M
[    4.943145] i915 0000:00:02.0: setting latency timer to 64
[    4.970767] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    4.970776] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.970777] [drm] Driver supports precise vblank timestamp query.
[    4.970838] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    5.248049] usb 2-1: new full-speed USB device number 2 using uhci_hcd
[    5.254800] fbcon: inteldrmfb (fb0) is primary device
[    5.260046] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.262541] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    5.262543] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    5.262545] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    5.265808] ata1.00: ATA-8: ST93205620AS, SD28, max UDMA/133
[    5.265809] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    5.267325] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    5.267327] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    5.267329] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    5.269475] ata1.00: configured for UDMA/133
[    5.269631] scsi 1:0:0:0: Direct-Access     ATA      ST93205620AS     SD28 PQ: 0 ANSI: 5
[    5.415072] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.415074] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.415076] usb 2-1: Product: Fingerprint Sensor
[    5.520028] tsc: Refined TSC clocksource calibration: 2526.999 MHz
[    5.520031] Switching to clocksource tsc
[    5.528013] usb 2-2: new full-speed USB device number 3 using uhci_hcd
[    5.588032] ata2: SATA link down (SStatus 0 SControl 300)
[    5.609709] sd 1:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    5.609783] sd 1:0:0:0: [sda] Write Protect is off
[    5.609785] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.609825] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.610394]  sda: sda1 sda2
[    5.610774] sd 1:0:0:0: [sda] Attached SCSI disk
[    5.613905] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    5.681572] irq 16: nobody cared (try booting with the "irqpoll" option)
[    5.681574] Pid: 0, comm: swapper/1 Not tainted 3.9.0-rc1 #7
[    5.681574] Call Trace:
[    5.681580]  <IRQ>  [<ffffffff8109d24b>] ? __report_bad_irq+0x21/0xc1
[    5.681583]  [<ffffffff8109d62d>] ? note_interrupt+0x16e/0x201
[    5.681585]  [<ffffffff8109b8d4>] ? handle_irq_event_percpu+0x163/0x1ad
[    5.681587]  [<ffffffff81074c38>] ? ktime_get+0x5f/0x6b
[    5.681589]  [<ffffffff8109b953>] ? handle_irq_event+0x35/0x56
[    5.681592]  [<ffffffff81065768>] ? sched_clock_idle_wakeup_event+0xf/0x17
[    5.681594]  [<ffffffff8109df1f>] ? handle_fasteoi_irq+0x80/0xb6
[    5.681596]  [<ffffffff8100f974>] ? handle_irq+0x18/0x20
[    5.681597]  [<ffffffff8100f6c1>] ? do_IRQ+0x41/0x97
[    5.681600]  [<ffffffff8138592d>] ? common_interrupt+0x6d/0x6d
[    5.681603]  <EOI>  [<ffffffff8102f48b>] ? native_safe_halt+0x2/0x3
[    5.681606]  [<ffffffff8101458b>] ? default_idle+0x34/0x5e
[    5.681608]  [<ffffffff81014c83>] ? cpu_idle+0xa6/0xe6
[    5.681610]  [<ffffffff81376cd6>] ? start_secondary+0x1e0/0x1e6
[    5.681611] handlers:
[    5.681615] [<ffffffffa007b93e>] mvumi_isr_handler [mvumi]
[    5.681620] [<ffffffffa0028fba>] usb_hcd_irq [usbcore]
[    5.681621] Disabling IRQ #16
[    5.690061] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
[    5.690063] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.690065] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    5.690066] usb 2-2: Manufacturer: Lenovo Computer Corp
[    5.804014] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[    5.859258] Console: switching to colour frame buffer device 160x50
[    5.862588] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    5.862590] i915 0000:00:02.0: registered panic notifier
[    5.865898] acpi device:01: registered as cooling_device0
[    5.866066] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    5.866118] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    5.866173] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    5.947466] usb 3-1: New USB device found, idVendor=17ef, idProduct=1005
[    5.947470] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.950496] hub 3-1:1.0: USB hub found
[    5.952466] hub 3-1:1.0: 4 ports detected
[    6.068057] usb 3-2: new full-speed USB device number 3 using uhci_hcd
[    6.224464] usb 3-2: New USB device found, idVendor=17ef, idProduct=480c
[    6.224469] usb 3-2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    6.224471] usb 3-2: Manufacturer: Chicony Electronics Co., Ltd.
[    6.305471] usb 3-1.2: new low-speed USB device number 4 using uhci_hcd
[    6.449464] usb 3-1.2: New USB device found, idVendor=04b3, idProduct=3025
[    6.449468] usb 3-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.449470] usb 3-1.2: Product: USB NetVista Full Width Keyboard.
[    6.449473] usb 3-1.2: Manufacturer: LITE-ON Technology
[    6.471914] hidraw: raw HID events driver (C) Jiri Kosina
[    6.487662] usbcore: registered new interface driver usbhid
[    6.487665] usbhid: USB HID core driver
[    6.490266] input: LITE-ON Technology USB NetVista Full Width Keyboard. as /devices/pci0000:00/0000:00:1a.2/usb3/3-1/3-1.2/3-1.2:1.0/input/input5
[    6.490353] hid-generic 0003:04B3:3025.0001: input,hidraw0: USB HID v1.10 Keyboard [LITE-ON Technology USB NetVista Full Width Keyboard.] on usb-0000:00:1a.2-1.2/input0
[    6.557472] usb 3-1.3: new full-speed USB device number 5 using uhci_hcd
[    6.624411] device-mapper: uevent: version 1.0.3
[    6.624723] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    6.679490] usb 3-1.3: New USB device found, idVendor=0424, idProduct=2514
[    6.679495] usb 3-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.682530] hub 3-1.3:1.0: USB hub found
[    6.684472] hub 3-1.3:1.0: 2 ports detected
[    7.680038] scsi 0:0:0:0: Processor         SR64C8MM Flash Console    2037 PQ: 0 ANSI: 3
[    7.680192] scsi 0:0:0:0: Attached scsi generic sg1 type 3
[    7.880035] scsi 0:0:1:0: Direct-Access     SR64C8MM Flash Disk       2037 PQ: 0 ANSI: 3
[    7.880203] sd 0:0:1:0: Attached scsi generic sg2 type 0
[    8.080029] sd 0:0:1:0: [sdb] 104857600 512-byte logical blocks: (53.6 GB/50.0 GiB)
[    8.180025] sd 0:0:1:0: [sdb] Write Protect is off
[    8.180028] sd 0:0:1:0: [sdb] Mode Sense: 17 00 00 00
[    8.380023] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.980085]  sdb: sdb1
[    9.480031] sd 0:0:1:0: [sdb] Attached SCSI disk
[   20.448318] bio: create slab <bio-1> at 1
[   20.717517] bio: create slab <bio-1> at 1
[   23.108008] raid6: sse2x1    4124 MB/s
[   23.176014] raid6: sse2x2    4304 MB/s
[   23.244007] raid6: sse2x4    7426 MB/s
[   23.244009] raid6: using algorithm sse2x4 (7426 MB/s)
[   23.244011] raid6: using ssse3x2 recovery algorithm
[   23.245253] xor: measuring software checksum speed
[   23.284002]    prefetch64-sse: 11019.000 MB/sec
[   23.324002]    generic_sse:  9659.000 MB/sec
[   23.324004] xor: using function: prefetch64-sse (11019.000 MB/sec)
[   23.351334] Btrfs loaded
[   23.580056] device fsid a517c6b2-003d-4054-97ed-dd34808d627d devid 1 transid 27 /dev/sdb
[   23.836083] PM: Starting manual resume from disk
[   23.836086] PM: Hibernation image partition 254:4 present
[   23.836088] PM: Looking for hibernation image.
[   23.836931] PM: Image not found (code -22)
[   23.836933] PM: Hibernation image not present or could not be loaded.
[   23.874550] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   23.878695] XFS (dm-1): Mounting Filesystem
[   24.153259] XFS (dm-1): Ending clean mount
[   24.799594] udevd[531]: starting version 175
[   25.063722] ehci-pci: EHCI PCI platform driver
[   25.063851] ehci-pci 0000:00:1a.7: setting latency timer to 64
[   25.063856] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   25.063864] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 7
[   25.063883] ehci-pci 0000:00:1a.7: debug port 1
[   25.067821] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   25.068692] ehci-pci 0000:00:1a.7: irq 23, io mem 0xf2925c00
[   25.080034] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   25.080083] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[   25.080086] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   25.080089] usb usb7: Product: EHCI Host Controller
[   25.080091] usb usb7: Manufacturer: Linux 3.9.0-rc1 ehci_hcd
[   25.080093] usb usb7: SerialNumber: 0000:00:1a.7
[   25.080234] hub 7-0:1.0: USB hub found
[   25.080240] hub 7-0:1.0: 6 ports detected
[   25.080608] ehci-pci 0000:00:1d.7: setting latency timer to 64
[   25.080612] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   25.080619] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 8
[   25.080635] ehci-pci 0000:00:1d.7: debug port 1
[   25.084577] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   25.084632] ehci-pci 0000:00:1d.7: irq 19, io mem 0xf2926000
[   25.096450] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   25.096487] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[   25.096490] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   25.096493] usb usb8: Product: EHCI Host Controller
[   25.096495] usb usb8: Manufacturer: Linux 3.9.0-rc1 ehci_hcd
[   25.096497] usb usb8: SerialNumber: 0000:00:1d.7
[   25.098791] ACPI: Requesting acpi_cpufreq
[   25.099044] hub 8-0:1.0: USB hub found
[   25.099052] hub 8-0:1.0: 6 ports detected
[   25.102476] Monitor-Mwait will be used to enter C-1 state
[   25.102482] Monitor-Mwait will be used to enter C-2 state
[   25.102486] Monitor-Mwait will be used to enter C-3 state
[   25.102489] tsc: Marking TSC unstable due to TSC halts in idle
[   25.102500] ACPI: acpi_idle registered with cpuidle
[   25.102530] Switching to clocksource hpet
[   25.200058] usb 2-1: USB disconnect, device number 2
[   25.211028] ACPI: Battery Slot [BAT0] (battery present)
[   25.215250] ACPI: AC Adapter [AC] (on-line)
[   25.252794] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   25.328072] usb 2-2: USB disconnect, device number 3
[   25.334971] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   25.416034] tpm_tis 00:09: 1.2 TPM (device-id 0x1020, rev-id 6)
[   25.416040] tpm_tis 00:09: Intel iTPM workaround enabled
[   25.456083] usb 3-1: USB disconnect, device number 2
[   25.456086] usb 3-1.2: USB disconnect, device number 4
[   25.472053] usb 3-1.3: USB disconnect, device number 5
[   25.600063] usb 3-2: USB disconnect, device number 3
[   25.694231] ACPI Warning: 0x0000000000001028-0x000000000000102f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20130117/utaddress-251)
[   25.694239] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   25.694244] ACPI Warning: 0x00000000000011b0-0x00000000000011bf SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130117/utaddress-251)
[   25.694248] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   25.694249] ACPI Warning: 0x0000000000001180-0x00000000000011af SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130117/utaddress-251)
[   25.694253] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   25.694255] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   25.797109] iTCO_vendor_support: vendor-support=0
[   25.822940] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   25.823020] iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x1060)
[   25.823357] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   26.360074] usb 7-5: new high-speed USB device number 4 using ehci-pci
[   26.492542] usb 7-5: New USB device found, idVendor=17ef, idProduct=1005
[   26.492547] usb 7-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   26.493017] hub 7-5:1.0: USB hub found
[   26.493111] hub 7-5:1.0: 4 ports detected
[   26.546879] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[   26.604063] usb 7-6: new high-speed USB device number 5 using ehci-pci
[   26.741759] usb 7-6: New USB device found, idVendor=17ef, idProduct=480c
[   26.741771] usb 7-6: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[   26.741779] usb 7-6: Manufacturer: Chicony Electronics Co., Ltd.
[   26.880063] Non-volatile memory driver v1.3
[   26.901416] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   26.920845] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input7
[   27.083638] cfg80211: Calling CRDA to update world regulatory domain
[   27.112072] usb 2-1: new full-speed USB device number 4 using uhci_hcd
[   27.289113] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[   27.289125] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   27.289133] usb 2-1: Product: Fingerprint Sensor
[   27.333437] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   27.333440] thinkpad_acpi: http://ibm-acpi.sf.net/
[   27.333442] thinkpad_acpi: ThinkPad BIOS 7XET72WW (3.22 ), EC 7XHT24WW-1.06
[   27.333443] thinkpad_acpi: Lenovo ThinkPad X200, model 7458E46
[   27.358427] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   27.358594] thinkpad_acpi: radio switch found; radios are enabled
[   27.358609] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   27.358610] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   27.361063] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   27.363936] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   27.364032] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   27.365685] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[   27.540050] usb 2-2: new full-speed USB device number 5 using uhci_hcd
[   27.628617] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   27.628620] Copyright(c) 2003-2013 Intel Corporation
[   27.628845] iwlwifi 0000:03:00.0: irq 46 for MSI/MSI-X
[   27.630834] cfg80211: World regulatory domain updated:
[   27.630836] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   27.630839] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   27.630841] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   27.630843] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   27.630844] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   27.630846] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   27.715103] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
[   27.715115] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   27.715123] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[   27.715130] usb 2-2: Manufacturer: Lenovo Computer Corp
[   27.754395] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
[   27.804276] usb 7-5.2: new low-speed USB device number 6 using ehci-pci
[   27.853933] Bluetooth: Core ver 2.16
[   27.853990] NET: Registered protocol family 31
[   27.853996] Bluetooth: HCI device and connection manager initialized
[   27.854018] Bluetooth: HCI socket layer initialized
[   27.854029] Bluetooth: L2CAP socket layer initialized
[   27.854048] Bluetooth: SCO socket layer initialized
[   27.875688] usbcore: registered new interface driver btusb
[   27.919245] usb 7-5.2: New USB device found, idVendor=04b3, idProduct=3025
[   27.919251] usb 7-5.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   27.919255] usb 7-5.2: Product: USB NetVista Full Width Keyboard.
[   27.919259] usb 7-5.2: Manufacturer: LITE-ON Technology
[   27.925773] input: LITE-ON Technology USB NetVista Full Width Keyboard. as /devices/pci0000:00/0000:00:1a.7/usb7/7-5/7-5.2/7-5.2:1.0/input/input9
[   27.926119] hid-generic 0003:04B3:3025.0002: input,hidraw0: USB HID v1.10 Keyboard [LITE-ON Technology USB NetVista Full Width Keyboard.] on usb-0000:00:1a.7-5.2/input0
[   28.016295] usb 7-5.3: new high-speed USB device number 7 using ehci-pci
[   28.108791] usb 7-5.3: New USB device found, idVendor=0424, idProduct=2514
[   28.108803] usb 7-5.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   28.109388] hub 7-5.3:1.0: USB hub found
[   28.109753] hub 7-5.3:1.0: 2 ports detected
[   28.481901] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   28.674962] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
[   28.676972] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
[   28.685013] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   28.685254] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   28.685475] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   28.685705] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   29.093610] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   29.093621] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   29.093628] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   29.093635] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   29.093642] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
[   29.093650] iwlwifi 0000:03:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
[   29.093690] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   29.096665] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[   29.128248] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   34.880156] device fsid a517c6b2-003d-4054-97ed-dd34808d627d devid 1 transid 27 /dev/sdb
[   61.751180] loop: module loaded
[   85.375607] Adding 4251644k swap on /dev/mapper/main-swap.  Priority:-1 extents:1 across:4251644k 
[   86.757273] kjournald starting.  Commit interval 5 seconds
[   86.758259] EXT3-fs (sda1): using internal journal
[   86.758268] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   86.760115] XFS (dm-3): Mounting Filesystem
[   86.885349] XFS (dm-3): Ending clean mount
[   86.886680] XFS (dm-2): Mounting Filesystem
[   87.079164] XFS (dm-2): Ending clean mount
[   87.133957] XFS (dm-5): Mounting Filesystem
[   87.470866] XFS (dm-5): Ending clean mount
[   88.121860] EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: (null)
[   89.318355] sit: IPv6 over IPv4 tunneling driver
[   89.342790] tun: Universal TUN/TAP device driver, 1.6
[   89.342793] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   90.159170] RPC: Registered named UNIX socket transport module.
[   90.159174] RPC: Registered udp transport module.
[   90.159175] RPC: Registered tcp transport module.
[   90.159177] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   90.292267] FS-Cache: Loaded
[   90.741336] FS-Cache: Netfs 'nfs' registered for caching
[   91.149818] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   91.489558] fuse init (API version 7.21)
[   92.104887] NET: Registered protocol family 15
[   92.115587] alg: No test for cipher_null (cipher_null-generic)
[   92.115795] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[   92.115825] alg: No test for compress_null (compress_null-generic)
[   92.115851] alg: No test for digest_null (digest_null-generic)
[   92.161887] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[   92.275704] zfs-fuse (3415): /proc/3489/oom_adj is deprecated, please use /proc/3489/oom_score_adj instead.
[   93.764098] Bluetooth: RFCOMM TTY layer initialized
[   93.764111] Bluetooth: RFCOMM socket layer initialized
[   93.764113] Bluetooth: RFCOMM ver 1.11
[   93.870170] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input15
[   93.913190] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   93.913195] Bluetooth: BNEP filters: protocol multicast
[   93.913209] Bluetooth: BNEP socket layer initialized
[   94.226331] lp: driver loaded but no devices found
[   94.349775] ppdev: user-space parallel port driver
[   95.354518] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   95.456193] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   95.456444] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   96.952901] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[   96.953012] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[   96.953167] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   97.162848] Bridge firewalling registered
[   97.196281] device virbr0-nic entered promiscuous mode
[   97.357958] ip_tables: (C) 2000-2006 Netfilter Core Team
[   98.105365] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   98.601649] device virbr0-nic left promiscuous mode
[   98.601654] virbr0: port 1(virbr0-nic) entered disabled state
[   98.696262] device virbr1-nic entered promiscuous mode
[   98.771905] IPv6: ADDRCONF(NETDEV_UP): virbr1: link is not ready
[   99.530589] Ebtables v2.0 registered
[   99.640735] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  129.494579] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[  129.494597] Bluetooth: HIDP socket layer initialized
[  129.503489] hid-generic 0005:17EF:6002.0003: unknown main item tag 0x0
[  129.503575] input: ThinkPad Bluetooth Laser Mouse as /devices/pci0000:00/0000:00:1a.1/usb2/2-2/2-2:1.0/bluetooth/hci0/hci0:11/input16
[  129.504765] hid-generic 0005:17EF:6002.0003: input,hidraw1: BLUETOOTH HID v2.45 Mouse [ThinkPad Bluetooth Laser Mouse] on 00:25:56:cf:81:19

--=-=-=


-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~

--=-=-=--
