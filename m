Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaDCUl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:41:56 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47407 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaDCUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:41:51 -0400
Message-ID: <533DC78B.4070301@gmail.com>
Date: Thu, 03 Apr 2014 22:41:47 +0200
From: Jernej Jakob <jernej.jakob@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Fan speed bugs (serious)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] Fan speed bugs (serious)

[2.] I've recently installed the beta release of Ubuntu 14.04 Trusty Tahr
on my HP ProBook 4710s and discovered some quite serious bugs with fan 
speed control.

1) Fan speed does not change in response to temperature
2) Fan completely stops running after:
	- resume from suspend
	- unplugging AC power (running on battery)
3) ACPI thermal zone 5 (/sys/class/thermal/thermal_zone5) temperature is 
in fact the current fan speed!

No matter how hot the CPU/chipset/GPU get, the fan doesn't respond. The 
only way I can bring it back to life is with:
- echo 1 > /sys/class/thermal/cooling_device[x]/curr_state

I've played around with which cooling devices correspond to what fan 
speed, and this is what I've found:
(cooling_device = thermal_zone5/fan speed)
cdev.0  = 90000
cdev.1  = 75000
cdev.2  = 55000
cdev.3  = 45000
cdev.4  = 30000
cdev.5  = 0
cdev.6  = 0
cdev.7  = 90000
cdev.8  = 75000
cdev.9  = 55000
cdev.10 = 45000
cdev.11 = 30000
cdev.12 = 0

4) The trip points are currently set wrong, i.e. they should be:
for thermal zone 0 (GPU):
cdev0_trip_point:1
cdev1_trip_point:2
cdev2_trip_point:3
cdev3_trip_point:4
cdev4_trip_point:5

for thermal zone 2 (CPU):
cdev0_trip_point:2
cdev1_trip_point:3
cdev2_trip_point:4
cdev3_trip_point:5
cdev4_trip_point:6

These should yield reasonable temperatures at least in my case (but I'm 
inable to actually test them)

[3.] acpi

[4.] $ cat /proc/version
Linux version 3.14.0-031400rc7-generic (apw@gomeisa) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201403162235 SMP Mon Mar 17 02:36:19 
UTC 2014

[5.]
[6.]

[7.] $ lsb_release -rd
Description:	Ubuntu Trusty Tahr (development branch)
Release:	14.04

[7.1.] $ sudo ./ver_linux

Linux jernej-ProBook 3.14.0-031400rc7-generic #201403162235 SMP Mon Mar 
17 02:36:19 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

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
Modules Loaded         ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT 
xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter 
ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables joydev 
snd_hda_codec_analog snd_hda_codec_generic ppdev hp_wmi sparse_keymap 
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep arc4 coretemp 
snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi kvm_intel b43 
snd_seq kvm bcma snd_seq_device microcode snd_timer mac80211 bnep rfcomm 
bluetooth uvcvideo 6lowpan_iphc videobuf2_vmalloc snd psmouse 
videobuf2_memops serio_raw videobuf2_core videodev lpc_ich cfg80211 
soundcore parport_pc hp_accel lis3lv02d input_polldev mac_hid lp parport 
xts gf128mul dm_crypt hid_generic usbhid hid radeon ahci libahci sky2 
i2c_algo_bit ttm ssb drm_kms_helper drm video wmi

[7.2.] $ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
stepping	: 10
microcode	: 0xa0b
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm 
constant_tsc arch_perfmon pebs bts nopl aperfmperf pni dtes64 monitor 
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida 
dtherm tpr_shadow vnmi flexpriority
bogomips	: 4788.11
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
stepping	: 10
microcode	: 0xa0b
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm 
constant_tsc arch_perfmon pebs bts nopl aperfmperf pni dtes64 monitor 
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida 
dtherm tpr_shadow vnmi flexpriority
bogomips	: 4788.11
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

[7.3.] $ cat /proc/modules
ipt_MASQUERADE 12880 3 - Live 0x0000000000000000
iptable_nat 13151 1 - Live 0x0000000000000000
nf_nat_ipv4 13316 1 iptable_nat, Live 0x0000000000000000
nf_nat 26147 3 ipt_MASQUERADE,iptable_nat,nf_nat_ipv4, Live 
0x0000000000000000
nf_conntrack_ipv4 14857 2 - Live 0x0000000000000000
nf_defrag_ipv4 12758 1 nf_conntrack_ipv4, Live 0x0000000000000000
xt_conntrack 12760 1 - Live 0x0000000000000000
nf_conntrack 97139 6 
ipt_MASQUERADE,iptable_nat,nf_nat_ipv4,nf_nat,nf_conntrack_ipv4,xt_conntrack, 
Live 0x0000000000000000
ipt_REJECT 12579 2 - Live 0x0000000000000000
xt_CHECKSUM 12549 1 - Live 0x0000000000000000
iptable_mangle 12734 1 - Live 0x0000000000000000
xt_tcpudp 12924 6 - Live 0x0000000000000000
bridge 116296 0 - Live 0x0000000000000000
stp 12976 1 bridge, Live 0x0000000000000000
llc 14441 2 bridge,stp, Live 0x0000000000000000
ip6table_filter 12815 0 - Live 0x0000000000000000
ip6_tables 27503 1 ip6table_filter, Live 0x0000000000000000
iptable_filter 12810 1 - Live 0x0000000000000000
ip_tables 27717 3 iptable_nat,iptable_mangle,iptable_filter, Live 
0x0000000000000000
ebtable_nat 12807 0 - Live 0x0000000000000000
ebtables 31209 1 ebtable_nat, Live 0x0000000000000000
x_tables 34194 11 
ipt_MASQUERADE,xt_conntrack,ipt_REJECT,xt_CHECKSUM,iptable_mangle,xt_tcpudp,ip6table_filter,ip6_tables,iptable_filter,ip_tables,ebtables, 
Live 0x0000000000000000
joydev 17575 0 - Live 0x0000000000000000
snd_hda_codec_analog 15049 1 - Live 0x0000000000000000
snd_hda_codec_generic 69424 1 snd_hda_codec_analog, Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
hp_wmi 18202 0 - Live 0x0000000000000000
sparse_keymap 13890 1 hp_wmi, Live 0x0000000000000000
snd_hda_codec_hdmi 47124 1 - Live 0x0000000000000000
snd_hda_intel 57222 10 - Live 0x0000000000000000
snd_hda_codec 142651 4 
snd_hda_codec_analog,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel, 
Live 0x0000000000000000
snd_hwdep 13613 1 snd_hda_codec, Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
coretemp 17768 0 - Live 0x0000000000000000
snd_pcm 108860 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 
0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 30465 1 snd_seq_midi, Live 0x0000000000000000
kvm_intel 148674 0 - Live 0x0000000000000000
b43 397438 0 - Live 0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
kvm 471679 1 kvm_intel, Live 0x0000000000000000
bcma 52681 1 b43, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 
0x0000000000000000
microcode 24391 0 - Live 0x0000000000000000
snd_timer 30038 2 snd_pcm,snd_seq, Live 0x0000000000000000
mac80211 676864 1 b43, Live 0x0000000000000000
bnep 19884 2 - Live 0x0000000000000000
rfcomm 74734 0 - Live 0x0000000000000000
bluetooth 426845 10 bnep,rfcomm, Live 0x0000000000000000
uvcvideo 82247 0 - Live 0x0000000000000000
6lowpan_iphc 18968 1 bluetooth, Live 0x0000000000000000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
snd 73979 32 
snd_hda_codec_analog,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, 
Live 0x0000000000000000
psmouse 108621 0 - Live 0x0000000000000000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000
serio_raw 13462 0 - Live 0x0000000000000000
videobuf2_core 45465 1 uvcvideo, Live 0x0000000000000000
videodev 149340 2 uvcvideo,videobuf2_core, Live 0x0000000000000000
lpc_ich 21163 0 - Live 0x0000000000000000
cfg80211 531467 2 b43,mac80211, Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
parport_pc 32866 0 - Live 0x0000000000000000
hp_accel 26012 0 - Live 0x0000000000000000
lis3lv02d 20280 1 hp_accel, Live 0x0000000000000000
input_polldev 13896 1 lis3lv02d, Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42481 3 ppdev,parport_pc,lp, Live 0x0000000000000000
xts 12951 1 - Live 0x0000000000000000
gf128mul 14951 1 xts, Live 0x0000000000000000
dm_crypt 23456 1 - Live 0x0000000000000000
hid_generic 12548 0 - Live 0x0000000000000000
usbhid 53067 0 - Live 0x0000000000000000
hid 106254 2 hid_generic,usbhid, Live 0x0000000000000000
radeon 1576014 3 - Live 0x0000000000000000
ahci 30066 3 - Live 0x0000000000000000
libahci 32191 1 ahci, Live 0x0000000000000000
sky2 63205 0 - Live 0x0000000000000000
i2c_algo_bit 13564 1 radeon, Live 0x0000000000000000
ttm 90127 1 radeon, Live 0x0000000000000000
ssb 63194 1 b43, Live 0x0000000000000000
drm_kms_helper 53224 1 radeon, Live 0x0000000000000000
drm 308197 5 radeon,ttm,drm_kms_helper, Live 0x0000000000000000
video 19914 0 - Live 0x0000000000000000
wmi 19363 1 hp_wmi, Live 0x0000000000000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0062-0062 : EC data
   0064-0064 : keyboard
   0066-0066 : EC cmd
   0070-0077 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   0200-027f : pnp 00:06
   03c0-03df : vesafb
   0400-0403 : ACPI PM1a_EVT_BLK
   0404-0405 : ACPI PM1a_CNT_BLK
   0408-040b : ACPI PM_TMR
   0410-0415 : ACPI CPU throttle
   0420-042f : ACPI GPE0_BLK
   0430-0433 : iTCO_wdt
   0450-0450 : ACPI PM2_CNT_BLK
   0460-047f : iTCO_wdt
   0500-057f : pnp 00:06
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   1000-1003 : pnp 00:06
   1010-101f : pnp 00:06
   2000-2fff : PCI Bus 0000:86
     2000-20ff : 0000:86:00.0
       2000-20ff : sky2
   3000-4fff : PCI Bus 0000:45
   5000-6fff : PCI Bus 0000:04
   7000-7fff : PCI Bus 0000:01
     7000-70ff : 0000:01:00.0
   8000-801f : 0000:00:1f.2
     8000-801f : ahci
   8020-803f : 0000:00:1d.2
     8020-803f : uhci_hcd
   8040-805f : 0000:00:1d.1
     8040-805f : uhci_hcd
   8060-807f : 0000:00:1d.0
     8060-807f : uhci_hcd
   8080-809f : 0000:00:1a.2
     8080-809f : uhci_hcd
   80a0-80bf : 0000:00:1a.1
     80a0-80bf : uhci_hcd
   80c0-80df : 0000:00:1a.0
     80c0-80df : uhci_hcd
   80e0-80e7 : 0000:00:1f.2
     80e0-80e7 : ahci
   80e8-80ef : 0000:00:1f.2
     80e8-80ef : ahci
   80f0-80f3 : 0000:00:1f.2
     80f0-80f3 : ahci
   80f4-80f7 : 0000:00:1f.2
     80f4-80f7 : ahci
   9000-9fff : PCI Bus 0000:02
   a000-afff : PCI Bus 0000:03
   ef80-ef9f : pnp 00:06
   fe00-fe0f : pnp 00:03
   fe80-fe8f : pnp 00:03
   ffff-ffff : pnp 00:06

$ cat /proc/iomem
00000000-00000fff : reserved
00001000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cf7ff : Video ROM
000ef000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-b8f3ffff : System RAM
   01000000-01776085 : Kernel code
   01776086-01d157bf : Kernel data
   01e73000-01fd8fff : Kernel bss
b8f40000-b8f41fff : reserved
b8f42000-b9d6ffff : System RAM
b9d70000-b9d7ffff : ACPI Non-volatile Storage
b9d80000-bc4e0fff : System RAM
bc4e1000-bc6e0fff : ACPI Non-volatile Storage
bc6e1000-bde91fff : System RAM
bde92000-bde99fff : reserved
bde9a000-bdebefff : System RAM
bdebf000-bdecefff : reserved
bdecf000-bdfcefff : ACPI Non-volatile Storage
bdfcf000-bdffefff : ACPI Tables
bdfff000-bdffffff : System RAM
be000000-bfffffff : reserved
c0000000-dfffffff : PCI Bus 0000:00
   c0000000-cfffffff : PCI Bus 0000:01
     c0000000-cfffffff : 0000:01:00.0
   d0000000-d00fffff : PCI Bus 0000:87
   d0100000-d01fffff : PCI Bus 0000:86
     d0100000-d0103fff : 0000:86:00.0
       d0100000-d0103fff : sky2
   d0200000-d41fffff : PCI Bus 0000:45
   d4200000-d81fffff : PCI Bus 0000:04
   d8200000-d82fffff : PCI Bus 0000:03
     d8200000-d8203fff : 0000:03:00.0
       d8200000-d8203fff : b43-pci-bridge
   d8300000-d83fffff : PCI Bus 0000:02
   d8400000-d84fffff : PCI Bus 0000:01
     d8400000-d840ffff : 0000:01:00.0
     d8410000-d8413fff : 0000:01:00.1
       d8410000-d8413fff : ICH HD audio
     d8420000-d843ffff : 0000:01:00.0
   d8500000-d8503fff : 0000:00:1b.0
     d8500000-d8503fff : ICH HD audio
   d8504000-d85047ff : 0000:00:1f.2
     d8504000-d85047ff : ahci
   d8505000-d85053ff : 0000:00:1d.7
     d8505000-d85053ff : ehci_hcd
   d8506000-d85063ff : 0000:00:1a.7
     d8506000-d85063ff : ehci_hcd
   d8600000-d87fffff : PCI Bus 0000:02
   d8800000-d89fffff : PCI Bus 0000:03
   d8a00000-d8bfffff : PCI Bus 0000:04
   d8c00000-d8dfffff : PCI Bus 0000:45
   d8e00000-d90fffff : PCI Bus 0000:86
     d8e00000-d8e1ffff : 0000:86:00.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
   e0000000-efffffff : reserved
     e0000000-efffffff : pnp 00:00
f0000000-fedfffff : PCI Bus 0000:00
   fec00000-fec00fff : reserved
     fec00000-fec003ff : IOAPIC 0
   fed00000-fed003ff : HPET 0
     fed00000-fed003ff : pnp 00:04
   fed10000-fed13fff : reserved
     fed10000-fed13fff : pnp 00:00
   fed18000-fed19fff : reserved
     fed18000-fed18fff : pnp 00:00
     fed19000-fed19fff : pnp 00:00
   fed1c000-fed1ffff : reserved
     fed1c000-fed1ffff : pnp 00:00
       fed1f410-fed1f414 : iTCO_wdt
   fed20000-fed3ffff : pnp 00:00
   fed40000-fed44fff : pnp 00:03
   fed45000-fed8ffff : pnp 00:00
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
fee01000-ffffffff : PCI Bus 0000:00
   ffe00000-ffffffff : reserved
100000000-13fffffff : System RAM

[7.5.] $ sudo lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory 
Controller Hub (rev 07)
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0a <?>

00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI 
Express Graphics Port (rev 07) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: d8400000-d84fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Hewlett-Packard Company Device 3074
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41b1
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit Latency 
L0s <256ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed19000
	Kernel driver in use: pcieport

00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 80c0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 80a0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 8080 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at d8506000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio 
Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 3076
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 49
	Region 0: Memory at d8500000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4192
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=7f
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: d8300000-d83fffff
	Prefetchable memory behind bridge: 00000000d8600000-00000000d87fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41c1
	Capabilities: [90] Subsystem: Device 0000:0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: d8200000-d82fffff
	Prefetchable memory behind bridge: 00000000d8800000-00000000d89fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #1, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41d1
	Capabilities: [90] Subsystem: Device 0000:0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 3 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=44, sec-latency=0
	I/O behind bridge: 00005000-00006fff
	Memory behind bridge: d4200000-d81fffff
	Prefetchable memory behind bridge: 00000000d8a00000-00000000d8bfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+ HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41e1
	Capabilities: [90] Subsystem: Device 0000:0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=03 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 5 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=45, subordinate=85, sec-latency=0
	I/O behind bridge: 00003000-00004fff
	Memory behind bridge: d0200000-d41fffff
	Prefetchable memory behind bridge: 00000000d8c00000-00000000d8dfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #4, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+ HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4122
	Capabilities: [90] Subsystem: Device 0000:0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=05 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 6 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=86, subordinate=86, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d0100000-d01fffff
	Prefetchable memory behind bridge: 00000000d8e00000-00000000d90fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0
			ExtTag- RBE+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4142
	Capabilities: [90] Subsystem: Device 0000:0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=06 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 8060 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 22
	Region 4: I/O ports at 8040 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 8020 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 20
	Region 0: Memory at d8505000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) 
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=87, subordinate=87, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: d0000000-d00fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Device 0000:0000

00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller 
(rev 03)
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 82801IBM/IEM (ICH9M/ICH9M-E) 
4 port SATA Controller [AHCI mode] (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 46
	Region 0: I/O ports at 80e8 [size=8]
	Region 1: I/O ports at 80f4 [size=4]
	Region 2: I/O ports at 80e0 [size=8]
	Region 3: I/O ports at 80f0 [size=4]
	Region 4: I/O ports at 8000 [size=32]
	Region 5: Memory at d8504000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
		Address: fee0300c  Data: 4162
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. 
[AMD/ATI] RV710/M92 [Mobility Radeon HD 4330/4350/4550] (prog-if 00 [VGA 
controller])
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 48
	Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 7000 [size=256]
	Region 2: Memory at d8400000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at d8420000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit Latency 
L0s <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF 
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF 
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4182
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
	Kernel driver in use: radeon

01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] RV710/730 
HDMI Audio [Radeon HD 4000 series]
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RV710/730 HDMI Audio 
[Radeon HD 4000 series]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 50
	Region 0: Memory at d8410000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit Latency 
L0s <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF 
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF 
Disabled
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41a2
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
	Kernel driver in use: snd_hda_intel

03:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g 
LP-PHY (rev 01)
	Subsystem: Hewlett-Packard Company Device 1508
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at d8200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s <4us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-ff-ff-00-ff-ff
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: b43-pci-bridge

86:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8072 PCI-E 
Gigabit Ethernet Controller (rev 10)
	Subsystem: Hewlett-Packard Company Device 3074
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at d0100000 (64-bit, non-prefetchable) [size=16K]
	Region 2: I/O ports at 2000 [size=256]
	Expansion ROM at d8e00000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Vital Product Data
		Product Name: Marvell Yukon 88E8072 Gigabit Ethernet Controller
		Read-only fields:
			[PN] Part number: Yukon 88E8072
			[EC] Engineering changes: Rev. 1.0
			[MN] Manufacture ID: 4d 61 72 76 65 6c 6c
			[SN] Serial number: AbCdEfGA0BD70
			[CP] Extended capability: 01 10 cc 03
			[RV] Reserved: checksum good, 9 byte(s) reserved
		Read/write fields:
			[RW] Read-write area: 1 byte(s) free
		End
	Capabilities: [5c] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4172
	Capabilities: [c0] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 
unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency 
L0s <256ns, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF 
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF 
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 1f, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [130 v1] Device Serial Number 70-bd-a0-ff-ff-05-a9-18
	Kernel driver in use: sky2

[7.6.] $ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: KINGSTON SVP200S Rev: 507K
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: hp       Model: DVDRAM GT20L     Rev: DC05
   Type:   CD-ROM                           ANSI  SCSI revision: 05

[7.7.] /sys/class/thermal after cold boot:
$ cd /sys/class/thermal && grep . */* 2>/dev/null
cooling_device0/cur_state:0
cooling_device0/max_state:1
cooling_device0/type:Fan
cooling_device10/cur_state:1
cooling_device10/max_state:1
cooling_device10/type:Fan
cooling_device11/cur_state:1
cooling_device11/max_state:1
cooling_device11/type:Fan
cooling_device12/cur_state:1
cooling_device12/max_state:1
cooling_device12/type:Fan
cooling_device13/cur_state:0
cooling_device13/max_state:10
cooling_device13/type:Processor
cooling_device14/cur_state:0
cooling_device14/max_state:10
cooling_device14/type:Processor
cooling_device15/cur_state:0
cooling_device15/max_state:24
cooling_device15/type:LCD
cooling_device1/cur_state:0
cooling_device1/max_state:1
cooling_device1/type:Fan
cooling_device2/cur_state:1
cooling_device2/max_state:1
cooling_device2/type:Fan
cooling_device3/cur_state:1
cooling_device3/max_state:1
cooling_device3/type:Fan
cooling_device4/cur_state:1
cooling_device4/max_state:1
cooling_device4/type:Fan
cooling_device5/cur_state:1
cooling_device5/max_state:1
cooling_device5/type:Fan
cooling_device6/cur_state:0
cooling_device6/max_state:1
cooling_device6/type:Fan
cooling_device7/cur_state:0
cooling_device7/max_state:1
cooling_device7/type:Fan
cooling_device8/cur_state:0
cooling_device8/max_state:1
cooling_device8/type:Fan
cooling_device9/cur_state:0
cooling_device9/max_state:1
cooling_device9/type:Fan
thermal_zone0/cdev0_trip_point:1
thermal_zone0/cdev1_trip_point:7
thermal_zone0/cdev2_trip_point:6
thermal_zone0/cdev3_trip_point:5
thermal_zone0/cdev4_trip_point:4
thermal_zone0/cdev5_trip_point:3
thermal_zone0/cdev6_trip_point:2
thermal_zone0/mode:enabled
thermal_zone0/passive:0
thermal_zone0/policy:step_wise
thermal_zone0/temp:69000
thermal_zone0/trip_point_0_temp:108000
thermal_zone0/trip_point_0_type:critical
thermal_zone0/trip_point_1_temp:105000
thermal_zone0/trip_point_1_type:active
thermal_zone0/trip_point_2_temp:96000
thermal_zone0/trip_point_2_type:active
thermal_zone0/trip_point_3_temp:87000
thermal_zone0/trip_point_3_type:active
thermal_zone0/trip_point_4_temp:72000
thermal_zone0/trip_point_4_type:active
thermal_zone0/trip_point_5_temp:64000
thermal_zone0/trip_point_5_type:active
thermal_zone0/trip_point_6_temp:57000
thermal_zone0/trip_point_6_type:active
thermal_zone0/trip_point_7_temp:30000
thermal_zone0/trip_point_7_type:active
thermal_zone0/type:acpitz
thermal_zone1/mode:enabled
thermal_zone1/passive:0
thermal_zone1/policy:step_wise
thermal_zone1/temp:48000
thermal_zone1/trip_point_0_temp:105000
thermal_zone1/trip_point_0_type:critical
thermal_zone1/type:acpitz
thermal_zone2/cdev0_trip_point:1
thermal_zone2/cdev1_trip_point:1
thermal_zone2/cdev2_trip_point:7
thermal_zone2/cdev3_trip_point:6
thermal_zone2/cdev4_trip_point:5
thermal_zone2/cdev5_trip_point:4
thermal_zone2/cdev6_trip_point:3
thermal_zone2/cdev7_trip_point:2
thermal_zone2/mode:enabled
thermal_zone2/policy:step_wise
thermal_zone2/temp:40000
thermal_zone2/trip_point_0_temp:108000
thermal_zone2/trip_point_0_type:critical
thermal_zone2/trip_point_1_temp:105000
thermal_zone2/trip_point_1_type:passive
thermal_zone2/trip_point_2_temp:84000
thermal_zone2/trip_point_2_type:active
thermal_zone2/trip_point_3_temp:74000
thermal_zone2/trip_point_3_type:active
thermal_zone2/trip_point_4_temp:62000
thermal_zone2/trip_point_4_type:active
thermal_zone2/trip_point_5_temp:45000
thermal_zone2/trip_point_5_type:active
thermal_zone2/trip_point_6_temp:38000
thermal_zone2/trip_point_6_type:active
thermal_zone2/trip_point_7_temp:30000
thermal_zone2/trip_point_7_type:active
thermal_zone2/type:acpitz
thermal_zone3/cdev0_trip_point:1
thermal_zone3/cdev1_trip_point:1
thermal_zone3/mode:enabled
thermal_zone3/policy:step_wise
thermal_zone3/temp:46000
thermal_zone3/trip_point_0_temp:105000
thermal_zone3/trip_point_0_type:critical
thermal_zone3/trip_point_1_temp:95000
thermal_zone3/trip_point_1_type:passive
thermal_zone3/type:acpitz
thermal_zone4/cdev0_trip_point:1
thermal_zone4/cdev1_trip_point:1
thermal_zone4/mode:enabled
thermal_zone4/policy:step_wise
thermal_zone4/temp:22300
thermal_zone4/trip_point_0_temp:108000
thermal_zone4/trip_point_0_type:critical
thermal_zone4/trip_point_1_temp:60000
thermal_zone4/trip_point_1_type:passive
thermal_zone4/type:acpitz
thermal_zone5/mode:enabled
thermal_zone5/passive:0
thermal_zone5/policy:step_wise
thermal_zone5/temp:55000
thermal_zone5/trip_point_0_temp:110000
thermal_zone5/trip_point_0_type:critical
thermal_zone5/type:acpitz


/sys/class/thermal after resume from suspend:
$ cd /sys/class/thermal && grep . */* 2>/dev/null
cooling_device0/cur_state:0
cooling_device0/max_state:1
cooling_device0/type:Fan
cooling_device10/cur_state:0
cooling_device10/max_state:1
cooling_device10/type:Fan
cooling_device11/cur_state:0
cooling_device11/max_state:1
cooling_device11/type:Fan
cooling_device12/cur_state:0
cooling_device12/max_state:1
cooling_device12/type:Fan
cooling_device13/cur_state:0
cooling_device13/max_state:10
cooling_device13/type:Processor
cooling_device14/cur_state:0
cooling_device14/max_state:10
cooling_device14/type:Processor
cooling_device15/cur_state:0
cooling_device15/max_state:24
cooling_device15/type:LCD
cooling_device1/cur_state:0
cooling_device1/max_state:1
cooling_device1/type:Fan
cooling_device2/cur_state:0
cooling_device2/max_state:1
cooling_device2/type:Fan
cooling_device3/cur_state:0
cooling_device3/max_state:1
cooling_device3/type:Fan
cooling_device4/cur_state:0
cooling_device4/max_state:1
cooling_device4/type:Fan
cooling_device5/cur_state:0
cooling_device5/max_state:1
cooling_device5/type:Fan
cooling_device6/cur_state:0
cooling_device6/max_state:1
cooling_device6/type:Fan
cooling_device7/cur_state:0
cooling_device7/max_state:1
cooling_device7/type:Fan
cooling_device8/cur_state:0
cooling_device8/max_state:1
cooling_device8/type:Fan
cooling_device9/cur_state:0
cooling_device9/max_state:1
cooling_device9/type:Fan
thermal_zone0/cdev0_trip_point:1
thermal_zone0/cdev1_trip_point:7
thermal_zone0/cdev2_trip_point:6
thermal_zone0/cdev3_trip_point:5
thermal_zone0/cdev4_trip_point:4
thermal_zone0/cdev5_trip_point:3
thermal_zone0/cdev6_trip_point:2
thermal_zone0/mode:enabled
thermal_zone0/passive:0
thermal_zone0/policy:step_wise
thermal_zone0/temp:65000
thermal_zone0/trip_point_0_temp:108000
thermal_zone0/trip_point_0_type:critical
thermal_zone0/trip_point_1_temp:105000
thermal_zone0/trip_point_1_type:active
thermal_zone0/trip_point_2_temp:96000
thermal_zone0/trip_point_2_type:active
thermal_zone0/trip_point_3_temp:87000
thermal_zone0/trip_point_3_type:active
thermal_zone0/trip_point_4_temp:79000
thermal_zone0/trip_point_4_type:active
thermal_zone0/trip_point_5_temp:71000
thermal_zone0/trip_point_5_type:active
thermal_zone0/trip_point_6_temp:63000
thermal_zone0/trip_point_6_type:active
thermal_zone0/trip_point_7_temp:56000
thermal_zone0/trip_point_7_type:active
thermal_zone0/type:acpitz
thermal_zone1/mode:enabled
thermal_zone1/passive:0
thermal_zone1/policy:step_wise
thermal_zone1/temp:37000
thermal_zone1/trip_point_0_temp:105000
thermal_zone1/trip_point_0_type:critical
thermal_zone1/type:acpitz
thermal_zone2/cdev0_trip_point:1
thermal_zone2/cdev1_trip_point:1
thermal_zone2/cdev2_trip_point:7
thermal_zone2/cdev3_trip_point:6
thermal_zone2/cdev4_trip_point:5
thermal_zone2/cdev5_trip_point:4
thermal_zone2/cdev6_trip_point:3
thermal_zone2/cdev7_trip_point:2
thermal_zone2/mode:enabled
thermal_zone2/policy:step_wise
thermal_zone2/temp:42000
thermal_zone2/trip_point_0_temp:108000
thermal_zone2/trip_point_0_type:critical
thermal_zone2/trip_point_1_temp:105000
thermal_zone2/trip_point_1_type:passive
thermal_zone2/trip_point_2_temp:84000
thermal_zone2/trip_point_2_type:active
thermal_zone2/trip_point_3_temp:74000
thermal_zone2/trip_point_3_type:active
thermal_zone2/trip_point_4_temp:62000
thermal_zone2/trip_point_4_type:active
thermal_zone2/trip_point_5_temp:52000
thermal_zone2/trip_point_5_type:active
thermal_zone2/trip_point_6_temp:44000
thermal_zone2/trip_point_6_type:active
thermal_zone2/trip_point_7_temp:30000
thermal_zone2/trip_point_7_type:active
thermal_zone2/type:acpitz
thermal_zone3/cdev0_trip_point:1
thermal_zone3/cdev1_trip_point:1
thermal_zone3/mode:enabled
thermal_zone3/policy:step_wise
thermal_zone3/temp:45000
thermal_zone3/trip_point_0_temp:105000
thermal_zone3/trip_point_0_type:critical
thermal_zone3/trip_point_1_temp:95000
thermal_zone3/trip_point_1_type:passive
thermal_zone3/type:acpitz
thermal_zone4/cdev0_trip_point:1
thermal_zone4/cdev1_trip_point:1
thermal_zone4/mode:enabled
thermal_zone4/policy:step_wise
thermal_zone4/temp:22300
thermal_zone4/trip_point_0_temp:108000
thermal_zone4/trip_point_0_type:critical
thermal_zone4/trip_point_1_temp:60000
thermal_zone4/trip_point_1_type:passive
thermal_zone4/type:acpitz
thermal_zone5/mode:enabled
thermal_zone5/passive:0
thermal_zone5/policy:step_wise
thermal_zone5/temp:0
thermal_zone5/trip_point_0_temp:110000
thermal_zone5/trip_point_0_type:critical
thermal_zone5/type:acpitz

[8.] Downstream bug report: 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1290110
