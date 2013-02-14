Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427Ab3BNA2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 19:28:05 -0500
Received: from mout.gmx.net ([212.227.15.19]:59016 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab3BNA2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 19:28:01 -0500
X-Authenticated: #51636571
X-Provags-ID: V01U2FsdGVkX1+2Ark4kFK2avGvUPApF1GJfhCRqAasJKCw6zBXt4
	FhIlmSG0jkB38Y
Message-ID: <511C2F86.1050702@gmx.com>
Date: Thu, 14 Feb 2013 08:27:50 +0800
From: Federico Vecchiarelli <fedev@gmx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: ATI vgaswitcheroo backlight issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:    ATI + I Muxed - vgaswitcheroo - low backlight when switching to ATI
[2.] Full description of the problem/report:

	This issue started with kernel 3.7.1-17.1. Kernels 3.6.10-3 or earlier are not affected. When switching from the integrated Intel to the discrete ATI, the screen goes dark.
Everything else works fine, you can see the screen if you point a flashlight to it. Changing the brightness with the Fn keys or by sending a value directly thru the /sys/class/backlight
branch has no effect. Switching back to the Intel GPU makes the screen visible again. Suse's desktop kernel and vanilla kernels have the same issue.

Have tried adding acpi_osi=Linux and acpi_backlight=vendor (or legacy) but made no difference.

[3.] Keywords (i.e., modules, networking, kernel): Hybrid, ATI, Intel, muxed, kernel, GPU, vgaswitcheroo
[4.] Kernel version (from /proc/version):

Linux version 3.7.6-23-desktop (geeko@buildhost) (gcc version 4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PREEMPT Tue Feb 5 15:27:05 UTC 2013 (d5cefdd)

[5.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)
[6.] A small shell script or example program which triggers the
      problem (if possible)

----------------------------------------
#!/bin/bash
systemctl stop xdm.service
killall -u gdm

activeVGA= grep 'DIS:+' /sys/kernel/debug/vgaswitcheroo/switch >/dev/null
if [[ "$?" -ne 0 ]]
then
	echo "DDIS" > /sys/kernel/debug/vgaswitcheroo/switch
	echo "Discrete VGA Adapter Enabled"
else
	echo "DIGD" > /sys/kernel/debug/vgaswitcheroo/switch
	echo "Integrated VGA Adapter Enabled"
fi
pkill X
killall gnome-session

#The below two lines are not applicable when using acpi_backlight=vendor
echo 10 > /sys/class/backlight/acpi_video0/brightness
echo 10 > /sys/class/backlight/acpi_video1/brightness

systemctl start xdm.service
------------------------------------

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

If some fields are empty or look unusual you may have an old version.

Compare to the current minimal requirements in Documentation/Changes.

  

Linux zeus.olympus 3.7.6-23-desktop #1 SMP PREEMPT Tue Feb 5 15:27:05 UTC 2013 (d5cefdd) x86_64 x86_64 x86_64 GNU/Linux

  

Gnu C                  4.7

Gnu make               3.82

binutils               12.2

2.22

util-linux             2.21.2

mount                  debug

module-init-tools      3.15

e2fsprogs              1.42.6

jfsutils               1.1.15

reiserfsprogs          3.6.21

xfsprogs               3.1.6

pcmciautils            017

PPP                    2.4.5

isdn4k-utils           3.13

Linux C Library        2.15

Dynamic linker (ldd)   2.15

Procps                 3.3.3

Net-tools              1.60

Kbd                    1.15.3

Sh-utils               8.16

wireless-tools         30

Modules Loaded         binfmt_misc fuse rfcomm tun bnep vboxpci
vboxnetadp vboxnetflt vboxdrv xt_tcpudp xt_LOG iptable_filter ip_tables
af_packet nf_conntrack_pptp nf_conntrack_sip nf_conntrack_proto_gre
nf_conntrack_ftp nf_conntrack_netbios_ns nf_conntrack_sane ts_kmp
nf_conntrack_amanda nf_conntrack_proto_dccp nf_conntrack_proto_sctp
nf_conntrack_h323 nf_conntrack_slp nf_conntrack_tftp
nf_conntrack_proto_udplite nf_conntrack_snmp nf_conntrack_irc
xt_conntrack x_tables nf_conntrack_netlink nfnetlink
nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
cpufreq_conservative cpufreq_userspace cpufreq_powersave
snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec arc4
iwldvm snd_hwdep uvcvideo mac80211 snd_pcm_oss videobuf2_core videodev
videobuf2_vmalloc videobuf2_memops snd_pcm snd_seq snd_timer
snd_seq_device snd_mixer_oss btusb acpi_cpufreq bluetooth mperf i915
radeon iTCO_wdt coretemp iwlwifi kvm_intel ttm cfg80211 hp_accel hp_wmi
iTCO_vendor_support drm_kms_helper drm mei lis3lv02d snd r8169 joydev
lpc_ich sparse_keymap serio_raw wmi intel_ips i2c_i801 i2c_algo_bit kvm
video sr_mod sg cdrom rfkill pcspkr mfd_core input_polldev button
battery soundcore ac snd_page_alloc microcode autofs4 btrfs zlib_deflate
  libcrc32c linear ghash_clmulni_intel crc32c_intel aesni_intel
ablk_helper cryptd lrw xts gf128mul scsi_dh_hp_sw scsi_dh_alua
scsi_dh_rdac scsi_dh_emc scsi_dh aes_x86_64 sha256_generic dm_crypt
dm_mod fan processor ata_generic pata_amd thermal thermal_sys

[7.2.] Processor information (from /proc/cpuinfo):

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 560  @ 2.67GHz
stepping	: 5
microcode	: 0x3
cpu MHz		: 1199.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt aes lahf_lm ida arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5319.86
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 560  @ 2.67GHz
stepping	: 5
microcode	: 0x3
cpu MHz		: 1199.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt aes lahf_lm ida arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5319.86
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 560  @ 2.67GHz
stepping	: 5
microcode	: 0x3
cpu MHz		: 1199.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 2
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt aes lahf_lm ida arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5319.86
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 560  @ 2.67GHz
stepping	: 5
microcode	: 0x3
cpu MHz		: 1199.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 2
apicid		: 5
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt aes lahf_lm ida arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5319.86
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

binfmt_misc 17464 1 - Live 0xffffffffa0961000
fuse 87139 3 - Live 0xffffffffa0942000
rfcomm 73109 9 - Live 0xffffffffa092f000
tun 22988 2 - Live 0xffffffffa0924000
bnep 19702 2 - Live 0xffffffffa0912000
vboxpci 27291 0 - Live 0xffffffffa0906000 (O)
vboxnetadp 25671 0 - Live 0xffffffffa08fe000 (O)
vboxnetflt 23480 0 - Live 0xffffffffa091d000 (O)
vboxdrv 336753 3 vboxpci,vboxnetadp,vboxnetflt, Live 0xffffffffa08aa000 (O)
xt_tcpudp 12885 38 - Live 0xffffffffa0897000
xt_LOG 17522 13 - Live 0xffffffffa08a4000
iptable_filter 12811 1 - Live 0xffffffffa087d000
ip_tables 27240 1 iptable_filter, Live 0xffffffffa089c000
af_packet 39587 4 - Live 0xffffffffa088c000
nf_conntrack_pptp 19246 0 - Live 0xffffffffa0882000
nf_conntrack_sip 33868 0 - Live 0xffffffffa0873000
nf_conntrack_proto_gre 14435 1 nf_conntrack_pptp, Live 0xffffffffa086a000
nf_conntrack_ftp 18680 0 - Live 0xffffffffa0860000
nf_conntrack_netbios_ns 12666 0 - Live 0xffffffffa085b000
nf_conntrack_sane 13144 0 - Live 0xffffffffa0856000
ts_kmp 12606 5 - Live 0xffffffffa0851000
nf_conntrack_amanda 13042 0 - Live 0xffffffffa084c000
nf_conntrack_proto_dccp 13511 0 - Live 0xffffffffa083f000
nf_conntrack_proto_sctp 18823 0 - Live 0xffffffffa0846000
nf_conntrack_h323 73846 0 - Live 0xffffffffa082b000
nf_conntrack_slp 12648 0 - Live 0xffffffffa0826000
nf_conntrack_tftp 13122 0 - Live 0xffffffffa0821000
nf_conntrack_proto_udplite 13282 0 - Live 0xffffffffa081c000
nf_conntrack_snmp 12858 0 - Live 0xffffffffa0817000
nf_conntrack_irc 13519 0 - Live 0xffffffffa0808000
xt_conntrack 12761 53 - Live 0xffffffffa07f9000
x_tables 34060 5 xt_tcpudp,xt_LOG,iptable_filter,ip_tables,xt_conntrack, Live 0xffffffffa080d000
nf_conntrack_netlink 35452 0 - Live 0xffffffffa07fe000
nfnetlink 14407 1 nf_conntrack_netlink, Live 0xffffffffa07a0000
nf_conntrack_broadcast 12590 2 nf_conntrack_netbios_ns,nf_conntrack_snmp, Live 0xffffffffa079b000
nf_conntrack_ipv4 15013 53 - Live 0xffffffffa07a7000
nf_conntrack 98519 19 nf_conntrack_pptp,nf_conntrack_sip,nf_conntrack_proto_gre,nf_conntrack_ftp,nf_conntrack_netbios_ns,nf_conntrack_sane,nf_conntrack_amanda,nf_conntrack_proto_dccp,nf_conntrack_proto_sctp,nf_conntrack_h323,nf_conntrack_slp,nf_conntrack_tftp,nf_conntrack_proto_udplite,nf_conntrack_snmp,nf_conntrack_irc,xt_conntrack,nf_conntrack_netlink,nf_conntrack_broadcast,nf_conntrack_ipv4, Live 0xffffffffa07df000
nf_defrag_ipv4 12730 1 nf_conntrack_ipv4, Live 0xffffffffa0796000
cpufreq_conservative 13822 0 - Live 0xffffffffa0670000
cpufreq_userspace 13163 0 - Live 0xffffffffa0431000
cpufreq_powersave 12619 0 - Live 0xffffffffa03f3000
snd_hda_codec_hdmi 40844 1 - Live 0xffffffffa07ae000
snd_hda_codec_idt 74313 1 - Live 0xffffffffa03df000
snd_hda_intel 42034 3 - Live 0xffffffffa078a000
snd_hda_codec 147417 3 snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel, Live 0xffffffffa07ba000
arc4 12616 2 - Live 0xffffffffa03b1000
iwldvm 249890 0 - Live 0xffffffffa074b000
snd_hwdep 13603 1 snd_hda_codec, Live 0xffffffffa03b7000
uvcvideo 84941 0 - Live 0xffffffffa065a000
mac80211 598150 1 iwldvm, Live 0xffffffffa06b3000
snd_pcm_oss 57811 0 - Live 0xffffffffa0459000
videobuf2_core 35910 1 uvcvideo, Live 0xffffffffa03bc000
videodev 129333 2 uvcvideo,videobuf2_core, Live 0xffffffffa0692000
videobuf2_vmalloc 13021 1 uvcvideo, Live 0xffffffffa03ac000
videobuf2_memops 13645 1 videobuf2_vmalloc, Live 0xffffffffa03a7000
snd_pcm 110154 4 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xffffffffa0676000
snd_seq 69780 0 - Live 0xffffffffa0446000
snd_timer 29371 2 snd_pcm,snd_seq, Live 0xffffffffa043d000
snd_seq_device 14498 1 snd_seq, Live 0xffffffffa042c000
snd_mixer_oss 22414 1 snd_pcm_oss, Live 0xffffffffa0425000
btusb 23871 0 - Live 0xffffffffa0436000
acpi_cpufreq 19572 1 - Live 0xffffffffa03fc000
bluetooth 341895 28 rfcomm,bnep,btusb, Live 0xffffffffa0605000
mperf 12668 1 acpi_cpufreq, Live 0xffffffffa03ca000
i915 605629 8 - Live 0xffffffffa0570000
radeon 948614 0 - Live 0xffffffffa0487000
iTCO_wdt 13481 0 - Live 0xffffffffa02a8000
coretemp 13394 0 - Live 0xffffffffa0228000
iwlwifi 109256 1 iwldvm, Live 0xffffffffa046b000
kvm_intel 136915 0 - Live 0xffffffffa0402000
ttm 91975 1 radeon, Live 0xffffffffa0290000
cfg80211 218484 3 iwldvm,mac80211,iwlwifi, Live 0xffffffffa0370000
hp_accel 26013 0 - Live 0xffffffffa0288000
hp_wmi 13953 0 - Live 0xffffffffa0203000
iTCO_vendor_support 13719 1 iTCO_wdt, Live 0xffffffffa0238000
drm_kms_helper 50840 2 i915,radeon, Live 0xffffffffa03d1000
drm 293115 6 i915,radeon,ttm,drm_kms_helper, Live 0xffffffffa0327000
mei 79557 0 - Live 0xffffffffa0273000
lis3lv02d 20192 1 hp_accel, Live 0xffffffffa0255000
snd 91489 17 snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_pcm,snd_seq,snd_timer,snd_seq_device,snd_mixer_oss, Live 0xffffffffa025b000
r8169 67643 0 - Live 0xffffffffa0243000
joydev 17378 0 - Live 0xffffffffa023d000
lpc_ich 17062 0 - Live 0xffffffffa0232000
sparse_keymap 13891 1 hp_wmi, Live 0xffffffffa022d000
serio_raw 13376 0 - Live 0xffffffffa01f4000
wmi 19071 1 hp_wmi, Live 0xffffffffa0222000
intel_ips 18422 0 - Live 0xffffffffa021c000
i2c_i801 22440 0 - Live 0xffffffffa0215000
i2c_algo_bit 13414 2 i915,radeon, Live 0xffffffffa01e2000
kvm 475491 1 kvm_intel, Live 0xffffffffa02b1000
video 19401 1 i915, Live 0xffffffffa020f000
sr_mod 22296 0 - Live 0xffffffffa0208000
sg 36525 0 - Live 0xffffffffa01f9000
cdrom 46688 1 sr_mod, Live 0xffffffffa01e7000
rfkill 26530 6 bluetooth,cfg80211,hp_wmi, Live 0xffffffffa01d1000
pcspkr 12719 0 - Live 0xffffffffa01be000
mfd_core 13436 1 lpc_ich, Live 0xffffffffa01a6000
input_polldev 13897 1 lis3lv02d, Live 0xffffffffa01dd000
button 13953 1 i915, Live 0xffffffffa01cc000
battery 18769 0 - Live 0xffffffffa01c6000
soundcore 15048 1 snd, Live 0xffffffffa01ab000
ac 13133 0 - Live 0xffffffffa00bc000
snd_page_alloc 18711 2 snd_hda_intel,snd_pcm, Live 0xffffffffa01a0000
microcode 35785 0 - Live 0xffffffffa0196000
autofs4 42771 3 - Live 0xffffffffa01b2000
btrfs 834759 0 - Live 0xffffffffa00c9000
zlib_deflate 26915 1 btrfs, Live 0xffffffffa00b4000
libcrc32c 12645 1 btrfs, Live 0xffffffffa00af000
linear 12895 0 - Live 0xffffffffa00c4000
ghash_clmulni_intel 13260 0 - Live 0xffffffffa00aa000
crc32c_intel 12902 1 - Live 0xffffffffa0087000
aesni_intel 55441 5 - Live 0xffffffffa009b000
ablk_helper 13598 1 aesni_intel, Live 0xffffffffa0091000
cryptd 16307 4 ghash_clmulni_intel,aesni_intel,ablk_helper, Live 0xffffffffa0096000
lrw 13287 1 aesni_intel, Live 0xffffffffa0082000
xts 12915 1 aesni_intel, Live 0xffffffffa008c000
gf128mul 14952 2 lrw,xts, Live 0xffffffffa007d000
scsi_dh_hp_sw 12895 0 - Live 0xffffffffa0078000
scsi_dh_alua 17162 0 - Live 0xffffffffa0072000
scsi_dh_rdac 17409 0 - Live 0xffffffffa006c000
scsi_dh_emc 17259 0 - Live 0xffffffffa0066000
scsi_dh 14844 4 scsi_dh_hp_sw,scsi_dh_alua,scsi_dh_rdac,scsi_dh_emc, Live 0xffffffffa005d000
aes_x86_64 17256 1 aesni_intel, Live 0xffffffffa004e000
sha256_generic 16910 2 - Live 0xffffffffa0028000
dm_crypt 22845 1 - Live 0xffffffffa0056000
dm_mod 92315 12 dm_crypt, Live 0xffffffffa0033000
fan 13003 0 - Live 0xffffffffa002e000
processor 44950 1 acpi_cpufreq, Live 0xffffffffa001c000
ata_generic 12911 0 - Live 0xffffffffa0012000
pata_amd 14130 0 - Live 0xffffffffa0017000
thermal 18712 0 - Live 0xffffffffa000c000
thermal_sys 24957 4 video,fan,processor,thermal, Live 0xffffffffa0000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

/proc/ioports:
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
   03c0-03df : vga+
   0400-047f : pnp 00:05
     0400-0403 : ACPI PM1a_EVT_BLK
     0404-0405 : ACPI PM1a_CNT_BLK
     0408-040b : ACPI PM_TMR
     0410-0415 : ACPI CPU throttle
     0420-042f : ACPI GPE0_BLK
     0430-0433 : iTCO_wdt
       0430-0433 : iTCO_wdt
     0450-0450 : ACPI PM2_CNT_BLK
     0460-047f : iTCO_wdt
       0460-047f : iTCO_wdt
   0500-0501 : pnp 00:05
   0680-069f : pnp 00:05
   0700-077f : pnp 00:05
   0800-080f : pnp 00:05
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   1000-1fff : PCI Bus 0000:03
   2000-2fff : PCI Bus 0000:02
     2000-20ff : 0000:02:00.0
       2000-20ff : r8169
   3000-3fff : PCI Bus 0000:01
     3000-30ff : 0000:01:00.0
   4000-401f : 0000:00:1f.3
   4020-403f : 0000:00:1f.2
     4020-403f : ahci
   4040-4047 : 0000:00:1f.2
     4040-4047 : ahci
   4048-404f : 0000:00:1f.2
     4048-404f : ahci
   4050-4057 : 0000:00:02.0
   4058-405b : 0000:00:1f.2
     4058-405b : ahci
   405c-405f : 0000:00:1f.2
     405c-405f : ahci
   ffff-ffff : pnp 00:05
     ffff-ffff : pnp 00:05

/proc/iomem:

00000000-0000ffff : reserved
00010000-0009cfff : System RAM
0009d000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cefff : Video ROM
000cf000-000cffff : Adapter ROM
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-9b63efff : System RAM
   01000000-015a27b8 : Kernel code
   015a27b9-01ab297f : Kernel data
   01bb2000-01d7ffff : Kernel bss
9b63f000-9b6befff : reserved
9b6bf000-9b7befff : ACPI Non-volatile Storage
9b7bf000-9b7fefff : ACPI Tables
9b7ff000-9b7fffff : System RAM
9b800000-9fffffff : reserved
a0000000-feafffff : PCI Bus 0000:00
   a0000000-afffffff : PCI Bus 0000:01
     a0000000-afffffff : 0000:01:00.0
   b0000000-bfffffff : 0000:00:02.0
   c0000000-c03fffff : 0000:00:02.0
   c0400000-c13fffff : PCI Bus 0000:02
     c0400000-c0403fff : 0000:02:00.0
       c0400000-c0403fff : r8169
     c0404000-c0404fff : 0000:02:00.0
       c0404000-c0404fff : r8169
   c1400000-c23fffff : PCI Bus 0000:03
   c2400000-c33fffff : PCI Bus 0000:03
     c2400000-c2401fff : 0000:03:00.0
       c2400000-c2401fff : iwlwifi
   c3400000-c43fffff : PCI Bus 0000:02
   c4400000-c44fffff : PCI Bus 0000:01
     c4400000-c441ffff : 0000:01:00.0
     c4420000-c4423fff : 0000:01:00.1
       c4420000-c4423fff : ICH HD audio
     c4440000-c445ffff : 0000:01:00.0
   c4500000-c4503fff : 0000:00:1b.0
     c4500000-c4503fff : ICH HD audio
   c4504000-c4504fff : 0000:00:1f.6
     c4504000-c4504fff : ips thermal sensor
   c4505000-c45057ff : 0000:00:1f.2
     c4505000-c45057ff : ahci
   c4505800-c4505bff : 0000:00:1d.0
     c4505800-c4505bff : ehci_hcd
   c4505c00-c4505fff : 0000:00:1a.0
     c4505c00-c4505fff : ehci_hcd
   c4506000-c45060ff : 0000:00:1f.3
   c4506100-c450610f : 0000:00:16.0
     c4506100-c450610f : mei
   c4507000-c4507fff : Intel Flush Page
   c4600000-c4600fff : pnp 00:0a
   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
     e0000000-efffffff : reserved
       e0000000-efffffff : pnp 00:0a
feb00000-feb03fff : reserved
fec00000-fec00fff : reserved
   fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed10000-fed13fff : reserved
   fed10000-fed13fff : pnp 00:0a
fed18000-fed19fff : reserved
   fed18000-fed18fff : pnp 00:0a
   fed19000-fed19fff : pnp 00:0a
fed1b000-fed1ffff : reserved
   fed1c000-fed1ffff : pnp 00:0a
     fed1f410-fed1f414 : iTCO_wdt
       fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:0a
fed45000-fed8ffff : pnp 00:0a
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ffe00000-ffffffff : reserved
100000000-157ffffff : System RAM


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: c4400000-c44fffff
	Prefetchable memory behind bridge: 00000000a0000000-00000000afffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Hewlett-Packard Company Device 162f
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4181
	Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #17, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
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
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 46
	Region 0: Memory at c0000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 4050 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4142
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: i915

00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at c4506100 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41d1
	Kernel driver in use: mei

00:1a.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at c4505c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP+
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at c4500000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 4162
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=02
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: c3400000-c43fffff
	Prefetchable memory behind bridge: 00000000c0400000-00000000c13fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+ ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 162f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: c2400000-c33fffff
	Prefetchable memory behind bridge: 00000000c1400000-00000000c23fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+ ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 162f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at c4505800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device 162f

00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=10 <?>
	Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 41
	Region 0: I/O ports at 4048 [size=8]
	Region 1: I/O ports at 405c [size=4]
	Region 2: I/O ports at 4040 [size=8]
	Region 3: I/O ports at 4058 [size=4]
	Region 4: I/O ports at 4020 [size=32]
	Region 5: Memory at c4505000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41a1
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 19
	Region 0: Memory at c4506000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 4000 [size=32]

00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at c4504000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Kernel driver in use: intel ips

01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Robson CE [AMD Radeon HD 6300 Series] (rev ff) (prog-if ff)
	!!! Unknown header type 7f
	Kernel driver in use: radeon

01:00.1 Audio device: Advanced Micro Devices [AMD] nee ATI Cedar HDMI Audio [Radeon HD 5400/6300 Series] (rev ff) (prog-if ff)
	!!! Unknown header type 7f
	Kernel driver in use: snd_hda_intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 42
	Region 0: I/O ports at 2000 [size=256]
	Region 2: Memory at c0404000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at c0400000 (64-bit, prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41c1
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [ac] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [cc] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
	Kernel driver in use: r8169

03:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
	Subsystem: Intel Corporation Centrino Wireless-N 1000 BGN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at c2400000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 41e1
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-26-c7-ff-ff-d8-ce-b8
	Kernel driver in use: iwlwifi

ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
	Subsystem: Hewlett-Packard Company Device 162f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0


[7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: TOSHIBA MK6476GS Rev: GS00
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: hp       Model: CDDVDW TS-U633F  Rev: HH05
   Type:   CD-ROM                           ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):

hwinfo --gfxcard
10: PCI 02.0: 0300 VGA compatible controller (VGA)
   [Created at pci.319]
   Unique ID: _Znp.sEfI3w+edXC
   SysFS ID: /devices/pci0000:00/0000:00:02.0
   SysFS BusID: 0000:00:02.0
   Hardware Class: graphics card
   Model: "Intel Arrandale Integrated Graphics Controller"
   Vendor: pci 0x8086 "Intel Corporation"
   Device: pci 0x0046 "Arrandale Integrated Graphics Controller"
   SubVendor: pci 0x103c "Hewlett-Packard Company"
   SubDevice: pci 0x162f
   Revision: 0x02
   Driver: "i915"
   Driver Modules: "drm"
   Memory Range: 0xc0000000-0xc03fffff (rw,non-prefetchable)
   Memory Range: 0xb0000000-0xbfffffff (ro,non-prefetchable)
   I/O Ports: 0x4050-0x4057 (rw)
   IRQ: 46 (224904 events)
   Module Alias: "pci:v00008086d00000046sv0000103Csd0000162Fbc03sc00i00"
   Driver Info #0:
     Driver Status: i915 is active
     Driver Activation Cmd: "modprobe i915"
   Config Status: cfg=new, avail=yes, need=no, active=unknown

22: PCI 100.0: 0300 VGA compatible controller (VGA)
   [Created at pci.319]
   Unique ID: VCu0.bF8MD6aKQ12
   Parent ID: vSkL.S788AHbvEDD
   SysFS ID: /devices/pci0000:00/0000:00:01.0/0000:01:00.0
   SysFS BusID: 0000:01:00.0
   Hardware Class: graphics card
   Model: "ATI VGA compatible controller"
   Vendor: pci 0x1002 "ATI Technologies Inc"
   Device: pci 0x68e4
   SubVendor: pci 0x103c "Hewlett-Packard Company"
   SubDevice: pci 0x162f
   Revision: 0xff
   Driver: "radeon"
   Driver Modules: "drm"
   Memory Range: 0xa0000000-0xafffffff (ro,non-prefetchable)
   Memory Range: 0xc4400000-0xc441ffff (rw,non-prefetchable)
   I/O Ports: 0x3000-0x3fff (rw)
   Memory Range: 0xc4440000-0xc445ffff (ro,non-prefetchable)
   IRQ: 45 (302 events)
   Module Alias: "pci:v00001002d000068E4sv0000103Csd0000162Fbc03sc00i00"
   Driver Info #0:
     Driver Status: radeon is active
     Driver Activation Cmd: "modprobe radeon"
   Config Status: cfg=new, avail=yes, need=no, active=unknown
   Attached to: #9 (PCI bridge)

Primary display adapter: #10



[X.] Other notes, patches, fixes, workarounds:


cat /sys/class/backlight/acpi_video1/max_brightness
10

cat /sys/class/backlight/radeon_bl0/max_brightness
255



