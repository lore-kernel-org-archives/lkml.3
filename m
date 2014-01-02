Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaABSUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:20:25 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:39010 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaABSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:20:24 -0500
Message-ID: <52C5ADE3.7020905@gmail.com>
Date: Thu, 02 Jan 2014 19:20:19 +0100
From: Diego Rodriguez Gonzalez <gran.diego@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Fwd: [Gigabyte GA-MA78GPM-DS2H] ACPI wakeup fails if HPET enabled
 in BIOS
References: <52C5AD26.9010603@gmail.com>
In-Reply-To: <52C5AD26.9010603@gmail.com>
X-Forwarded-Message-Id: <52C5AD26.9010603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Full Description]

If I enable HPET in BIOS on Gigabyte GA-MA78GPM-DS2H (AMD 780G chipset) 
and I try to set up ACPI wakeup using (as root):

echo `date '+%s' -d '+ 5 minutes'` > /sys/class/rtc/rtc0/wakealarm

or:

rtcwake -d rtc0 -u -m no -t `date '+%s' -d '+ 5 minutes'`

The computer does not wake up.

[4.] Kernel version (from /proc/version):

Linux version 3.13.0-031300rc6-generic (apw@gomeisa) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201312291935 SMP Mon Dec 30 00:37:05 
UTC 2013

[7.] Environment

lsb_release -rd

Description:    Ubuntu 13.10
Release:    13.10

[7.1.] Software (add the output of the ver_linux script here)

Description:    Ubuntu 13.10
Release:    13.10

[7.2.] Processor information (from /proc/cpuinfo):

cat /proc/cpuinfo
processor    : 0
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 10
model name    : AMD Phenom(tm) II X6 1100T Processor
stepping    : 0
microcode    : 0x10000dc
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 6
core id        : 0
cpu cores    : 6
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 6
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips    : 6629.47
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

(repeated 6 times)

[7.3.] Module information (from /proc/modules):

dm_crypt 23417 0 - Live 0x0000000000000000
cuse 13566 3 - Live 0x0000000000000000
rpcsec_gss_krb5 40513 1 - Live 0x0000000000000000
nfsv4 486302 2 - Live 0x0000000000000000
parport_pc 36962 0 - Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42481 3 parport_pc,ppdev,lp, Live 0x0000000000000000
bnep 19884 2 - Live 0x0000000000000000
rfcomm 74748 0 - Live 0x0000000000000000
snd_hda_codec_hdmi 46898 1 - Live 0x0000000000000000
bluetooth 411140 10 bnep,rfcomm, Live 0x0000000000000000
snd_hda_codec_realtek 61978 1 - Live 0x0000000000000000
snd_hda_intel 57222 5 - Live 0x0000000000000000
kvm_amd 60554 0 - Live 0x0000000000000000
kvm 468147 1 kvm_amd, Live 0x0000000000000000
psmouse 108513 0 - Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
microcode 23788 0 - Live 0x0000000000000000
snd_hda_codec 199156 3 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 
0x0000000000000000
snd_rawmidi 30465 1 snd_seq_midi, Live 0x0000000000000000
snd_hwdep 13613 1 snd_hda_codec, Live 0x0000000000000000
serio_raw 13462 0 - Live 0x0000000000000000
snd_pcm 107140 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 
0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
edac_core 62944 0 - Live 0x0000000000000000
edac_mce_amd 22792 0 - Live 0x0000000000000000
snd_page_alloc 18798 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 
0x0000000000000000
sp5100_tco 14114 0 - Live 0x0000000000000000
snd_timer 30038 2 snd_pcm,snd_seq, Live 0x0000000000000000
i2c_piix4 22299 0 - Live 0x0000000000000000
snd 73850 21 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_seq_midi,snd_hda_codec,snd_rawmidi,snd_hwdep,snd_pcm,snd_seq,snd_seq_device,snd_timer, 
Live 0x0000000000000000
binfmt_misc 17508 1 - Live 0x0000000000000000
k10temp 13173 0 - Live 0x0000000000000000
nfsd 292634 13 - Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
it87 47334 0 - Live 0x0000000000000000
hwmon_vid 12827 1 it87, Live 0x0000000000000000
auth_rpcgss 60158 3 rpcsec_gss_krb5,nfsd, Live 0x0000000000000000
nfs_acl 12883 1 nfsd, Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
shpchp 37201 0 - Live 0x0000000000000000
msr 12908 0 - Live 0x0000000000000000
nfs 247331 2 nfsv4, Live 0x0000000000000000
lockd 95174 2 nfsd,nfs, Live 0x0000000000000000
sunrpc 295412 31 
rpcsec_gss_krb5,nfsv4,nfsd,auth_rpcgss,nfs_acl,nfs,lockd, Live 
0x0000000000000000
fscache 64282 2 nfsv4,nfs, Live 0x0000000000000000
raid10 48667 0 - Live 0x0000000000000000
raid1 35921 0 - Live 0x0000000000000000
raid0 17969 0 - Live 0x0000000000000000
multipath 13145 0 - Live 0x0000000000000000
linear 12894 0 - Live 0x0000000000000000
raid456 87551 1 - Live 0x0000000000000000
async_raid6_recov 12984 1 raid456, Live 0x0000000000000000
async_memcpy 12689 1 raid456, Live 0x0000000000000000
async_pq 13456 1 raid456, Live 0x0000000000000000
async_xor 13233 2 raid456,async_pq, Live 0x0000000000000000
async_tx 13509 5 
raid456,async_raid6_recov,async_memcpy,async_pq,async_xor, Live 
0x0000000000000000
hid_generic 12548 0 - Live 0x0000000000000000
xor 21411 1 async_xor, Live 0x0000000000000000
usbhid 53067 0 - Live 0x0000000000000000
hid 106254 2 hid_generic,usbhid, Live 0x0000000000000000
raid6_pq 97812 2 async_raid6_recov,async_pq, Live 0x0000000000000000
pata_acpi 13038 0 - Live 0x0000000000000000
radeon 1565590 2 - Live 0x0000000000000000
i2c_algo_bit 13564 1 radeon, Live 0x0000000000000000
ttm 89884 1 radeon, Live 0x0000000000000000
ahci 30063 6 - Live 0x0000000000000000
r8169 73299 0 - Live 0x0000000000000000
pata_atiixp 13271 0 - Live 0x0000000000000000
drm_kms_helper 53224 1 radeon, Live 0x0000000000000000
libahci 32277 1 ahci, Live 0x0000000000000000
mii 13981 1 r8169, Live 0x0000000000000000
drm 308397 4 radeon,ttm,drm_kms_helper, Live 0x0000000000000000
wmi 19363 0 - Live 0x0000000000000000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
*While booted into the newest upstream mainline kernel only*, execute 
the following in a terminal, and paste the results:
cat /proc/ioports

0000-0cf7 : PCI Bus 0000:00
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
   0170-0177 : 0000:00:14.1
     0170-0177 : pata_atiixp
   01f0-01f7 : 0000:00:14.1
     01f0-01f7 : pata_atiixp
   0220-0225 : pnp 00:00
   0228-022f : pnp 00:01
     022d-022e : it87
       022d-022e : it87
   0238-023f : pnp 00:01
   0290-0294 : pnp 00:00
   0376-0376 : 0000:00:14.1
     0376-0376 : pata_atiixp
   03f6-03f6 : 0000:00:14.1
     03f6-03f6 : pata_atiixp
   040b-040b : pnp 00:01
   04d0-04d1 : pnp 00:00
   04d6-04d6 : pnp 00:01
   0b00-0b0f : pnp 00:01
   0b10-0b1f : pnp 00:01
   0b20-0b3f : pnp 00:01
   0c00-0c01 : pnp 00:01
   0c14-0c14 : pnp 00:01
   0c50-0c52 : pnp 00:01
   0c6c-0c6d : pnp 00:01
   0c6f-0c6f : pnp 00:01
   0cd0-0cd1 : pnp 00:01
   0cd2-0cd3 : pnp 00:01
   0cd4-0cdf : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   4000-4003 : ACPI PM1a_EVT_BLK
   4004-4005 : ACPI PM1a_CNT_BLK
   4008-400b : ACPI PM_TMR
   4010-4015 : ACPI CPU throttle
   4020-4027 : ACPI GPE0_BLK
   4050-4050 : ACPI PM2_CNT_BLK
   4100-411f : pnp 00:01
   4210-4217 : pnp 00:01
   c000-cfff : PCI Bus 0000:03
     ca00-caff : 0000:03:06.0
       ca00-ca07 : serial
     cc00-ccff : 0000:03:06.0
     cf00-cf07 : 0000:03:06.0
   d000-dfff : PCI Bus 0000:02
     de00-deff : 0000:02:00.0
       de00-deff : r8169
   e000-efff : PCI Bus 0000:01
     ee00-eeff : 0000:01:05.0
   fa00-fa0f : 0000:00:14.1
     fa00-fa0f : pata_atiixp
   fb00-fb0f : 0000:00:11.0
     fb00-fb0f : ahci
   fc00-fc03 : 0000:00:11.0
     fc00-fc03 : ahci
   fd00-fd07 : 0000:00:11.0
     fd00-fd07 : ahci
   fe00-fe03 : 0000:00:11.0
     fe00-fe03 : ahci
   ff00-ff07 : 0000:00:11.0
     ff00-ff07 : ahci

cat /proc/iomem

00000000-00000fff : reserved
00001000-00096fff : System RAM
00097000-0009f7ff : RAM buffer
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00
   000c0000-000ce9ff : Video ROM
000f0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-d7ddffff : System RAM
   01000000-01770f9d : Kernel code
   01770f9e-01d1bf3f : Kernel data
   01e78000-01fdcfff : Kernel bss
   cc000000-cfffffff : GART
d7de0000-d7de2fff : ACPI Non-volatile Storage
d7de3000-d7deffff : ACPI Tables
d7df0000-d7dfffff : reserved
   d7df0000-d7dfffff : pnp 00:08
d7e00000-d7efffff : RAM buffer
d7f00000-febfffff : PCI Bus 0000:00
   d8000000-dfffffff : PCI Bus 0000:01
     d8000000-dfffffff : 0000:01:05.0
       d8000000-d82fffff : BOOTFB
   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
     e0000000-efffffff : reserved
       e0000000-efffffff : pnp 00:07
   fda00000-fdafffff : PCI Bus 0000:02
     fda00000-fda0ffff : 0000:02:00.0
     fdae0000-fdaeffff : 0000:02:00.0
       fdae0000-fdaeffff : r8169
     fdaff000-fdafffff : 0000:02:00.0
       fdaff000-fdafffff : r8169
   fdb00000-fdbfffff : PCI Bus 0000:03
   fdc00000-fdcfffff : PCI Bus 0000:03
     fdcff000-fdcff0ff : 0000:03:06.0
   fdd00000-fddfffff : PCI Bus 0000:02
   fde00000-fdffffff : PCI Bus 0000:01
     fde00000-fdefffff : 0000:01:05.0
     fdfe0000-fdfeffff : 0000:01:05.0
     fdffc000-fdffffff : 0000:01:05.1
       fdffc000-fdffffff : ICH HD audio
   fe024000-fe027fff : 0000:00:14.2
     fe024000-fe027fff : ICH HD audio
   fe028000-fe028fff : 0000:00:14.5
     fe028000-fe028fff : ohci_hcd
   fe029000-fe0290ff : 0000:00:13.2
     fe029000-fe0290ff : ehci_hcd
   fe02a000-fe02afff : 0000:00:13.1
     fe02a000-fe02afff : ohci_hcd
   fe02b000-fe02bfff : 0000:00:13.0
     fe02b000-fe02bfff : ohci_hcd
   fe02c000-fe02c0ff : 0000:00:12.2
     fe02c000-fe02c0ff : ehci_hcd
   fe02d000-fe02dfff : 0000:00:12.1
     fe02d000-fe02dfff : ohci_hcd
   fe02e000-fe02efff : 0000:00:12.0
     fe02e000-fe02efff : ohci_hcd
   fe02f000-fe02f3ff : 0000:00:11.0
     fe02f000-fe02f3ff : ahci
fec00000-ffffffff : reserved
   fec00000-fec003ff : IOAPIC 0
   fed00000-fed003ff : HPET 0
   fee00000-fee00fff : Local APIC
     fee00400-fee00fff : pnp 00:01
   fff80000-fffeffff : pnp 00:08
   ffff0000-ffffffff : pnp 00:08
100000000-227ffffff : System RAM


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] RS780 Host Bridge
     Subsystem: Advanced Micro Devices, Inc. [AMD] RS780 Host Bridge
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 32
     Region 3: Memory at <ignored> (64-bit, non-prefetchable)
     Capabilities: [c4] HyperTransport: Slave or Primary Interface
         Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
         Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- 
<CRCErr=0 IsocEn+ LSEn- ExtCTL- 64b-
         Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit 
DwFcInEn- LWO=16bit DwFcOutEn-
         Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ 
<CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
         Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit 
DwFcInEn- LWO=8bit DwFcOutEn-
         Revision ID: 3.00
         Link Frequency 0: [b]
         Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
         Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 
600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
         Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
         Link Frequency 1: 200MHz
         Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
         Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 
600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
         Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- 
SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
         Prefetchable memory behind bridge Upper: 00-00
         Bus Number: 00
     Capabilities: [54] HyperTransport: UnitID Clumping
     Capabilities: [40] HyperTransport: Retry Mode
     Capabilities: [9c] HyperTransport: #1a
     Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI 
to PCI bridge (int gfx) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 99
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
     I/O behind bridge: 0000e000-0000efff
     Memory behind bridge: fde00000-fdffffff
     Prefetchable memory behind bridge: 00000000d8000000-00000000dfffffff
     Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
     Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] 
RS780/RS880 PCI to PCI bridge (int gfx)

00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI 
to PCI bridge (PCIE port 5) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 0000d000-0000dfff
     Memory behind bridge: fdd00000-fddfffff
     Prefetchable memory behind bridge: 00000000fda00000-00000000fdafffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag+ RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep+ BwNot+
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #10, PowerLimit 25.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -3.5dB
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee3f00c  Data: 4181
     Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] 
Device 9600
     Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
     Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
     Capabilities: [110 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
     Subsystem: Gigabyte Technology Co., Ltd Device b002
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 22
     Region 0: I/O ports at ff00 [size=8]
     Region 1: I/O ports at fe00 [size=4]
     Region 2: I/O ports at fd00 [size=8]
     Region 3: I/O ports at fc00 [size=4]
     Region 4: I/O ports at fb00 [size=16]
     Region 5: Memory at fe02f000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [60] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [70] SATA HBA v1.0 InCfgSpace
     Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
     Subsystem: Gigabyte Technology Co., Ltd Device 5004
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci-pci

00:12.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0 USB 
OHCI1 Controller (prog-if 10 [OHCI])
     Subsystem: Gigabyte Technology Co., Ltd Device 5004
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci-pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
     Subsystem: Gigabyte Technology Co., Ltd Device 5004
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at fe02c000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Bridge: PM- B3+
     Capabilities: [e4] Debug port: BAR=1 offset=00e0
     Kernel driver in use: ehci-pci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
     Subsystem: Gigabyte Technology Co., Ltd Device 5004
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci-pci

00:13.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0 USB 
OHCI1 Controller (prog-if 10 [OHCI])
     Subsystem: Gigabyte Technology Co., Ltd Device 5004
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci-pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
     Subsystem: Gigabyte Technology Co., Ltd Device 5004
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin B routed to IRQ 19
     Region 0: Memory at fe029000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Bridge: PM- B3+
     Capabilities: [e4] Debug port: BAR=1 offset=00e0
     Kernel driver in use: ehci-pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus 
Controller (rev 3a)
     Subsystem: Gigabyte Technology Co., Ltd GA-MA770-DS3rev2.0 Motherboard
     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+

00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 IDE Controller (prog-if 8a [Master SecP PriP])
     Subsystem: Gigabyte Technology Co., Ltd Device 5002
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: I/O ports at 01f0 [size=8]
     Region 1: I/O ports at 03f4 [size=1]
     Region 2: I/O ports at 0170 [size=8]
     Region 3: I/O ports at 0374 [size=1]
     Region 4: I/O ports at fa00 [size=16]
     Capabilities: [70] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Kernel driver in use: pata_atiixp

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 
Azalia (Intel HDA)
     Subsystem: Gigabyte Technology Co., Ltd Device a102
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at fe024000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 LPC host controller
     Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 
LPC host controller
     Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to 
PCI Bridge (prog-if 01 [Subtractive decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 64
     Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
     I/O behind bridge: 0000c000-0000cfff
     Memory behind bridge: fdc00000-fdcfffff
     Prefetchable memory behind bridge: fdb00000-fdbfffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] 
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
     Subsystem: Gigabyte Technology Co., Ltd Device 5004
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin C routed to IRQ 18
     Region 0: Memory at fe028000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci-pci

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h 
Processor HyperTransport Configuration
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Capabilities: [80] HyperTransport: Host or Secondary Interface
         Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- 
<EOCErr- DUL-
         Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- 
<CRCErr=0 IsocEn+ LSEn+ ExtCTL- 64b-
         Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit 
DwFcInEn- LWO=16bit DwFcOutEn-
         Revision ID: 3.00
         Link Frequency: [b]
         Link Error: <Prot- <Ovfl- <EOC- CTLTm-
         Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 
600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
         Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- 
ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h 
Processor Address Map
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h 
Processor DRAM Controller
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h 
Processor Miscellaneous Control
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Capabilities: [f0] Secure device <?>
     Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h 
Processor Link Control
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:05.0 VGA compatible controller: Advanced Micro Devices, Inc. 
[AMD/ATI] RS780 [Radeon HD 3200] (prog-if 00 [VGA controller])
     Subsystem: Gigabyte Technology Co., Ltd GA-MA78GM-S2H Motherboard
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
     Region 1: I/O ports at ee00 [size=256]
     Region 2: Memory at fdfe0000 (32-bit, non-prefetchable) [size=64K]
     Region 5: Memory at fde00000 (32-bit, non-prefetchable) [size=1M]
     Expansion ROM at <unassigned> [disabled]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Kernel driver in use: radeon

01:05.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] RS780 HDMI 
Audio [Radeon (HD) 3000 Series]
     Subsystem: Gigabyte Technology Co., Ltd Device 960f
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin B routed to IRQ 19
     Region 0: Memory at fdffc000 (32-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Kernel driver in use: snd_hda_intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 02)
     Subsystem: Gigabyte Technology Co., Ltd Motherboard
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 41
     Region 0: I/O ports at de00 [size=256]
     Region 2: Memory at fdaff000 (64-bit, prefetchable) [size=4K]
     Region 4: Memory at fdae0000 (64-bit, prefetchable) [size=64K]
     [virtual] Expansion ROM at fda00000 [disabled] [size=64K]
     Capabilities: [40] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
         Address: 00000000fee3f00c  Data: 41a1
     Capabilities: [70] Express (v1) Endpoint, MSI 01
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <8us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <64us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
         Vector table: BAR=4 offset=00000000
         PBA: BAR=4 offset=00000800
     Capabilities: [d0] Vital Product Data
         Unknown small resource type 00, will not decode more.
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
     Capabilities: [140 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Capabilities: [160 v1] Device Serial Number 12-34-56-78-12-34-56-78
     Kernel driver in use: r8169

03:06.0 Communication controller: LSI Corporation Venus Modem (V90, 56KFlex)
     Subsystem: LSI Corporation Device 5656
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0 (63000ns min, 3500ns max)
     Interrupt: pin A routed to IRQ 20
     Region 0: Memory at fdcff000 (32-bit, non-prefetchable) [size=256]
     Region 1: I/O ports at ca00 [size=256]
     Region 2: I/O ports at cc00 [size=256]
     Region 3: I/O ports at cf00 [size=8]
     Capabilities: [f8] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: serial



[7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: M4-CT256M4SSD2   Rev: 070H
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 01.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ST3500418AS      Rev: CC46
   Type:   Direct-Access                    ANSI  SCSI revision: 05

[Other notes]

Workaround: disable HPET in BIOS.

Problem found between Ubuntu kernel 3.8.0-23.34 and Ubuntu kernel 
3.8.0-26.38 (corresponding to mainline 3.8.11 and 3.8.13)

I ran git bisect and found the offending commit to be 
6d22382d7148a132fb7b4c461cb2940df4f0c77e

Author: Derek Basehore <dbasehore@chromium.org>
Date: Mon Apr 29 16:20:23 2013 -0700

     drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend


Problem tested and found on another Gigabyte motherboard (GA-G31MF-S2, 
Intel G31 chipset, Intel Core2Duo processor).

First reported at 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1197871

Best regards.


