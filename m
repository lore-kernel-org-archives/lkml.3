Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaBYNPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:15:05 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47813 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaBYNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:15:04 -0500
MIME-Version: 1.0
Date: Tue, 25 Feb 2014 20:15:01 +0700
Message-ID: <CAEjyFXfkjUYJytPQPKw+tFhN5DQLWXqjXWxmhs19Yf5Z6NsjcA@mail.gmail.com>
Subject: PROBLEM: CPU#1 stuck for 23s! [qemu-system-x86:1662]
From: "mrDoctorWho0 ." <mrdoctorwho@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: Qemu (with kvm) causes kernel oops.

Description: While booted into the newest mainline kernel (3.14rc2) i
launched Qemu-kvm. In different time happens kernel oops: soft lockup
- CPU#1 stuck for 23s! [qemu-system-x86:1662]. This affects linux from
3.13 to 3.14

Kernel version: Linux version 3.14.0-031400rc2-generic (apw@gomeisa)
(gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201402092235 SMP
Mon Feb 10 03:57:45 UTC 2014

Keywords: qemu, kvm, cpu stock

Oops text:


[102537.162416] BUG: soft lockup - CPU#1 stuck for 23s! [qemu-system-x86:1662]

[102537.162420] Modules linked in: ppp_mppe
ppp_async crc_ccitt cpuid btrfs raid6_pq xor ufs qnx4 hfsplus hfs
minix ntfs msdos jfs xfs libcrc32c option usb_wwan usbserial cdc_acm
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM
iptable_mangle xt_tcpudp bridge 8021q garp stp mrp llc
ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat
ebtables x_tables zram(C) arc4 brcmsmac cordic brcmutil b43 mac80211
cfg80211 joydev hid_generic ssb rtsx_pci_ms rtsx_pci_sdmmc memstick
snd_hda_codec_hdmi snd_hda_codec_via usbhid hid usb_storage
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc
snd_seq_midi snd_seq_midi_event snd_rawmidi dm_multipath scsi_dh
intel_rapl x86_pkg_temp_thermal intel_powerclamp snd_seq kvm_intel
kvm parport_pc ppdev snd_seq_device snd_timer crc32_pclmul btusb snd
bnep rfcomm psmouse bluetooth lpc_ich serio_raw r8169 mei_me rtsx_pci
mii bcma mei soundcore mac_hid intel_smartconnect coretemp
binfmt_misc lp parport i915 i2c_algo_bit microcode drm_kms_helper
ahci drm libahci wmi video [last unloaded: videobuf2_memops]

[102537.162491] CPU: 1 PID: 1662 Comm:
qemu-system-x86 Tainted: G         C   3.13.0-8-generic #28-Ubuntu

[102537.162492] Hardware name: CLEVO CO.
               W240EU/W250EUQ/W270EUQ
/W240EU/W250EUQ/W270EUQ          , BIOS 4.6.5 02/26/2013

[102537.162494] task: cb582700 ti: c21c6000
task.ti: c21c6000

[102537.162496] EIP: 0060:[<c10a9c2b>]
EFLAGS: 00000202 CPU: 1

[102537.162501] EIP is at
__srcu_read_unlock+0xb/0x20

[102537.162502] EAX: c0188024 EBX: c0188024 ECX:
d146f000 EDX: 00000001

[102537.162504] ESI: cb582700 EDI: c5718000 EBP:
c21c7e6c ESP: c21c7e6c

[102537.162505]  DS: 007b ES: 007b FS: 00d8 GS:
00e0 SS: 0068

[102537.162506] CR0: 80050033 CR2: 00000000 CR3:
1146e000 CR4: 001427f0

[102537.162508] Stack:

[102537.162509]  c21c7e94 f8793276 c0188024
c21c7e74 00000001 7ffbfeff fffffffe c5718000

[102537.162513]  f2d95600 0000ae80 c21c7f18
f877f0f3 00000000 00000000 c10b95ff 00000002

[102537.162518]  00000000 c21c7ee8 c21c7ed0
c10b9865 b7ccc000 f7bd75b0 ffffffff ffffffff

[102537.162522]
Call Trace:

Release:

Description: Ubuntu Trusty Tahr (development branch)

Release: 14.04

Software: # /usr/src/linux-headers-3.14.0-031400rc2/scripts/ver_linux

If some fields are empty or look unusual you may have an old version.

Compare to the current minimal requirements in Documentation/Changes.

Linux mrDoctorWho-Lap 3.14.0-031400rc2-generic #201402092235 SMP Mon
Feb 10 03:57:45 UTC 2014 i686 i686 i686 GNU/Linux

Gnu C 4.8

Gnu make 3.81

binutils 2.24

util-linux 2.20.1

mount support

module-init-tools 15

e2fsprogs 1.42.9

pcmciautils 018

PPP 2.4.5

Linux C Library 2.19

Dynamic linker (ldd) 2.19

Procps 3.3.9

Net-tools 1.60

Kbd 1.15.5

Sh-utils 8.21

wireless-tools 30

Modules Loaded btrfs raid6_pq xor ufs qnx4 hfsplus hfs minix ntfs
msdos jfs xfs libcrc32c ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT
xt_CHECKSUM iptable_mangle xt_tcpudp bridge 8021q garp stp mrp llc
ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat
ebtables x_tables zram arc4 brcmsmac cordic brcmutil b43 mac80211
cfg80211 joydev hid_generic snd_hda_codec_hdmi ssb rtsx_pci_ms
snd_hda_codec_via memstick snd_hda_codec_generic rtsx_pci_sdmmc
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device intel_rapl
dm_multipath x86_pkg_temp_thermal snd_timer usbhid hid
intel_powerclamp scsi_dh snd kvm_intel btusb kvm crc32_pclmul bcma
parport_pc soundcore ppdev rfcomm psmouse r8169 rtsx_pci bnep mii
lpc_ich serio_raw bluetooth 6lowpan_iphc tpm_infineon mei_me mei
mac_hid intel_smartconnect coretemp lp binfmt_misc parport i915
microcode i2c_algo_bit drm_kms_helper ahci drm libahci wmi video


Cpuinfo:

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i3-3120M CPU @ 2.50GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2125.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fdiv_bug    : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc
aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx f16c lahf_lm arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips    : 4988.25
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i3-3120M CPU @ 2.50GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2400.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 2
initial apicid    : 2
fdiv_bug    : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc
aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx f16c lahf_lm arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips    : 4988.25
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i3-3120M CPU @ 2.50GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2425.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fdiv_bug    : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc
aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx f16c lahf_lm arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips    : 4988.25
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 58
model name    : Intel(R) Core(TM) i3-3120M CPU @ 2.50GHz
stepping    : 9
microcode    : 0x19
cpu MHz        : 2400.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 3
initial apicid    : 3
fdiv_bug    : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc
aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer xsave avx f16c lahf_lm arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips    : 4988.25
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:


Modules:

btrfs 889224 0 - Live 0xfa215000

raid6_pq 97455 1 btrfs, Live 0xf9684000

xor 26221 1 btrfs, Live 0xf8b6e000

ufs 78193 0 - Live 0xf94bc000

qnx4 13162 0 - Live 0xf8961000

hfsplus 93816 0 - Live 0xf966c000

hfs 49548 0 - Live 0xf8df0000

minix 31567 0 - Live 0xf896c000

ntfs 100206 0 - Live 0xf9575000

msdos 17132 0 - Live 0xf8966000

jfs 175347 0 - Live 0xf95b5000

xfs 832673 0 - Live 0xf9c38000

libcrc32c 12543 1 xfs, Live 0xf9b30000

ipt_MASQUERADE 12760 3 - Live 0xf88d9000

iptable_nat 12983 1 - Live 0xf87a8000

nf_nat_ipv4 13140 1 iptable_nat, Live 0xf87a3000

nf_nat 20998 3 ipt_MASQUERADE,iptable_nat,nf_nat_ipv4, Live 0xf88d2000

nf_conntrack_ipv4 14361 2 - Live 0xf88c0000

nf_defrag_ipv4 12649 1 nf_conntrack_ipv4, Live 0xf879e000

xt_conntrack 12664 1 - Live 0xf8633000

nf_conntrack 83615 6
ipt_MASQUERADE,iptable_nat,nf_nat_ipv4,nf_nat,nf_conntrack_ipv4,xt_conntrack,
Live 0xf9489000

ipt_REJECT 12515 2 - Live 0xf8612000

xt_CHECKSUM 12493 1 - Live 0xf85b0000

iptable_mangle 12646 1 - Live 0xf8549000

xt_tcpudp 12788 6 - Live 0xf8799000

bridge 95753 0 - Live 0xf9061000

8021q 23848 0 - Live 0xf8937000

garp 14164 1 8021q, Live 0xf88c5000

stp 12848 2 bridge,garp, Live 0xf88ae000

mrp 18451 1 8021q, Live 0xf88ba000

llc 14065 3 bridge,garp,stp, Live 0xf8a1e000

ip6table_filter 12711 0 - Live 0xf87f7000

ip6_tables 18135 1 ip6table_filter, Live 0xf88a8000

iptable_filter 12706 1 - Live 0xf85d5000

ip_tables 18303 3 iptable_nat,iptable_mangle,iptable_filter, Live 0xf8888000

ebtable_nat 12695 0 - Live 0xf84b9000

ebtables 21539 1 ebtable_nat, Live 0xf8777000

x_tables 22180 11
ipt_MASQUERADE,xt_conntrack,ipt_REJECT,xt_CHECKSUM,iptable_mangle,xt_tcpudp,ip6table_filter,ip6_tables,iptable_filter,ip_tables,ebtables,
Live 0xf959a000

zram 18197 4 - Live 0xf96bb000

arc4 12509 2 - Live 0xf85ba000

brcmsmac 534347 0 - Live 0xf95e8000

cordic 12518 1 brcmsmac, Live 0xf8828000

brcmutil 15066 1 brcmsmac, Live 0xf8691000

b43 369680 0 - Live 0xf94f5000

mac80211 578740 2 brcmsmac,b43, Live 0xf8adf000

cfg80211 447797 3 brcmsmac,b43,mac80211, Live 0xf8d81000

joydev 17299 0 - Live 0xf868b000

hid_generic 12492 0 - Live 0xf860d000

snd_hda_codec_hdmi 46041 1 - Live 0xf880a000

ssb 56629 1 b43, Live 0xf882d000

rtsx_pci_ms 17944 0 - Live 0xf85fd000

snd_hda_codec_via 23198 1 - Live 0xf8606000

memstick 16176 1 rtsx_pci_ms, Live 0xf85db000

snd_hda_codec_generic 63224 1 snd_hda_codec_via, Live 0xf8788000

rtsx_pci_sdmmc 23051 0 - Live 0xf8781000

snd_hda_intel 43274 8 - Live 0xf867f000

snd_hda_codec 119362 4
snd_hda_codec_hdmi,snd_hda_codec_via,snd_hda_codec_generic,snd_hda_intel,
Live 0xf87ad000

snd_hwdep 13276 1 snd_hda_codec, Live 0xf859e000

snd_pcm 96053 4 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0xf87de000

snd_seq_midi 13132 0 - Live 0xf85b5000

snd_seq_midi_event 14475 1 snd_seq_midi, Live 0xf85a6000

snd_rawmidi 25198 1 snd_seq_midi, Live 0xf85f5000

snd_seq 55716 2 snd_seq_midi,snd_seq_midi_event, Live 0xf85bf000

snd_seq_device 14137 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8599000

intel_rapl 18676 0 - Live 0xf87d8000

dm_multipath 22754 0 - Live 0xf87cd000

x86_pkg_temp_thermal 13901 0 - Live 0xf8594000

snd_timer 28971 2 snd_pcm,snd_seq, Live 0xf84ec000

usbhid 47406 0 - Live 0xf8697000

hid 87718 2 hid_generic,usbhid, Live 0xf8668000

intel_powerclamp 18539 0 - Live 0xf8638000

scsi_dh 14449 1 dm_multipath, Live 0xf8558000

snd 61456 27 snd_hda_codec_hdmi,snd_hda_codec_via,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0xf8622000

kvm_intel 138023 0 - Live 0xf8571000

btusb 27686 0 - Live 0xf861a000

kvm 404104 1 kvm_intel, Live 0xf8701000

crc32_pclmul 13006 0 - Live 0xf84e3000

bcma 46628 3 brcmsmac,b43, Live 0xf8511000

parport_pc 32114 0 - Live 0xf8497000

soundcore 12600 1 snd, Live 0xf84de000

ppdev 17423 0 - Live 0xf850b000

rfcomm 59012 12 - Live 0xf8561000

psmouse 97104 0 - Live 0xf864f000

r8169 62856 0 - Live 0xf863e000

rtsx_pci 44147 2 rtsx_pci_ms,rtsx_pci_sdmmc, Live 0xf84ff000

bnep 19107 2 - Live 0xf84f5000

mii 13693 1 r8169, Live 0xf85ab000

lpc_ich 16987 0 - Live 0xf8552000

serio_raw 13230 0 - Live 0xf848c000

bluetooth 371682 22 btusb,rfcomm,bnep, Live 0xf86a5000

6lowpan_iphc 18480 1 bluetooth, Live 0xf8526000

tpm_infineon 16992 0 - Live 0xf8491000

mei_me 13992 0 - Live 0xf84d1000

mei 71466 1 mei_me, Live 0xf8533000

mac_hid 13077 0 - Live 0xf842c000

intel_smartconnect 12555 0 - Live 0xf852e000

coretemp 13384 0 - Live 0xf84d9000

lp 13359 0 - Live 0xf84a0000

binfmt_misc 13172 1 - Live 0xf8483000

parport 40945 3 parport_pc,ppdev,lp, Live 0xf87ff000

i915 737788 3 - Live 0xf8a29000

microcode 19509 0 - Live 0xf889d000

i2c_algo_bit 13316 1 i915, Live 0xf88b5000

drm_kms_helper 47293 1 i915, Live 0xf8451000

ahci 29802 1 - Live 0xf8474000

drm 249035 4 i915,drm_kms_helper, Live 0xf88e2000

libahci 30899 1 ahci, Live 0xf846b000

wmi 18827 0 - Live 0xf8461000

video 19283 1 i915, Live 0xf8438000


Drivers/Hardware:

Ioports:

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

03c0-03df : vesafb

0400-0403 : ACPI PM1a_EVT_BLK

0404-0405 : ACPI PM1a_CNT_BLK

0408-040b : ACPI PM_TMR

0410-0415 : ACPI CPU throttle

0420-042f : ACPI GPE0_BLK

0430-0433 : iTCO_wdt

0450-0450 : ACPI PM2_CNT_BLK

0454-0457 : pnp 00:06

0458-047f : pnp 00:04

0460-047f : iTCO_wdt

04d0-04d1 : pnp 00:09

0500-057f : pnp 00:04

0680-069f : pnp 00:04

0cf8-0cff : PCI conf1

0d00-ffff : PCI Bus 0000:00

1000-100f : pnp 00:04

164e-164f : pnp 00:04

3322-3323 : pnp 00:04

e000-efff : PCI Bus 0000:03

e000-e0ff : 0000:03:00.2

e000-e0ff : r8169

f000-f03f : 0000:00:02.0

f040-f05f : 0000:00:1f.3

f060-f07f : 0000:00:1f.2

f060-f07f : ahci

f080-f083 : 0000:00:1f.2

f080-f083 : ahci

f090-f097 : 0000:00:1f.2

f090-f097 : ahci

f0a0-f0a3 : 0000:00:1f.2

f0a0-f0a3 : ahci

f0b0-f0b7 : 0000:00:1f.2

f0b0-f0b7 : ahci

ffff-ffff : pnp 00:04

ffff-ffff : pnp 00:04


Iomem:

00000000-00000fff : reserved

00001000-0009d7ff : System RAM

0009d800-0009ffff : reserved

000a0000-000bffff : PCI Bus 0000:00

000a0000-000bffff : Video RAM area

000c0000-000cefff : Video ROM

000cf000-000cffff : Adapter ROM

000d0000-000d3fff : PCI Bus 0000:00

000d4000-000d7fff : PCI Bus 0000:00

000d8000-000dbfff : PCI Bus 0000:00

000dc000-000dffff : PCI Bus 0000:00

000e0000-000fffff : reserved

000e0000-000e3fff : PCI Bus 0000:00

000e4000-000e7fff : PCI Bus 0000:00

000f0000-000fffff : System ROM

00100000-1fffffff : System RAM

01000000-016912e5 : Kernel code

016912e6-01a08b3f : Kernel data

01aef000-01bd3fff : Kernel bss

20000000-201fffff : reserved

20000000-201fffff : pnp 00:0c

20200000-40003fff : System RAM

40004000-40004fff : reserved

40004000-40004fff : pnp 00:0c

40005000-d9861fff : System RAM

d9862000-d9f5ffff : reserved

d9f60000-d9feafff : System RAM

d9feb000-da087fff : ACPI Non-volatile Storage

da088000-da6b6fff : reserved

da6b7000-da6b7fff : System RAM

da6b8000-da6fafff : ACPI Non-volatile Storage

da6fb000-dadb0fff : System RAM

dadb1000-daff2fff : reserved

daff3000-daffffff : System RAM

db000000-db7fffff : RAM buffer

db800000-df9fffff : reserved

dba00000-df9fffff : Graphics Stolen Memory

dfa00000-feafffff : PCI Bus 0000:00

dfa00000-dfa00fff : pnp 00:0b

e0000000-efffffff : 0000:00:02.0

f0000000-f00fffff : PCI Bus 0000:03

f0000000-f0003fff : 0000:03:00.2

f0000000-f0003fff : r8169

f0004000-f0004fff : 0000:03:00.2

f0004000-f0004fff : r8169

f7800000-f7bfffff : 0000:00:02.0

f7c00000-f7cfffff : PCI Bus 0000:03

f7c00000-f7c0ffff : 0000:03:00.0

f7c00000-f7c0ffff : rtsx_pci

f7d00000-f7dfffff : PCI Bus 0000:02

f7d00000-f7d03fff : 0000:02:00.0

f7d00000-f7d03fff : bcma-pci-bridge

f7e00000-f7e0ffff : 0000:00:14.0

f7e00000-f7e0ffff : xhci_hcd

f7e10000-f7e13fff : 0000:00:1b.0

f7e10000-f7e13fff : ICH HD audio

f7e15000-f7e150ff : 0000:00:1f.3

f7e16000-f7e167ff : 0000:00:1f.2

f7e16000-f7e167ff : ahci

f7e17000-f7e173ff : 0000:00:1d.0

f7e17000-f7e173ff : ehci_hcd

f7e18000-f7e183ff : 0000:00:1a.0

f7e18000-f7e183ff : ehci_hcd

f7e1a000-f7e1a00f : 0000:00:16.0

f7e1a000-f7e1a00f : mei_me

f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]

f8000000-fbffffff : reserved

f8000000-fbffffff : pnp 00:0b

fec00000-fec00fff : reserved

fec00000-fec003ff : IOAPIC 0

fed00000-fed03fff : reserved

fed00000-fed003ff : HPET 0

fed10000-fed17fff : pnp 00:0b

fed18000-fed18fff : pnp 00:0b

fed19000-fed19fff : pnp 00:0b

fed1c000-fed1ffff : reserved

fed1c000-fed1ffff : pnp 00:0b

fed1f410-fed1f414 : iTCO_wdt

fed20000-fed3ffff : pnp 00:0b

fed40000-fed44fff : pnp 00:00

fed45000-fed8ffff : pnp 00:0b

fed90000-fed93fff : pnp 00:0b

fee00000-fee00fff : Local APIC

fee00000-fee00fff : reserved

ff000000-ffffffff : reserved

ff000000-ffffffff : pnp 00:0b

100000000-11f5fffff : System RAM

11f600000-11fffffff : RAM buffer


PCI info:

00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
Controller (rev 09)

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-

Latency: 0

Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0

Interrupt: pin A routed to IRQ 42

Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=4M]

Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]

Region 4: I/O ports at f000 [size=64]

Expansion ROM at <unassigned> [disabled]

Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-

Address: fee0f00c Data: 41a1

Capabilities: [d0] Power Management version 2

Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [a4] PCI Advanced Features

AFCap: TP+ FLR+

AFCtrl: FLR-

AFStatus: TP-

Kernel driver in use: i915

00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0

Interrupt: pin A routed to IRQ 40

Region 0: Memory at f7e00000 (64-bit, non-prefetchable) [size=64K]

Capabilities: [70] Power Management version 2

Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+

Address: 00000000fee0f00c Data: 4181

Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 7 Series/C210
Series Chipset Family MEI Controller #1 (rev 04)

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0

Interrupt: pin A routed to IRQ 43

Region 0: Memory at f7e1a000 (64-bit, non-prefetchable) [size=16]

Capabilities: [50] Power Management version 3

Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+

Address: 00000000fee0f00c Data: 41b1

Kernel driver in use: mei_me

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0

Interrupt: pin A routed to IRQ 16

Region 0: Memory at f7e18000 (32-bit, non-prefetchable) [size=1K]

Capabilities: [50] Power Management version 2

Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [58] Debug port: BAR=1 offset=00a0

Capabilities: [98] PCI Advanced Features

AFCap: TP+ FLR+

AFCtrl: FLR-

AFStatus: TP-

Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes

Interrupt: pin A routed to IRQ 46

Region 0: Memory at f7e10000 (64-bit, non-prefetchable) [size=16K]

Capabilities: [50] Power Management version 2

Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+

Address: 00000000fee0f00c Data: 4122

Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0

ExtTag- RBE-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-

MaxPayload 128 bytes, MaxReadReq 128 bytes

DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-

Capabilities: [100 v1] Virtual Channel

Caps: LPEVC=0 RefClk=100ns PATEntryBits=1

Arb: Fixed- WRR32- WRR64- WRR128-

Ctrl: ArbSelect=Fixed

Status: InProgress-

VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-

Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-

Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01

Status: NegoPending- InProgress-

VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-

Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-

Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=22

Status: NegoPending- InProgress-

Capabilities: [130 v1] Root Complex Link

Desc: PortNumber=0f ComponentID=00 EltType=Config

Link0: Desc: TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+

Addr: 00000000fed1c000

Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes

Bus: primary=00, secondary=01, subordinate=01, sec-latency=0

I/O behind bridge: 0000f000-00000fff

Memory behind bridge: fff00000-000fffff

Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-

BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-

PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0

ExtTag- RBE+

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-

MaxPayload 128 bytes, MaxReadReq 128 bytes

DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-

LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<1us, L1 <16us

ClockPM- Surprise- LLActRep+ BwNot-

LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-

Slot #0, PowerLimit 10.000W; Interlock- NoCompl+

SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-

Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-

SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-

Changed: MRL- PresDet- LinkState-

RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-

RootSta: PME ReqID 0000, PMEStatus- PMEPending-

DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-

LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB

LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-

EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-

Address: 00000000 Data: 0000

Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 0240

Capabilities: [a0] Power Management version 2

Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 3 (rev c4) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes

Bus: primary=00, secondary=02, subordinate=02, sec-latency=0

I/O behind bridge: 0000f000-00000fff

Memory behind bridge: f7d00000-f7dfffff

Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-

BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-

PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0

ExtTag- RBE+

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-

MaxPayload 128 bytes, MaxReadReq 128 bytes

DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-

LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <16us

ClockPM- Surprise- LLActRep+ BwNot-

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-

SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-

Slot #2, PowerLimit 10.000W; Interlock- NoCompl+

SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-

Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-

SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-

Changed: MRL- PresDet- LinkState-

RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-

RootSta: PME ReqID 0000, PMEStatus- PMEPending-

DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-

LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB

LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-

EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-

Address: 00000000 Data: 0000

Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 0240

Capabilities: [a0] Power Management version 2

Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 4 (rev c4) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes

Bus: primary=00, secondary=03, subordinate=03, sec-latency=0

I/O behind bridge: 0000e000-0000efff

Memory behind bridge: f7c00000-f7cfffff

Prefetchable memory behind bridge: 00000000f0000000-00000000f00fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-

BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-

PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0

ExtTag- RBE+

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-

MaxPayload 128 bytes, MaxReadReq 128 bytes

DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-

LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <16us

ClockPM- Surprise- LLActRep+ BwNot-

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-

SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-

Slot #3, PowerLimit 10.000W; Interlock- NoCompl+

SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-

Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-

SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-

Changed: MRL- PresDet- LinkState-

RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-

RootSta: PME ReqID 0000, PMEStatus- PMEPending-

DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-

LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB

LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-

EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-

Address: 00000000 Data: 0000

Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 0240

Capabilities: [a0] Power Management version 2

Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0

Interrupt: pin A routed to IRQ 23

Region 0: Memory at f7e17000 (32-bit, non-prefetchable) [size=1K]

Capabilities: [50] Power Management version 2

Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [58] Debug port: BAR=1 offset=00a0

Capabilities: [98] PCI Advanced Features

AFCap: TP+ FLR+

AFCtrl: FLR-

AFStatus: TP-

Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC
Controller (rev 04)

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0

Capabilities: [e0] Vendor Specific Information: Len=0c <?>

Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0

Interrupt: pin B routed to IRQ 41

Region 0: I/O ports at f0b0 [size=8]

Region 1: I/O ports at f0a0 [size=4]

Region 2: I/O ports at f090 [size=8]

Region 3: I/O ports at f080 [size=4]

Region 4: I/O ports at f060 [size=32]

Region 5: Memory at f7e16000 (32-bit, non-prefetchable) [size=2K]

Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-

Address: fee0500c Data: 4191

Capabilities: [70] Power Management version 3

Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)

Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004

Capabilities: [b0] PCI Advanced Features

AFCap: TP+ FLR+

AFCtrl: FLR-

AFStatus: TP-

Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
SMBus Controller (rev 04)

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Interrupt: pin C routed to IRQ 3

Region 0: Memory at f7e15000 (64-bit, non-prefetchable) [size=256]

Region 4: I/O ports at f040 [size=32]

02:00.0 Network controller: Broadcom Corporation BCM4313 802.11bgn
Wireless Network Adapter (rev 01)

Subsystem: Askey Computer Corp. Device 7179

Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes

Interrupt: pin A routed to IRQ 18

Region 0: Memory at f7d00000 (64-bit, non-prefetchable) [size=16K]

Capabilities: [40] Power Management version 3

Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-

Capabilities: [58] Vendor Specific Information: Len=78 <?>

Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+

Address: 0000000000000000 Data: 0000

Capabilities: [d0] Express (v1) Endpoint, MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited

ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-

MaxPayload 128 bytes, MaxReadReq 128 bytes

DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-

LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <4us, L1 <64us

ClockPM+ Surprise- LLActRep+ BwNot-

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-

Capabilities: [100 v1] Advanced Error Reporting

UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-

CESta: RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-

Capabilities: [13c v1] Virtual Channel

Caps: LPEVC=0 RefClk=100ns PATEntryBits=1

Arb: Fixed- WRR32- WRR64- WRR128-

Ctrl: ArbSelect=Fixed

Status: InProgress-

VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-

Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-

Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01

Status: NegoPending- InProgress-

Capabilities: [160 v1] Device Serial Number 00-00-df-ff-ff-c0-e8-39

Capabilities: [16c v1] Power Budgeting <?>

Kernel driver in use: bcma-pci-bridge

03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
Device 5289 (rev 01)

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes

Interrupt: pin B routed to IRQ 45

Region 0: Memory at f7c00000 (32-bit, non-prefetchable) [size=64K]

Capabilities: [40] Power Management version 3

Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+

Address: 00000000fee0f00c Data: 41d1

Capabilities: [70] Express (v2) Endpoint, MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us

ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-

MaxPayload 128 bytes, MaxReadReq 512 bytes

DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-

LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s unlimited, L1 <64us

ClockPM+ Surprise- LLActRep- BwNot-

LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk-

ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled

LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB

LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-

EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [b0] MSI-X: Enable- Count=1 Masked-

Vector table: BAR=0 offset=00000000

PBA: BAR=0 offset=00000000

Capabilities: [d0] Vital Product Data

pcilib: sysfs_read_vpd: read failed: Connection timed out

Not readable

Capabilities: [100 v1] Advanced Error Reporting

UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-

CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-

Capabilities: [140 v1] Virtual Channel

Caps: LPEVC=0 RefClk=100ns PATEntryBits=1

Arb: Fixed- WRR32- WRR64- WRR128-

Ctrl: ArbSelect=Fixed

Status: InProgress-

VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-

Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-

Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01

Status: NegoPending- InProgress-

Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00

Kernel driver in use: rtsx_pci

03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0a)

Subsystem: CLEVO/KAPOK Computer Device 0240

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes

Interrupt: pin A routed to IRQ 44

Region 0: I/O ports at e000 [size=256]

Region 2: Memory at f0004000 (64-bit, prefetchable) [size=4K]

Region 4: Memory at f0000000 (64-bit, prefetchable) [size=16K]

Capabilities: [40] Power Management version 3

Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)

Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+

Address: 00000000fee0f00c Data: 41c1

Capabilities: [70] Express (v2) Endpoint, MSI 01

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us

ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-

MaxPayload 128 bytes, MaxReadReq 4096 bytes

DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-

LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s unlimited, L1 <64us

ClockPM+ Surprise- LLActRep- BwNot-

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled

LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-

EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [b0] MSI-X: Enable- Count=4 Masked-

Vector table: BAR=4 offset=00000000

PBA: BAR=4 offset=00000800

Capabilities: [d0] Vital Product Data

Unknown small resource type 00, will not decode more.

Capabilities: [100 v1] Advanced Error Reporting

UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-

CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-

Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00

Kernel driver in use: r8169


SCSI:
Attached devices:

Host: scsi0 Channel: 00 Id: 00 Lun: 00

Vendor: ATA Model: OCZ-VERTEX3 Rev: 2.25

Type: Direct-Access ANSI SCSI revision: 05



Link to launchpad bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1281660
