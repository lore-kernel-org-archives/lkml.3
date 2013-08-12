Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3HLUri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:47:38 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:41368 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3HLUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:47:37 -0400
MIME-Version: 1.0
Date: Mon, 12 Aug 2013 23:47:36 +0300
Message-ID: <CAMWSX=awEh4iNPX-mbfu8sp4w-Wis4YR-MQg3aGK6w=F9WqYmQ@mail.gmail.com>
Subject: "PROBLEM: Crashes"
From: Alex Calinoiu <calinoiualex@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The system seems to crash after I try to lseek /dev/watchdog and
/dev/watchdog0 as root. As a regular user, the problem does not occur.

Crash, kernel panic.

[root@arch ~]# cat /proc/version
Linux version 3.10.6-1-ARCH (tobias@T-POWA-LX) (gcc version 4.8.1
20130725 (prerelease) (GCC) ) #1 SMP PREEMPT Mon Aug 12 07:55:48 CEST
2013


This is the code that reproduces the problem. The parameters should be
/dev/watchdog or /dev/watchdog0:

#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int fd;
    if (argc != 2)
    {
    printf ("2 argumente!\n");
    exit (EXIT_FAILURE);
    }
    fd = open (argv[1],O_RDONLY);
    lseek (fd,0,SEEK_END);
    return 0;
}


[root@arch ~]$ uname -a
Linux arch 3.10.6-1-ARCH #1 SMP PREEMPT Mon Aug 12 07:55:48 CEST 2013
x86_64 GNU/Linux



[root@arch ~]# cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 42
model name    : Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz
stepping    : 7
microcode    : 0x14
cpu MHz        : 1012.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
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
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips    : 4591.18
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 42
model name    : Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz
stepping    : 7
microcode    : 0x14
cpu MHz        : 2070.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips    : 4591.18
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 42
model name    : Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz
stepping    : 7
microcode    : 0x14
cpu MHz        : 1978.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips    : 4591.18
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 42
model name    : Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz
stepping    : 7
microcode    : 0x14
cpu MHz        : 1840.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 2
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips    : 4591.18
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:



[root@arch ~]# cat /proc/modules
vhost_net 27076 1 - Live 0xffffffffa05f2000
macvtap 10322 1 vhost_net, Live 0xffffffffa0508000
macvlan 9336 1 macvtap, Live 0xffffffffa04dc000
tun 19528 3 vhost_net, Live 0xffffffffa04a5000
ipt_MASQUERADE 2154 3 - Live 0xffffffffa047e000
iptable_nat 3358 1 - Live 0xffffffffa0477000
nf_nat_ipv4 3568 1 iptable_nat, Live 0xffffffffa0424000
nf_nat 14964 3 ipt_MASQUERADE,iptable_nat,nf_nat_ipv4, Live 0xffffffffa046a000
nf_conntrack_ipv4 9262 2 - Live 0xffffffffa041d000
nf_defrag_ipv4 1371 1 nf_conntrack_ipv4, Live 0xffffffffa0403000
xt_conntrack 3265 1 - Live 0xffffffffa03fa000
nf_conntrack 71841 6
ipt_MASQUERADE,iptable_nat,nf_nat_ipv4,nf_nat,nf_conntrack_ipv4,xt_conntrack,
Live 0xffffffffa04b2000
ipt_REJECT 2313 2 - Live 0xffffffffa03ef000
xt_CHECKSUM 1231 1 - Live 0xffffffffa03e6000
iptable_mangle 1584 1 - Live 0xffffffffa03d1000
xt_tcpudp 3143 5 - Live 0xffffffffa037c000
bridge 92995 0 - Live 0xffffffffa042f000
stp 1621 1 bridge, Live 0xffffffffa0327000
llc 3729 2 bridge,stp, Live 0xffffffffa0323000
ip6table_filter 1428 0 - Live 0xffffffffa02a7000
ip6_tables 17056 1 ip6table_filter, Live 0xffffffffa03c1000
iptable_filter 1488 1 - Live 0xffffffffa019f000
ip_tables 17282 3 iptable_nat,iptable_mangle,iptable_filter, Live
0xffffffffa03bb000
x_tables 17351 10
ipt_MASQUERADE,xt_conntrack,ipt_REJECT,xt_CHECKSUM,iptable_mangle,xt_tcpudp,ip6table_filter,ip6_tables,iptable_filter,ip_tables,
Live 0xffffffffa03a2000
bbswitch 6182 0 - Live 0xffffffffa02f4000 (O)
snd_hda_codec_hdmi 29701 4 - Live 0xffffffffa038e000
snd_hda_codec_idt 37944 1 - Live 0xffffffffa0364000
joydev 9663 0 - Live 0xffffffffa030e000
arc4 2000 2 - Live 0xffffffffa0045000
iwldvm 171906 0 - Live 0xffffffffa0b90000
intel_powerclamp 8802 0 - Live 0xffffffffa0291000
coretemp 6038 0 - Live 0xffffffffa0211000
kvm_intel 128977 6 - Live 0xffffffffa0b0c000
mac80211 455011 1 iwldvm, Live 0xffffffffa0a76000
iwlwifi 136611 1 iwldvm, Live 0xffffffffa06ce000
kvm 376394 1 kvm_intel, Live 0xffffffffa07f5000
btusb 18496 0 - Live 0xffffffffa01d7000
r8169 57672 0 - Live 0xffffffffa01c2000
bluetooth 308366 2 btusb, Live 0xffffffffa0122000
iTCO_wdt 5407 0 - Live 0xffffffffa011d000
microcode 13172 0 - Live 0xffffffffa00ce000
dell_wmi 1485 0 - Live 0xffffffffa0017000
snd_hda_intel 35309 5 - Live 0xffffffffa00b8000
sparse_keymap 3114 1 dell_wmi, Live 0xffffffffa0013000
i915 572259 3 - Live 0xffffffffa06fc000
iTCO_vendor_support 1929 1 iTCO_wdt, Live 0xffffffffa06f8000
snd_hda_codec 147506 3
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel, Live
0xffffffffa0688000
intel_agp 10872 1 i915, Live 0xffffffffa0681000
dell_laptop 8851 0 - Live 0xffffffffa067a000
mxm_wmi 1467 0 - Live 0xffffffffa0676000
intel_gtt 12664 2 i915,intel_agp, Live 0xffffffffa066e000
dcdbas 6487 1 dell_laptop, Live 0xffffffffa0668000
ttm 65388 0 - Live 0xffffffffa064d000
drm_kms_helper 35438 1 i915, Live 0xffffffffa062d000
mii 4027 1 r8169, Live 0xffffffffa0629000
uvcvideo 72761 0 - Live 0xffffffffa0611000
snd_hwdep 6332 1 snd_hda_codec, Live 0xffffffffa060b000
drm 231168 5 i915,ttm,drm_kms_helper, Live 0xffffffffa05b8000
videobuf2_vmalloc 3272 1 uvcvideo, Live 0xffffffffa05b4000
videobuf2_memops 2335 1 videobuf2_vmalloc, Live 0xffffffffa05b0000
videobuf2_core 27797 1 uvcvideo, Live 0xffffffffa05a4000
cfg80211 406112 3 iwldvm,mac80211,iwlwifi, Live 0xffffffffa0513000
videodev 105373 2 uvcvideo,videobuf2_core, Live 0xffffffffa04ed000
evdev 9880 17 - Live 0xffffffffa04e6000
snd_pcm 77765 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0xffffffffa04c8000
rfkill 15666 4 bluetooth,cfg80211, Live 0xffffffffa04ad000
psmouse 85132 0 - Live 0xffffffffa048f000
pcspkr 2027 0 - Live 0xffffffffa048b000
media 10916 2 uvcvideo,videodev, Live 0xffffffffa0483000
serio_raw 5041 0 - Live 0xffffffffa0479000
ac 3324 0 - Live 0xffffffffa0475000
snd_page_alloc 7234 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0447000
shpchp 25489 0 - Live 0xffffffffa0427000
thermal 8620 0 - Live 0xffffffffa0419000
battery 6925 0 - Live 0xffffffffa0413000
wmi 8283 2 dell_wmi,mxm_wmi, Live 0xffffffffa0405000
lpc_ich 12849 0 - Live 0xffffffffa03fc000
snd_timer 18718 1 snd_pcm, Live 0xffffffffa03f2000
mei_me 9688 0 - Live 0xffffffffa03eb000
mei 61444 1 mei_me, Live 0xffffffffa03d3000
i2c_algo_bit 5391 1 i915, Live 0xffffffffa03ce000
i2c_i801 11237 0 - Live 0xffffffffa03c7000
video 11328 1 i915, Live 0xffffffffa03b7000
button 4669 1 i915, Live 0xffffffffa03b1000
i2c_core 23720 6
i915,drm_kms_helper,drm,videodev,i2c_algo_bit,i2c_i801, Live
0xffffffffa0397000
snd 58950 17 snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xffffffffa037e000
mperf 1267 0 - Live 0xffffffffa037a000
soundcore 5418 1 snd, Live 0xffffffffa0374000
processor 27755 0 - Live 0xffffffffa0333000
xts 3007 1 - Live 0xffffffffa032f000
gf128mul 5858 1 xts, Live 0xffffffffa0329000
hid_generic 1153 0 - Live 0xffffffffa0325000
usbhid 41466 0 - Live 0xffffffffa0314000
hid 88502 2 hid_generic,usbhid, Live 0xffffffffa02f7000
dm_crypt 15239 1 - Live 0xffffffffa02ef000
sr_mod 14898 0 - Live 0xffffffffa02e7000
sd_mod 30730 3 - Live 0xffffffffa02da000
cdrom 34848 1 sr_mod, Live 0xffffffffa02cc000
ahci 22792 2 - Live 0xffffffffa02c0000
libahci 21169 1 ahci, Live 0xffffffffa02b5000
crc32_pclmul 3019 0 - Live 0xffffffffa02a9000
crc32c_intel 14249 0 - Live 0xffffffffa0289000
ghash_clmulni_intel 4501 0 - Live 0xffffffffa0275000
cryptd 8473 1 ghash_clmulni_intel, Live 0xffffffffa0260000
ehci_pci 4120 0 - Live 0xffffffffa0256000
libata 171016 2 ahci,libahci, Live 0xffffffffa0215000
xhci_hcd 89455 0 - Live 0xffffffffa01f4000
ehci_hcd 47640 1 ehci_pci, Live 0xffffffffa01e2000
scsi_mod 127740 3 sr_mod,sd_mod,libata, Live 0xffffffffa01a1000
usbcore 177151 6 btusb,uvcvideo,usbhid,ehci_pci,xhci_hcd,ehci_hcd,
Live 0xffffffffa00de000
usb_common 1648 1 usbcore, Live 0xffffffffa00da000
ext4 456123 2 - Live 0xffffffffa0047000
crc16 1359 2 bluetooth,ext4, Live 0xffffffffa0043000
mbcache 5866 1 ext4, Live 0xffffffffa003d000
jbd2 81946 1 ext4, Live 0xffffffffa001c000
dm_mod 72431 3 dm_crypt, Live 0xffffffffa0000000



[root@arch ~]# cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vga+
  0400-0453 : pnp 00:03
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0430-0433 : iTCO_wdt
      0430-0433 : iTCO_wdt
    0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:05
  0458-047f : pnp 00:03
    0460-047f : iTCO_wdt
      0460-047f : iTCO_wdt
  04d0-04d1 : pnp 00:07
  0500-057f : pnp 00:03
  0680-069f : pnp 00:03
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-100f : pnp 00:03
  164e-164f : pnp 00:03
  b000-cfff : PCI Bus 0000:11
  d000-dfff : PCI Bus 0000:05
    d000-d0ff : 0000:05:00.0
      d000-d0ff : r8169
  e000-efff : PCI Bus 0000:01
    e000-e07f : 0000:01:00.0
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
  ffff-ffff : pnp 00:03
    ffff-ffff : pnp 00:03



[root@arch ~]# cat /proc/iomem
00000000-00000fff : reserved
00001000-0009d3ff : System RAM
0009d400-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cedff : Video ROM
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
  01000000-014d3842 : Kernel code
  014d3843-018c213f : Kernel data
  019e3000-01b21fff : Kernel bss
20000000-201fffff : reserved
  20000000-201fffff : pnp 00:0b
20200000-3fffffff : System RAM
40000000-401fffff : reserved
  40000000-401fffff : pnp 00:0b
40200000-ca4e3fff : System RAM
ca4e4000-ca526fff : ACPI Non-volatile Storage
ca527000-ca791fff : System RAM
ca792000-ca966fff : reserved
ca967000-caba6fff : System RAM
caba7000-cad67fff : reserved
cad68000-cafacfff : ACPI Non-volatile Storage
cafad000-cafbafff : ACPI Tables
cafbb000-cafe7fff : ACPI Non-volatile Storage
cafe8000-caffffff : ACPI Tables
cb000000-cb7fffff : RAM buffer
cb800000-cf9fffff : reserved
cfa00000-feafffff : PCI Bus 0000:00
  cfa00000-cfa00fff : pnp 00:0a
  d0000000-dfffffff : 0000:00:02.0
  e0000000-f1ffffff : PCI Bus 0000:01
    e0000000-efffffff : 0000:01:00.0
    f0000000-f1ffffff : 0000:01:00.0
  f2100000-f31fffff : PCI Bus 0000:11
  f3200000-f32fffff : PCI Bus 0000:05
    f3200000-f3203fff : 0000:05:00.0
      f3200000-f3203fff : r8169
    f3204000-f3204fff : 0000:05:00.0
      f3204000-f3204fff : r8169
  f5000000-f60fffff : PCI Bus 0000:01
    f5000000-f5ffffff : 0000:01:00.0
    f6000000-f607ffff : 0000:01:00.0
    f6080000-f6083fff : 0000:01:00.1
      f6080000-f6083fff : ICH HD audio
  f6400000-f67fffff : 0000:00:02.0
  f6800000-f78fffff : PCI Bus 0000:11
  f7900000-f79fffff : PCI Bus 0000:0b
    f7900000-f7901fff : 0000:0b:00.0
      f7900000-f7901fff : xhci_hcd
  f7a00000-f7afffff : PCI Bus 0000:09
    f7a00000-f7a01fff : 0000:09:00.0
      f7a00000-f7a01fff : iwlwifi
  f7b00000-f7b03fff : 0000:00:1b.0
    f7b00000-f7b03fff : ICH HD audio
  f7b05000-f7b050ff : 0000:00:1f.3
  f7b06000-f7b067ff : 0000:00:1f.2
    f7b06000-f7b067ff : ahci
  f7b07000-f7b073ff : 0000:00:1d.0
    f7b07000-f7b073ff : ehci_hcd
  f7b08000-f7b083ff : 0000:00:1a.0
    f7b08000-f7b083ff : ehci_hcd
  f7b0a000-f7b0a00f : 0000:00:16.0
    f7b0a000-f7b0a00f : mei_me
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:0a
  fe800000-fe802fff : pnp 00:07
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed03fff : reserved
  fed00000-fed003ff : HPET 0
fed10000-fed17fff : pnp 00:0a
fed18000-fed18fff : pnp 00:0a
fed19000-fed19fff : pnp 00:0a
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:0a
    fed1f410-fed1f414 : iTCO_wdt
      fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:0a
fed40000-fed44fff : PCI Bus 0000:00
fed45000-fed8ffff : pnp 00:0a
fed90000-fed93fff : pnp 00:0a
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
  ff000000-ffffffff : pnp 00:0a
100000000-12fdfffff : System RAM
12fe00000-12fffffff : RAM buffer



[root@arch ~]# lspci -vvv
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
Family DRAM Controller (rev 09)
    Subsystem: Dell Device 04b0
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core
Processor Family PCI Express Root Port (rev 09) (prog-if 00 [Normal
decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 0000e000-0000efff
    Memory behind bridge: f5000000-f60fffff
    Prefetchable memory behind bridge: 00000000e0000000-00000000f1ffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [88] Subsystem: Dell Device 04b0
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 4181
    Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #2, Speed 5GT/s, Width x16, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
            ClockPM- Surprise- LLActRep- BwNot+
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled+ Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet+ LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR+,
OBFF Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
            Status:    NegoPending+ InProgress-
    Capabilities: [140 v1] Root Complex Link
        Desc:    PortNumber=02 ComponentID=01 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed19000
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09) (prog-if
00 [VGA controller])
    Subsystem: Dell Device 04ca
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 53
    Region 0: Memory at f6400000 (64-bit, non-prefetchable) [size=4M]
    Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
    Region 4: I/O ports at f000 [size=64]
    Expansion ROM at <unassigned> [disabled]
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 41a2
    Capabilities: [d0] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a4] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: i915
    Kernel modules: i915

00:16.0 Communication controller: Intel Corporation 6 Series/C200
Series Chipset Family MEI Controller #1 (rev 04)
    Subsystem: Dell Device 04b0
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 52
    Region 0: Memory at f7b0a000 (64-bit, non-prefetchable) [size=16]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 4192
    Kernel driver in use: mei_me
    Kernel modules: mei_me

00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
    Subsystem: Dell Device 04b0
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at f7b08000 (32-bit, non-prefetchable) [size=1K]
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
    Kernel modules: ehci_pci

00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
Family High Definition Audio Controller (rev 05)
    Subsystem: Dell Device 04b0
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 56
    Region 0: Memory at f7b00000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 41e2
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE- FLReset+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
        VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=1 ArbSelect=Fixed TC/VC=22
            Status:    NegoPending- InProgress-
    Capabilities: [130 v1] Root Complex Link
        Desc:    PortNumber=0f ComponentID=00 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: snd_hda_intel
    Kernel modules: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 4191
    Capabilities: [90] Subsystem: Dell Device 04b0
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 2 (rev b5) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=05, subordinate=06, sec-latency=0
    I/O behind bridge: 0000d000-0000dfff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000f3200000-00000000f32fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #2, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 41a1
    Capabilities: [90] Subsystem: Dell Device 04b0
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=09, subordinate=0a, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: f7a00000-f7afffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #4, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 41b1
    Capabilities: [90] Subsystem: Dell Device 04b0
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 5 (rev b5) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=0b, subordinate=0c, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: f7900000-f79fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #5, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #4, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet- LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 41c1
    Capabilities: [90] Subsystem: Dell Device 04b0
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1c.7 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 8 (rev b5) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=11, subordinate=1f, sec-latency=0
    I/O behind bridge: 0000b000-0000cfff
    Memory behind bridge: f6800000-f78fffff
    Prefetchable memory behind bridge: 00000000f2100000-00000000f31fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #8, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <16us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF
Not Supported ARIFwd-
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled ARIFwd-
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 41d1
    Capabilities: [90] Subsystem: Dell Device 04b0
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pcieport
    Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
    Subsystem: Dell Device 04b0
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at f7b07000 (32-bit, non-prefetchable) [size=1K]
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
    Kernel modules: ehci_pci

00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC
Controller (rev 05)
    Subsystem: Dell Device 04b0
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>
    Kernel driver in use: lpc_ich
    Kernel modules: lpc_ich

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
Chipset Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI
1.0])
    Subsystem: Dell Device 04b0
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 51
    Region 0: I/O ports at f0b0 [size=8]
    Region 1: I/O ports at f0a0 [size=4]
    Region 2: I/O ports at f090 [size=8]
    Region 3: I/O ports at f080 [size=4]
    Region 4: I/O ports at f060 [size=32]
    Region 5: Memory at f7b06000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0f00c  Data: 4172
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
    Capabilities: [b0] PCI Advanced Features
        AFCap: TP+ FLR+
        AFCtrl: FLR-
        AFStatus: TP-
    Kernel driver in use: ahci
    Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
SMBus Controller (rev 05)
    Subsystem: Dell Device 04b0
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 18
    Region 0: Memory at f7b05000 (64-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at f040 [size=32]
    Kernel modules: i2c_i801

01:00.0 VGA compatible controller: NVIDIA Corporation GF108M [GeForce
GT 525M] (rev ff) (prog-if ff)
    !!! Unknown header type 7f
    Kernel modules: nouveau

01:00.1 Audio device: NVIDIA Corporation GF108 High Definition Audio
Controller (rev ff) (prog-if ff)
    !!! Unknown header type 7f
    Kernel driver in use: snd_hda_intel
    Kernel modules: snd_hda_intel

05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 05)
    Subsystem: Dell Device 04b0
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 54
    Region 0: I/O ports at d000 [size=256]
    Region 2: Memory at f3204000 (64-bit, prefetchable) [size=4K]
    Region 4: Memory at f3200000 (64-bit, prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 41b2
    Capabilities: [70] Express (v2) Endpoint, MSI 01
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 <64us
            ClockPM+ Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
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
        CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
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
    Capabilities: [160 v1] Device Serial Number 01-00-00-00-36-4c-e0-00
    Kernel driver in use: r8169
    Kernel modules: r8169

09:00.0 Network controller: Intel Corporation Centrino Wireless-N 1030
[Rainbow Peak] (rev 34)
    Subsystem: Intel Corporation Centrino Wireless-N 1030 BGN
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 55
    Region 0: Memory at f7a00000 (64-bit, non-prefetchable) [size=8K]
    Capabilities: [c8] Power Management version 3
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0f00c  Data: 41c2
    Capabilities: [e0] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <4us, L1 <32us
            ClockPM+ Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
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
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [140 v1] Device Serial Number ac-72-89-ff-ff-10-4c-3a
    Kernel driver in use: iwlwifi
    Kernel modules: iwlwifi

0b:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host
Controller (rev 04) (prog-if 30 [XHCI])
    Subsystem: Dell Device 04b0
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at f7900000 (64-bit, non-prefetchable) [size=8K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
        Vector table: BAR=0 offset=00001000
        PBA: BAR=0 offset=00001080
    Capabilities: [a0] Express (v2) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <4us, L1 unlimited
            ClockPM+ Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+,
OBFF Not Supported
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
             Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
    Capabilities: [150 v1] Latency Tolerance Reporting
        Max snoop latency: 0ns
        Max no snoop latency: 0ns
    Kernel driver in use: xhci_hcd
    Kernel modules: xhci_hcd



[root@arch ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000BPVT-7 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: MATSHITA Model: DVD+-RW UJ8B1    Rev: D.04
  Type:   CD-ROM                           ANSI  SCSI revision: 05


If you need more details, or you think that the report is incomplete
and/or wrong, please, don't hesitate to contact me.


Thanks,
Alex
