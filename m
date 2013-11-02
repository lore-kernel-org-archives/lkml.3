Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3KBTo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 15:44:28 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:44124 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab3KBToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 15:44:21 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net BA993D7DE7
Date: Sat, 2 Nov 2013 20:44:18 +0100 (CET)
From: gabivandelaar@arcor.de
To: linux-kernel@vger.kernel.org
Message-ID: <352261908.3353.1383421458737.JavaMail.ngmail@webmail07.arcor-online.net>
Subject: PROBLEM: only on Linux amd64 no network/usb 2
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 84.174.60.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux amd64 on my system fails to recognise network and usb 2.0, in contrast to Linux i386.

On my new system (CPU: AMD FX-6300, Mobo Gigabyte GA-990XA-UD3 with Realtek GbE NIC and AMD SB950 USB 2.0 host controller on board) Linux does not recognise my network and USB 2.0. After trying the following versions:

Linux 3.0.0-12-generic x86_64 (Ubuntu 11.10)
Linux 3.2.0-23-generic i386 (Ubuntu 12.04)
Linux 3.9.6 i686 (Knoppix 7.2.0)
Linux 3.11.0-12-generic x86_64 (Ubuntu 13.10)
Linux 3.11.2-1-ARCH i686 (Arch Linux 201310 Live)
Linux 3.11.2-1-ARCH x86_64 (Arch Linux 201310 Live)

I established that the problem only occurs with the x86_64 versions of Linux, while the i686 versions run well. On Ubuntu 13.10 (Linux 3.11.0-12-generic x86_64), after a while network-manager-gnome reported a network connection, and `ifconfig` showed the correct inet/netmask/broadcast data. Still `ping ubuntu.com` gave an 'unable to resolve host' error, and firefox gave a 'connection timed out' error. On plugging in a keyboard to a USB 2.0 port on Arch Linux amd64 I got the following error:

[  36.670642] usb 11-4: device descriptor read/64, error -32
[  36.907119] usb 11-4: device descriptor read/64, error -32
[  37.273488] usb 11-4: device descriptor read/64, error -32
[  37.509965] usb 11-4: device descriptor read/64, error -32
[  38.149441] usb 11-4: device not accepting address 12, error -32
[  38.685674] usb 11-4: device not accepting address 12, error -32
[  38.685778] hub 11-0:1.0 unable to enumerate USB device on port 4
[  39.128651] usb 6-2: device descriptor read/64, error -32
[  39.365128] usb 6-2: device descriptor read/64, error -32
[  39.731498] usb 6-2: device descriptor read/64, error -32
[  39.967970] usb 6-2: device descriptor read/64, error -32
[  40.607447] usb 6-2: device not accepting address 4, error -32
[  41.143683] usb 6-2: device not accepting address 5, error -32
[  41.143761] hub 6-0:1.0 unable to enumerate USB device on port 2

Setting up a network manually led to same result as described above: ifconfig listing the correct connection data but no network connection. Comparing the dmesg's of an i686 and an amd64 system yielded following difference (line 4):

i686
[    3.045475] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.045484] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    3.045746] r8169 0000:03:00.0: irq 72 for MSI/MSI-X
[    3.045921] r8169 0000:03:00.0 eth0: RTL8168evl/8111evl at 0xf8752000, 94:de:80:bf:d1:e3, XID 0c900800 IRQ 72
[    3.045923] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]

x86_64
[    2.431513] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.431523] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    2.431750] r8169 0000:03:00.0: irq 72 for MSI/MSI-X
[    2.432042] r8169 0000:03:00.0 eth0: RTL8168evl/8111evl at 0xffffc90000616000, 94:de:80:bf:d1:e3, XID 0c900800 IRQ 72
[    2.432044] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]

Reproducibility: always. Known fixes: none. Please let me know how I can contribute.

Here follow the system data according to https://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html (including a dmesg) from my Ubuntu 13.10 system:

ver_linux -----------------------------------------------

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux schosskaetzchen 3.11.0-12-generic #19-Ubuntu SMP Wed Oct 9 16:20:46 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.8
Gnu make               3.81
binutils               2.23.52.20130913
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.8
jfsutils               1.1.15
pcmciautils            018
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.20
wireless-tools         30
Modules Loaded         cuse dm_crypt parport_pc ppdev binfmt_misc nfsd auth_rpcgss nfs_acl nfs lockd sunrpc fscache kvm_amd kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd joydev edac_core snd_hda_codec_hdmi edac_mce_amd snd_hda_codec_realtek sp5100_tco fam15h_power microcode snd_hda_intel snd_hda_codec snd_hwdep psmouse serio_raw k10temp snd_pcm snd_page_alloc i2c_piix4 ohci_pci snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore mac_hid lp parport btrfs xor zlib_deflate raid6_pq libcrc32c pata_acpi hid_generic usbhid hid radeon mxm_wmi i2c_algo_bit ttm drm_kms_helper firewire_ohci firewire_core drm pata_atiixp crc_itu_t r8169 ahci libahci mii wmi

/proc/version -----------------------------------------------

Linux version 3.11.0-12-generic (buildd@allspice) (gcc version 4.8.1 (Ubuntu/Linaro 4.8.1-10ubuntu7) ) #19-Ubuntu SMP Wed Oct 9 16:20:46 UTC 2013

/proc/cpuinfo -----------------------------------------------

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 2
model name	: AMD FX(tm)-6300 Six-Core Processor
stepping	: 0
microcode	: 0x6000822
cpu MHz		: 3500.000
cache size	: 2048 KB
physical id	: 0
siblings	: 6
core id		: 0
cpu cores	: 3
apicid		: 16
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold bmi1
bogomips	: 7031.68
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 2
model name	: AMD FX(tm)-6300 Six-Core Processor             
stepping	: 0
microcode	: 0x6000822
cpu MHz		: 3500.000
cache size	: 2048 KB
physical id	: 0
siblings	: 6
core id		: 1
cpu cores	: 3
apicid		: 17
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold bmi1
bogomips	: 7031.68
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro

processor	: 2
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 2
model name	: AMD FX(tm)-6300 Six-Core Processor             
stepping	: 0
microcode	: 0x6000822
cpu MHz		: 3500.000
cache size	: 2048 KB
physical id	: 0
siblings	: 6
core id		: 2
cpu cores	: 3
apicid		: 18
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold bmi1
bogomips	: 7031.68
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro

processor	: 3
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 2
model name	: AMD FX(tm)-6300 Six-Core Processor             
stepping	: 0
microcode	: 0x6000822
cpu MHz		: 3500.000
cache size	: 2048 KB
physical id	: 0
siblings	: 6
core id		: 3
cpu cores	: 3
apicid		: 19
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold bmi1
bogomips	: 7031.68
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro

processor	: 4
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 2
model name	: AMD FX(tm)-6300 Six-Core Processor             
stepping	: 0
microcode	: 0x6000822
cpu MHz		: 3500.000
cache size	: 2048 KB
physical id	: 0
siblings	: 6
core id		: 4
cpu cores	: 3
apicid		: 20
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold bmi1
bogomips	: 7031.68
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro

processor	: 5
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 2
model name	: AMD FX(tm)-6300 Six-Core Processor             
stepping	: 0
microcode	: 0x6000822
cpu MHz		: 3500.000
cache size	: 2048 KB
physical id	: 0
siblings	: 6
core id		: 5
cpu cores	: 3
apicid		: 21
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce nodeid_msr tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold bmi1
bogomips	: 7031.68
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro

/proc/modules -----------------------------------------------

cuse 13274 3 - Live 0x0000000000000000
dm_crypt 22728 1 - Live 0x0000000000000000 (F)
parport_pc 32701 0 - Live 0x0000000000000000 (F)
ppdev 17671 0 - Live 0x0000000000000000 (F)
binfmt_misc 17468 1 - Live 0x0000000000000000 (F)
nfsd 279192 2 - Live 0x0000000000000000 (F)
auth_rpcgss 54489 1 nfsd, Live 0x0000000000000000 (F)
nfs_acl 12837 1 nfsd, Live 0x0000000000000000 (F)
nfs 180519 0 - Live 0x0000000000000000 (F)
lockd 93583 2 nfsd,nfs, Live 0x0000000000000000 (F)
sunrpc 271025 6 nfsd,auth_rpcgss,nfs_acl,nfs,lockd, Live 0x0000000000000000 (F)
fscache 58475 1 nfs, Live 0x0000000000000000 (F)
kvm_amd 59958 0 - Live 0x0000000000000000 (F)
kvm 431315 1 kvm_amd, Live 0x0000000000000000 (F)
crct10dif_pclmul 14289 0 - Live 0x0000000000000000 (F)
crc32_pclmul 13113 0 - Live 0x0000000000000000 (F)
ghash_clmulni_intel 13259 0 - Live 0x0000000000000000 (F)
aesni_intel 55624 16 - Live 0x0000000000000000 (F)
aes_x86_64 17131 1 aesni_intel, Live 0x0000000000000000 (F)
lrw 13257 1 aesni_intel, Live 0x0000000000000000 (F)
gf128mul 14951 1 lrw, Live 0x0000000000000000 (F)
glue_helper 13990 1 aesni_intel, Live 0x0000000000000000 (F)
ablk_helper 13597 1 aesni_intel, Live 0x0000000000000000 (F)
cryptd 20329 10 ghash_clmulni_intel,aesni_intel,ablk_helper, Live 0x0000000000000000 (F)
joydev 17377 0 - Live 0x0000000000000000 (F)
edac_core 62312 0 - Live 0x0000000000000000
snd_hda_codec_hdmi 41276 1 - Live 0x0000000000000000
edac_mce_amd 22617 0 - Live 0x0000000000000000
snd_hda_codec_realtek 51465 1 - Live 0x0000000000000000
sp5100_tco 13979 0 - Live 0x0000000000000000
fam15h_power 13119 0 - Live 0x0000000000000000
microcode 23518 0 - Live 0x0000000000000000 (F)
snd_hda_intel 48171 5 - Live 0x0000000000000000
snd_hda_codec 188738 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0x0000000000000000
snd_hwdep 13602 1 snd_hda_codec, Live 0x0000000000000000 (F)
psmouse 97626 0 - Live 0x0000000000000000 (F)
serio_raw 13413 0 - Live 0x0000000000000000 (F)
k10temp 13126 0 - Live 0x0000000000000000
snd_pcm 102033 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0x0000000000000000 (F)
snd_page_alloc 18710 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000 (F)
i2c_piix4 22106 0 - Live 0x0000000000000000
ohci_pci 13561 0 - Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000 (F)
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000 (F)
snd_rawmidi 30095 1 snd_seq_midi, Live 0x0000000000000000 (F)
snd_seq 61560 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000 (F)
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000 (F)
snd_timer 29433 2 snd_pcm,snd_seq, Live 0x0000000000000000 (F)
snd 69141 21 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, Live 0x0000000000000000 (F)
soundcore 12680 1 snd, Live 0x0000000000000000 (F)
mac_hid 13205 0 - Live 0x0000000000000000
lp 17759 0 - Live 0x0000000000000000 (F)
parport 42299 3 parport_pc,ppdev,lp, Live 0x0000000000000000 (F)
btrfs 815968 0 - Live 0x0000000000000000 (F)
xor 21411 1 btrfs, Live 0x0000000000000000 (F)
zlib_deflate 26885 1 btrfs, Live 0x0000000000000000 (F)
raid6_pq 97812 1 btrfs, Live 0x0000000000000000 (F)
libcrc32c 12615 1 btrfs, Live 0x0000000000000000 (F)
pata_acpi 13038 0 - Live 0x0000000000000000
hid_generic 12548 0 - Live 0x0000000000000000
usbhid 53014 0 - Live 0x0000000000000000
hid 101512 2 hid_generic,usbhid, Live 0x0000000000000000
radeon 1402449 3 - Live 0x0000000000000000
mxm_wmi 13021 0 - Live 0x0000000000000000
i2c_algo_bit 13413 1 radeon, Live 0x0000000000000000
ttm 83995 1 radeon, Live 0x0000000000000000
drm_kms_helper 52651 1 radeon, Live 0x0000000000000000
firewire_ohci 40060 0 - Live 0x0000000000000000
firewire_core 64476 1 firewire_ohci, Live 0x0000000000000000
drm 296739 5 radeon,ttm,drm_kms_helper, Live 0x0000000000000000
pata_atiixp 13242 0 - Live 0x0000000000000000
crc_itu_t 12707 1 firewire_core, Live 0x0000000000000000 (F)
r8169 67341 0 - Live 0x0000000000000000
ahci 25819 2 - Live 0x0000000000000000 (F)
libahci 31898 1 ahci, Live 0x0000000000000000 (F)
mii 13934 1 r8169, Live 0x0000000000000000 (F)
wmi 19070 1 mxm_wmi, Live 0x0000000000000000

/proc/ioports -----------------------------------------------

0000-03af : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:14.1
    0170-0177 : pata_atiixp
  01f0-01f7 : 0000:00:14.1
    01f0-01f7 : pata_atiixp
  0220-0227 : pnp 00:02
  0228-0237 : pnp 00:02
  0376-0376 : 0000:00:14.1
    0376-0376 : pata_atiixp
03b0-03df : PCI Bus 0000:00
03e0-0cf7 : PCI Bus 0000:00
  03f6-03f6 : 0000:00:14.1
    03f6-03f6 : pata_atiixp
  03f8-03ff : serial
  040b-040b : pnp 00:01
  04d0-04d1 : pnp 00:07
  04d6-04d6 : pnp 00:01
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0827 : ACPI GPE0_BLK
  0900-090f : pnp 00:01
  0910-091f : pnp 00:01
  0a20-0a2f : pnp 00:02
  0b00-0b07 : piix4_smbus
  0b20-0b3f : pnp 00:01
  0c00-0c01 : pnp 00:01
  0c14-0c14 : pnp 00:01
  0c50-0c51 : pnp 00:01
  0c52-0c52 : pnp 00:01
  0c6c-0c6c : pnp 00:01
  0c6f-0c6f : pnp 00:01
  0cd0-0cd1 : pnp 00:01
  0cd2-0cd3 : pnp 00:01
  0cd4-0cd5 : pnp 00:01
  0cd6-0cd7 : pnp 00:01
    0cd6-0cd7 : SB800 TCO
  0cd8-0cdf : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  c000-cfff : PCI Bus 0000:05
    c000-c07f : 0000:05:0e.0
  d000-dfff : PCI Bus 0000:03
    d000-d0ff : 0000:03:00.0
      d000-d0ff : r8169
  e000-efff : PCI Bus 0000:01
    e000-e0ff : 0000:01:00.0
  f000-f00f : 0000:00:14.1
    f000-f00f : pata_atiixp
  f050-f05f : 0000:00:11.0
    f050-f05f : ahci
  f060-f063 : 0000:00:11.0
    f060-f063 : ahci
  f070-f077 : 0000:00:11.0
    f070-f077 : ahci
  f080-f083 : 0000:00:11.0
    f080-f083 : ahci
  f090-f097 : 0000:00:11.0
    f090-f097 : ahci
  fe00-fefe : pnp 00:01

/proc/iomem -----------------------------------------------

00000000-00000fff : reserved
00001000-0009e7ff : System RAM
0009e800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00
  000c0000-000cffff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-be3dafff : System RAM
  01000000-016f9945 : Kernel code
  016f9946-01d0e7ff : Kernel data
  01e6d000-01fcffff : Kernel bss
be3db000-be998fff : reserved
be999000-bed91fff : ACPI Non-volatile Storage
bed92000-bf156fff : reserved
bf157000-bf157fff : System RAM
bf158000-bf35dfff : ACPI Non-volatile Storage
bf35e000-bf7fffff : System RAM
bf800000-bfffffff : RAM buffer
c0000000-ffffffff : PCI Bus 0000:00
  c0000000-cfffffff : PCI Bus 0000:01
    c0000000-cfffffff : 0000:01:00.0
  d0000000-d00fffff : PCI Bus 0000:03
    d0000000-d0003fff : 0000:03:00.0
      d0000000-d0003fff : r8169
    d0004000-d0004fff : 0000:03:00.0
      d0004000-d0004fff : r8169
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : pnp 00:00
  f8000000-fbffffff : reserved
    f8000000-fbffffff : GART
  fe700000-fe7fffff : PCI Bus 0000:05
    fe700000-fe7007ff : 0000:05:0e.0
      fe700000-fe7007ff : firewire_ohci
  fe800000-fe8fffff : PCI Bus 0000:04
    fe800000-fe807fff : 0000:04:00.0
      fe800000-fe807fff : xhci_hcd
  fe900000-fe9fffff : PCI Bus 0000:02
    fe900000-fe907fff : 0000:02:00.0
      fe900000-fe907fff : xhci_hcd
  fea00000-feafffff : PCI Bus 0000:01
    fea00000-fea1ffff : 0000:01:00.0
    fea20000-fea3ffff : 0000:01:00.0
    fea40000-fea43fff : 0000:01:00.1
      fea40000-fea43fff : ICH HD audio
  feb00000-feb03fff : 0000:00:14.2
    feb00000-feb03fff : ICH HD audio
  feb04000-feb040ff : 0000:00:16.2
    feb04000-feb040ff : ehci_hcd
  feb05000-feb05fff : 0000:00:16.0
    feb05000-feb05fff : ohci_hcd
  feb06000-feb06fff : 0000:00:14.5
    feb06000-feb06fff : ohci_hcd
  feb07000-feb070ff : 0000:00:13.2
    feb07000-feb070ff : ehci_hcd
  feb08000-feb08fff : 0000:00:13.0
    feb08000-feb08fff : ohci_hcd
  feb09000-feb090ff : 0000:00:12.2
    feb09000-feb090ff : ehci_hcd
  feb0a000-feb0afff : 0000:00:12.0
    feb0a000-feb0afff : ohci_hcd
  feb0b000-feb0b3ff : 0000:00:11.0
    feb0b000-feb0b3ff : ahci
  fec00000-fec00fff : reserved
    fec00000-fec003ff : IOAPIC 0
  fec10000-fec10fff : reserved
    fec10000-fec10fff : pnp 00:01
  fec20000-fec20fff : reserved
    fec20000-fec203ff : IOAPIC 1
  fed00000-fed00fff : reserved
    fed00000-fed00fff : pnp 00:01
      fed00000-fed003ff : HPET 0
  fed61000-fed70fff : reserved
    fed61000-fed70fff : pnp 00:01
  fed80000-fed8ffff : reserved
    fed80000-fed8ffff : pnp 00:01
      fed80b00-fed80b07 : SB800 TCO
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:01
  fef00000-ffffffff : reserved
    ffc00000-ffffffff : pnp 00:01
100001000-13effffff : System RAM
13f000000-13fffffff : RAM buffer

sudo lspci -vvv -----------------------------------------------

00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (external gfx0 port B) (rev 02)
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (external gfx0 port B)
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Capabilities: [f0] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=20 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b+
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: [e]
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [70] MSI: Enable- Count=1/4 Maskable- 64bit-
		Address: 00000000  Data: 0000

00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port B) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fea00000-feafffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <1us, L1 <8us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #2, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [190 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port D) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fe900000-fe9fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x2, ASPM L0s L1, Latency L0 <1us, L1 <8us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #4, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [190 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (PCI express gpp port H) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #9, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [190 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI bridge (external gfx1 port A) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fe800000-fe8fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #10, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [190 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40) (prog-if 01 [AHCI 1.0])
	Subsystem: Gigabyte Technology Co., Ltd Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at f090 [size=8]
	Region 1: I/O ports at f080 [size=4]
	Region 2: I/O ports at f070 [size=8]
	Region 3: I/O ports at f060 [size=4]
	Region 4: I/O ports at f050 [size=16]
	Region 5: Memory at feb0b000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] SATA HBA v1.0 InCfgSpace
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at feb0a000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at feb09000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci-pci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at feb08000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at feb07000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci-pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller (rev 42)
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: piix4_smbus

00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 IDE Controller (rev 40) (prog-if 8a [Master SecP PriP])
	Subsystem: Gigabyte Technology Co., Ltd Device 5002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at f000 [size=16]
	Kernel driver in use: pata_atiixp

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 Azalia (Intel HDA) (rev 40)
	Subsystem: Gigabyte Technology Co., Ltd Device a132
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at feb00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 LPC host controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fe700000-fe7fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at feb06000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at feb05000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at feb04000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci-pci

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 0
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b+
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [e]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 1
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 2
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 3
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 4
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: fam15h_power

00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor Function 5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Turks XT [Radeon HD 6670/7670] (prog-if 00 [VGA controller])
	Subsystem: PC Partner Limited / Sapphire Technology Device e198
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 75
	Region 0: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at fea20000 (64-bit, non-prefetchable) [size=128K]
	Region 4: I/O ports at e000 [size=256]
	Expansion ROM at fea00000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee3f00c  Data: 4162
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: radeon

01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Turks/Whistler HDMI Audio [Radeon HD 6000 Series]
	Subsystem: PC Partner Limited / Sapphire Technology Device aa90
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 76
	Region 0: Memory at fea40000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee3f00c  Data: 4192
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: snd_hda_intel

02:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host Controller (rev 01) (prog-if 30 [XHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5007
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 72
	Region 0: Memory at fe900000 (64-bit, non-prefetchable) [size=32K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable+ Count=1/4 Maskable+ 64bit+
		Address: 00000000fee0300c  Data: 41b1
		Masking: 0000000e  Pending: 00000000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [190 v1] Device Serial Number 01-01-01-01-01-01-01-01
	Kernel driver in use: xhci_hcd

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
	Subsystem: Gigabyte Technology Co., Ltd Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 74
	Region 0: I/O ports at d000 [size=256]
	Region 2: Memory at d0004000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at d0000000 (64-bit, prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0400c  Data: 4122
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
	Kernel driver in use: r8169

04:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host Controller (rev 01) (prog-if 30 [XHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device 5007
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 73
	Region 0: Memory at fe800000 (64-bit, non-prefetchable) [size=32K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable+ Count=1/4 Maskable+ 64bit+
		Address: 00000000fee3f00c  Data: 41c1
		Masking: 0000000e  Pending: 00000000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [190 v1] Device Serial Number 01-01-01-01-01-01-01-01
	Kernel driver in use: xhci_hcd

05:0e.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd GA-7VT600-1394 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (8000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fe700000 (32-bit, non-prefetchable) [size=2K]
	Region 1: I/O ports at c000 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: firewire_ohci

/proc/scsi/scsi -----------------------------------------------

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AZLX-0 Rev: 80.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3200BUDT-6 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD6400BEVT-2 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: CDDVDW SH-224DB  Rev: SB00
  Type:   CD-ROM                           ANSI  SCSI revision: 05

dmesg -----------------------------------------------

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0-12-generic (buildd@allspice) (gcc version 4.8.1 (Ubuntu/Linaro 4.8.1-10ubuntu7) ) #19-Ubuntu SMP Wed Oct 9 16:20:46 UTC 2013 (Ubuntu 3.11.0-12.19-generic 3.11.3)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0-12-generic root=UUID=8986b034-d68c-4c67-9007-67005e5876ed ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000be3dafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000be3db000-0x00000000be998fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000be999000-0x00000000bed91fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bed92000-0x00000000bf156fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf157000-0x00000000bf157fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf158000-0x00000000bf35dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf35e000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000013effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by O.E.M./990XA-UD3, BIOS FD 02/04/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x13f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000BF800000 mask FFFFFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000013f000000 aka 5104M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3064MB, range: 8MB, type UC
[    0.000000] total RAM covered: 3064M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3064MB, range: 8MB, type UC
[    0.000000] e820: update [mem 0xbf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd850-0x000fd85f] mapped at [ffff8800000fd850]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fd1000, 0x01fd1fff] PGTABLE
[    0.000000] BRK [0x01fd2000, 0x01fd2fff] PGTABLE
[    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13ee00000-0x13effffff]
[    0.000000]  [mem 0x13ee00000-0x13effffff] page 2M
[    0.000000] BRK [0x01fd4000, 0x01fd4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13edfffff]
[    0.000000]  [mem 0x13c000000-0x13edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100001000-0x13bffffff]
[    0.000000]  [mem 0x100001000-0x1001fffff] page 4k
[    0.000000]  [mem 0x100200000-0x13bffffff] page 2M
[    0.000000] BRK [0x01fd5000, 0x01fd5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbe3dafff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbe1fffff] page 2M
[    0.000000]  [mem 0xbe200000-0xbe3dafff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf157000-0xbf157fff]
[    0.000000]  [mem 0xbf157000-0xbf157fff] page 4k
[    0.000000] BRK [0x01fd6000, 0x01fd6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbf35e000-0xbf7fffff]
[    0.000000]  [mem 0xbf35e000-0xbf3fffff] page 4k
[    0.000000]  [mem 0xbf400000-0xbf7fffff] page 2M
[    0.000000] RAMDISK: [mem 0x34e9a000-0x36744fff]
[    0.000000] ACPI: RSDP 00000000000f0490 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000bed75070 00064 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000bed7b818 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20130517/tbfadt-603)
[    0.000000] ACPI: DSDT 00000000bed75170 066A3 (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bed8cf80 00040
[    0.000000] ACPI: APIC 00000000bed7b910 0008E (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 00000000bed7b9a0 00044 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000bed7b9e8 0003C (v01 ALASKA    A M I 01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 00000000bed7ba28 00038 (v01 ALASKA    A M I 01072009 AMI  00000005)
[    0.000000] ACPI: BGRT 00000000bed7ba60 00038 (v00 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000bed7ba98 01158 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: MATS 00000000bed7cbf0 00034 (v02 ALASKA    A M I 00000002 w?x2 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013effffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13effffff]
[    0.000000]   NODE_DATA [mem 0x13eff8000-0x13effcfff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013a600000-ffff88013e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xbe3dafff]
[    0.000000]   node   0: [mem 0xbf157000-0xbf157fff]
[    0.000000]   node   0: [mem 0xbf35e000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100001000-0x13effffff]
[    0.000000] On node 0 totalpages: 1038362
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12130 pages used for memmap
[    0.000000]   DMA32 zone: 776318 pages, LIFO batch:31
[    0.000000]   Normal zone: 4032 pages used for memmap
[    0.000000]   Normal zone: 258047 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 7, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec20000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 8, version 33, address 0xfec20000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbe3db000-0xbe998fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbe999000-0xbed91fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbed92000-0xbf156fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf158000-0xbf35dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfec1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec20000-0xfec20fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec21000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed60fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed61000-0xfed70fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed71000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x100000000-0x100000fff]
[    0.000000] e820: [mem 0xbf800000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88013ec00000 s86720 r8192 d23872 u262144
[    0.000000] pcpu-alloc: s86720 r8192 d23872 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1022115
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0-12-generic root=UUID=8986b034-d68c-4c67-9007-67005e5876ed ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ f8000000 size 64 MB
[    0.000000] Memory: 3979316K/4153448K available (7141K kernel code, 1082K rwdata, 3260K rodata, 1364K init, 1420K bss, 174132K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=6.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-255.
[    0.000000] NR_IRQS:16640 nr_irqs:1272 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3515.843 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 7031.68 BogoMIPS (lpj=14063372)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000027] Security Framework initialized
[    0.000044] AppArmor: AppArmor initialized
[    0.000045] Yama: becoming mindful.
[    0.000296] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001306] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001739] Mount-cache hash table entries: 256
[    0.001889] Initializing cgroup subsys memory
[    0.001899] Initializing cgroup subsys devices
[    0.001900] Initializing cgroup subsys freezer
[    0.001901] Initializing cgroup subsys blkio
[    0.001902] Initializing cgroup subsys perf_event
[    0.001904] Initializing cgroup subsys hugetlb
[    0.001921] tseg: 00bf800000
[    0.001923] CPU: Physical Processor ID: 0
[    0.001924] CPU: Processor Core ID: 0
[    0.001925] mce: CPU supports 7 MCE banks
[    0.001932] LVT offset 1 assigned for vector 0xf9
[    0.001936] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.001936] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.001936] tlb_flushall_shift: 5
[    0.002010] Freeing SMP alternatives memory: 28K (ffffffff81e65000 - ffffffff81e6c000)
[    0.003383] ACPI: Core revision 20130517
[    0.005448] ACPI: All ACPI Tables successfully acquired
[    0.011194] ftrace: allocating 27796 entries in 109 pages
[    0.019796] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.059448] smpboot: CPU0: AMD FX(tm)-6300 Six-Core Processor (fam: 15, model: 02, stepping: 00)
[    0.163755] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.163759] ... version:                0
[    0.163760] ... bit width:              48
[    0.163761] ... generic registers:      6
[    0.163762] ... value mask:             0000ffffffffffff
[    0.163763] ... max period:             00007fffffffffff
[    0.163764] ... fixed-purpose events:   0
[    0.163765] ... event mask:             000000000000003f
[    0.165105] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.165170] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 OK
[    0.233789] Brought up 6 CPUs
[    0.233792] smpboot: Total of 6 processors activated (42190.11 BogoMIPS)
[    0.249552] devtmpfs: initialized
[    0.250787] EVM: security.selinux
[    0.250788] EVM: security.SMACK64
[    0.250789] EVM: security.capability
[    0.250862] PM: Registering ACPI NVS region [mem 0xbe999000-0xbed91fff] (4165632 bytes)
[    0.250922] PM: Registering ACPI NVS region [mem 0xbf158000-0xbf35dfff] (2121728 bytes)
[    0.251743] regulator-dummy: no parameters
[    0.251766] RTC time: 19:24:12, date: 11/02/13
[    0.251798] NET: Registered protocol family 16
[    0.251957] ACPI: bus type PCI registered
[    0.251959] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.252003] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.252005] PCI: not using MMCONFIG
[    0.252006] PCI: Using configuration type 1 for base access
[    0.252007] PCI: Using configuration type 1 for extended access
[    0.252975] bio: create slab <bio-0> at 0
[    0.253158] ACPI: Added _OSI(Module Device)
[    0.253159] ACPI: Added _OSI(Processor Device)
[    0.253161] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.253162] ACPI: Added _OSI(Processor Aggregator Device)
[    0.254121] ACPI: EC: Look up EC in DSDT
[    0.255596] ACPI: Executed 3 blocks of module-level executable AML code
[    0.260155] ACPI: Interpreter enabled
[    0.260161] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130517/hwxface-571)
[    0.260164] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    0.260178] ACPI: (supports S0 S3 S4 S5)
[    0.260180] ACPI: Using IOAPIC for interrupt routing
[    0.260310] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.260350] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.272824] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.272912] ACPI: No dock devices found.
[    0.282796] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.282801] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.282802] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.283182] PCI host bridge to bus 0000:00
[    0.283185] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.283187] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.283188] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.283190] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.283191] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.283193] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.283194] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.283196] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    0.283206] pci 0000:00:00.0: [1002:5a14] type 00 class 0x060000
[    0.283328] pci 0000:00:02.0: [1002:5a16] type 01 class 0x060400
[    0.283360] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.283418] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.283446] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    0.283477] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.283533] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.283562] pci 0000:00:09.0: [1002:5a1c] type 01 class 0x060400
[    0.283592] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.283652] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.283677] pci 0000:00:0a.0: [1002:5a1d] type 01 class 0x060400
[    0.283708] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.283765] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    0.283800] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.283815] pci 0000:00:11.0: reg 0x10: [io  0xf090-0xf097]
[    0.283822] pci 0000:00:11.0: reg 0x14: [io  0xf080-0xf083]
[    0.283830] pci 0000:00:11.0: reg 0x18: [io  0xf070-0xf077]
[    0.283837] pci 0000:00:11.0: reg 0x1c: [io  0xf060-0xf063]
[    0.283844] pci 0000:00:11.0: reg 0x20: [io  0xf050-0xf05f]
[    0.283852] pci 0000:00:11.0: reg 0x24: [mem 0xfeb0b000-0xfeb0b3ff]
[    0.283957] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.283968] pci 0000:00:12.0: reg 0x10: [mem 0xfeb0a000-0xfeb0afff]
[    0.284061] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.284090] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.284105] pci 0000:00:12.2: reg 0x10: [mem 0xfeb09000-0xfeb090ff]
[    0.284166] pci 0000:00:12.2: supports D1 D2
[    0.284168] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.284225] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.284254] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.284264] pci 0000:00:13.0: reg 0x10: [mem 0xfeb08000-0xfeb08fff]
[    0.284358] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.284387] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.284402] pci 0000:00:13.2: reg 0x10: [mem 0xfeb07000-0xfeb070ff]
[    0.284464] pci 0000:00:13.2: supports D1 D2
[    0.284465] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.284522] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.284551] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.284667] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
[    0.284677] pci 0000:00:14.1: reg 0x10: [io  0xf040-0xf047]
[    0.284684] pci 0000:00:14.1: reg 0x14: [io  0xf030-0xf033]
[    0.284691] pci 0000:00:14.1: reg 0x18: [io  0xf020-0xf027]
[    0.284699] pci 0000:00:14.1: reg 0x1c: [io  0xf010-0xf013]
[    0.284706] pci 0000:00:14.1: reg 0x20: [io  0xf000-0xf00f]
[    0.284798] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.284814] pci 0000:00:14.2: reg 0x10: [mem 0xfeb00000-0xfeb03fff 64bit]
[    0.284864] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.284919] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.284945] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.285063] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.285139] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.285164] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.285174] pci 0000:00:14.5: reg 0x10: [mem 0xfeb06000-0xfeb06fff]
[    0.285266] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.285294] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.285304] pci 0000:00:16.0: reg 0x10: [mem 0xfeb05000-0xfeb05fff]
[    0.285397] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.285426] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.285440] pci 0000:00:16.2: reg 0x10: [mem 0xfeb04000-0xfeb040ff]
[    0.285502] pci 0000:00:16.2: supports D1 D2
[    0.285504] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.285561] pci 0000:00:16.2: System wakeup disabled by ACPI
[    0.285589] pci 0000:00:18.0: [1022:1600] type 00 class 0x060000
[    0.285668] pci 0000:00:18.1: [1022:1601] type 00 class 0x060000
[    0.285747] pci 0000:00:18.2: [1022:1602] type 00 class 0x060000
[    0.285824] pci 0000:00:18.3: [1022:1603] type 00 class 0x060000
[    0.285904] pci 0000:00:18.4: [1022:1604] type 00 class 0x060000
[    0.285978] pci 0000:00:18.5: [1022:1605] type 00 class 0x060000
[    0.286097] pci 0000:01:00.0: [1002:6758] type 00 class 0x030000
[    0.286111] pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.286122] pci 0000:01:00.0: reg 0x18: [mem 0xfea20000-0xfea3ffff 64bit]
[    0.286129] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.286142] pci 0000:01:00.0: reg 0x30: [mem 0xfea00000-0xfea1ffff pref]
[    0.286175] pci 0000:01:00.0: supports D1 D2
[    0.286213] pci 0000:01:00.1: [1002:aa90] type 00 class 0x040300
[    0.286227] pci 0000:01:00.1: reg 0x10: [mem 0xfea40000-0xfea43fff 64bit]
[    0.286287] pci 0000:01:00.1: supports D1 D2
[    0.291682] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.291686] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.291688] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.291691] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.291738] pci 0000:02:00.0: [1b6f:7023] type 00 class 0x0c0330
[    0.291752] pci 0000:02:00.0: reg 0x10: [mem 0xfe900000-0xfe907fff 64bit]
[    0.291817] pci 0000:02:00.0: supports D1 D2
[    0.291819] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.299672] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.299677] pci 0000:00:04.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.299731] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.299743] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.299763] pci 0000:03:00.0: reg 0x18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    0.299776] pci 0000:03:00.0: reg 0x20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.299827] pci 0000:03:00.0: supports D1 D2
[    0.299829] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.299858] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.307662] pci 0000:00:09.0: PCI bridge to [bus 03]
[    0.307666] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.307670] pci 0000:00:09.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.307714] pci 0000:04:00.0: [1b6f:7023] type 00 class 0x0c0330
[    0.307729] pci 0000:04:00.0: reg 0x10: [mem 0xfe800000-0xfe807fff 64bit]
[    0.307794] pci 0000:04:00.0: supports D1 D2
[    0.307796] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.315658] pci 0000:00:0a.0: PCI bridge to [bus 04]
[    0.315663] pci 0000:00:0a.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.315714] pci 0000:05:0e.0: [1106:3044] type 00 class 0x0c0010
[    0.315733] pci 0000:05:0e.0: reg 0x10: [mem 0xfe700000-0xfe7007ff]
[    0.315743] pci 0000:05:0e.0: reg 0x14: [io  0xc000-0xc07f]
[    0.315819] pci 0000:05:0e.0: supports D2
[    0.315821] pci 0000:05:0e.0: PME# supported from D2 D3hot D3cold
[    0.315874] pci 0000:00:14.4: PCI bridge to [bus 05] (subtractive decode)
[    0.315877] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.315880] pci 0000:00:14.4:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.315884] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.315885] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.315886] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.315888] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.315889] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.315891] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.315892] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.316371] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.316440] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.316510] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.316578] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 14 15) *0
[    0.316636] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 10 11 14 15) *0
[    0.316681] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 10 11 14 15) *0
[    0.316727] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 14 15) *0
[    0.316772] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 10 11 14 15) *0
[    0.316883] ACPI: \_SB_.PCI0: notify handler is installed
[    0.316920] Found 1 acpi root devices
[    0.317002] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.317004] vgaarb: loaded
[    0.317005] vgaarb: bridge control possible 0000:01:00.0
[    0.317151] SCSI subsystem initialized
[    0.317152] ACPI: bus type ATA registered
[    0.317208] libata version 3.00 loaded.
[    0.317222] ACPI: bus type USB registered
[    0.317235] usbcore: registered new interface driver usbfs
[    0.317242] usbcore: registered new interface driver hub
[    0.317268] usbcore: registered new device driver usb
[    0.317393] PCI: Using ACPI for IRQ routing
[    0.323675] PCI: pci_cache_line_size set to 64 bytes
[    0.323729] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.323731] e820: reserve RAM buffer [mem 0xbe3db000-0xbfffffff]
[    0.323732] e820: reserve RAM buffer [mem 0xbf158000-0xbfffffff]
[    0.323733] e820: reserve RAM buffer [mem 0xbf800000-0xbfffffff]
[    0.323734] e820: reserve RAM buffer [mem 0x13f000000-0x13fffffff]
[    0.323800] NetLabel: Initializing
[    0.323801] NetLabel:  domain hash size = 128
[    0.323802] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.323810] NetLabel:  unlabeled traffic allowed by default
[    0.323858] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.323861] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.325919] Switched to clocksource hpet
[    0.331063] AppArmor: AppArmor Filesystem Enabled
[    0.331078] pnp: PnP ACPI init
[    0.331087] ACPI: bus type PNP registered
[    0.331167] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.331170] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.331449] system 00:01: [io  0x040b] has been reserved
[    0.331451] system 00:01: [io  0x04d6] has been reserved
[    0.331453] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.331455] system 00:01: [io  0x0c14] has been reserved
[    0.331457] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.331458] system 00:01: [io  0x0c52] has been reserved
[    0.331460] system 00:01: [io  0x0c6c] has been reserved
[    0.331461] system 00:01: [io  0x0c6f] has been reserved
[    0.331463] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.331464] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.331466] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.331467] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.331469] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.331470] system 00:01: [io  0x0800-0x089f] could not be reserved
[    0.331472] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.331474] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.331475] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.331477] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.331479] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.331481] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.331483] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.331485] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.331487] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.331488] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.331490] system 00:01: [mem 0xffc00000-0xffffffff] has been reserved
[    0.331492] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.331640] system 00:02: [io  0x0220-0x0227] has been reserved
[    0.331642] system 00:02: [io  0x0228-0x0237] has been reserved
[    0.331644] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.331646] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.331910] pnp 00:03: [dma 0 disabled]
[    0.331948] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.331958] pnp 00:04: [dma 4]
[    0.331973] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.331996] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.332018] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.332067] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.332069] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.332091] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.332124] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.332253] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.332369] system 00:0b: [mem 0xfec20000-0xfec200ff] could not be reserved
[    0.332371] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.332511] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.332516] pnp: PnP ACPI: found 13 devices
[    0.332517] ACPI: bus type PNP unregistered
[    0.338674] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.338677] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.338680] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.338682] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.338685] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.338688] pci 0000:00:04.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.338691] pci 0000:00:09.0: PCI bridge to [bus 03]
[    0.338693] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.338696] pci 0000:00:09.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.338699] pci 0000:00:0a.0: PCI bridge to [bus 04]
[    0.338702] pci 0000:00:0a.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.338705] pci 0000:00:14.4: PCI bridge to [bus 05]
[    0.338708] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.338711] pci 0000:00:14.4:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.338954] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.338956] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.338957] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.338959] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.338960] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.338962] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.338963] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xffffffff]
[    0.338965] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.338966] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.338968] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.338969] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.338971] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.338972] pci_bus 0000:03: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.338974] pci_bus 0000:04: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.338975] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.338977] pci_bus 0000:05: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.338978] pci_bus 0000:05: resource 4 [io  0x0000-0x03af]
[    0.338979] pci_bus 0000:05: resource 5 [io  0x03e0-0x0cf7]
[    0.338981] pci_bus 0000:05: resource 6 [io  0x03b0-0x03df]
[    0.338982] pci_bus 0000:05: resource 7 [io  0x0d00-0xffff]
[    0.338983] pci_bus 0000:05: resource 8 [mem 0x000a0000-0x000bffff]
[    0.338985] pci_bus 0000:05: resource 9 [mem 0x000c0000-0x000dffff]
[    0.338986] pci_bus 0000:05: resource 10 [mem 0xc0000000-0xffffffff]
[    0.339007] NET: Registered protocol family 2
[    0.339160] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    0.339289] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.339391] TCP: Hash tables configured (established 32768 bind 32768)
[    0.339419] TCP: reno registered
[    0.339426] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.339446] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.339504] NET: Registered protocol family 1
[    0.677851] pci 0000:01:00.0: Boot video device
[    0.677968] PCI: CLS 64 bytes, default 64
[    0.678012] Trying to unpack rootfs image as initramfs...
[    1.015971] Freeing initrd memory: 25260K (ffff880034e9a000 - ffff880036745000)
[    1.016214] PCI-DMA: Disabling AGP.
[    1.016291] PCI-DMA: aperture base @ f8000000 size 65536 KB
[    1.016293] init_memory_mapping: [mem 0xf8000000-0xfbffffff]
[    1.016295]  [mem 0xf8000000-0xfbffffff] page 2M
[    1.016303] PCI-DMA: using GART IOMMU.
[    1.016305] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.020740] perf: AMD NB counters detected
[    1.020772] LVT offset 0 assigned for vector 0x400
[    1.020795] perf: AMD IBS detected (0x000000ff)
[    1.020821] Scanning for low memory corruption every 60 seconds
[    1.021072] Initialise module verification
[    1.021104] audit: initializing netlink socket (disabled)
[    1.021112] type=2000 audit(1383420252.900:1): initialized
[    1.042409] bounce pool size: 64 pages
[    1.042418] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.043523] zbud: loaded
[    1.043624] VFS: Disk quotas dquot_6.5.2
[    1.043656] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.044085] fuse init (API version 7.22)
[    1.044147] msgmni has been set to 7950
[    1.044713] Key type asymmetric registered
[    1.044714] Asymmetric key parser 'x509' registered
[    1.044739] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.044788] io scheduler noop registered
[    1.044789] io scheduler deadline registered (default)
[    1.044809] io scheduler cfq registered
[    1.044960] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.044971] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.045064] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.045068] ACPI: Power Button [PWRB]
[    1.045097] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.045099] ACPI: Power Button [PWRF]
[    1.045135] ACPI: acpi_idle registered with cpuidle
[    1.045810] GHES: HEST is not enabled!
[    1.045945] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.066372] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.068849] Linux agpgart interface v0.103
[    1.071362] brd: module loaded
[    1.072834] loop: module loaded
[    1.073583] libphy: Fixed MDIO Bus: probed
[    1.073768] tun: Universal TUN/TAP device driver, 1.6
[    1.073771] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.073849] PPP generic driver version 2.4.2
[    1.073918] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.073921] ehci-pci: EHCI PCI platform driver
[    1.074145] ehci-pci 0000:00:12.2: EHCI Host Controller
[    1.074157] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.074178] QUIRK: Enable AMD PLL fix
[    1.074181] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.074196] ehci-pci 0000:00:12.2: debug port 1
[    1.074252] ehci-pci 0000:00:12.2: irq 17, io mem 0xfeb09000
[    1.085351] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.085369] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.085371] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.085373] usb usb1: Product: EHCI Host Controller
[    1.085374] usb usb1: Manufacturer: Linux 3.11.0-12-generic ehci_hcd
[    1.085375] usb usb1: SerialNumber: 0000:00:12.2
[    1.085459] hub 1-0:1.0: USB hub found
[    1.085462] hub 1-0:1.0: 5 ports detected
[    1.085629] ehci-pci 0000:00:13.2: EHCI Host Controller
[    1.085633] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.085636] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.085644] ehci-pci 0000:00:13.2: debug port 1
[    1.085665] ehci-pci 0000:00:13.2: irq 17, io mem 0xfeb07000
[    1.097327] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.097340] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.097341] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.097343] usb usb2: Product: EHCI Host Controller
[    1.097344] usb usb2: Manufacturer: Linux 3.11.0-12-generic ehci_hcd
[    1.097345] usb usb2: SerialNumber: 0000:00:13.2
[    1.097426] hub 2-0:1.0: USB hub found
[    1.097429] hub 2-0:1.0: 5 ports detected
[    1.097584] ehci-pci 0000:00:16.2: EHCI Host Controller
[    1.097590] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 3
[    1.097592] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.097601] ehci-pci 0000:00:16.2: debug port 1
[    1.097619] ehci-pci 0000:00:16.2: irq 17, io mem 0xfeb04000
[    1.109317] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.109329] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.109331] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.109332] usb usb3: Product: EHCI Host Controller
[    1.109333] usb usb3: Manufacturer: Linux 3.11.0-12-generic ehci_hcd
[    1.109335] usb usb3: SerialNumber: 0000:00:16.2
[    1.109416] hub 3-0:1.0: USB hub found
[    1.109419] hub 3-0:1.0: 4 ports detected
[    1.109491] ehci-platform: EHCI generic platform driver
[    1.109497] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.109498] ohci-platform: OHCI generic platform driver
[    1.109503] uhci_hcd: USB Universal Host Controller Interface driver
[    1.109558] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    1.109561] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 4
[    1.109646] xhci_hcd 0000:02:00.0: irq 72 for MSI/MSI-X
[    1.109685] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    1.109687] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.109688] usb usb4: Product: xHCI Host Controller
[    1.109689] usb usb4: Manufacturer: Linux 3.11.0-12-generic xhci_hcd
[    1.109691] usb usb4: SerialNumber: 0000:02:00.0
[    1.109742] xHCI xhci_add_endpoint called for root hub
[    1.109743] xHCI xhci_check_bandwidth called for root hub
[    1.109759] hub 4-0:1.0: USB hub found
[    1.109764] hub 4-0:1.0: 2 ports detected
[    1.109813] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    1.109816] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 5
[    1.109837] usb usb5: New USB device found, idVendor=1d6b, idProduct=0003
[    1.109838] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.109840] usb usb5: Product: xHCI Host Controller
[    1.109841] usb usb5: Manufacturer: Linux 3.11.0-12-generic xhci_hcd
[    1.109842] usb usb5: SerialNumber: 0000:02:00.0
[    1.109890] xHCI xhci_add_endpoint called for root hub
[    1.109891] xHCI xhci_check_bandwidth called for root hub
[    1.109907] hub 5-0:1.0: USB hub found
[    1.109911] hub 5-0:1.0: 2 ports detected
[    1.117385] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    1.117390] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 6
[    1.117473] xhci_hcd 0000:04:00.0: irq 73 for MSI/MSI-X
[    1.117513] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    1.117515] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.117516] usb usb6: Product: xHCI Host Controller
[    1.117518] usb usb6: Manufacturer: Linux 3.11.0-12-generic xhci_hcd
[    1.117519] usb usb6: SerialNumber: 0000:04:00.0
[    1.117575] xHCI xhci_add_endpoint called for root hub
[    1.117577] xHCI xhci_check_bandwidth called for root hub
[    1.117592] hub 6-0:1.0: USB hub found
[    1.117596] hub 6-0:1.0: 2 ports detected
[    1.117646] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    1.117649] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 7
[    1.117666] usb usb7: New USB device found, idVendor=1d6b, idProduct=0003
[    1.117668] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.117669] usb usb7: Product: xHCI Host Controller
[    1.117670] usb usb7: Manufacturer: Linux 3.11.0-12-generic xhci_hcd
[    1.117672] usb usb7: SerialNumber: 0000:04:00.0
[    1.117721] xHCI xhci_add_endpoint called for root hub
[    1.117723] xHCI xhci_check_bandwidth called for root hub
[    1.117738] hub 7-0:1.0: USB hub found
[    1.117742] hub 7-0:1.0: 2 ports detected
[    1.125377] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.125746] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.125756] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.125900] mousedev: PS/2 mouse device common for all mice
[    1.126102] rtc_cmos 00:05: RTC can wake from S4
[    1.126252] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.126278] rtc_cmos 00:05: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.126402] device-mapper: uevent: version 1.0.3
[    1.126509] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
[    1.126665] cpuidle: using governor ladder
[    1.126905] cpuidle: using governor menu
[    1.126925] ledtrig-cpu: registered to indicate activity on CPUs
[    1.127082] TCP: cubic registered
[    1.127270] NET: Registered protocol family 10
[    1.127639] NET: Registered protocol family 17
[    1.127652] Key type dns_resolver registered
[    1.128498] PM: Hibernation image not present or could not be loaded.
[    1.128504] Loading module verification certificates
[    1.130517] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: fddf6943d8ac4f5b6eb0919a7a3ee3d9088b1bfa'
[    1.130534] registered taskstats version 1
[    1.135270] Key type trusted registered
[    1.139281] Key type encrypted registered
[    1.143304] AppArmor: AppArmor sha1 policy hashing enabled
[    1.143626]   Magic number: 5:570:444
[    1.143690] rtc_cmos 00:05: setting system clock to 2013-11-02 19:24:13 UTC (1383420253)
[    1.143806] acpi-cpufreq: overriding BIOS provided _PSD data
[    1.144104] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.144105] EDD information not available.
[    1.145065] Freeing unused kernel memory: 1364K (ffffffff81d10000 - ffffffff81e65000)
[    1.145067] Write protecting the kernel read-only data: 12288k
[    1.147481] Freeing unused kernel memory: 1040K (ffff8800016fc000 - ffff880001800000)
[    1.149290] Freeing unused kernel memory: 836K (ffff880001b2f000 - ffff880001c00000)
[    1.161786] systemd-udevd[131]: starting version 204
[    1.172263] wmi: Mapper loaded
[    1.176772] mii: module verification failed: signature and/or required key missing - tainting kernel
[    1.177894] ahci 0000:00:11.0: version 3.0
[    1.178065] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps 0xf impl SATA mode
[    1.178067] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[    1.178481] scsi0 : ahci
[    1.178583] scsi1 : ahci
[    1.178647] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.178658] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    1.178756] scsi2 : ahci
[    1.178828] scsi3 : ahci
[    1.178875] r8169 0000:03:00.0: irq 74 for MSI/MSI-X
[    1.178893] ata1: SATA max UDMA/133 abar m1024@0xfeb0b000 port 0xfeb0b100 irq 19
[    1.178898] ata2: SATA max UDMA/133 abar m1024@0xfeb0b000 port 0xfeb0b180 irq 19
[    1.178900] ata3: SATA max UDMA/133 abar m1024@0xfeb0b000 port 0xfeb0b200 irq 19
[    1.178903] ata4: SATA max UDMA/133 abar m1024@0xfeb0b000 port 0xfeb0b280 irq 19
[    1.179061] r8169 0000:03:00.0 eth0: RTL8168evl/8111evl at 0xffffc90000646000, 94:de:80:bf:d1:e3, XID 0c900800 IRQ 74
[    1.179064] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    1.181063] scsi4 : pata_atiixp
[    1.181540] scsi5 : pata_atiixp
[    1.181759] [drm] Initialized drm 1.1.0 20060810
[    1.181999] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    1.182002] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    1.203824] [drm] radeon kernel modesetting enabled.
[    1.204051] [drm] initializing kernel modesetting (TURKS 0x1002:0x6758 0x174B:0xE198).
[    1.204066] [drm] register mmio base: 0xFEA20000
[    1.204067] [drm] register mmio size: 131072
[    1.204127] ATOM BIOS: AMD
[    1.204254] radeon 0000:01:00.0: VRAM: 2048M 0x0000000000000000 - 0x000000007FFFFFFF (2048M used)
[    1.204256] radeon 0000:01:00.0: GTT: 512M 0x0000000080000000 - 0x000000009FFFFFFF
[    1.204257] [drm] Detected VRAM RAM=2048M, BAR=256M
[    1.204258] [drm] RAM width 128bits DDR
[    1.204317] [TTM] Zone  kernel: Available graphics memory: 2036898 kiB
[    1.204318] [TTM] Initializing pool allocator
[    1.204322] [TTM] Initializing DMA pool allocator
[    1.204336] [drm] radeon: 2048M of VRAM memory ready
[    1.204337] [drm] radeon: 512M of GTT memory ready.
[    1.204533] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.204969] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[    1.216594] [drm] Loading TURKS Microcode
[    1.217855] [drm] PCIE GART of 512M enabled (table at 0x0000000000273000).
[    1.217965] radeon 0000:01:00.0: WB enabled
[    1.217967] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff880132fafc00
[    1.217969] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff880132fafc0c
[    1.219408] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000072118 and cpu addr 0xffffc90010cb2118
[    1.219410] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.219411] [drm] Driver supports precise vblank timestamp query.
[    1.219426] radeon 0000:01:00.0: irq 75 for MSI/MSI-X
[    1.219434] radeon 0000:01:00.0: radeon: using MSI.
[    1.219460] [drm] radeon: irq initialized.
[    1.235695] [drm] ring test on 0 succeeded in 3 usecs
[    1.235758] [drm] ring test on 3 succeeded in 1 usecs
[    1.253287] firewire_ohci 0000:05:0e.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x11
[    1.421258] [drm] ring test on 5 succeeded in 1 usecs
[    1.421262] [drm] UVD initialized successfully.
[    1.421412] [drm] ib test on ring 0 succeeded in 0 usecs
[    1.421461] [drm] ib test on ring 3 succeeded in 0 usecs
[    1.533005] usb 4-1: new low-speed USB device number 2 using xhci_hcd
[    1.566706] usb 4-1: New USB device found, idVendor=04b4, idProduct=0033
[    1.566709] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.566866] usb 4-1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.571030] hidraw: raw HID events driver (C) Jiri Kosina
[    1.572423] [drm] ib test on ring 5 succeeded
[    1.572724] [drm] Radeon Display Connectors
[    1.572726] [drm] Connector 0:
[    1.572727] [drm]   HDMI-A-1
[    1.572728] [drm]   HPD1
[    1.572729] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[    1.572730] [drm]   Encoders:
[    1.572731] [drm]     DFP1: INTERNAL_UNIPHY2
[    1.572731] [drm] Connector 1:
[    1.572732] [drm]   DVI-D-1
[    1.572733] [drm]   HPD4
[    1.572734] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0x645c 0x645c
[    1.572735] [drm]   Encoders:
[    1.572736] [drm]     DFP2: INTERNAL_UNIPHY
[    1.572736] [drm] Connector 2:
[    1.572737] [drm]   VGA-1
[    1.572738] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    1.572739] [drm]   Encoders:
[    1.572740] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.572820] [drm] Internal thermal controller with fan control
[    1.573682] [drm] radeon: power management initialized
[    1.583692] usbcore: registered new interface driver usbhid
[    1.583693] usbhid: USB HID core driver
[    1.585155] input: HID 04b4:0033 as /devices/pci0000:00/0000:00:04.0/0000:02:00.0/usb4/4-1/4-1:1.0/input/input2
[    1.585284] hid-generic 0003:04B4:0033.0001: input,hidraw0: USB HID v1.00 Mouse [HID 04b4:0033] on usb-0000:02:00.0-1/input0
[    1.608748] [drm] fb mappable at 0xC0375000
[    1.608749] [drm] vram apper at 0xC0000000
[    1.608750] [drm] size 7680000
[    1.608751] [drm] fb depth is 24
[    1.608752] [drm]    pitch is 6400
[    1.608816] fbcon: radeondrmfb (fb0) is primary device
[    1.668936] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.668960] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.668982] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.669007] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.669962] ata1.00: ATA-8: WDC WD5000AZLX-00K4KA0, 80.00A80, max UDMA/133
[    1.669966] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.670565] ata2.00: HPA detected: current 625142192, native 625142448
[    1.670571] ata2.00: ATA-8: WDC WD3200BUDT-63DPZY0, 01.01A01, max UDMA/133
[    1.670574] ata2.00: 625142192 sectors, multi 16: LBA48 
[    1.671113] ata3.00: ATA-8: WDC WD6400BEVT-22A0RT0, 01.01A01, max UDMA/133
[    1.671114] ata3.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.671127] ata4.00: ATAPI: TSSTcorp CDDVDW SH-224DB, SB00, max UDMA/100
[    1.671860] ata1.00: configured for UDMA/133
[    1.671946] ata4.00: configured for UDMA/100
[    1.671987] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AZLX-0 80.0 PQ: 0 ANSI: 5
[    1.672110] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.672111] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.672129] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.672214] sd 0:0:0:0: [sda] Write Protect is off
[    1.672216] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.672268] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.672897] ata2.00: configured for UDMA/133
[    1.672985] scsi 1:0:0:0: Direct-Access     ATA      WDC WD3200BUDT-6 01.0 PQ: 0 ANSI: 5
[    1.673116] sd 1:0:0:0: [sdb] 625142192 512-byte logical blocks: (320 GB/298 GiB)
[    1.673117] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.673148] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.673211] sd 1:0:0:0: [sdb] Write Protect is off
[    1.673212] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.673222] ata3.00: configured for UDMA/133
[    1.673250] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.673298] scsi 2:0:0:0: Direct-Access     ATA      WDC WD6400BEVT-2 01.0 PQ: 0 ANSI: 5
[    1.673460] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.673466] sd 2:0:0:0: [sdc] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
[    1.673565] sd 2:0:0:0: [sdc] Write Protect is off
[    1.673566] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.673604] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.674254] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-224DB  SB00 PQ: 0 ANSI: 5
[    1.676875] usb 4-2: new low-speed USB device number 3 using xhci_hcd
[    1.677067] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.677068] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.677163] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.677227] sr 3:0:0:0: Attached scsi generic sg3 type 5
[    1.727597] usb 4-2: New USB device found, idVendor=1c4f, idProduct=0026
[    1.727601] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.727603] usb 4-2: Product: USB Keyboard
[    1.727605] usb 4-2: Manufacturer: SIGMACHIP
[    1.727772] usb 4-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.727776] usb 4-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.740889] input: SIGMACHIP USB Keyboard as /devices/pci0000:00/0000:00:04.0/0000:02:00.0/usb4/4-2/4-2:1.0/input/input3
[    1.741056] hid-generic 0003:1C4F:0026.0002: input,hidraw1: USB HID v1.10 Keyboard [SIGMACHIP USB Keyboard] on usb-0000:02:00.0-2/input0
[    1.753019] firewire_core 0000:05:0e.0: created device fw0: GUID 0049e550673f0c00, S400
[    1.757551]  sdc: sdc1 sdc2 sdc3 < sdc5 sdc6 sdc7 >
[    1.758201] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.760777] input: SIGMACHIP USB Keyboard as /devices/pci0000:00/0000:00:04.0/0000:02:00.0/usb4/4-2/4-2:1.1/input/input4
[    1.760958] hid-generic 0003:1C4F:0026.0003: input,hidraw2: USB HID v1.10 Device [SIGMACHIP USB Keyboard] on usb-0000:02:00.0-2/input1
[    1.764809]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
[    1.764809]  sda1: <openbsd: sda10 sda11 sda12 sda13 sda14 sda15 sda16bad subpartition - ignored
[    1.764809] bad subpartition - ignored
[    1.764809]  sda17 sda18 sda19bad subpartition - ignored
[    1.764809]  >
[    1.765620] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.789174]  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 >
[    1.789174]  sdb2: <openbsd: sdb9 sdb10 sdb11 sdb12 sdb13 sdb14 sdb15bad subpartition - ignored
[    1.789174] bad subpartition - ignored
[    1.789174] bad subpartition - ignored
[    1.789174] bad subpartition - ignored
[    1.789174]  sdb16 sdb17 sdb18bad subpartition - ignored
[    1.789174]  >
[    1.789559] sdb: p8 size 19532464 extends beyond EOD, enabling native capacity
[    1.789579] ata2: hard resetting link
[    1.831009] Console: switching to colour frame buffer device 200x75
[    1.834244] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    1.834245] radeon 0000:01:00.0: registered panic notifier
[    1.834249] [drm] Initialized radeon 2.34.0 20080528 for 0000:01:00.0 on minor 0
[    2.016641] tsc: Refined TSC clocksource calibration: 3516.056 MHz
[    2.280437] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.287827] ata2.00: configured for UDMA/133
[    2.287836] ata2: EH complete
[    2.399799]  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 >
[    2.399799]  sdb2: <openbsd: sdb9 sdb10 sdb11 sdb12 sdb13 sdb14 sdb15bad subpartition - ignored
[    2.399799] bad subpartition - ignored
[    2.399799] bad subpartition - ignored
[    2.399799] bad subpartition - ignored
[    2.399799]  sdb16 sdb17 sdb18bad subpartition - ignored
[    2.399799]  >
[    2.400116] sdb: p8 size 19532464 extends beyond EOD, truncated
[    2.400776] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.015909] Switched to clocksource tsc
[    5.174002] raid6: sse2x1    7350 MB/s
[    5.241937] raid6: sse2x2   11400 MB/s
[    5.309890] raid6: sse2x4   13352 MB/s
[    5.309891] raid6: using algorithm sse2x4 (13352 MB/s)
[    5.309892] raid6: using ssse3x2 recovery algorithm
[    5.310229] xor: automatically using best checksumming function:
[    5.349855]    avx       :  4855.000 MB/sec
[    5.352729] bio: create slab <bio-1> at 1
[    5.352926] Btrfs loaded
[    6.193637] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[   20.299031] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.345366] systemd-udevd[348]: starting version 204
[   20.468526] lp: driver loaded but no devices found
[   20.513655] ohci-pci: OHCI PCI platform driver
[   20.513788] ohci-pci 0000:00:12.0: OHCI PCI host controller
[   20.513794] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 8
[   20.513822] ohci-pci 0000:00:12.0: irq 18, io mem 0xfeb0a000
[   20.538338] microcode: CPU0: patch_level=0x06000803
[   20.573585] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   20.573588] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   20.573602] usb usb8: Product: OHCI PCI host controller
[   20.573603] usb usb8: Manufacturer: Linux 3.11.0-12-generic ohci_hcd
[   20.573605] usb usb8: SerialNumber: 0000:00:12.0
[   20.573713] hub 8-0:1.0: USB hub found
[   20.573719] hub 8-0:1.0: 5 ports detected
[   20.573909] ohci-pci 0000:00:13.0: OHCI PCI host controller
[   20.573914] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 9
[   20.573926] ohci-pci 0000:00:13.0: irq 18, io mem 0xfeb08000
[   20.633505] usb usb9: New USB device found, idVendor=1d6b, idProduct=0001
[   20.633508] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   20.633510] usb usb9: Product: OHCI PCI host controller
[   20.633511] usb usb9: Manufacturer: Linux 3.11.0-12-generic ohci_hcd
[   20.633513] usb usb9: SerialNumber: 0000:00:13.0
[   20.633613] hub 9-0:1.0: USB hub found
[   20.633619] hub 9-0:1.0: 5 ports detected
[   20.633806] ohci-pci 0000:00:14.5: OHCI PCI host controller
[   20.633812] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 10
[   20.633824] ohci-pci 0000:00:14.5: irq 18, io mem 0xfeb06000
[   20.693448] usb usb10: New USB device found, idVendor=1d6b, idProduct=0001
[   20.693452] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   20.693454] usb usb10: Product: OHCI PCI host controller
[   20.693456] usb usb10: Manufacturer: Linux 3.11.0-12-generic ohci_hcd
[   20.693457] usb usb10: SerialNumber: 0000:00:14.5
[   20.693555] hub 10-0:1.0: USB hub found
[   20.693561] hub 10-0:1.0: 2 ports detected
[   20.693644] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   20.693795] ohci-pci 0000:00:16.0: OHCI PCI host controller
[   20.693802] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 11
[   20.693820] ohci-pci 0000:00:16.0: irq 18, io mem 0xfeb05000
[   20.694768] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   20.694813] sp5100_tco: PCI Revision ID: 0x42
[   20.694836] sp5100_tco: Using 0xfed80b00 for watchdog MMIO address
[   20.694846] sp5100_tco: Last reboot was not triggered by watchdog.
[   20.694879] sp5100_tco: initialized (0xffffc90010c3cb00). heartbeat=60 sec (nowayout=0)
[   20.753464] usb usb11: New USB device found, idVendor=1d6b, idProduct=0001
[   20.753467] usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   20.753469] usb usb11: Product: OHCI PCI host controller
[   20.753470] usb usb11: Manufacturer: Linux 3.11.0-12-generic ohci_hcd
[   20.753471] usb usb11: SerialNumber: 0000:00:16.0
[   20.753734] hub 11-0:1.0: USB hub found
[   20.753741] hub 11-0:1.0: 4 ports detected
[   20.753988] hda-intel 0000:00:14.2: Using LPIB position fix
[   20.757468] hda-intel 0000:00:14.2: Enable sync_write for stable communication
[   20.763630] SKU: Nid=0x1d sku_cfg=0x4005e601
[   20.763632] SKU: port_connectivity=0x1
[   20.763633] SKU: enable_pcbeep=0x0
[   20.763634] SKU: check_sum=0x00000005
[   20.763635] SKU: customization=0x000000e6
[   20.763636] SKU: external_amp=0x0
[   20.763637] SKU: platform_type=0x0
[   20.763638] SKU: swap=0x0
[   20.763639] SKU: override=0x1
[   20.764108] autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
[   20.764110]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   20.764112]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   20.764113]    mono: mono_out=0x0
[   20.764114]    dig-out=0x11/0x1e
[   20.764115]    inputs:
[   20.764117]      Front Mic=0x19
[   20.764119]      Rear Mic=0x18
[   20.764120]      Line=0x1a
[   20.764122] realtek: No valid SSID, checking pincfg 0x4005e601 for NID 0x1d
[   20.764123] realtek: Enabling init ASM_ID=0xe601 CODEC_ID=10ec0889
[   20.778427] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
[   20.778493] input: HDA ATI SB Line Out Side as /devices/pci0000:00/0000:00:14.2/sound/card0/input6
[   20.778550] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[   20.778605] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[   20.778659] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[   20.778710] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input10
[   20.778763] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input11
[   20.778815] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input12
[   20.779093] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
[   20.779095] hda-intel 0000:01:00.1: Using LPIB position fix
[   20.779128] snd_hda_intel 0000:01:00.1: irq 76 for MSI/MSI-X
[   20.781439] hda-intel 0000:01:00.1: Enable sync_write for stable communication
[   20.844971] MCE: In-kernel MCE decoding enabled.
[   20.914338] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input13
[   20.927365] EDAC MC: Ver: 3.0.0
[   20.991646] AMD64 EDAC driver v3.4.0
[   20.991668] EDAC amd64: DRAM ECC disabled.
[   20.991678] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[   20.991678]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[   20.991678]  (Note that use of the override may cause unknown side effects.)
[   21.207778] type=1400 audit(1383416673.576:2): apparmor="STATUS" operation="profile_load" parent=411 profile="unconfined" name="/sbin/dhclient" pid=415 comm="apparmor_parser"
[   21.207879] type=1400 audit(1383416673.576:3): apparmor="STATUS" operation="profile_load" parent=411 profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=415 comm="apparmor_parser"
[   21.207974] type=1400 audit(1383416673.576:4): apparmor="STATUS" operation="profile_load" parent=411 profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=415 comm="apparmor_parser"
[   21.295056] type=1400 audit(1383416673.664:5): apparmor="STATUS" operation="profile_replace" parent=439 profile="unconfined" name="/sbin/dhclient" pid=440 comm="apparmor_parser"
[   21.295141] type=1400 audit(1383416673.664:6): apparmor="STATUS" operation="profile_replace" parent=439 profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=440 comm="apparmor_parser"
[   21.295215] type=1400 audit(1383416673.664:7): apparmor="STATUS" operation="profile_replace" parent=439 profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=440 comm="apparmor_parser"
[   21.401639] microcode: CPU0: new patch_level=0x06000822
[   21.401652] microcode: CPU1: patch_level=0x06000803
[   21.401724] microcode: CPU2: patch_level=0x06000803
[   21.416420] microcode: CPU2: new patch_level=0x06000822
[   21.416433] microcode: CPU3: patch_level=0x06000803
[   21.416444] microcode: CPU4: patch_level=0x06000803
[   21.422724] microcode: CPU4: new patch_level=0x06000822
[   21.422743] microcode: CPU5: patch_level=0x06000803
[   21.422867] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   21.956896] init: Failed to obtain startpar-bridge instance: Unknown parameter: INSTANCE
[   22.304354] kvm: Nested Virtualization enabled
[   22.304359] kvm: Nested Paging enabled
[   22.770097] EXT4-fs (sdb1): re-mounted. Opts: errors=remount-ro
[   23.475028] FS-Cache: Loaded
[   23.478174] RPC: Registered named UNIX socket transport module.
[   23.478176] RPC: Registered udp transport module.
[   23.478178] RPC: Registered tcp transport module.
[   23.478179] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   23.481178] FS-Cache: Netfs 'nfs' registered for caching
[   23.484652] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   23.505042] init: failsafe main process (694) killed by TERM signal
[   24.524297] init: bluetooth main process (801) terminated with status 1
[   24.524315] init: bluetooth main process ended, respawning
[   24.541539] init: bluetooth main process (836) terminated with status 1
[   24.541557] init: bluetooth main process ended, respawning
[   24.558639] init: bluetooth main process (860) terminated with status 1
[   24.558660] init: bluetooth main process ended, respawning
[   24.574931] init: bluetooth main process (884) terminated with status 1
[   24.574948] init: bluetooth main process ended, respawning
[   24.591465] init: bluetooth main process (908) terminated with status 1
[   24.591483] init: bluetooth main process ended, respawning
[   24.608693] init: bluetooth main process (932) terminated with status 1
[   24.608712] init: bluetooth main process ended, respawning
[   24.625774] init: bluetooth main process (958) terminated with status 1
[   24.625793] init: bluetooth main process ended, respawning
[   24.644791] init: bluetooth main process (982) terminated with status 1
[   24.644811] init: bluetooth main process ended, respawning
[   24.660568] init: bluetooth main process (1006) terminated with status 1
[   24.660588] init: bluetooth main process ended, respawning
[   24.735580] init: bluetooth main process (1043) terminated with status 1
[   24.735603] init: bluetooth main process ended, respawning
[   24.823352] init: bluetooth main process (1067) terminated with status 1
[   24.823374] init: bluetooth respawning too fast, stopped
[   24.988066] init: avahi-cups-reload main process (1093) terminated with status 1
[   25.052105] type=1400 audit(1383416677.424:8): apparmor="STATUS" operation="profile_load" parent=1026 profile="unconfined" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-uccsconfigure/uccsconfigure-session-wrapper" pid=1034 comm="apparmor_parser"
[   25.052449] type=1400 audit(1383416677.424:9): apparmor="STATUS" operation="profile_load" parent=1026 profile="unconfined" name="chromium_browser" pid=1034 comm="apparmor_parser"
[   25.074875] ppdev: user-space parallel port driver
[   25.086286] type=1400 audit(1383416677.460:10): apparmor="STATUS" operation="profile_replace" parent=1026 profile="unconfined" name="/sbin/dhclient" pid=1035 comm="apparmor_parser"
[   25.086440] type=1400 audit(1383416677.460:11): apparmor="STATUS" operation="profile_replace" parent=1026 profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1035 comm="apparmor_parser"
[   27.090351] r8169 0000:03:00.0 eth0: link down
[   27.090395] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   27.090419] r8169 0000:03:00.0 eth0: link down
[   27.090617] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   28.042478] bio: create slab <bio-2> at 2
[   28.708271] r8169 0000:03:00.0 eth0: link up
[   28.708279] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   28.926670] Adding 7811068k swap on /dev/mapper/cryptswap1.  Priority:-1 extents:1 across:7811068k FS
[   29.415002] audit_printk_skb: 45 callbacks suppressed
[   29.415005] type=1400 audit(1383416681.792:27): apparmor="STATUS" operation="profile_load" parent=1026 profile="unconfined" name="/usr/bin/evince" pid=1037 comm="apparmor_parser"
[   29.415678] type=1400 audit(1383416681.792:28): apparmor="STATUS" operation="profile_load" parent=1026 profile="unconfined" name="sanitized_helper" pid=1037 comm="apparmor_parser"
[   29.416822] type=1400 audit(1383416681.792:29): apparmor="STATUS" operation="profile_load" parent=1026 profile="unconfined" name="/usr/bin/evince-previewer" pid=1037 comm="apparmor_parser"
[   29.417336] type=1400 audit(1383416681.792:30): apparmor="STATUS" operation="profile_load" parent=1026 profile="unconfined" name="sanitized_helper" pid=1037 comm="apparmor_parser"
[   29.418107] type=1400 audit(1383416681.792:31): apparmor="STATUS" operation="profile_load" parent=1026 profile="unconfined" name="/usr/bin/evince-thumbnailer" pid=1037 comm="apparmor_parser"
[   29.418543] type=1400 audit(1383416681.796:32): apparmor="STATUS" operation="profile_load" parent=1026 profile="unconfined" name="sanitized_helper" pid=1037 comm="apparmor_parser"
[   88.826392] ------------[ cut here ]------------
[   88.826421] WARNING: CPU: 4 PID: 0 at /build/buildd/linux-3.11.0/net/sched/sch_generic.c:260 dev_watchdog+0x26a/0x280()
[   88.826425] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
[   88.826428] Modules linked in: cuse dm_crypt(F) parport_pc(F) ppdev(F) binfmt_misc(F) nfsd(F) auth_rpcgss(F) nfs_acl(F) nfs(F) lockd(F) sunrpc(F) fscache(F) kvm_amd(F) kvm(F) crct10dif_pclmul(F) crc32_pclmul(F) ghash_clmulni_intel(F) aesni_intel(F) aes_x86_64(F) lrw(F) gf128mul(F) glue_helper(F) ablk_helper(F) cryptd(F) joydev(F) edac_core snd_hda_codec_hdmi edac_mce_amd snd_hda_codec_realtek sp5100_tco fam15h_power microcode(F) snd_hda_intel snd_hda_codec snd_hwdep(F) psmouse(F) serio_raw(F) k10temp snd_pcm(F) snd_page_alloc(F) i2c_piix4 ohci_pci snd_seq_midi(F) snd_seq_midi_event(F) snd_rawmidi(F) snd_seq(F) snd_seq_device(F) snd_timer(F) snd(F) soundcore(F) mac_hid lp(F) parport(F) btrfs(F) xor(F) zlib_deflate(F) raid6_pq(F) libcrc32c(F) pata_acpi hid_generic usbhid hid radeon mxm_wmi i2c_algo_bit ttm drm_kms_helper firewire_ohci firewire_core drm pata_atiixp crc_itu_t(F) r8169 ahci(F) libahci(F) mii(F) wmi
[   88.826547] CPU: 4 PID: 0 Comm: swapper/4 Tainted: GF            3.11.0-12-generic #19-Ubuntu
[   88.826555] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./990XA-UD3, BIOS FD 02/04/2013
[   88.826558]  0000000000000009 ffff88013ed03d90 ffffffff816e547a ffff88013ed03dd8
[   88.826571]  ffff88013ed03dc8 ffffffff81061dbd ffff880133188000 0000000000000000
[   88.826577]  0000000000000004 ffff8801336bf480 ffff8801336bf400 ffff88013ed03e28
[   88.826587] Call Trace:
[   88.826592]  <IRQ>  [<ffffffff816e547a>] dump_stack+0x45/0x56
[   88.826614]  [<ffffffff81061dbd>] warn_slowpath_common+0x7d/0xa0
[   88.826625]  [<ffffffff81061e2c>] warn_slowpath_fmt+0x4c/0x50
[   88.826647]  [<ffffffff8160e14a>] dev_watchdog+0x26a/0x280
[   88.826666]  [<ffffffff8160dee0>] ? dev_deactivate_queue.constprop.32+0x60/0x60
[   88.826681]  [<ffffffff8106e886>] call_timer_fn+0x36/0x110
[   88.826688]  [<ffffffff8160dee0>] ? dev_deactivate_queue.constprop.32+0x60/0x60
[   88.826709]  [<ffffffff8106f95d>] run_timer_softirq+0x1fd/0x2b0
[   88.826713]  [<ffffffff81067397>] __do_softirq+0xf7/0x240
[   88.826717]  [<ffffffff81067675>] irq_exit+0xb5/0xc0
[   88.826721]  [<ffffffff816f75c5>] smp_apic_timer_interrupt+0x45/0x60
[   88.826724]  [<ffffffff816f5f5d>] apic_timer_interrupt+0x6d/0x80
[   88.826725]  <EOI>  [<ffffffff8159e9ef>] ? cpuidle_enter_state+0x4f/0xc0
[   88.826732]  [<ffffffff8159eb29>] cpuidle_idle_call+0xc9/0x210
[   88.826736]  [<ffffffff8101bade>] arch_cpu_idle+0xe/0x30
[   88.826740]  [<ffffffff810b54ee>] cpu_startup_entry+0xce/0x280
[   88.826747]  [<ffffffff810bdd53>] ? clockevents_register_device+0xe3/0x150
[   88.826752]  [<ffffffff8103eef7>] start_secondary+0x217/0x2c0
[   88.826754] ---[ end trace 25f42642f3c790c5 ]---
[   88.840615] r8169 0000:03:00.0 eth0: link up
[  184.771123] r8169 0000:03:00.0 eth0: link up

