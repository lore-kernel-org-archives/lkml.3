Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaHOHp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:45:58 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50403 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaHOHp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:45:56 -0400
MIME-Version: 1.0
Date: Fri, 15 Aug 2014 14:45:55 +0700
Message-ID: <CAEjyFXeheAk5vDzvw3YQOXrcqLdVBJM2Z2JvXhfXYVCVSXkOhQ@mail.gmail.com>
Subject: PROBLEM: External USB HDD Seagate Backup Plus tooks too much time to
 mount in linux 3.15+
From: "mrDoctorWho0 ." <mrdoctorwho@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. External USB HDD Seagate Backup Plus tooks too much time to mount
2. When i used linux 3.14 all was fine, but when i've updated it to
3.15 i began to experience these problems:
- random system freezes when something read/write on the disk (linux
ver 3.15, not 3.16)
- too much time to mount (linux ver 3.15, 3.16)
3. usb, scsi, hdd
4. Linux version 3.16.1-1-ARCH
(nobody@var-lib-archbuild-testing-x86_64-tobias) (gcc version 4.9.1
(GCC) ) #1 SMP PREEMPT Thu Aug 14 07:40:19 CEST 2014
5. There is no oops, but dmesg:
[   65.838872] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
[   65.878230] usbcore: registered new interface driver usb-storage
[   65.880424] scsi6 : uas
[   65.880594] usbcore: registered new interface driver uas
[   65.881711] scsi 6:0:0:0: Direct-Access     Seagate  Backup+  BK
  0143 PQ: 0 ANSI: 6
[   65.883573] sd 6:0:0:0: [sdb] Spinning up disk...
[   69.826438] .ready
[   69.826743] sd 6:0:0:0: [sdb] 1953525167 512-byte logical blocks:
(1.00 TB/931 GiB)
[   69.827792] sd 6:0:0:0: [sdb] Write Protect is off
[   69.827797] sd 6:0:0:0: [sdb] Mode Sense: 2b 00 10 08
[   69.828590] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[   69.853590]  sdb: sdb1
[   69.856505] sd 6:0:0:0: [sdb] Attached SCSI disk
[   77.468535] sd 6:0:0:0: [sdb] uas_eh_abort_handler ffff8800d3d6ca80
tag 1, inflight: CMD IN
[   80.471984] scsi host6: uas_eh_task_mgmt: ABORT TASK timed out
[   80.471999] sd 6:0:0:0: [sdb] uas_eh_abort_handler ffff8800d3d6de00
tag 2, inflight: CMD
[   80.472003] scsi host6: uas_eh_task_mgmt: ABORT TASK: error already
running a task
[  100.498150] sd 6:0:0:0: [sdb] uas_eh_abort_handler ffff8800d3d6d380
tag 0, inflight: CMD IN
[  100.498158] scsi host6: uas_eh_task_mgmt: ABORT TASK: error already
running a task
[  100.498165] sd 6:0:0:0: uas_eh_device_reset_handler
[  100.498167] scsi host6: uas_eh_task_mgmt: LOGICAL UNIT RESET: error
already running a task
[  100.498172] scsi host6: uas_eh_bus_reset_handler start
[  100.498205] usb 2-2: stat urb: killed, stream 2
[  100.498234] usb 2-2: stat urb: killed, stream 4
[  100.498277] usb 2-2: stat urb: killed, stream 3
[  100.498320] sd 6:0:0:0: [sdb] uas_data_cmplt ffff8800d3d6d380 tag
0, inflight: CMD abort
[  100.498325] sd 6:0:0:0: [sdb] data cmplt err -2 stream 2
[  100.498356] sd 6:0:0:0: [sdb] uas_data_cmplt ffff8800d3d6ca80 tag
1, inflight: CMD abort
[  100.498360] sd 6:0:0:0: [sdb] data cmplt err -2 stream 3
[  100.498373] sd 6:0:0:0: [sdb] uas_zap_dead ffff8800d3d6ca80 tag 1,
inflight: CMD abort
[  100.498378] sd 6:0:0:0: [sdb] abort completed
[  100.498384] sd 6:0:0:0: [sdb] uas_zap_dead ffff8800d3d6de00 tag 2,
inflight: CMD abort
[  100.498388] sd 6:0:0:0: [sdb] abort completed
[  100.498394] sd 6:0:0:0: [sdb] uas_zap_dead ffff8800d3d6d380 tag 0,
inflight: CMD abort
[  100.498398] sd 6:0:0:0: [sdb] abort completed
[  100.605487] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  100.619203] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880117ea9e48
[  100.619210] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880117ea9ed8
[  100.619214] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880117ea9e00
[  100.619217] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880117ea9e90
[  100.619791] scsi host6: uas_eh_bus_reset_handler success
[  108.477313] sd 6:0:0:0: [sdb] uas_eh_abort_handler ffff8800cd863680
tag 1, inflight: CMD IN
[  111.480721] scsi host6: uas_eh_task_mgmt: ABORT TASK timed out
[  138.568358] sd 6:0:0:0: uas_eh_abort_handler ffff8801184c1680 tag
0, inflight: CMD IN
[  138.568374] scsi host6: uas_eh_task_mgmt: ABORT TASK: error already
running a task
[  138.568385] sd 6:0:0:0: uas_eh_device_reset_handler
[  138.568389] scsi host6: uas_eh_task_mgmt: LOGICAL UNIT RESET: error
already running a task
[  138.568394] scsi host6: uas_eh_bus_reset_handler start
[  138.568446] usb 2-2: stat urb: killed, stream 2
[  138.568517] usb 2-2: stat urb: killed, stream 3
[  138.568581] sd 6:0:0:0: uas_data_cmplt ffff8801184c1680 tag 0,
inflight: CMD abort
[  138.568587] sd 6:0:0:0: data cmplt err -2 stream 2
[  138.568669] sd 6:0:0:0: [sdb] uas_data_cmplt ffff8800cd863680 tag
1, inflight: CMD abort
[  138.568682] sd 6:0:0:0: [sdb] data cmplt err -2 stream 3
[  138.568740] sd 6:0:0:0: [sdb] uas_zap_dead ffff8800cd863680 tag 1,
inflight: CMD abort
[  138.568749] sd 6:0:0:0: [sdb] abort completed
[  138.568761] sd 6:0:0:0: uas_zap_dead ffff8801184c1680 tag 0,
inflight: CMD abort
[  138.568770] sd 6:0:0:0: abort completed
[  138.675781] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  138.689618] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880117ea9e48
[  138.689626] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880117ea9ed8
[  138.689629] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880117ea9e00
[  138.689632] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880117ea9e90
[  138.690302] scsi host6: uas_eh_bus_reset_handler success
[  138.716604]  sdb: sdb1

7.1
Linux mrDoctorWho-arch 3.16.1-1-ARCH #1 SMP PREEMPT Thu Aug 14
07:40:19 CEST 2014 x86_64 GNU/Linux

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
PPP                    2.4.6
Linux C Library        2.19
Dynamic linker (ldd)   2.19
Linux C++ Library      6.0.20
Procps                 3.3.9
Net-tools              2.10-alpha
Kbd                    2.0.2
Sh-utils               8.23
wireless-tools         30
Modules Loaded         cpufreq_conservative cpufreq_userspace uas
usb_storage pci_stub vboxpci vboxnetflt vboxnetadp vboxdrv ctr ccm
fuse arc4 brcmsmac ecb cordic brcmutil b43 mousedev joydev btusb
hid_generic led_class bluetooth coretemp hwmon usbhid intel_rapl
mac80211 cfg80211 6lowpan_iphc hid x86_pkg_temp_thermal
intel_powerclamp ssb kvm_intel rfkill kvm rng_core pcmcia pcmcia_core
crct10dif_pclmul crc32_pclmul crc32c_intel iTCO_wdt
iTCO_vendor_support ghash_clmulni_intel cryptd snd_hda_codec_hdmi
snd_hda_codec_via snd_hda_codec_generic r8169 pcspkr i2c_i801 psmouse
microcode serio_raw mii snd_hda_intel rtsx_pci_ms bcma memstick
snd_hda_controller wmi snd_hda_codec snd_hwdep snd_pcm tpm_infineon
snd_timer tpm_tis snd tpm shpchp ac mei_me soundcore mei evdev lpc_ich
battery thermal mac_hid processor zram lz4_compress msr ext4 crc16
mbcache jbd2 sd_mod crc_t10dif crct10dif_common rtsx_pci_sdmmc
mmc_core atkbd libps2 ahci libahci libata ehci_pci xhci_hcd ehci_hcd
scsi_mod rtsx_pci usbcore usb_common i8042 serio i915 button intel_gtt
i2c_algo_bit video drm_kms_helper drm i2c_core

7.2
# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 58
model name      : Intel(R) Core(TM) i3-3120M CPU @ 2.50GHz
stepping        : 9
microcode       : 0x1b
cpu MHz         : 2381.835
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic
popcnt tsc_deadline_timer xsave avx f16c lahf_lm arat epb xsaveopt pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
bogomips        : 4990.13
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

7.3
# cat /proc/modules
cpufreq_conservative 14184 0 - Live 0xffffffffa065d000
cpufreq_userspace 12525 0 - Live 0xffffffffa0658000
uas 22044 1 - Live 0xffffffffa0662000
usb_storage 60311 1 uas, Live 0xffffffffa0648000
pci_stub 12429 1 - Live 0xffffffffa0643000
vboxpci 23139 0 - Live 0xffffffffa0638000 (O)
vboxnetflt 27412 0 - Live 0xffffffffa062c000 (O)
vboxnetadp 25443 0 - Live 0xffffffffa0614000 (O)
vboxdrv 348330 3 vboxpci,vboxnetflt,vboxnetadp, Live 0xffffffffa093a000 (O)
ctr 12927 1 - Live 0xffffffffa060f000
ccm 17534 1 - Live 0xffffffffa05e8000
fuse 87446 3 - Live 0xffffffffa05d1000
arc4 12536 2 - Live 0xffffffffa05c6000
brcmsmac 532342 0 - Live 0xffffffffa08b7000
ecb 12737 1 - Live 0xffffffffa0627000
cordic 12352 1 brcmsmac, Live 0xffffffffa0622000
brcmutil 13093 1 brcmsmac, Live 0xffffffffa059e000
b43 386134 0 - Live 0xffffffffa0857000
mousedev 17272 0 - Live 0xffffffffa061c000
joydev 17063 0 - Live 0xffffffffa05cb000
btusb 25625 0 - Live 0xffffffffa05a3000
hid_generic 12393 0 - Live 0xffffffffa0593000
led_class 12859 2 brcmsmac,b43, Live 0xffffffffa056c000
bluetooth 394557 2 btusb, Live 0xffffffffa07f5000
coretemp 12820 0 - Live 0xffffffffa0599000
hwmon 12930 1 coretemp, Live 0xffffffffa060a000
usbhid 44507 0 - Live 0xffffffffa0587000
intel_rapl 17356 0 - Live 0xffffffffa0573000
mac80211 514630 2 brcmsmac,b43, Live 0xffffffffa0776000
cfg80211 454161 3 brcmsmac,b43,mac80211, Live 0xffffffffa0676000
6lowpan_iphc 16588 1 bluetooth, Live 0xffffffffa057d000
hid 102220 2 hid_generic,usbhid, Live 0xffffffffa05ac000
x86_pkg_temp_thermal 12951 0 - Live 0xffffffffa04f3000
intel_powerclamp 17122 0 - Live 0xffffffffa0600000
ssb 61410 1 b43, Live 0xffffffffa05f0000
kvm_intel 143217 0 - Live 0xffffffffa0726000
rfkill 18867 3 bluetooth,cfg80211, Live 0xffffffffa04c9000
kvm 413027 1 kvm_intel, Live 0xffffffffa0506000
rng_core 12733 1 b43, Live 0xffffffffa049f000
pcmcia 53108 2 b43,ssb, Live 0xffffffffa04f8000
pcmcia_core 18431 1 pcmcia, Live 0xffffffffa04ed000
crct10dif_pclmul 13394 0 - Live 0xffffffffa04d3000
crc32_pclmul 12915 0 - Live 0xffffffffa04a9000
crc32c_intel 21809 0 - Live 0xffffffffa048b000
iTCO_wdt 12831 0 - Live 0xffffffffa0452000
iTCO_vendor_support 12649 1 iTCO_wdt, Live 0xffffffffa04a4000
ghash_clmulni_intel 12978 0 - Live 0xffffffffa04af000
cryptd 18553 1 ghash_clmulni_intel, Live 0xffffffffa03cb000
snd_hda_codec_hdmi 45117 1 - Live 0xffffffffa0492000
snd_hda_codec_via 30990 1 - Live 0xffffffffa0472000
snd_hda_codec_generic 63126 1 snd_hda_codec_via, Live 0xffffffffa04dc000
r8169 68119 0 - Live 0xffffffffa04b7000
pcspkr 12595 0 - Live 0xffffffffa0486000
i2c_i801 16965 0 - Live 0xffffffffa047c000
psmouse 102792 0 - Live 0xffffffffa0457000
microcode 22061 0 - Live 0xffffffffa044b000
serio_raw 12849 0 - Live 0xffffffffa0446000
mii 12675 1 r8169, Live 0xffffffffa03d1000
snd_hda_intel 26327 5 - Live 0xffffffffa043e000
rtsx_pci_ms 16898 0 - Live 0xffffffffa0438000
bcma 45870 3 brcmsmac,b43, Live 0xffffffffa042b000
memstick 13696 1 rtsx_pci_ms, Live 0xffffffffa02b3000
snd_hda_controller 26727 1 snd_hda_intel, Live 0xffffffffa03c3000
wmi 17339 0 - Live 0xffffffffa03a4000
snd_hda_codec 108552 5 snd_hda_codec_hdmi,snd_hda_
codec_via,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller, Live
0xffffffffa040f000
snd_hwdep 17244 1 snd_hda_codec, Live 0xffffffffa0368000
snd_pcm 88487 5
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec,
Live 0xffffffffa03f8000
tpm_infineon 16882 0 - Live 0xffffffffa0362000
snd_timer 26614 1 snd_pcm, Live 0xffffffffa03e8000
tpm_tis 17134 0 - Live 0xffffffffa03f2000
snd 69340 17 snd_hda_codec_hdmi,snd_hda_codec_via,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xffffffffa03d6000
tpm 31467 2 tpm_infineon,tpm_tis, Live 0xffffffffa03ba000
shpchp 35210 0 - Live 0xffffffffa03b0000
ac 12715 0 - Live 0xffffffffa039f000
mei_me 17941 0 - Live 0xffffffffa03aa000
soundcore 13031 2 snd_hda_codec,snd, Live 0xffffffffa0377000
mei 75033 1 mei_me, Live 0xffffffffa0387000
evdev 21544 13 - Live 0xffffffffa037c000
lpc_ich 20768 0 - Live 0xffffffffa0370000
battery 13356 0 - Live 0xffffffffa035d000
thermal 17559 0 - Live 0xffffffffa02ad000
mac_hid 12633 0 - Live 0xffffffffa027e000
processor 27777 0 - Live 0xffffffffa0276000
zram 18714 4 - Live 0xffffffffa0223000
lz4_compress 12350 1 zram, Live 0xffffffffa021e000
msr 12677 0 - Live 0xffffffffa015b000
ext4 497695 2 - Live 0xffffffffa02e2000
crc16 12343 2 bluetooth,ext4, Live 0xffffffffa0219000
mbcache 17171 1 ext4, Live 0xffffffffa0229000
jbd2 86460 1 ext4, Live 0xffffffffa02cb000
sd_mod 44356 4 - Live 0xffffffffa01fb000
crc_t10dif 12431 1 sd_mod, Live 0xffffffffa01f0000
crct10dif_common 12356 2 crct10dif_pclmul,crc_t10dif, Live 0xffffffffa0156000
rtsx_pci_sdmmc 21105 0 - Live 0xffffffffa0212000
mmc_core 110475 3 b43,ssb,rtsx_pci_sdmmc, Live 0xffffffffa0232000
atkbd 22254 0 - Live 0xffffffffa020b000
libps2 12739 2 psmouse,atkbd, Live 0xffffffffa01f6000
ahci 29195 1 - Live 0xffffffffa01e7000
libahci 27158 1 ahci, Live 0xffffffffa01a1000
libata 181553 2 ahci,libahci, Live 0xffffffffa01b9000
ehci_pci 12512 0 - Live 0xffffffffa0198000
xhci_hcd 152990 0 - Live 0xffffffffa0286000
ehci_hcd 69939 1 ehci_pci, Live 0xffffffffa02b8000
scsi_mod 142915 4 uas,usb_storage,sd_mod,libata, Live 0xffffffffa024e000
rtsx_pci 41815 2 rtsx_pci_ms,rtsx_pci_sdmmc, Live 0xffffffffa01ad000
usbcore 199328 7
uas,usb_storage,btusb,usbhid,ehci_pci,xhci_hcd,ehci_hcd, Live
0xffffffffa0166000
usb_common 12440 1 usbcore, Live 0xffffffffa0062000
i8042 18002 1 libps2, Live 0xffffffffa0160000
serio 18282 9 psmouse,serio_raw,atkbd,i8042, Live 0xffffffffa006c000
i915 864723 4 - Live 0xffffffffa0081000
button 12909 1 i915, Live 0xffffffffa0067000
intel_gtt 17848 1 i915, Live 0xffffffffa0056000
i2c_algo_bit 12744 1 i915, Live 0xffffffffa005d000
video 17995 1 i915, Live 0xffffffffa000e000
drm_kms_helper 49262 1 i915, Live 0xffffffffa0073000
drm 258005 6 i915,drm_kms_helper, Live 0xffffffffa0016000
i2c_core 50152 5 i2c_i801,i915,i2c_algo_bit,drm_kms_helper,drm, Live
0xffffffffa0000000

7.4

# cat /proc/ioports

0000-0cf7 : PCI Bus 0000:00

0000-001f : dma1

0020-0021 : pic1

0040-0043 : timer0

0050-0053 : timer1

0060-0060 : keyboard

0062-0062 : PNP0C09:00

0062-0062 : EC data

0064-0064 : keyboard

0066-0066 : PNP0C09:00

0066-0066 : EC cmd

0070-0077 : rtc0

0080-008f : dma page reg

00a0-00a1 : pic2

00c0-00df : dma2

00f0-00ff : PNP0C04:00

00f0-00ff : fpu

03c0-03df : vesafb

0400-0403 : ACPI PM1a_EVT_BLK

0404-0405 : ACPI PM1a_CNT_BLK

0408-040b : ACPI PM_TMR

0410-0415 : ACPI CPU throttle

0420-042f : ACPI GPE0_BLK

0430-0433 : iTCO_wdt

0430-0433 : iTCO_wdt

0450-0450 : ACPI PM2_CNT_BLK

0454-0457 : pnp 00:03

0458-047f : pnp 00:01

0460-047f : iTCO_wdt

0460-047f : iTCO_wdt

04d0-04d1 : pnp 00:06

0500-057f : pnp 00:01

0680-069f : pnp 00:01

0cf8-0cff : PCI conf1

0d00-ffff : PCI Bus 0000:00

1000-100f : pnp 00:01

164e-164f : pnp 00:01

3322-3323 : pnp 00:01

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

ffff-ffff : pnp 00:01

ffff-ffff : pnp 00:01


7.5 # lspci -vvv
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
Controller (rev 09)
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: ivb_uncore

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 40
        Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at f000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4181
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

00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at f7e00000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 41a1
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci_hcd

00:16.0 Communication controller: Intel Corporation 7 Series/C210
Series Chipset Family MEI Controller #1 (rev 04)
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 44
        Region 0: Memory at f7e1a000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 41c1
        Kernel driver in use: mei_me
        Kernel modules: mei_me

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f7e18000 (32-bit, non-prefetchable) [size=1K]
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

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 45
        Region 0: Memory at f7e10000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 41e1
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=22
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=0f ComponentID=00 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=00
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
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
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <1us, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+,
LTR-, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 0240
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 3 (rev c4) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
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
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+,
LTR-, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 0240
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 4 (rev c4) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
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
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surprise-
                        Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+,
LTR-, OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 0240
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f7e17000 (32-bit, non-prefetchable) [size=1K]
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

00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC
Controller (rev 04)
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: lpc_ich
        Kernel modules: lpc_ich

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 43
        Region 0: I/O ports at f0b0 [size=8]
        Region 1: I/O ports at f0a0 [size=4]
        Region 2: I/O ports at f090 [size=8]
        Region 3: I/O ports at f080 [size=4]
        Region 4: I/O ports at f060 [size=32]
        Region 5: Memory at f7e16000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 41b1
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

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
SMBus Controller (rev 04)
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at f7e15000 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at f040 [size=32]
        Kernel modules: i2c_i801

02:00.0 Network controller: Broadcom Corporation BCM4313 802.11bgn
Wireless Network Adapter (rev 01)
        Subsystem: Askey Computer Corp. Device 7179
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f7d00000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
        Capabilities: [58] Vendor Specific Information: Len=78 <?>
        Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [d0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <4us, L1 <64us
                        ClockPM+ Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [13c v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-df-ff-ff-c0-e8-39
        Capabilities: [16c v1] Power Budgeting <?>
        Kernel driver in use: bcma-pci-bridge
        Kernel modules: bcma

03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
Device 5289 (rev 01)
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 41
        Region 0: Memory at f7c00000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 4191
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk-
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+,
LTR-, OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable- Count=1 Masked-
                Vector table: BAR=0 offset=00000000
                PBA: BAR=0 offset=00000000
        Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
                Not readable
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: rtsx_pci
        Kernel modules: rtsx_pci

03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0a)
        Subsystem: CLEVO/KAPOK Computer Device 0240
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 46
        Region 0: I/O ports at e000 [size=256]
        Region 2: Memory at f0004000 (64-bit, prefetchable) [size=4K]
        Region 4: Memory at f0000000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 4122
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+,
LTR-, OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data
                Unknown small resource type 00, will not decode more.
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
        Kernel modules: r8169

7.6 # cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: OCZ-VERTEX3      Rev: 2.25
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: Seagate  Model: Backup+  BK      Rev: 0143
  Type:   Direct-Access                    ANSI  SCSI revision: 06
