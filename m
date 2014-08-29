Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaH2NoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:44:21 -0400
Received: from choapas.atasta.net ([212.83.146.160]:15737 "EHLO
	choapas.atasta.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaH2NoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:44:19 -0400
Message-ID: <540083B4.8050401@atasta.net>
Date: Fri, 29 Aug 2014 15:44:20 +0200
From: =?UTF-8?B?Q2hsb8OpIERlc291dHRlcg==?= <chloe.desoutter@atasta.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: linux 3.16 APIC and bhyve won't boot
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[1.] One line summary of the problem:
On Linux 3.16 a custom-built kernel with bhyve won't boot and will hang on the APIC timer calibration.
[2.] Full description of the problem/report:
I'm booting a 3.16 in bhyve (FreeBSD hypervisor) and according to my tests
lapic_cal_handler never gets called. This prevents the lapic_cal_loops
counter from being incremented and therefore the APIC calibration never
finishes. It is supposed to be called 25 times (APIC_CAL_LOOPS
constant). I added some apic_printk's to check for these infos (not a
best practice but I don't have access to a debugger in this specific
context).

[3.] Keywords (i.e., modules, networking, kernel):
kernel, apic
[4.] Kernel version (from /proc/version):
n/a (won't boot)
Linux version 3.16.1-bhyve (root@localhost) (gcc version 4.8.2 (Funtoo
4.8.2-r2) ) #22 SMP Fri Aug 29 12:23:32 Local
[5.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)
N/A
[6.] A small shell script or example program which triggers the
      problem (if possible)
N/A
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
  
Linux localhost 3.2.0-4-amd64 #1 SMP Debian 3.2.60-1+deb7u3 x86_64 Intel(R) Xeon(R)
CPU E3-1240 v3 @ 3.40GHz GenuineIntel GNU/Linux
  
Gnu C                  4.8.2
Gnu make               4.0
binutils               2.23.2
1.0
2.23.2
util-linux             scripts/ver_linux: line 23: fdformat: command not found
mount                  assert
module-init-tools      15
e2fsprogs              1.42.10
xfsprogs               3.1.11
Linux C Library        2.18
Dynamic linker (ldd)   2.18
Procps                 3.3.9
Net-tools              1.60_p20130513023548
Kbd                    2.0.1
Sh-utils               8.21
Modules Loaded         ext4 crc16 jbd2 mbcache sg sr_mod cdrom virtio_blk virtio_net ahci libahci libata scsi_mod virtio_pci virtio_ring virtio

[7.2.] Processor information (from /proc/cpuinfo):
[snip]
processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Xeon(R) CPU E3-1240 v3 @ 3.40GHz
stepping	: 3
cpu MHz		: 3388.196
cache size	: 0 KB
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae cx8 apic sep pge cmov pat pse36 clflush mmx fxsr sse sse2 ss pbe syscall nx pdpe1gb lm constant_tsc rep_good nopl nonstop_tsc pni pclmulqdq dtes64 ds_cpl smx ssse3 fma cx16 xtpr pcid sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm abm xsaveopt fsgsbase erms
bogomips	: 6776.74
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual

[7.3.] Module information (from /proc/modules):
N/A
[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
/proc/ioports
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0064-0064 : keyboard
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   0220-0223 : pnp 00:01
   0224-0227 : pnp 00:01
   02f8-02ff : serial
   03f8-03ff : serial
   0400-0407 : pnp 00:01
     0400-0403 : ACPI PM1a_EVT_BLK
     0404-0405 : ACPI PM1a_CNT_BLK
   0408-040b : ACPI PM_TMR
   04d0-04d1 : pnp 00:01
0cf8-0cff : PCI conf1
0d00-1fff : PCI Bus 0000:00
2000-209f : PCI Bus 0000:00
   2000-203f : 0000:00:01.0
     2000-203f : virtio-pci
   2040-205f : 0000:00:02.0
     2040-205f : virtio-pci
   2060-207f : 0000:00:03.0
     2060-207f : virtio-pci

/proc/iomem
00000000-0000ffff : reserved
00010000-0009fffe : System RAM
000f0000-000fffff : System ROM
00100000-bfffffff : System RAM
   01000000-01359d65 : Kernel code
   01359d66-01694f7f : Kernel data
   0172a000-01807fff : Kernel bss
c0000000-c01fffff : PCI Bus 0000:00
   c0000000-c0001fff : 0000:00:01.0
     c0000000-c0001fff : virtio-pci
   c0002000-c0003fff : 0000:00:02.0
     c0002000-c0003fff : virtio-pci
   c0004000-c0005fff : 0000:00:03.0
     c0004000-c0005fff : virtio-pci
   c0006000-c00063ff : 0000:00:04.0
     c0006000-c00063ff : ahci
   c0006800-c0006fff : 0000:00:01.0
   c0007000-c00077ff : 0000:00:02.0
   c0007800-c0007fff : 0000:00:03.0
   c0008000-c00087ff : 0000:00:04.0
   c0008800-c0008fff : 0000:00:0f.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
   e0000000-efffffff : pnp 00:01
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fee00000-fee00fff : Local APIC
100000000-13fffffff : System RAM

  [7.5.] PCI information ('lspci -vvv' as root)
root@localhost:/# lspci -vvv
00:00.0 Host bridge: Network Appliance Corporation Device 1275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF+ FastB2B+ ParErr+ DEVSEL=?? >TAbort+ <TAbort+ <MAbort+ >SERR+ <PERR+ INTx+
	Latency: 64
	Bus: primary=00, secondary=00, subordinate=00, sec-latency=0
	I/O behind bridge: 00000000-00000fff
	Memory behind bridge: 00000000-000fffff
	Prefetchable memory behind bridge: 00000000-000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

00:01.0 SCSI storage controller: Red Hat, Inc Virtio block device
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 2000 [size=64]
	Region 1: Memory at c0000000 (32-bit, non-prefetchable) [size=8K]
	[virtual] Expansion ROM at c0006800 [disabled] [size=2K]
	Capabilities: [40] MSI-X: Enable+ Count=2 Masked-
		Vector table: BAR=1 offset=00000000
		PBA: BAR=1 offset=00001000
	Capabilities: [4c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

00:02.0 Ethernet controller: Red Hat, Inc Virtio network device
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at 2040 [size=32]
	Region 1: Memory at c0002000 (32-bit, non-prefetchable) [size=8K]
	[virtual] Expansion ROM at c0007000 [disabled] [size=2K]
	Capabilities: [40] MSI-X: Enable+ Count=3 Masked-
		Vector table: BAR=1 offset=00000000
		PBA: BAR=1 offset=00001000
	Capabilities: [4c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

00:03.0 Ethernet controller: Red Hat, Inc Virtio network device
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 2060 [size=32]
	Region 1: Memory at c0004000 (32-bit, non-prefetchable) [size=8K]
	[virtual] Expansion ROM at c0007800 [disabled] [size=2K]
	Capabilities: [40] MSI-X: Enable+ Count=3 Masked-
		Vector table: BAR=1 offset=00000000
		PBA: BAR=1 offset=00001000
	Capabilities: [4c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

00:04.0 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 6 port SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 44
	Region 5: Memory at c0006000 (32-bit, non-prefetchable) [size=1K]
	[virtual] Expansion ROM at c0008000 [disabled] [size=2K]
	Capabilities: [40] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00000  Data: 4091

00:0f.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	[virtual] Expansion ROM at c0008800 [disabled] [size=2K]

root@localhost:/#

[7.6.] SCSI information (from /proc/scsi/scsi)
N/A
[7.7.] Other information that might be relevant to the problem
A stock Debian 3.2 kernel will boot. I don't have the possibility to build such a bloated kernel to
see what's missing. My goal is to identify what is the minimal set of functionalities needed to have
a kernel start up in a bhyve context. I have several other Linux VMs able to run on this hypervisor,
none with such a recent kernel.

Yours sincerely,

-- 
Chloé Desoutter
C[A-Z]O, Atasta NET
