Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaGPVGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:06:40 -0400
Received: from emout01.email.it ([212.97.34.23]:52431 "EHLO emout01.email.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbaGPVGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:06:04 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 17:06:03 EDT
Date: Wed, 16 Jul 2014 22:55:27 +0200
To: linux-kernel@vger.kernel.org
From: augusto.bortoluzzi@email.it
Reply-to: augusto.bortoluzzi@email.it
Subject: PROBLEM: Samsung SSD 840 failed to get NCQ Send/Recv, failed to set xfermode
Message-ID: <f6d0c612834724b71b748ec3fbc91748@95.244.131.147>
X-Priority: 
X-Mailer: Webmail-Email.it [Mailer version 1.70]
X-SenderIP: 95.244.131.147
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I found a problem with Samsung SSD 840, I reproduced the problem with
mainline kernel versions 3.12.x -> 3.16-rc5
I filled this report, please let me know if I can help providing more
informations.

Thanks.

Augusto


[1.] One line summary of the problem:
	Samsung SSD 840 failed to get NCQ Send/Recv Log Emask 0x1 failed to set
xfermode (err_mask=0x40) on upstream kernel >= 3.12

[2.] Full description of the problem/report:

	The disk device is not recognized, neither listed in /proc/scsi/scsi.
	The problem with Samsung SSD 840 Series is reproducible just booting the
system with a kernel >= 3.12, including the latest 3.16-rc5

	When booting the system with mainline kernel > 3.11.x, there is some delay
and are shown repeated errors on screen:
	ata5.00: failed to set xfermode (err_mask=0x40)

	dmesg reports:
	ata5.00: failed to get NCQ Send/Recv Log Emask 0x1

	
[3.] Keywords (i.e., modules, networking, kernel):

[4.] Kernel version (from /proc/version):
	Linux version 3.16.0-031600rc5-generic (apw@gomeisa) (gcc version 4.6.3
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201407131735 SMP Sun Jul 13 21:36:15 UTC
2014

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)

	$ dmesg |grep ata5

	[    1.054846] ata5: SATA max UDMA/133 abar m8192@0xfcf76000 port
0xfcf76200 irq 40
	[    1.372077] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
	[    1.372703] ata5.00: failed to get NCQ Send/Recv Log Emask 0x1
	[    1.372705] ata5.00: ATA-9: Samsung SSD 840 Series, DXT06B0Q, max
UDMA/133
	[    1.372708] ata5.00: 488397168 sectors, multi 16: LBA48 NCQ (depth
31/32)
	[    6.372040] ata5.00: qc timeout (cmd 0x2f)
	[    6.372048] ata5.00: failed to get Identify Device Data, Emask 0x5
	[    6.372057] ata5.00: failed to set xfermode (err_mask=0x40)
	[    6.692025] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
	[    6.692655] ata5.00: failed to get NCQ Send/Recv Log Emask 0x1
	[   11.692029] ata5.00: qc timeout (cmd 0x2f)
	[   11.692033] ata5.00: failed to get Identify Device Data, Emask 0x5
	[   11.692040] ata5.00: failed to set xfermode (err_mask=0x40)
	[   11.692189] ata5: limiting SATA link speed to 1.5 Gbps
	[   11.692191] ata5.00: limiting speed to UDMA/133:PIO3
	[   12.012022] ata5: SATA link up <unknown> (SStatus 103 SControl 310)
	[   12.012182] ata5.00: failed to get NCQ Send/Recv Log Emask 0x1
	[   17.012026] ata5.00: qc timeout (cmd 0x2f)
	[   17.012030] ata5.00: failed to get Identify Device Data, Emask 0x5
	[   17.012036] ata5.00: failed to set xfermode (err_mask=0x40)
	[   17.012184] ata5.00: disabled
	[   17.012193] ata5: hard resetting link
	[   17.332021] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
	[   17.332026] ata5: EH complete


[6.] A small shell script or example program which triggers the
     problem (if possible)
[7.] Environment

	Description:	Ubuntu 14.04 LTS
	Release:	14.04

[7.1.] Software (add the output of the ver_linux script here)

	$ sh ver_linux 
	If some fields are empty or look unusual you may have an old version.
	Compare to the current minimal requirements in Documentation/Changes.
 
	Linux pc-user 3.16.0-031600rc5-generic #201407131735 SMP Sun Jul 13
21:36:15 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
 
	Gnu C                  4.8
	Gnu make               3.81
	binutils               2.24
	util-linux             2.20.1
	mount                  support
	module-init-tools      15
	e2fsprogs              1.42.9
	pcmciautils            018
	PPP                    2.4.5
	Linux C Library        2.19
	Dynamic linker (ldd)   2.19
	Procps                 3.3.9
	Net-tools              1.60
	Kbd                    1.15.5
	Sh-utils               8.21
	wireless-tools         30
	Modules Loaded         bnep rfcomm bluetooth snd_hda_codec_hdmi
6lowpan_iphc snd_hda_codec_realtek snd_hda_codec_generic kvm_amd nouveau
snd_hda_intel kvm snd_hda_controller snd_hda_codec mxm_wmi 	snd_hwdep ttm
snd_pcm drm_kms_helper drm i2c_algo_bit shpchp edac_core snd_seq_midi
snd_seq_midi_event snd_rawmidi k8temp psmouse edac_mce_amd serio_raw snd_seq
ppdev snd_seq_device snd_timer lp joydev parport_pc snd parport mac_hid wmi
video i2c_nforce2 asus_atk0110 soundcore pata_acpi hid_generic usbhid hid
firewire_ohci firewire_core crc_itu_t forcedeth ahci libahci pata_amd
ohci_pci	

[7.2.] Processor information (from /proc/cpuinfo):

	processor	: 0
	vendor_id	: AuthenticAMD
	cpu family	: 15
	model		: 107
	model name	: AMD Athlon(tm) Dual Core Processor 4850e
	stepping	: 2
	cpu MHz		: 1000.000
	cache size	: 512 KB
	physical id	: 0
	siblings	: 2
	core id		: 0
	cpu cores	: 2
	apicid		: 0
	initial apicid	: 0
	fpu		: yes
	fpu_exception	: yes
	cpuid level	: 1
	wp		: yes
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm
3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm
extapic cr8_legacy 3dnowprefetch lbrv
	bogomips	: 1999.99
	TLB size	: 1024 4K pages
	clflush size	: 64
	cache_alignment	: 64
	address sizes	: 40 bits physical, 48 bits virtual
	power management: ts fid vid ttp tm stc 100mhzsteps

	processor	: 1
	vendor_id	: AuthenticAMD
	cpu family	: 15
	model		: 107
	model name	: AMD Athlon(tm) Dual Core Processor 4850e
	stepping	: 2
	cpu MHz		: 1000.000
	cache size	: 512 KB
	physical id	: 0
	siblings	: 2
	core id		: 1
	cpu cores	: 2
	apicid		: 1
	initial apicid	: 1
	fpu		: yes
	fpu_exception	: yes
	cpuid level	: 1
	wp		: yes
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm
3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm
extapic cr8_legacy 3dnowprefetch lbrv
	bogomips	: 1999.99
	TLB size	: 1024 4K pages
	clflush size	: 64
	cache_alignment	: 64
	address sizes	: 40 bits physical, 48 bits virtual
	power management: ts fid vid ttp tm stc 100mhzsteps


[7.3.] Module information (from /proc/modules):

	bnep 19884 2 - Live 0xffffffffc03d0000
	rfcomm 75114 0 - Live 0xffffffffc03e3000
	bluetooth 467228 10 bnep,rfcomm, Live 0xffffffffc04af000
	snd_hda_codec_hdmi 48243 1 - Live 0xffffffffc03d6000
	6lowpan_iphc 18968 1 bluetooth, Live 0xffffffffc025f000
	snd_hda_codec_realtek 73695 1 - Live 0xffffffffc046f000
	snd_hda_codec_generic 70087 1 snd_hda_codec_realtek, Live
0xffffffffc049c000
	kvm_amd 60904 0 - Live 0xffffffffc053a000
	nouveau 1230411 3 - Live 0xffffffffc02a2000
	snd_hda_intel 30683 3 - Live 0xffffffffc0493000
	kvm 464279 1 kvm_amd, Live 0xffffffffc03fc000
	snd_hda_controller 35518 1 snd_hda_intel, Live 0xffffffffc01d2000
	snd_hda_codec 144889 5
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller,
Live 0xffffffffc027d000
	mxm_wmi 13021 1 nouveau, Live 0xffffffffc01cd000
	snd_hwdep 17709 1 snd_hda_codec, Live 0xffffffffc0259000
	ttm 90341 1 nouveau, Live 0xffffffffc0265000
	snd_pcm 105052 4
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec, Live
0xffffffffc022b000
	drm_kms_helper 62042 1 nouveau, Live 0xffffffffc0248000
	drm 316819 6 nouveau,ttm,drm_kms_helper, Live 0xffffffffc01dc000
	i2c_algo_bit 13564 1 nouveau, Live 0xffffffffc01ba000
	shpchp 37216 0 - Live 0xffffffffc01c2000
	edac_core 57103 0 - Live 0xffffffffc01ab000
	snd_seq_midi 13564 0 - Live 0xffffffffc01a1000
	snd_seq_midi_event 14899 1 snd_seq_midi, Live 0xffffffffc01a6000
	snd_rawmidi 31197 1 snd_seq_midi, Live 0xffffffffc0198000
	k8temp 13076 0 - Live 0xffffffffc0120000
	psmouse 113097 0 - Live 0xffffffffc017b000
	edac_mce_amd 22753 0 - Live 0xffffffffc0174000
	serio_raw 13483 0 - Live 0xffffffffc004a000
	snd_seq 63540 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffc0163000
	ppdev 17711 0 - Live 0xffffffffc015d000
	snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
0xffffffffc0144000
	snd_timer 30118 2 snd_pcm,snd_seq, Live 0xffffffffc0154000
	lp 17799 0 - Live 0xffffffffc014a000
	joydev 17587 0 - Live 0xffffffffc0126000
	parport_pc 32906 1 - Live 0xffffffffc0116000
	snd 84025 17
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0xffffffffc012e000
	parport 42481 3 ppdev,lp,parport_pc, Live 0xffffffffc010a000
	mac_hid 13275 0 - Live 0xffffffffc00af000
	wmi 19379 2 nouveau,mxm_wmi, Live 0xffffffffc007c000
	video 20521 1 nouveau, Live 0xffffffffc0054000
	i2c_nforce2 13317 0 - Live 0xffffffffc004f000
	asus_atk0110 19219 0 - Live 0xffffffffc0044000
	soundcore 15091 2 snd_hda_codec,snd, Live 0xffffffffc003b000
	pata_acpi 13053 0 - Live 0xffffffffc0033000
	hid_generic 12559 0 - Live 0xffffffffc0095000
	usbhid 53122 0 - Live 0xffffffffc00fc000
	hid 110572 3 hid_generic,usbhid, Live 0xffffffffc00c4000
	firewire_ohci 45300 0 - Live 0xffffffffc00b7000
	firewire_core 69405 1 firewire_ohci, Live 0xffffffffc009d000
	crc_itu_t 12707 1 firewire_core, Live 0xffffffffc006e000
	forcedeth 72441 0 - Live 0xffffffffc0082000
	ahci 30167 5 - Live 0xffffffffc0073000
	libahci 32533 1 ahci, Live 0xffffffffc0065000
	pata_amd 18230 0 - Live 0xffffffffc005b000
	ohci_pci 13570 0 - Live 0xffffffffc002e000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
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
  0170-0177 : 0000:00:06.0
    0170-0177 : pata_amd
  01f0-01f7 : 0000:00:06.0
    01f0-01f7 : pata_amd
  0230-023f : pnp 00:04
  0290-029f : pnp 00:04
  0376-0376 : 0000:00:06.0
    0376-0376 : pata_amd
  0378-037a : parport0
  03c0-03df : vesafb
  03f6-03f6 : 0000:00:06.0
    03f6-03f6 : pata_amd
  03f8-03ff : serial
  04d0-04d1 : pnp 00:01
  0500-0503 : ACPI PM1a_EVT_BLK
  0504-0505 : ACPI PM1a_CNT_BLK
  0508-050b : ACPI PM_TMR
  0510-0515 : ACPI CPU throttle
  0520-0527 : ACPI GPE0_BLK
  0580-05ff : pnp 00:01
  0600-063f : 0000:00:01.1
    0600-063f : nForce2_smbus
  0700-073f : 0000:00:01.1
  0800-080f : pnp 00:01
  0880-08ff : pnp 00:01
    08a0-08af : ACPI GPE1_BLK
  0900-09ff : 0000:00:01.0
  0a00-0a0f : pnp 00:04
  0a10-0a1f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  0d00-0d7f : pnp 00:01
  0d80-0dff : pnp 00:01
  0e00-0e3f : 0000:00:01.1
  c880-c887 : 0000:00:0a.0
    c880-c887 : forcedeth
  cc00-cc0f : 0000:00:09.0
    cc00-cc0f : ahci
  d000-d003 : 0000:00:09.0
    d000-d003 : ahci
  d080-d087 : 0000:00:09.0
    d080-d087 : ahci
  d400-d403 : 0000:00:09.0
    d400-d403 : ahci
  d480-d487 : 0000:00:09.0
    d480-d487 : ahci
  e000-efff : PCI Bus 0000:02
    ec00-ec7f : 0000:02:00.0
  ffa0-ffaf : 0000:00:06.0
    ffa0-ffaf : pata_amd


$ cat /proc/iomem
00000000-00000fff : reserved
00001000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cd5ff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
  000d0000-000d3fff : pnp 00:01
  000d4000-000d7fff : pnp 00:01
  000de000-000dffff : pnp 00:01
000e3000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-d7f8ffff : System RAM
  01000000-01794ed8 : Kernel code
  01794ed9-01d1713f : Kernel data
  01e76000-01fb8fff : Kernel bss
d7f90000-d7f9dfff : ACPI Tables
d7f9e000-d7fdffff : ACPI Non-volatile Storage
d7fe0000-d7fedfff : reserved
d7fee000-d7feffff : RAM buffer
d7ff0000-d7ffffff : reserved
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:06
f0000000-febfffff : PCI Bus 0000:00
  f0000000-fbffffff : PCI Bus 0000:02
    f0000000-f7ffffff : 0000:02:00.0
    fa000000-fbffffff : 0000:02:00.0
  fcf76000-fcf77fff : 0000:00:09.0
    fcf76000-fcf77fff : ahci
  fcf78000-fcf7bfff : 0000:00:07.0
    fcf78000-fcf7bfff : ICH HD audio
  fcf7c000-fcf7cfff : 0000:00:0a.0
    fcf7c000-fcf7cfff : forcedeth
  fcf7d000-fcf7dfff : 0000:00:04.0
    fcf7d000-fcf7dfff : ohci_hcd
  fcf7e000-fcf7efff : 0000:00:02.0
    fcf7e000-fcf7efff : ohci_hcd
  fcf7f000-fcf7f00f : 0000:00:0a.0
    fcf7f000-fcf7f00f : forcedeth
  fcf7f400-fcf7f4ff : 0000:00:0a.0
    fcf7f400-fcf7f4ff : forcedeth
  fcf7f800-fcf7f8ff : 0000:00:04.1
    fcf7f800-fcf7f8ff : ehci_hcd
  fcf7fc00-fcf7fcff : 0000:00:02.1
    fcf7fc00-fcf7fcff : ehci_hcd
  fcf80000-fcffffff : 0000:00:01.3
  fd000000-feafffff : PCI Bus 0000:02
    fd000000-fdffffff : 0000:02:00.0
    feae0000-feafffff : 0000:02:00.0
  feb00000-febfffff : PCI Bus 0000:05
    febfec00-febfec7f : 0000:05:00.0
    febff000-febff07f : 0000:05:00.0
    febff400-febff47f : 0000:05:00.0
    febff800-febfffff : 0000:05:00.0
      febff800-febfffff : firewire_ohci
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed00fff : PNP0103:00
  fed00000-fed003ff : HPET 0
fed04000-fed04fff : pnp 00:01
fee00000-feefffff : reserved
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:03
  fee01000-feefffff : pnp 00:01
fff00000-ffffffff : reserved
100000000-21fffffff : System RAM


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 RAM memory: NVIDIA Corporation MCP78S [GeForce 8200] Memory
Controller (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- TAbort- <TAbort- <MAbort- >SERR- TAbort- <TAbort- <MAbort-
>SERR- TAbort- <TAbort- <MAbort- >SERR- TAbort- <TAbort- <MAbort- >SERR-
TAbort- <TAbort- <MAbort- >SERR- TAbort- <TAbort- <MAbort- >SERR- TAbort-
<TAbort- <MAbort- >SERR- TAbort- <TAbort- <MAbort- >SERR- TAbort- <TAbort-
<MAbort- >SERR- TAbort- <TAbort- <MAbort- >SERR- TAbort- <TAbort- <MAbort-
>SERR- TAbort- <TAbort- <MAbort- >SERR- TAbort- <TAbort- <MAbort+ <SERR-
Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b8] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:09.0 SATA controller: NVIDIA Corporation MCP78S [GeForce 8200] AHCI
Controller (rev a2) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- TAbort- <TAbort- <MAbort- >SERR- TAbort- <TAbort- <MAbort-
>SERR- TAbort- <TAbort- <MAbort+ <SERR- Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:10.0 PCI bridge: NVIDIA Corporation MCP78S [GeForce 8200] PCI Express
Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- TAbort- <TAbort- <MAbort- <SERR- Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range AB, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Kernel driver in use: pcieport

00:12.0 PCI bridge: NVIDIA Corporation MCP78S [GeForce 8200] PCI Express
Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- TAbort- <TAbort- <MAbort- <SERR- Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #3, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport

00:13.0 PCI bridge: NVIDIA Corporation MCP78S [GeForce 8200] PCI Bridge (rev
a1) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- TAbort- <TAbort- <MAbort+ <SERR- Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #4, PowerLimit 10.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- TAbort- <TAbort- <MAbort- >SERR- TAbort- <TAbort- <MAbort-
>SERR- TAbort- <TAbort- <MAbort- >SERR- 
	Kernel driver in use: k8temp

02:00.0 VGA compatible controller: NVIDIA Corporation C77 [GeForce 8300]
(rev a2) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at febff400 (32-bit, non-prefetchable) [size=128]
	Region 4: Memory at febff000 (32-bit, non-prefetchable) [size=128]
	Region 5: Memory at febfec00 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel driver in use: firewire_ohci


[7.6.] SCSI information (from /proc/scsi/scsi)

	Attached devices:
	Host: scsi2 Channel: 00 Id: 00 Lun: 00
	  Vendor: ATA      Model: WDC WD5000AACS-0 Rev: 1B01
	  Type:   Direct-Access                    ANSI  SCSI revision: 05
	Host: scsi3 Channel: 00 Id: 00 Lun: 00
	  Vendor: Optiarc  Model: DVD RW AD-7200S  Rev: 1.06
	  Type:   CD-ROM                           ANSI  SCSI revision: 05



[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
	

[X.] Other notes, patches, fixes, workarounds:

	Until kernel 3.11.10 the Samsung SSD worked flawlessly, I had:

	$ cat  /proc/scsi/scsi 

	Attached devices:
	Host: scsi2 Channel: 00 Id: 00 Lun: 00
	  Vendor: ATA      Model: WDC WD5000AACS-0 Rev: 01.0
	  Type:   Direct-Access                    ANSI  SCSI revision: 05
	Host: scsi3 Channel: 00 Id: 00 Lun: 00
	  Vendor: Optiarc  Model: DVD RW AD-7200S  Rev: 1.06
	  Type:   CD-ROM                           ANSI  SCSI revision: 05
	Host: scsi4 Channel: 00 Id: 00 Lun: 00
	  Vendor: ATA      Model: Samsung SSD 840  Rev: DXT0
	  Type:   Direct-Access                    ANSI  SCSI revision: 05



 


