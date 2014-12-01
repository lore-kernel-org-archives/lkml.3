Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaLAGcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:32:08 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:49701 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaLAGcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:32:06 -0500
MIME-Version: 1.0
Date: Mon, 1 Dec 2014 07:32:05 +0100
Message-ID: <CAE8gLhn9wFBLvdxTonD5m8Q_wYG_eg_TQOuZnEFPEVXstHdbvw@mail.gmail.com>
Subject: PROBLEM: [Launchpad #1396889] [Lenovo ThinkPad T400] kexec reboot fails
From: MegaBrutal <megabrutal@gmail.com>
To: Linux kernel <linux-kernel@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I use the form I've been requested to use to report the kernel bug below.


[1.] One line summary of the problem:
When I reboot with kexec, my computer cold reboots after "Starting new
kernel" (i.e. I need to get through the POST and GRUB), instead of the
new kernel being booted instantly.


[2.] Full description of the problem/report:
To reproduce, install kexec-tools, set it up so that it shall try to
reboot the actual mainline kernel. Then issue a kexec reboot (if kexec
installed a "reboot" hook script, just issue "reboot"). You should see
a "Starting new kernel" message before the reported problem presents
itself.

I have a Lenovo Thinkpad T400. I didn't experience the same on my
other machines, so I suspect some hardware-dependent issue.

The problem is introduced by KASLR and is present on kernels compiled
with CONFIG_RANDOMIZE_BASE.


[3.] Keywords (i.e., modules, networking, kernel):


[4.] Kernel version (from /proc/version):
Linux version 3.18.0-031800rc7-generic (apw@gomeisa) (gcc version
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201411302035 SMP Mon Dec 1
01:36:38 UTC 2014


[5.] Output of Oops.. message (if applicable) with symbolic
information resolved (see Documentation/oops-tracing.txt)
N/A (I have no Oops message, or at least it's not visible).


[6.] A small shell script or example program which triggers the
problem (if possible)
See #2 for reproduce instructions, no shell script is required.


[7.] Environment
$ lsb_release -rd

Description:    Ubuntu 14.10
Release:    14.10


[7.1.] Software (add the output of the ver_linux script here)

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux thinkpad 3.18.0-031800rc7-generic #201411302035 SMP Mon Dec 1
01:36:38 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.9.1
Gnu make               4.0
binutils               2.24.90.20141014
util-linux             csomagból
mount                  debug
module-init-tools      18
e2fsprogs              1.42.10
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.19
Dynamic linker (ldd)   2.19
Procps                 3.3.9
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.23
wireless-tools         30
Modules Loaded         xt_conntrack ipt_REJECT nf_reject_ipv4
snd_hrtimer xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack xt_tcpudp bridge stp llc
iptable_filter ip_tables x_tables rfcomm bnep binfmt_misc btusb
bluetooth arc4 iwldvm mac80211 snd_hda_codec_conexant
snd_hda_codec_generic iwlwifi snd_hda_intel coretemp
snd_hda_controller snd_hda_codec kvm_intel kvm snd_hwdep i915 pcmcia
snd_pcm thinkpad_acpi joydev cfg80211 snd_seq_midi serio_raw
snd_seq_midi_event nvram yenta_socket drm_kms_helper snd_rawmidi drm
pcmcia_rsrc lpc_ich snd_seq shpchp pcmcia_core snd_seq_device
8250_fintek wmi i2c_algo_bit snd_timer mei_me snd mei soundcore ppdev
video lp mac_hid parport_pc parport btrfs xor raid6_pq psmouse
firewire_ohci pata_acpi firewire_core crc_itu_t e1000e ptp pps_core


[7.2.] Processor information (from /proc/cpuinfo):

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
stepping    : 10
microcode    : 0xa0c
cpu MHz        : 1600.000
cache size    : 3072 KB
physical id    : 0
siblings    : 2
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts nopl aperfmperf pni
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1
xsave lahf_lm ida dtherm tpr_shadow vnmi flexpriority
bugs        :
bogomips    : 4788.12
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
stepping    : 10
microcode    : 0xa0c
cpu MHz        : 800.000
cache size    : 3072 KB
physical id    : 0
siblings    : 2
core id        : 1
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts nopl aperfmperf pni
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1
xsave lahf_lm ida dtherm tpr_shadow vnmi flexpriority
bugs        :
bogomips    : 4788.12
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

xt_conntrack 12760 1 - Live 0x0000000000000000
ipt_REJECT 12541 2 - Live 0x0000000000000000
nf_reject_ipv4 13183 1 ipt_REJECT, Live 0x0000000000000000
snd_hrtimer 12744 1 - Live 0x0000000000000000
xt_CHECKSUM 12549 2 - Live 0x0000000000000000
iptable_mangle 12734 1 - Live 0x0000000000000000
ipt_MASQUERADE 12678 4 - Live 0x0000000000000000
nf_nat_masquerade_ipv4 13412 1 ipt_MASQUERADE, Live 0x0000000000000000
iptable_nat 12875 1 - Live 0x0000000000000000
nf_conntrack_ipv4 18953 2 - Live 0x0000000000000000
nf_defrag_ipv4 12758 1 nf_conntrack_ipv4, Live 0x0000000000000000
nf_nat_ipv4 14267 1 iptable_nat, Live 0x0000000000000000
nf_nat 26308 2 nf_nat_masquerade_ipv4,nf_nat_ipv4, Live 0x0000000000000000
nf_conntrack 105636 5
xt_conntrack,nf_nat_masquerade_ipv4,nf_conntrack_ipv4,nf_nat_ipv4,nf_nat,
Live 0x0000000000000000
xt_tcpudp 12924 11 - Live 0x0000000000000000
bridge 109756 0 - Live 0x0000000000000000
stp 12976 1 bridge, Live 0x0000000000000000
llc 14441 2 bridge,stp, Live 0x0000000000000000
iptable_filter 12810 1 - Live 0x0000000000000000
ip_tables 27718 3 iptable_mangle,iptable_nat,iptable_filter, Live
0x0000000000000000
x_tables 34102 8
xt_conntrack,ipt_REJECT,xt_CHECKSUM,iptable_mangle,ipt_MASQUERADE,xt_tcpudp,iptable_filter,ip_tables,
Live 0x0000000000000000
rfcomm 75066 0 - Live 0x0000000000000000
bnep 23980 2 - Live 0x0000000000000000
binfmt_misc 17501 1 - Live 0x0000000000000000
btusb 32691 0 - Live 0x0000000000000000
bluetooth 486890 11 rfcomm,bnep,btusb, Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
iwldvm 243857 0 - Live 0x0000000000000000
mac80211 697159 1 iwldvm, Live 0x0000000000000000
snd_hda_codec_conexant 23107 1 - Live 0x0000000000000000
snd_hda_codec_generic 69995 1 snd_hda_codec_conexant, Live 0x0000000000000000
iwlwifi 193813 1 iwldvm, Live 0x0000000000000000
snd_hda_intel 30824 3 - Live 0x0000000000000000
coretemp 13638 0 - Live 0x0000000000000000
snd_hda_controller 32234 1 snd_hda_intel, Live 0x0000000000000000
snd_hda_codec 144641 4
snd_hda_codec_conexant,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller,
Live 0x0000000000000000
kvm_intel 149984 0 - Live 0x0000000000000000
kvm 475237 1 kvm_intel, Live 0x0000000000000000
snd_hwdep 17709 1 snd_hda_codec, Live 0x0000000000000000
i915 1031996 3 - Live 0x0000000000000000
pcmcia 62760 0 - Live 0x0000000000000000
snd_pcm 106273 3 snd_hda_intel,snd_hda_controller,snd_hda_codec, Live
0x0000000000000000
thinkpad_acpi 82101 0 - Live 0x0000000000000000
joydev 17587 0 - Live 0x0000000000000000
cfg80211 520257 3 iwldvm,mac80211,iwlwifi, Live 0x0000000000000000
snd_seq_midi 13564 0 - Live 0x0000000000000000
serio_raw 13483 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
nvram 14462 1 thinkpad_acpi, Live 0x0000000000000000
yenta_socket 45447 0 - Live 0x0000000000000000
drm_kms_helper 99802 1 i915, Live 0x0000000000000000
snd_rawmidi 31197 1 snd_seq_midi, Live 0x0000000000000000
drm 323675 5 i915,drm_kms_helper, Live 0x0000000000000000
pcmcia_rsrc 18591 1 yenta_socket, Live 0x0000000000000000
lpc_ich 21176 0 - Live 0x0000000000000000
snd_seq 63540 3 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
shpchp 37216 0 - Live 0x0000000000000000
pcmcia_core 23715 3 pcmcia,yenta_socket,pcmcia_rsrc, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
8250_fintek 12925 0 - Live 0x0000000000000000
wmi 19379 0 - Live 0x0000000000000000
i2c_algo_bit 13564 1 i915, Live 0x0000000000000000
snd_timer 30118 3 snd_hrtimer,snd_pcm,snd_seq, Live 0x0000000000000000
mei_me 19565 0 - Live 0x0000000000000000
snd 84025 18 snd_hda_codec_conexant,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,thinkpad_acpi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
mei 88473 1 mei_me, Live 0x0000000000000000
soundcore 15091 2 snd_hda_codec,snd, Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
video 20649 1 i915, Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
mac_hid 13275 0 - Live 0x0000000000000000
parport_pc 32909 0 - Live 0x0000000000000000
parport 42481 3 ppdev,lp,parport_pc, Live 0x0000000000000000
btrfs 946082 2 - Live 0x0000000000000000
xor 21411 1 btrfs, Live 0x0000000000000000
raid6_pq 97812 1 btrfs, Live 0x0000000000000000
psmouse 118332 0 - Live 0x0000000000000000
firewire_ohci 45300 0 - Live 0x0000000000000000
pata_acpi 13053 0 - Live 0x0000000000000000
firewire_core 69403 1 firewire_ohci, Live 0x0000000000000000
crc_itu_t 12707 1 firewire_core, Live 0x0000000000000000
e1000e 230020 0 - Live 0x0000000000000000
ptp 19534 1 e1000e, Live 0x0000000000000000
pps_core 19381 1 ptp, Live 0x0000000000000000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

megabrutal@thinkpad:~$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0061-0061 : PNP0800:00
  0062-0062 : PNP0C09:00
    0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : PNP0C09:00
    0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
    00f0-00f0 : PNP0C04:00
  0170-0177 : 0000:00:1f.2
    0170-0177 : ata_piix
  01f0-01f7 : 0000:00:1f.2
    01f0-01f7 : ata_piix
  0376-0376 : 0000:00:1f.2
    0376-0376 : ata_piix
  03c0-03df : vga+
  03f6-03f6 : 0000:00:1f.2
    03f6-03f6 : ata_piix
  0800-080f : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  1010-1015 : ACPI CPU throttle
  1020-102f : ACPI GPE0_BLK
  1030-1033 : iTCO_wdt
  1050-1050 : ACPI PM2_CNT_BLK
  1060-107f : iTCO_wdt
  1180-11ff : pnp 00:01
  15e0-15ef : pnp 00:01
  1600-167f : pnp 00:01
  1680-169f : pnp 00:01
  1800-1807 : 0000:00:02.0
  1830-1837 : 0000:00:03.3
    1830-1837 : serial
  1840-185f : 0000:00:19.0
  1860-187f : 0000:00:1a.0
    1860-187f : uhci_hcd
  1880-189f : 0000:00:1a.1
    1880-189f : uhci_hcd
  18a0-18bf : 0000:00:1a.2
    18a0-18bf : uhci_hcd
  18c0-18df : 0000:00:1d.0
    18c0-18df : uhci_hcd
  18e0-18ff : 0000:00:1d.1
    18e0-18ff : uhci_hcd
  1c00-1c1f : 0000:00:1d.2
    1c00-1c1f : uhci_hcd
  1c20-1c2f : 0000:00:1f.2
    1c20-1c2f : ata_piix
  1c30-1c3f : 0000:00:1f.2
    1c30-1c3f : ata_piix
  1c60-1c7f : 0000:00:1f.3
  2000-2fff : PCI Bus 0000:05
  3000-3fff : PCI Bus 0000:0d
  4000-7fff : PCI Bus 0000:15
    4000-40ff : PCI CardBus 0000:16
    4400-44ff : PCI CardBus 0000:16
  8000-8fff : PCI Bus 0000:02
  9000-9fff : PCI Bus 0000:03

megabrutal@thinkpad:~$ cat /proc/iomem
00000000-00000fff : reserved
00001000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c7fff : Video ROM
000c8000-000cbfff : pnp 00:00
000cc000-000cffff : pnp 00:00
000d0000-000d0fff : Adapter ROM
000d1000-000d1fff : Adapter ROM
000d2000-000d2fff : Adapter ROM
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000fffff : reserved
  000e0000-000effff : Extension ROM
  000f0000-000fffff : System ROM
00100000-794a0fff : System RAM
  01000000-017b8537 : Kernel code
  017b8538-01d2123f : Kernel data
  01e87000-01fcffff : Kernel bss
794a1000-794a6fff : reserved
794a7000-795b6fff : System RAM
795b7000-7960efff : reserved
7960f000-796c5fff : System RAM
796c6000-796d0fff : ACPI Non-volatile Storage
796d1000-796d3fff : ACPI Tables
796d4000-796d7fff : reserved
796d8000-796dbfff : ACPI Non-volatile Storage
796dc000-796defff : reserved
796df000-79705fff : ACPI Non-volatile Storage
79706000-79707fff : ACPI Tables
79708000-7990efff : reserved
7990f000-7999efff : ACPI Non-volatile Storage
7999f000-799fefff : ACPI Tables
799ff000-799fffff : System RAM
79a00000-79bfffff : RAM buffer
79c00000-7bffffff : reserved
  7a000000-7bffffff : Graphics Stolen Memory
7c000000-febfffff : PCI Bus 0000:00
  7c000000-7c1fffff : PCI Bus 0000:02
  7c200000-7c3fffff : PCI Bus 0000:02
  7c400000-7c5fffff : PCI Bus 0000:03
  7c600000-7c600fff : Intel Flush Page
  80000000-83ffffff : PCI CardBus 0000:16
  d0000000-dfffffff : 0000:00:02.0
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:01
      e0000000-e3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f0000000-f3ffffff : PCI Bus 0000:15
    f0000000-f3ffffff : PCI CardBus 0000:16
  f4000000-f40fffff : PCI Bus 0000:05
  f4100000-f41fffff : PCI Bus 0000:0d
  f4200000-f42fffff : 0000:00:02.1
  f4300000-f43fffff : PCI Bus 0000:03
    f4300000-f4301fff : 0000:03:00.0
      f4300000-f4301fff : iwlwifi
  f4400000-f47fffff : 0000:00:02.0
  f4800000-f7ffffff : PCI Bus 0000:15
    f4800000-f4800fff : 0000:15:00.0
      f4800000-f4800fff : yenta_socket
    f4801000-f48017ff : 0000:15:00.1
      f4801000-f48017ff : firewire_ohci
  f8000000-f9ffffff : PCI Bus 0000:05
  fa000000-fbffffff : PCI Bus 0000:0d
  fc000000-fc01ffff : 0000:00:19.0
    fc000000-fc01ffff : e1000e
  fc020000-fc023fff : 0000:00:1b.0
    fc020000-fc023fff : ICH HD audio
  fc024000-fc024fff : 0000:00:03.3
  fc025000-fc025fff : 0000:00:19.0
    fc025000-fc025fff : e1000e
  fc226000-fc22600f : 0000:00:03.0
    fc226000-fc22600f : mei_me
  fc226400-fc2267ff : 0000:00:1a.7
    fc226400-fc2267ff : ehci_hcd
  fc226800-fc226bff : 0000:00:1d.7
    fc226800-fc226bff : ehci_hcd
  fc226c00-fc226cff : 0000:00:1f.3
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
    fed00000-fed003ff : PNP0103:00
fed10000-fed13fff : reserved
  fed10000-fed13fff : pnp 00:01
fed18000-fed19fff : reserved
  fed18000-fed18fff : pnp 00:01
  fed19000-fed19fff : pnp 00:01
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:01
    fed1f410-fed1f414 : iTCO_wdt
  fed45000-fed4bfff : pnp 00:01
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff800000-ffffffff : reserved


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
Controller Hub (rev 07)
    Subsystem: Lenovo Device 20e0
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0a <?>
    Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA
controller])
    Subsystem: Lenovo Device 20e4
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 30
    Region 0: Memory at f4400000 (64-bit, non-prefetchable) [size=4M]
    Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
    Region 4: I/O ports at 1800 [size=8]
    Expansion ROM at <unassigned> [disabled]
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 41e2
    Capabilities: [d0] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)
    Subsystem: Lenovo Device 20e4
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Region 0: Memory at f4200000 (64-bit, non-prefetchable) [size=1M]
    Capabilities: [d0] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Communication controller: Intel Corporation Mobile 4 Series
Chipset MEI Controller (rev 07)
    Subsystem: Lenovo Device 20e6
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 29
    Region 0: Memory at fc226000 (64-bit, non-prefetchable) [size=16]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0300c  Data: 41d2
    Kernel driver in use: mei_me

00:03.3 Serial controller: Intel Corporation Mobile 4 Series Chipset
AMT SOL Redirection (rev 07) (prog-if 02 [16550])
    Subsystem: Lenovo Device 20ec
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 17
    Region 0: I/O ports at 1830 [size=8]
    Region 1: Memory at fc024000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [c8] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Kernel driver in use: serial

00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network
Connection (rev 03)
    Subsystem: Lenovo Device 20ee
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 28
    Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=128K]
    Region 1: Memory at fc025000 (32-bit, non-prefetchable) [size=4K]
    Region 2: I/O ports at 1840 [size=32]
    Capabilities: [c8] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0200c  Data: 4163
    Capabilities: [e0] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: e1000e

00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo Device 20f0
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 20
    Region 4: I/O ports at 1860 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo Device 20f0
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 21
    Region 4: I/O ports at 1880 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1a.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #6 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo Device 20f0
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 22
    Region 4: I/O ports at 18a0 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
    Subsystem: Lenovo Device 20f1
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 23
    Region 0: Memory at fc226400 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
    Capabilities: [58] Debug port: BAR=1 offset=00a0
    Capabilities: [98] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)
    Subsystem: Lenovo Device 20f2
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin B routed to IRQ 31
    Region 0: Memory at fc020000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0300c  Data: 4123
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable- ID=0 ArbSelect=Fixed TC/VC=00
            Status:    NegoPending- InProgress-
    Capabilities: [130 v1] Root Complex Link
        Desc:    PortNumber=0f ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 00008000-00008fff
    Memory behind bridge: 7c000000-7c1fffff
    Prefetchable memory behind bridge: 000000007c200000-000000007c3fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <1us, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #0, PowerLimit 6.500W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg+
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 41d1
    Capabilities: [90] Subsystem: Lenovo Device 20f3
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=01 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 2 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 00009000-00009fff
    Memory behind bridge: f4300000-f43fffff
    Prefetchable memory behind bridge: 000000007c400000-000000007c5fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <256ns, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #1, PowerLimit 6.500W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg+
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 4122
    Capabilities: [90] Subsystem: Lenovo Device 20f3
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=02 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 4 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
    I/O behind bridge: 00002000-00002fff
    Memory behind bridge: f8000000-f9ffffff
    Prefetchable memory behind bridge: 00000000f4000000-00000000f40fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <1us, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg+
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 4152
    Capabilities: [90] Subsystem: Lenovo Device 20f3
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=04 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 5 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
    I/O behind bridge: 00003000-00003fff
    Memory behind bridge: fa000000-fbffffff
    Prefetchable memory behind bridge: 00000000f4100000-00000000f41fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <1us, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #4, PowerLimit 6.500W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg+
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 4162
    Capabilities: [90] Subsystem: Lenovo Device 20f3
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=05 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo Device 20f0
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 4: I/O ports at 18c0 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo Device 20f0
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 17
    Region 4: I/O ports at 18e0 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Lenovo Device 20f0
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 4: I/O ports at 1c00 [size=32]
    Capabilities: [50] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
    Subsystem: Lenovo Device 20f1
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin D routed to IRQ 19
    Region 0: Memory at fc226800 (32-bit, non-prefetchable) [size=1K]
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
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
    I/O behind bridge: 00004000-00007fff
    Memory behind bridge: f4800000-f7ffffff
    Prefetchable memory behind bridge: 00000000f0000000-00000000f3ffffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Subsystem: Lenovo Device 20f4

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
    Subsystem: Lenovo Device 20f5
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>
    Kernel driver in use: lpc_ich

00:1f.2 IDE interface: Intel Corporation 82801IBM/IEM (ICH9M/ICH9M-E)
2 port SATA Controller [IDE mode] (rev 03) (prog-if 8a [Master SecP
PriP])
    Subsystem: Lenovo Device 20f7
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 16
    Region 0: I/O ports at 01f0 [size=8]
    Region 1: I/O ports at 03f4
    Region 2: I/O ports at 0170 [size=8]
    Region 3: I/O ports at 0374
    Region 4: I/O ports at 1c30 [size=16]
    Region 5: I/O ports at 1c20 [size=16]
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [b0] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    Subsystem: Lenovo Device 20f9
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 11
    Region 0: Memory at fc226c00 (64-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at 1c60 [size=32]

03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN
[Shiloh] Network Connection
    Subsystem: Intel Corporation WiFi Link 5100 AGN
    Physical Slot: 1-1
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 32
    Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
    Capabilities: [c8] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0100c  Data: 4143
    Capabilities: [e0] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <128ns, L1 <32us
            ClockPM+ Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP+ BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [140 v1] Device Serial Number 00-1e-65-ff-ff-c6-87-bc
    Kernel driver in use: iwlwifi

15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
    Subsystem: Lenovo ThinkPad R61
    Physical Slot: 1
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 168, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at f4800000 (32-bit, non-prefetchable) [size=4K]
    Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
    Memory window 0: f0000000-f3ffffff (prefetchable)
    Memory window 1: 80000000-83ffffff
    I/O window 0: 00004000-000040ff
    I/O window 1: 00004400-000044ff
    BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
    16-bit legacy interface ports at 0001
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
        Bridge: PM- B3+
    Kernel driver in use: yenta_cardbus

15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
(rev 04) (prog-if 10 [OHCI])
    Subsystem: Lenovo ThinkPad R61
    Physical Slot: 1
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
    Interrupt: pin B routed to IRQ 17
    Region 0: Memory at f4801000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
    Kernel driver in use: firewire_ohci


[7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST9160412AS      Rev: LVM1
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GSA-U20N  Rev: HX12
  Type:   CD-ROM                           ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem (please
look in /proc and include all information that you think to be
relevant):
While booted into the newest upstream mainline kernel only, execute
the following via a terminal, and paste the results:
ls /proc

1     150   2     2430  2645  2940  457  60    asound       meminfo
10    1503  20    2447  2651  2942  458  605   buddyinfo    misc
1062  152   200   2458  2656  2944  459  623   bus          modules
1081  1527  201   2459  2666  2960  460  629   cgroups      mounts
11    153   2013  2468  2674  2968  461  639   cmdline      mtrr
12    1541  202   2481  2676  2974  462  642   consoles     net
1250  155   203   2483  2680  2983  463  647   cpuinfo      pagetypeinfo
1255  156   204   2487  2696  2984  464  669   crypto       partitions
1257  1575  205   2490  2697  3     465  674   devices      sched_debug
1264  1578  206   2494  2698  30    466  7     diskstats    schedstat
1266  158   207   2495  2699  3095  467  723   dma          scsi
1270  1589  208   2496  27    31    468  736   driver       self
13    159   209   25    2700  3117  489  743   execdomains  slabinfo
1300  160   21    2500  2701  32    490  745   fb           softirqs
1309  162   210   2505  2702  3219  491  8     filesystems  stat
1321  1681  211   2507  2703  33    492  80    fs           swaps
1327  17    212   2511  2742  34    5    81    interrupts   sys
1328  1707  213   2513  28    347   516  83    iomem        sysrq-trigger
1329  1746  214   2515  2842  35    52   9     ioports      sysvipc
133   18    215   2523  2849  36    520  900   irq          thread-self
134   1810  216   2534  2864  38    521  908   kallsyms     timer_list
135   1811  217   2556  2879  39    527  948   kcore        timer_stats
14    187   22    2563  29    40    53   960   keys         tty
143   1875  2278  2567  2907  450   54   971   key-users    uptime
144   19    23    26    2910  451   55   978   kmsg         version
145   1953  2324  2624  2911  452   56   984   kpagecount   vmallocinfo
146   196   2326  2628  2912  453   57   985   kpageflags   vmstat
148   197   24    2629  2913  454   58   995   loadavg      zoneinfo
1485  198   2418  2630  2927  455   59   998   locks
15    199   2429  2644  2933  456   6    acpi  mdstat


[X.] Other notes, patches, fixes, workarounds:
Downstream report (Ubuntu Launchpad):
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1396889

With kernel bisection, I've found, the first bad commit is
8ab3820fd5b2896d66da7bb2a906bc382e63e7bc x86, kaslr: Return location
from decompress_kernel
which introduces KASLR.
http://lkml.kernel.org/r/1381450698-28710-3-git-send-email-keescook@chromium.org

The problem only presents itself when CONFIG_RANDOMIZE_BASE=y.

For workaround, there is a "nokaslr" kernel parameter to disable the
feature, even if the kernel was compiled with CONFIG_RANDOMIZE_BASE.
