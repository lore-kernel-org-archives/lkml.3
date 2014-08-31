Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaHaP7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 11:59:01 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34681 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHaP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 11:58:58 -0400
MIME-Version: 1.0
Date: Sun, 31 Aug 2014 16:58:57 +0100
Message-ID: <CAK_USRH_wFt-adaedMxTpF2VkfXcU3UtMWURp+Q8LP8Apz5vqQ@mail.gmail.com>
Subject: Samsung SSD 840 PRO Series failed to get NCQ Send/Recv
From: Bruno Saraiva <bk201doesntexist@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been getting a error message related to my SSD for a while now.
Talked to some folks on IRC and we decided it was best to post it
here, since I also have a different SATA controller than the one in
use here (hyperlink: https://lkml.org/lkml/2014/7/16/724). In any
case, be sure to let me know if more info is needed.


[1.] One line summary of the problem:

"Samsung SSD 840 PRO Series failed to get NCQ Send/Recv Log Emask 0x1"

[2.] Full description of the problem/report:

The problem with Samsung SSD 840 Series is reproducible with the
latest 3.16.X and 3.17.X kernel series.


[3.] Keywords:

Samsung, SSD

[4.] Kernel version (from /proc/version):

Linux version 3.16.1-1-ARCH
(nobody@var-lib-archbuild-testing-x86_64-tobias) (gcc version 4.9.1
(GCC) ) #1 SMP PREEMPT Thu Aug 14 07:40:19 CEST 2014

[5.] Output of Oops.. message (if applicable) with symbolic
information resolved (see Documentation/oops-tracing.txt):

$ journalctl -k -b | grep ata3
Aug 31 14:48:40 valhalla kernel: ata3: SATA max UDMA/133 abar
m1024@0xfe5ffc00 port 0xfe5ffd00 irq 19
Aug 31 14:48:40 valhalla kernel: ata3: SATA link up 6.0 Gbps (SStatus
133 SControl 300)
Aug 31 14:48:40 valhalla kernel: ata3.00: failed to get NCQ Send/Recv
Log Emask 0x1
Aug 31 14:48:40 valhalla kernel: ata3.00: ATA-9: Samsung SSD 840 PRO
Series, DXM05B0Q, max UDMA/133
Aug 31 14:48:40 valhalla kernel: ata3.00: 500118192 sectors, multi 16:
LBA48 NCQ (depth 31/32), AA
Aug 31 14:48:40 valhalla kernel: ata3.00: failed to get NCQ Send/Recv
Log Emask 0x1
Aug 31 14:48:40 valhalla kernel: ata3.00: configured for UDMA/133


[6.] A small shell script or example program which triggers the
problem (if possible):

None required, just boot any kernel version since 3.16 (or later) with
refered SSD plugged in.


7.] Environment:

Distro: Arch Linux
Release: N/A

[7.1.] Software (add the output of the ver_linux script here):

Linux valhalla 3.16.1-1-ARCH #1 SMP PREEMPT Thu Aug 14 07:40:19 CEST
2014 x86_64 GNU/Linux

Gnu C                  4.9.1
Gnu make               4.0
binutils               2.24
util-linux             2.25
mount                  debug
module-init-tools      18
e2fsprogs              1.42.11
jfsutils               1.1.15
reiserfsprogs          3.6.24
xfsprogs               3.2.1
pcmciautils            018
Linux C Library        2.19
Dynamic linker (ldd)   2.19
Linux C++ Library      6.0.20
Procps                 3.3.9
Kbd                    2.0.2
Sh-utils               8.23
Modules Loaded         tun mousedev joydev hid_generic usbhid hid
crc32c_generic btrfs xor radeon kvm_amd kvm ext4 ttm r8169 evdev crc16
mbcache mac_hid jbd2 drm_kms_helper
snd_hda_codec_realtek snd_hda_codec_generic microcode edac_core
snd_hda_codec_hdmi psmouse serio_raw pcspkr edac_mce_amd k10temp drm
raid6_pq snd_hda_intel mii snd_hda_controller snd_hda_codec sp5100_tco
snd_hwdep snd_pcm
i2c_piix4 i2c_algo_bit snd_timer i2c_core snd soundcore asus_atk0110
hwmon wmi acpi_cpufreq shpchp processor button f2fs sd_mod ata_generic
pata_acpi crc_t10dif crct10dif_common atkbd libps2
firewire_ohci ohci_pci ehci_pci ohci_hcd ehci_hcd firewire_core
crc_itu_t ahci pata_jmicron libahci libata usbcore usb_common scsi_mod
i8042 serio

[7.2.] Processor information (from /proc/cpuinfo):

processor : 0
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 965 Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr hw_pstate npt lbrv svm_lock nrip_save
bogomips : 6825.87
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 1
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 965 Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 1
cpu cores : 4
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr hw_pstate npt lbrv svm_lock nrip_save
bogomips : 6825.87
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 2
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 965 Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 2
cpu cores : 4
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr hw_pstate npt lbrv svm_lock nrip_save
bogomips : 6825.87
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 3
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 965 Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 3
cpu cores : 4
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr hw_pstate npt lbrv svm_lock nrip_save
bogomips : 6825.87
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate


[7.3.] Module information (from /proc/modules):

tun 26411 2 - Live 0xffffffffa02f6000
mousedev 17272 0 - Live 0xffffffffa02cb000
joydev 17063 0 - Live 0xffffffffa02d5000
hid_generic 12393 0 - Live 0xffffffffa02c6000
usbhid 44507 0 - Live 0xffffffffa031b000
hid 102220 2 hid_generic,usbhid, Live 0xffffffffa039a000
crc32c_generic 12656 1 - Live 0xffffffffa02c1000
btrfs 894702 1 - Live 0xffffffffa04f8000
xor 21040 1 btrfs, Live 0xffffffffa02ac000
radeon 1376042 2 - Live 0xffffffffa06b2000
kvm_amd 59131 0 - Live 0xffffffffa038a000
kvm 413027 1 kvm_amd, Live 0xffffffffa0492000
ext4 497695 1 - Live 0xffffffffa03da000
ttm 73743 1 radeon, Live 0xffffffffa03c6000
r8169 68119 0 - Live 0xffffffffa03b4000
evdev 21544 7 - Live 0xffffffffa0356000
crc16 12343 1 ext4, Live 0xffffffffa02b4000
mbcache 17171 1 ext4, Live 0xffffffffa02a6000
mac_hid 12633 0 - Live 0xffffffffa033a000
jbd2 86460 1 ext4, Live 0xffffffffa0373000
drm_kms_helper 49262 1 radeon, Live 0xffffffffa035d000
snd_hda_codec_realtek 67127 1 - Live 0xffffffffa0344000
snd_hda_codec_generic 63126 1 snd_hda_codec_realtek, Live 0xffffffffa0329000
microcode 22061 0 - Live 0xffffffffa029f000
edac_core 51366 0 - Live 0xffffffffa030d000
snd_hda_codec_hdmi 45117 1 - Live 0xffffffffa0300000
psmouse 102792 0 - Live 0xffffffffa02db000
serio_raw 12849 0 - Live 0xffffffffa022a000
pcspkr 12595 0 - Live 0xffffffffa0217000
edac_mce_amd 21166 0 - Live 0xffffffffa0210000
k10temp 12618 0 - Live 0xffffffffa02bc000
drm 258005 5 radeon,ttm,drm_kms_helper, Live 0xffffffffa025f000
raid6_pq 99334 1 btrfs, Live 0xffffffffa0245000
snd_hda_intel 26327 0 - Live 0xffffffffa0222000
mii 12675 1 r8169, Live 0xffffffffa021d000
snd_hda_controller 26727 1 snd_hda_intel, Live 0xffffffffa0125000
snd_hda_codec 108552 5
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,
Live 0xffffffffa01f4000
sp5100_tco 12864 0 - Live 0xffffffffa0145000
snd_hwdep 17244 1 snd_hda_codec, Live 0xffffffffa011f000
snd_pcm 88487 4
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec,
Live 0xffffffffa01d9000
i2c_piix4 20857 0 - Live 0xffffffffa00d4000
i2c_algo_bit 12744 1 radeon, Live 0xffffffffa00e1000
snd_timer 26614 1 snd_pcm, Live 0xffffffffa013d000
i2c_core 50152 5 radeon,drm_kms_helper,drm,i2c_piix4,i2c_algo_bit,
Live 0xffffffffa01cb000
snd 69340 8 snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xffffffffa01b9000
soundcore 13031 2 snd_hda_codec,snd, Live 0xffffffffa00a4000
asus_atk0110 17209 0 - Live 0xffffffffa00ce000
hwmon 12930 3 radeon,k10temp,asus_atk0110, Live 0xffffffffa0076000
wmi 17339 0 - Live 0xffffffffa012d000
acpi_cpufreq 17218 1 - Live 0xffffffffa0080000
shpchp 35210 0 - Live 0xffffffffa0133000
processor 27777 1 acpi_cpufreq, Live 0xffffffffa008f000
button 12909 0 - Live 0xffffffffa002d000
f2fs 190871 1 - Live 0xffffffffa0178000
sd_mod 44356 7 - Live 0xffffffffa00ba000
ata_generic 12490 0 - Live 0xffffffffa0097000
pata_acpi 12771 0 - Live 0xffffffffa008a000
crc_t10dif 12431 1 sd_mod, Live 0xffffffffa001e000
crct10dif_common 12356 1 crc_t10dif, Live 0xffffffffa007b000
atkbd 22254 0 - Live 0xffffffffa0118000
libps2 12739 2 psmouse,atkbd, Live 0xffffffffa009f000
firewire_ohci 43373 0 - Live 0xffffffffa005c000
ohci_pci 12808 0 - Live 0xffffffffa0019000
ehci_pci 12512 0 - Live 0xffffffffa0010000
ohci_hcd 42990 1 ohci_pci, Live 0xffffffffa006a000
ehci_hcd 69939 1 ehci_pci, Live 0xffffffffa0232000
firewire_core 56700 1 firewire_ohci, Live 0xffffffffa01aa000
crc_itu_t 12347 1 firewire_core, Live 0xffffffffa00c9000
ahci 29195 6 - Live 0xffffffffa00b1000
pata_jmicron 12483 0 - Live 0xffffffffa00ac000
libahci 27158 1 ahci, Live 0xffffffffa0025000
libata 181553 5 ata_generic,pata_acpi,ahci,pata_jmicron,libahci, Live
0xffffffffa014a000
usbcore 199328 5 usbhid,ohci_pci,ehci_pci,ohci_hcd,ehci_hcd, Live
0xffffffffa00e6000
usb_common 12440 1 usbcore, Live 0xffffffffa00dc000
scsi_mod 142915 2 sd_mod,libata, Live 0xffffffffa0034000
i8042 18002 1 libps2, Live 0xffffffffa000a000
serio 18282 6 psmouse,serio_raw,atkbd,i8042, Live 0xffffffffa0000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem):

$ cat /proc/ioports
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
  00f0-00ff : PNP0C04:00
    00f0-00ff : fpu
  0230-023f : pnp 00:05
  0290-029f : pnp 00:05
  03c0-03df : vesafb
  03f8-03ff : serial
  040b-040b : pnp 00:04
  04d0-04d1 : pnp 00:04
  04d6-04d6 : pnp 00:04
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0827 : ACPI GPE0_BLK
  08ff-08ff : ACPI PM2_CNT_BLK
  0900-090f : pnp 00:04
  0910-091f : pnp 00:04
  0a30-0a3f : pnp 00:05
  0b00-0b1f : pnp 00:04
  0b20-0b3f : pnp 00:04
  0c00-0c01 : pnp 00:04
  0c14-0c14 : pnp 00:04
  0c50-0c51 : pnp 00:04
  0c52-0c52 : pnp 00:04
  0c6c-0c6c : pnp 00:04
  0c6f-0c6f : pnp 00:04
  0cd0-0cd1 : pnp 00:04
  0cd2-0cd3 : pnp 00:04
  0cd4-0cd5 : pnp 00:04
  0cd6-0cd7 : pnp 00:04
    0cd6-0cd7 : SB800 TCO
  0cd8-0cdf : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  0f40-0f4f : pnp 00:05
  6000-600f : 0000:00:11.0
    6000-600f : ahci
  7000-7003 : 0000:00:11.0
    7000-7003 : ahci
  8000-8007 : 0000:00:11.0
    8000-8007 : ahci
  9000-9003 : 0000:00:11.0
    9000-9003 : ahci
  a000-a007 : 0000:00:11.0
    a000-a007 : ahci
  b000-bfff : PCI Bus 0000:01
    b000-b0ff : 0000:01:00.0
  c000-cfff : PCI Bus 0000:02
    c400-c40f : 0000:02:00.1
      c400-c40f : pata_jmicron
    c480-c483 : 0000:02:00.1
      c480-c483 : pata_jmicron
    c800-c807 : 0000:02:00.1
      c800-c807 : pata_jmicron
    c880-c883 : 0000:02:00.1
      c880-c883 : pata_jmicron
    cc00-cc07 : 0000:02:00.1
      cc00-cc07 : pata_jmicron
  d000-dfff : PCI Bus 0000:03
    dc00-dc7f : 0000:03:07.0
  e000-efff : PCI Bus 0000:04
    e800-e8ff : 0000:04:00.0
      e800-e8ff : r8169
  fe00-fefe : pnp 00:04

$ cat /proc/iomem
00000000-00000fff : reserved
00001000-0009afff : System RAM
0009b000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cffff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
000e4000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cfe7ffff : System RAM
  01000000-015359e9 : Kernel code
  015359ea-018ddc7f : Kernel data
  019ff000-01b21fff : Kernel bss
cfe80000-cfe97fff : ACPI Tables
cfe98000-cfebffff : ACPI Non-volatile Storage
cfec0000-cfefffff : reserved
cff00000-dfffffff : PCI Bus 0000:00
  cff00000-cfffffff : pnp 00:04
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:06
f0000000-febfffff : PCI Bus 0000:00
  fdf00000-fdffffff : PCI Bus 0000:04
    fdff8000-fdffbfff : 0000:04:00.0
      fdff8000-fdffbfff : r8169
    fdfff000-fdffffff : 0000:04:00.0
      fdfff000-fdffffff : r8169
  fe5f3000-fe5f3fff : 0000:00:16.0
    fe5f3000-fe5f3fff : ohci_hcd
  fe5f4000-fe5f7fff : 0000:00:14.2
    fe5f4000-fe5f7fff : ICH HD audio
  fe5fc000-fe5fcfff : 0000:00:14.5
    fe5fc000-fe5fcfff : ohci_hcd
  fe5fd000-fe5fdfff : 0000:00:13.0
    fe5fd000-fe5fdfff : ohci_hcd
  fe5fe000-fe5fefff : 0000:00:12.0
    fe5fe000-fe5fefff : ohci_hcd
  fe5ff000-fe5ff0ff : 0000:00:16.2
    fe5ff000-fe5ff0ff : ehci_hcd
  fe5ff400-fe5ff4ff : 0000:00:13.2
    fe5ff400-fe5ff4ff : ehci_hcd
  fe5ff800-fe5ff8ff : 0000:00:12.2
    fe5ff800-fe5ff8ff : ehci_hcd
  fe5ffc00-fe5fffff : 0000:00:11.0
    fe5ffc00-fe5fffff : ahci
  fe600000-fe6fffff : PCI Bus 0000:01
    fe69c000-fe69ffff : 0000:01:00.1
      fe69c000-fe69ffff : ICH HD audio
    fe6a0000-fe6bffff : 0000:01:00.0
    fe6c0000-fe6fffff : 0000:01:00.0
  fe700000-fe7fffff : PCI Bus 0000:02
    fe7fe000-fe7fffff : 0000:02:00.0
      fe7fe000-fe7fffff : ahci
  fe800000-fe8fffff : PCI Bus 0000:03
    fe800000-fe81ffff : 0000:03:05.0
    fe820000-fe821fff : 0000:03:05.0
    fe8fd800-fe8fdfff : 0000:03:07.0
      fe8fd800-fe8fdfff : firewire_ohci
  fe900000-fe9fffff : PCI Bus 0000:04
    fe9f0000-fe9fffff : 0000:04:00.0
fec00000-fec003ff : IOAPIC 0
fec10000-fec1001f : pnp 00:04
fed00000-fed003ff : HPET 2
  fed00000-fed003ff : PNP0103:00
fed80000-fed80fff : pnp 00:04
  fed80b00-fed80b07 : SB800 TCO
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:03
ffb80000-ffbfffff : pnp 00:04
ffe00000-ffffffff : reserved
100000000-22fffffff : System RAM

[7.5.] PCI information ('lspci -vvv' as root):

# lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] RS880 Host Bridge
Subsystem: Advanced Micro Devices, Inc. [AMD] Device 9600
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
Latency: 0
Capabilities: [c4] HyperTransport: Slave or Primary Interface
Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn+ LSEn- ExtCTL- 64b-
Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn-
LWO=8bit DwFcOutEn-
Revision ID: 3.00
Link Frequency 0: [b]
Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
Link Frequency 1: 200MHz
Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
Prefetchable memory behind bridge Upper: 00-00
Bus Number: 00
Capabilities: [54] HyperTransport: UnitID Clumping
Capabilities: [40] HyperTransport: Retry Mode
Capabilities: [9c] HyperTransport: #1a
Capabilities: [f8] HyperTransport: #1c

00:03.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780 PCI to
PCI bridge (ext gfx port 1) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 0000b000-0000bfff
Memory behind bridge: fe600000-fe6fffff
Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag+ RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #1, Speed 5GT/s, Width x8, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #3, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c  Data: 4171
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] Device 9600
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [110 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Kernel driver in use: pcieport
Kernel modules: shpchp

00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI
to PCI bridge (PCIE port 5) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 0000c000-0000cfff
Memory behind bridge: fe700000-fe7fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag+ RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #10, PowerLimit 25.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c  Data: 4181
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] Device 9600
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [110 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Kernel driver in use: pcieport
Kernel modules: shpchp

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40) (prog-if 01
[AHCI 1.0])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
SATA Controller [AHCI mode]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 19
Region 0: I/O ports at a000 [size=8]
Region 1: I/O ports at 9000 [size=4]
Region 2: I/O ports at 8000 [size=8]
Region 3: I/O ports at 7000 [size=4]
Region 4: I/O ports at 6000 [size=16]
Region 5: Memory at fe5ffc00 (32-bit, non-prefetchable) [size=1K]
Capabilities: [70] SATA HBA v1.0 InCfgSpace
Capabilities: [a4] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ahci
Kernel modules: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB OHCI0 Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at fe5fe000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB EHCI Controller
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at fe5ff800 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci
Kernel modules: ehci_pci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB OHCI0 Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at fe5fd000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB EHCI Controller
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at fe5ff400 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci
Kernel modules: ehci_pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
Controller (rev 41)
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Kernel modules: i2c_piix4, sp5100_tco

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
Azalia (Intel HDA) (rev 40)
Subsystem: ASUSTeK Computer Inc. M4A89GTD PRO/USB3 Motherboard
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at fe5f4000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: snd_hda_intel
Kernel modules: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
LPC host controller
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI
to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64
Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: fe800000-fe8fffff
Prefetchable memory behind bridge: fff00000-000fffff
Secondary status: 66MHz- FastB2B+ ParErr+ DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR+
BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB OHCI2 Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin C routed to IRQ 18
Region 0: Memory at fe5fc000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:15.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal
decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
I/O behind bridge: 0000e000-0000efff
Memory behind bridge: fe900000-fe9fffff
Prefetchable memory behind bridge: 00000000fdf00000-00000000fdffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag+ RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #32, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41a1
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0000
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport
Kernel modules: shpchp

00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB OHCI0 Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at fe5f3000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci
Kernel modules: ohci_pci

00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB EHCI Controller
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at fe5ff000 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci
Kernel modules: ehci_pci

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor HyperTransport Configuration
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [80] HyperTransport: Host or Secondary Interface
Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn+ LSEn+ ExtCTL- 64b-
Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
Revision ID: 3.00
Link Frequency: [b]
Link Error: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

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
Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Miscellaneous Control
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [f0] Secure device <?>
Kernel driver in use: k10temp
Kernel modules: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Link Control
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Tahiti PRO [Radeon HD 7950/8950 OEM / R9 280] (prog-if 00
[VGA controller])
Subsystem: PC Partner Limited / Sapphire Technology Device e210
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 45
Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
Region 2: Memory at fe6c0000 (64-bit, non-prefetchable) [size=256K]
Region 4: I/O ports at b000 [size=256]
Expansion ROM at fe6a0000 [disabled] [size=128K]
Capabilities: [48] Vendor Specific Information: Len=08 <?>
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #1, Speed 8GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41e1
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [150 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [270 v1] #19
Capabilities: [2b0 v1] Address Translation Service (ATS)
ATSCap: Invalidate Queue Depth: 00
ATSCtl: Enable-, Smallest Translation Unit: 00
Capabilities: [2c0 v1] #13
Capabilities: [2d0 v1] #1b
Kernel driver in use: radeon
Kernel modules: radeon

01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Tahiti XT
HDMI Audio [Radeon HD 7970 Series]
Subsystem: PC Partner Limited / Sapphire Technology Device aaa0
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 43
Region 0: Memory at fe69c000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [48] Vendor Specific Information: Len=08 <?>
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #1, Speed 8GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41c1
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [150 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
Kernel driver in use: snd_hda_intel
Kernel modules: snd_hda_intel

02:00.0 SATA controller: JMicron Technology Corp. JMB361 AHCI/IDE (rev
02) (prog-if 01 [AHCI 1.0])
Subsystem: ASUSTeK Computer Inc. Device 824f
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 5: Memory at fe7fe000 (32-bit, non-prefetchable) [size=8K]
Capabilities: [68] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Exit Latency L0s
<1us, L1 <16us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
Kernel driver in use: ahci
Kernel modules: ahci

02:00.1 IDE interface: JMicron Technology Corp. JMB361 AHCI/IDE (rev
02) (prog-if 85 [Master SecO PriO])
Subsystem: ASUSTeK Computer Inc. Device 824f
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 19
Region 0: I/O ports at cc00 [size=8]
Region 1: I/O ports at c880 [size=4]
Region 2: I/O ports at c800 [size=8]
Region 3: I/O ports at c480 [size=4]
Region 4: I/O ports at c400 [size=16]
Capabilities: [68] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pata_jmicron
Kernel modules: pata_jmicron, pata_acpi, ata_generic

03:05.0 Network controller: Texas Instruments ACX 111 54Mbps Wireless Interface
Subsystem: D-Link System Inc DWL-G520+ Wireless PCI Adapter
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR+ INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 11
Region 0: Memory at fe820000 (32-bit, non-prefetchable) [size=8K]
Region 1: Memory at fe800000 (32-bit, non-prefetchable) [size=128K]
Capabilities: [40] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

03:07.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire
II(M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
Subsystem: ASUSTeK Computer Inc. Motherboard
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (8000ns max), Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 22
Region 0: Memory at fe8fd800 (32-bit, non-prefetchable) [size=2K]
Region 1: I/O ports at dc00 [size=128]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: firewire_ohci
Kernel modules: firewire_ohci

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
Subsystem: ASUSTeK Computer Inc. P8P67 and other motherboards
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 44
Region 0: I/O ports at e800 [size=256]
Region 2: Memory at fdfff000 (64-bit, prefetchable) [size=4K]
Region 4: Memory at fdff8000 (64-bit, prefetchable) [size=16K]
Expansion ROM at fe9f0000 [disabled] [size=64K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41d1
Capabilities: [70] Express (v2) Endpoint, MSI 01
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 4096 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <512ns, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
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
CESta: RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
Kernel driver in use: r8169
Kernel modules: r8169


[7.6.] SCSI information (from /proc/scsi/scsi):

$ cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Samsung SSD 840  Rev: 5B0Q
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKX-0 Rev: 1H15
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKX-6 Rev: 1H18
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKX-2 Rev: 1H17
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKX-0 Rev: 1H15
  Type:   Direct-Access                    ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

[X.] Other notes, patches, fixes, workarounds:

Doesn't seem to afect normal operation of SSD/system, at least I
haven't noticed anything.



-- 
Kind regards,
Bruno Saraiva
