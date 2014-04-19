Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaDSFJF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 01:09:05 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:57503 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaDSFJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 01:09:02 -0400
MIME-Version: 1.0
From: Bryan Quigley <gquigs@gmail.com>
Date: Sat, 19 Apr 2014 01:08:40 -0400
Message-ID: <CAAWf5=s8cAgwMcOcMRjinjs6h-vfyEGVkpw-cSRKPxewFQ+MYA@mail.gmail.com>
Subject: PROBLEM: Pulseaudio hung at schedule in 3.15-rc1
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me on replies

[1.] Pulseaudio hangs, preventing sound, and login/desktop loading
[2.] With 3.15rc1 pulseaudio get's stuck in a hang loop
[3.] audio, hung
[4.] Linux version 3.15.0-999-generic (apw@gomeisa) (gcc version 4.6.3
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201404180205 SMP Fri Apr 18 06:06:34
UTC 2014
Also tested w/ me compiling it myself..
[5.]
Apr 19 00:42:29 unstable kernel: [  239.991104] INFO: task
pulseaudio:1499 blocked for more than 120 seconds.
Apr 19 00:42:29 unstable kernel: [  239.991116]       Not tainted
3.15.0-999-generic #201404180205

Apr 19 00:42:29 unstable kernel: [  239.991121] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 19 00:42:29 unstable kernel: [  239.991127] pulseaudio      D
ffffffff81811b60     0  1499      1 0x00000004

Apr 19 00:42:29 unstable kernel: [  239.991137]  ffff8800cfb93478
0000000000000002 ffff88031c74e300 ffff8800cfb93fd8
Apr 19 00:42:29 unstable kernel: [  239.991145]  0000000000014500
0000000000014500 ffffffff81c174a0 ffff88031b51b280

Apr 19 00:42:29 unstable kernel: [  239.991153]  ffff8800cfb93488
ffff88031e13e890 0000000000000000 ffff88031e13e938
Apr 19 00:42:29 unstable kernel: [  239.991160] Call Trace:
Apr 19 00:42:29 unstable kernel: [  239.991176]  [<ffffffff817663d9>]
schedule+0x29/0x70

Apr 19 00:42:29 unstable kernel: [  239.991187]  [<ffffffff814b2235>]
rpm_resume+0x175/0x630
Apr 19 00:42:29 unstable kernel: [  239.991197]  [<ffffffff810b29e0>]
? __wake_up_sync+0x20/0x20
Apr 19 00:42:29 unstable kernel: [  239.991204]  [<ffffffff814b23aa>]
rpm_resume+0x2ea/0x630

Apr 19 00:42:29 unstable kernel: [  239.991213]  [<ffffffff811b1584>]
? kfree+0x134/0x170
Apr 19 00:42:29 unstable kernel: [  239.991221]  [<ffffffff814b3b8c>]
__pm_runtime_resume+0x5c/0x90
Apr 19 00:42:29 unstable kernel: [  239.991230]  [<ffffffff8156787d>]
usb_autopm_get_interface+0x2d/0x70

Apr 19 00:42:29 unstable kernel: [  239.991257]  [<ffffffffa03690c9>]
snd_usb_autoresume+0x49/0x70 [snd_usb_audio]
Apr 19 00:42:29 unstable kernel: [  239.991276]  [<ffffffffa036df21>]
snd_usb_mixer_set_ctl_value+0x61/0x240 [snd_usb_audio]

Apr 19 00:42:29 unstable kernel: [  239.991294]  [<ffffffffa036e17b>]
set_cur_mix_value+0x7b/0xe0 [snd_usb_audio]
Apr 19 00:42:29 unstable kernel: [  239.991311]  [<ffffffffa036e428>]
restore_mixer_value+0xa8/0xc0 [snd_usb_audio]

Apr 19 00:42:29 unstable kernel: [  239.991328]  [<ffffffffa0370961>]
snd_usb_mixer_resume+0x41/0x90 [snd_usb_audio]
Apr 19 00:42:29 unstable kernel: [  239.991343]  [<ffffffffa0368071>]
__usb_audio_resume+0x71/0xe0 [snd_usb_audio]

Apr 19 00:42:29 unstable kernel: [  239.991350]  [<ffffffff81569500>]
? usb_runtime_suspend+0x70/0x70
Apr 19 00:42:29 unstable kernel: [  239.991364]  [<ffffffffa03680f3>]
usb_audio_reset_resume+0x13/0x20 [snd_usb_audio]

Apr 19 00:42:29 unstable kernel: [  239.991373]  [<ffffffff815681ce>]
usb_resume_interface.isra.4.part.5+0x2e/0xe0
Apr 19 00:42:29 unstable kernel: [  239.991382]  [<ffffffff815682e0>]
usb_resume_interface.isra.4+0x60/0x90

Apr 19 00:42:29 unstable kernel: [  239.991389]  [<ffffffff81568384>]
usb_resume_both+0x74/0xd0
Apr 19 00:42:29 unstable kernel: [  239.991395]  [<ffffffff8156951a>]
usb_runtime_resume+0x1a/0x20
Apr 19 00:42:29 unstable kernel: [  239.991402]  [<ffffffff814b1fad>]
__rpm_callback+0x3d/0xc0

Apr 19 00:42:29 unstable kernel: [  239.991408]  [<ffffffff814b205f>]
rpm_callback+0x2f/0x90
Apr 19 00:42:29 unstable kernel: [  239.991415]  [<ffffffff814b258f>]
rpm_resume+0x4cf/0x630
Apr 19 00:42:29 unstable kernel: [  239.991422]  [<ffffffff814b23aa>]
rpm_resume+0x2ea/0x630

Apr 19 00:42:29 unstable kernel: [  239.991430]  [<ffffffff814b3b8c>]
__pm_runtime_resume+0x5c/0x90
Apr 19 00:42:29 unstable kernel: [  239.991438]  [<ffffffff8156787d>]
usb_autopm_get_interface+0x2d/0x70

Apr 19 00:42:29 unstable kernel: [  239.991453]  [<ffffffffa03690c9>]
snd_usb_autoresume+0x49/0x70 [snd_usb_audio]
Apr 19 00:42:29 unstable kernel: [  239.991471]  [<ffffffffa037348c>]
setup_hw_info+0x14c/0x2f0 [snd_usb_audio]

Apr 19 00:42:29 unstable kernel: [  239.991479]  [<ffffffff811604ae>]
? __get_free_pages+0xe/0x40
Apr 19 00:42:29 unstable kernel: [  239.991497]  [<ffffffffa0373724>]
snd_usb_pcm_open+0xf4/0x100 [snd_usb_audio]

Apr 19 00:42:29 unstable kernel: [  239.991514]  [<ffffffffa0373743>]
snd_usb_capture_open+0x13/0x20 [snd_usb_audio]
Apr 19 00:42:29 unstable kernel: [  239.991539]  [<ffffffffa01d8291>]
snd_pcm_open_substream+0x71/0x110 [snd_pcm]

Apr 19 00:42:29 unstable kernel: [  239.991556]  [<ffffffffa01d83ea>]
snd_pcm_open+0xba/0x230 [snd_pcm]
Apr 19 00:42:29 unstable kernel: [  239.991565]  [<ffffffff8109f5f0>]
? try_to_wake_up+0x210/0x210

Apr 19 00:42:29 unstable kernel: [  239.991574]  [<ffffffff814a41d9>]
? get_device+0x19/0x20
Apr 19 00:42:29 unstable kernel: [  239.991591]  [<ffffffffa01d85a7>]
snd_pcm_capture_open+0x47/0x70 [snd_pcm]

Apr 19 00:42:29 unstable kernel: [  239.991611]  [<ffffffffa00fc5d3>]
snd_open+0xc3/0x180 [snd]
Apr 19 00:42:29 unstable kernel: [  239.991622]  [<ffffffff811d1e90>]
? cdev_put+0x30/0x30
Apr 19 00:42:29 unstable kernel: [  239.991627]  [<ffffffff811d1f3f>]
chrdev_open+0xaf/0x1b0

Apr 19 00:42:29 unstable kernel: [  239.991634]  [<ffffffff811caee6>]
do_dentry_open+0x226/0x2e0
Apr 19 00:42:29 unstable kernel: [  239.991641]  [<ffffffff811cb345>]
finish_open+0x35/0x50
Apr 19 00:42:29 unstable kernel: [  239.991648]  [<ffffffff811dd08e>]
do_last+0x4ce/0x780

Apr 19 00:42:29 unstable kernel: [  239.991656]  [<ffffffff811dd404>]
path_openat+0xc4/0x4c0
Apr 19 00:42:29 unstable kernel: [  239.991663]  [<ffffffff811d8a09>]
? putname+0x29/0x40
Apr 19 00:42:29 unstable kernel: [  239.991670]  [<ffffffff811ddc13>]
? user_path_at_empty+0x63/0xa0

Apr 19 00:42:29 unstable kernel: [  239.991678]  [<ffffffff811ddd23>]
do_filp_open+0x43/0xa0
Apr 19 00:42:29 unstable kernel: [  239.991685]  [<ffffffff811ea9fd>]
? __alloc_fd+0xcd/0x120
Apr 19 00:42:29 unstable kernel: [  239.991692]  [<ffffffff811cc852>]
do_sys_open+0x132/0x220

Apr 19 00:42:29 unstable kernel: [  239.991699]  [<ffffffff810220bd>]
? syscall_trace_leave+0xdd/0x150
Apr 19 00:42:29 unstable kernel: [  239.991707]  [<ffffffff811ea2d5>]
? __fget_light+0x25/0x70
Apr 19 00:42:29 unstable kernel: [  239.991714]  [<ffffffff811cc95e>]
SyS_open+0x1e/0x20

Apr 19 00:42:29 unstable kernel: [  239.991720]  [<ffffffff8177373f>]
tracesys+0xe1/0xe6
Apr 19 00:42:29 unstable kernel: [  239.991757] INFO: task
pulseaudio:2489 blocked for more than 120 seconds.
Apr 19 00:42:29 unstable kernel: [  239.991762]       Not tainted
3.15.0-999-generic #201404180205

Apr 19 00:42:29 unstable kernel: [  239.991765] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 19 00:42:29 unstable kernel: [  239.991769] pulseaudio      D
ffffffff81811b60     0  2489   2266 0x00000004

Apr 19 00:42:29 unstable kernel: [  239.991776]  ffff88031ce53a48
0000000000000002 ffff88032fff9f80 ffff88031ce53fd8
Apr 19 00:42:29 unstable kernel: [  239.991783]  0000000000014500
0000000000014500 ffff88031e603280 ffff8800cb1f0000

Apr 19 00:42:29 unstable kernel: [  239.991789]  ffff88031ce53ad8
ffff88031d2f4f48 ffff88031d2f4f4c ffff8800cb1f0000
Apr 19 00:42:29 unstable kernel: [  239.991795] Call Trace:
Apr 19 00:42:29 unstable kernel: [  239.991804]  [<ffffffff817663d9>]
schedule+0x29/0x70

Apr 19 00:42:29 unstable kernel: [  239.991811]  [<ffffffff817666fe>]
schedule_preempt_disabled+0xe/0x10
Apr 19 00:42:29 unstable kernel: [  239.991820]  [<ffffffff81768515>]
__mutex_lock_slowpath+0xd5/0x1c0

Apr 19 00:42:29 unstable kernel: [  239.991828]  [<ffffffff81768623>]
mutex_lock+0x23/0x37
Apr 19 00:42:29 unstable kernel: [  239.991843]  [<ffffffffa01d04ab>]
snd_pcm_substream_proc_status_read+0x3b/0x1e0 [snd_pcm]

Apr 19 00:42:29 unstable kernel: [  239.991852]  [<ffffffff812e9dde>]
? security_inode_alloc+0x1e/0x20
Apr 19 00:42:29 unstable kernel: [  239.991860]  [<ffffffff811e76c3>]
? inode_init_always+0x113/0x1d0

Apr 19 00:42:29 unstable kernel: [  239.991868]  [<ffffffff81232cef>]
? proc_alloc_inode+0x6f/0xb0
Apr 19 00:42:29 unstable kernel: [  239.991875]  [<ffffffff811b276c>]
? kmem_cache_alloc_trace+0x12c/0x160

Apr 19 00:42:29 unstable kernel: [  239.991892]  [<ffffffffa00fee97>]
? snd_info_entry_open+0x297/0x310 [snd]
Apr 19 00:42:29 unstable kernel: [  239.991908]  [<ffffffffa00fed16>]
snd_info_entry_open+0x116/0x310 [snd]

Apr 19 00:42:29 unstable kernel: [  239.991923]  [<ffffffffa00fe2b0>]
? snd_info_dev_register_entry+0x20/0x20 [snd]
Apr 19 00:42:29 unstable kernel: [  239.991930]  [<ffffffff8123317d>]
proc_reg_open+0x7d/0x120

Apr 19 00:42:29 unstable kernel: [  239.991937]  [<ffffffff81233100>]
? proc_reg_llseek+0x70/0x70
Apr 19 00:42:29 unstable kernel: [  239.991943]  [<ffffffff811caee6>]
do_dentry_open+0x226/0x2e0
Apr 19 00:42:29 unstable kernel: [  239.991949]  [<ffffffff811cb345>]
finish_open+0x35/0x50

Apr 19 00:42:29 unstable kernel: [  239.991956]  [<ffffffff811dd08e>]
do_last+0x4ce/0x780
Apr 19 00:42:29 unstable kernel: [  239.991964]  [<ffffffff811dd404>]
path_openat+0xc4/0x4c0
Apr 19 00:42:29 unstable kernel: [  239.991972]  [<ffffffff811ddd23>]
do_filp_open+0x43/0xa0

Apr 19 00:42:29 unstable kernel: [  239.991979]  [<ffffffff811ea9fd>]
? __alloc_fd+0xcd/0x120
Apr 19 00:42:29 unstable kernel: [  239.991985]  [<ffffffff811cc852>]
do_sys_open+0x132/0x220
Apr 19 00:42:29 unstable kernel: [  239.991992]  [<ffffffff810220bd>]
? syscall_trace_leave+0xdd/0x150

Apr 19 00:42:29 unstable kernel: [  239.991998]  [<ffffffff811e05a8>]
? SyS_getdents+0xa8/0x110
Apr 19 00:42:29 unstable kernel: [  239.992004]  [<ffffffff811cc95e>]
SyS_open+0x1e/0x20
Apr 19 00:42:29 unstable kernel: [  239.992010]  [<ffffffff8177373f>]
tracesys+0xe1/0xe6



[6.] Run pulseaudio
[7.] Environment
[7.2.] AMD Phenom(tm) II X4 945 Processor
[7.3.] ipt_MASQUERADE 12880 3 - Live 0x0000000000000000
iptable_nat 13151 1 - Live 0x0000000000000000
nf_nat_ipv4 13316 1 iptable_nat, Live 0x0000000000000000
nf_nat 26147 3 ipt_MASQUERADE,iptable_nat,nf_nat_ipv4, Live 0x0000000000000000

nf_conntrack_ipv4 14857 2 - Live 0x0000000000000000
nf_defrag_ipv4 12758 1 nf_conntrack_ipv4, Live 0x0000000000000000
xt_conntrack 12760 1 - Live 0x0000000000000000
nf_conntrack 105687 6
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
ip6_tables 27504 1 ip6table_filter, Live 0x0000000000000000
iptable_filter 12810 1 - Live 0x0000000000000000

ip_tables 27718 3 iptable_nat,iptable_mangle,iptable_filter, Live
0x0000000000000000
ebtable_nat 12807 0 - Live 0x0000000000000000
ebtables 35305 1 ebtable_nat, Live 0x0000000000000000
x_tables 34194 11
ipt_MASQUERADE,xt_conntrack,ipt_REJECT,xt_CHECKSUM,iptable_mangle,xt_tcpudp,ip6table_filter,ip6_tables,iptable_filter,ip_tables,ebtables,
Live 0x0000000000000000

bnep 19884 2 - Live 0x0000000000000000
rfcomm 75078 0 - Live 0x0000000000000000
bluetooth 461775 10 bnep,rfcomm, Live 0x0000000000000000
6lowpan_iphc 18968 1 bluetooth, Live 0x0000000000000000
uvcvideo 82299 0 - Live 0x0000000000000000

snd_usb_audio 163898 4 - Live 0x0000000000000000
hid_generic 12559 0 - Live 0x0000000000000000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000

videobuf2_core 45435 1 uvcvideo, Live 0x0000000000000000
usbhid 53121 0 - Live 0x0000000000000000
videodev 149504 2 uvcvideo,videobuf2_core, Live 0x0000000000000000
hid 106436 2 hid_generic,usbhid, Live 0x0000000000000000

snd_usbmidi_lib 30189 1 snd_usb_audio, Live 0x0000000000000000
kvm_amd 60778 0 - Live 0x0000000000000000
radeon 1589917 5 - Live 0x0000000000000000
kvm 463808 1 kvm_amd, Live 0x0000000000000000
snd_hda_codec_realtek 72529 1 - Live 0x0000000000000000

snd_hda_codec_hdmi 48182 1 - Live 0x0000000000000000
snd_hda_codec_generic 70087 1 snd_hda_codec_realtek, Live 0x0000000000000000
snd_hda_intel 30608 4 - Live 0x0000000000000000
snd_hda_controller 35518 1 snd_hda_intel, Live 0x0000000000000000

ttm 90341 1 radeon, Live 0x0000000000000000
snd_hda_codec 144671 5
snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller,
Live 0x0000000000000000
drm_kms_helper 59729 1 radeon, Live 0x0000000000000000

snd_hwdep 13613 2 snd_usb_audio,snd_hda_codec, Live 0x0000000000000000
snd_pcm 113863 7
snd_usb_audio,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec,
Live 0x0000000000000000
drm 310694 8 radeon,ttm,drm_kms_helper, Live 0x0000000000000000

snd_seq_midi 13564 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 30865 2 snd_usbmidi_lib,snd_seq_midi, Live 0x0000000000000000
k10temp 13191 0 - Live 0x0000000000000000

sp5100_tco 14134 0 - Live 0x0000000000000000
snd_seq 67636 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
snd_timer 30118 2 snd_pcm,snd_seq, Live 0x0000000000000000

snd 74195 23 snd_usb_audio,snd_usbmidi_lib,snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000

i2c_algo_bit 13564 1 radeon, Live 0x0000000000000000
i2c_piix4 22310 0 - Live 0x0000000000000000
soundcore 12680 2 snd_hda_codec,snd, Live 0x0000000000000000
microcode 24391 0 - Live 0x0000000000000000
edac_core 63001 0 - Live 0x0000000000000000

serio_raw 13483 0 - Live 0x0000000000000000
ite_cir 25785 0 - Live 0x0000000000000000
edac_mce_amd 22792 0 - Live 0x0000000000000000
rc_core 28757 1 ite_cir, Live 0x0000000000000000
mac_hid 13275 0 - Live 0x0000000000000000

parport_pc 32906 0 - Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42481 3 parport_pc,ppdev,lp, Live 0x0000000000000000
pata_acpi 13053 0 - Live 0x0000000000000000

firewire_ohci 45300 0 - Live 0x0000000000000000
r8169 73316 0 - Live 0x0000000000000000
ahci 30080 3 - Live 0x0000000000000000
mii 13981 1 r8169, Live 0x0000000000000000
firewire_core 69403 1 firewire_ohci, Live 0x0000000000000000

libahci 32191 1 ahci, Live 0x0000000000000000
pata_via 13717 0 - Live 0x0000000000000000
crc_itu_t 12707 1 firewire_core, Live 0x0000000000000000

[7.4.] cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
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
  03c0-03df : vga+
  040b-040b : pnp 00:07
  04d0-04d1 : pnp 00:07
  04d6-04d6 : pnp 00:07
  0800-0803 : ACPI PM1a_EVT_BLK

  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0827 : ACPI GPE0_BLK
  08ff-08ff : ACPI PM2_CNT_BLK
  0900-090f : pnp 00:07
  0910-091f : pnp 00:07
  0a30-0a3f : pnp 00:09

  0b00-0b1f : pnp 00:07
    0b00-0b07 : piix4_smbus
  0b20-0b3f : pnp 00:07
    0b20-0b27 : piix4_smbus
  0c00-0c01 : pnp 00:07
  0c14-0c14 : pnp 00:07
  0c50-0c51 : pnp 00:07
  0c52-0c52 : pnp 00:07

  0c6c-0c6c : pnp 00:07
  0c6f-0c6f : pnp 00:07
  0cd0-0cd1 : pnp 00:07
  0cd2-0cd3 : pnp 00:07
  0cd4-0cd5 : pnp 00:07
  0cd6-0cd7 : pnp 00:07
    0cd6-0cd7 : SB800 TCO
  0cd8-0cdf : pnp 00:07
0cf8-0cff : PCI conf1

0d00-ffff : PCI Bus 0000:00
  0e00-0e0f : pnp 00:09
  0e80-0e8f : pnp 00:09
  0f40-0f4f : pnp 00:09
  1000-1fff : PCI Bus 0000:04
    1000-10ff : 0000:04:00.0
    1400-140f : 0000:04:00.1
      1400-140f : pata_via

    1410-1417 : 0000:04:00.1
      1410-1417 : pata_via
    1418-141f : 0000:04:00.1
      1418-141f : pata_via
    1420-1423 : 0000:04:00.1
      1420-1423 : pata_via
    1424-1427 : 0000:04:00.1
      1424-1427 : pata_via

  8000-800f : 0000:00:11.0
    8000-800f : ahci
  9000-9003 : 0000:00:11.0
    9000-9003 : ahci
  a000-a007 : 0000:00:11.0
    a000-a007 : ahci
  b000-b003 : 0000:00:11.0
    b000-b003 : ahci
  c000-c007 : 0000:00:11.0

    c000-c007 : ahci
  d000-dfff : PCI Bus 0000:01
    d000-d0ff : 0000:01:00.0
  e000-efff : PCI Bus 0000:02
    e800-e8ff : 0000:02:00.0
      e800-e8ff : r8169
  fe00-fefe : pnp 00:07
cat /proc/iomem

00000000-00000fff : reserved
00001000-0009b3ff : System RAM
0009b400-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cffff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
000e2000-000fffff : reserved

  000f0000-000fffff : System ROM
00100000-cffaffff : System RAM
  01000000-01777d18 : Kernel code
  01777d19-01d1dd7f : Kernel data
  01e7a000-01fdffff : Kernel bss
cffb0000-cffbdfff : ACPI Tables
cffbe000-cffdffff : ACPI Non-volatile Storage

cffe0000-cfffffff : reserved
d0000000-dfffffff : PCI Bus 0000:00
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:0a

f0000000-febfffff : PCI Bus 0000:00
  f0000000-f00fffff : PCI Bus 0000:04
    f0000000-f00007ff : 0000:04:00.0
      f0000000-f00007ff : firewire_ohci
  f0100000-f01fffff : PCI Bus 0000:04
    f0100000-f010ffff : 0000:04:00.1

  fdf00000-fdffffff : PCI Bus 0000:02
    fdff8000-fdffbfff : 0000:02:00.0
      fdff8000-fdffbfff : r8169
    fdfff000-fdffffff : 0000:02:00.0
      fdfff000-fdffffff : r8169
  fe7f3000-fe7f3fff : 0000:00:16.0

    fe7f3000-fe7f3fff : ohci_hcd
  fe7f4000-fe7f7fff : 0000:00:14.2
    fe7f4000-fe7f7fff : ICH HD audio
  fe7fc000-fe7fcfff : 0000:00:14.5
    fe7fc000-fe7fcfff : ohci_hcd
  fe7fd000-fe7fdfff : 0000:00:13.0

    fe7fd000-fe7fdfff : ohci_hcd
  fe7fe000-fe7fefff : 0000:00:12.0
    fe7fe000-fe7fefff : ohci_hcd
  fe7ff000-fe7ff0ff : 0000:00:16.2
    fe7ff000-fe7ff0ff : ehci_hcd
  fe7ff400-fe7ff4ff : 0000:00:13.2

    fe7ff400-fe7ff4ff : ehci_hcd
  fe7ff800-fe7ff8ff : 0000:00:12.2
    fe7ff800-fe7ff8ff : ehci_hcd
  fe7ffc00-fe7fffff : 0000:00:11.0
    fe7ffc00-fe7fffff : ahci
  fe800000-fe8fffff : PCI Bus 0000:01

    fe8c0000-fe8dffff : 0000:01:00.0
    fe8ec000-fe8effff : 0000:01:00.1
      fe8ec000-fe8effff : ICH HD audio
    fe8f0000-fe8fffff : 0000:01:00.0
  fe900000-fe9fffff : PCI Bus 0000:02
    fe9e0000-fe9fffff : 0000:02:00.0

fec00000-fec003ff : IOAPIC 0
fec10000-fec1001f : pnp 00:07
fed00000-fed003ff : HPET 2
fed80000-fed80fff : pnp 00:07
  fed80b00-fed80b07 : SB800 TCO
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:06

ffb80000-ffbfffff : pnp 00:07
fff00000-ffffffff : reserved
100000000-32fffffff : System RAM

[7.5.]
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] RS880 Host Bridge
Subsystem: Advanced Micro Devices, Inc. [AMD] RS880 Host Bridge
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

00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780 PCI to
PCI bridge (ext gfx port 0) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: fe800000-fe8fffff
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
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #2, PowerLimit 75.000W; Interlock- NoCompl+

SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+

RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
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

Address: fee0f00c  Data: 4161
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] Device 9601
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

00:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI
to PCI bridge (PCIE port 1) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0
Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
I/O behind bridge: 00001000-00001fff
Memory behind bridge: f0000000-f00fffff
Prefetchable memory behind bridge: 00000000f0100000-00000000f01fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
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
LnkCap: Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #5, PowerLimit 25.000W; Interlock- NoCompl+

SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+

RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
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

Address: fee0f00c  Data: 4171
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] Device 9601
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

00:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780 PCI to
PCI bridge (PCIE port 2) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 0000e000-0000efff
Memory behind bridge: fe900000-fe9fffff
Prefetchable memory behind bridge: 00000000fdf00000-00000000fdffffff

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
LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #6, PowerLimit 25.000W; Interlock- NoCompl+

SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+

RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
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
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] Device 9601
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

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40) (prog-if 01
[AHCI 1.0])

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
SATA Controller [AHCI mode]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 43
Region 0: I/O ports at c000 [size=8]
Region 1: I/O ports at b000 [size=4]
Region 2: I/O ports at a000 [size=8]
Region 3: I/O ports at 9000 [size=4]

Region 4: I/O ports at 8000 [size=16]
Region 5: Memory at fe7ffc00 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] MSI: Enable+ Count=1/8 Maskable- 64bit+
Address: 00000000fee0200c  Data: 41a1
Capabilities: [70] SATA HBA v1.0 InCfgSpace

Capabilities: [a4] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ahci

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
Region 0: Memory at fe7fe000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])

Subsystem: Biostar Microtech Int'l Corp Device 3701
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at fe7ff800 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci

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
Region 0: Memory at fe7fd000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])

Subsystem: Biostar Microtech Int'l Corp Device 3701
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at fe7ff400 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
Controller (rev 41)

Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Kernel driver in use: piix4_smbus

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
Azalia (Intel HDA) (rev 40)
Subsystem: Biostar Microtech Int'l Corp Device 8224
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at fe7f4000 (64-bit, non-prefetchable) [size=16K]

Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: snd_hda_intel


00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
Subsystem: Biostar Microtech Int'l Corp Device 3701
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI
to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])

Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 64
Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: fff00000-000fffff

Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-


00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
Subsystem: Biostar Microtech Int'l Corp Device 3701
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-

Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin C routed to IRQ 18
Region 0: Memory at fe7fc000 (32-bit, non-prefetchable) [size=4K]

Kernel driver in use: ohci-pci

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
Region 0: Memory at fe7f3000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])

Subsystem: Biostar Microtech Int'l Corp Device 3701
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at fe7ff000 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci

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

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] RV670 [Radeon HD 3870] (prog-if 00 [VGA controller])

Subsystem: Gigabyte Technology Co., Ltd Device 2198
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 46
Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
Region 2: Memory at fe8f0000 (64-bit, non-prefetchable) [size=64K]
Region 4: I/O ports at d000 [size=256]

Expansion ROM at fe8c0000 [disabled] [size=128K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us

ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41e1
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: radeon


01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] RV670/680
HDMI Audio [Radeon HD 3690/3800 Series]
Subsystem: Gigabyte Technology Co., Ltd Device aa18
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 45
Region 0: Memory at fe8ec000 (64-bit, non-prefetchable) [size=16K]

Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41d1
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: snd_hda_intel


02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 03)
Subsystem: Biostar Microtech Int'l Corp Device 2309
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 44
Region 0: I/O ports at e800 [size=256]

Region 2: Memory at fdfff000 (64-bit, prefetchable) [size=4K]
Region 4: Memory at fdff8000 (64-bit, prefetchable) [size=16K]
Expansion ROM at fe9e0000 [disabled] [size=128K]
Capabilities: [40] Power Management version 3

Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0100c  Data: 41b1

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

Capabilities: [ac] MSI-X: Enable- Count=4 Masked-
Vector table: BAR=4 offset=00000000
PBA: BAR=4 offset=00000800
Capabilities: [cc] Vital Product Data
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

Capabilities: [160 v1] Device Serial Number 41-00-00-00-68-4c-e0-00
Kernel driver in use: r8169

04:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6315 Series
Firewire Controller (prog-if 10 [OHCI])
Subsystem: Biostar Microtech Int'l Corp Device 0442

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0
Interrupt: pin A routed to IRQ 17
Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=2K]
Region 2: I/O ports at 1000 [size=256]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable+ 64bit+
Address: 0000000000000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [98] Express (v1) Endpoint, MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-

MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <1us, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Advanced Error Reporting

UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-

CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [130 v1] Device Serial Number 00-30-67-ff-ff-6a-f4-9b

Kernel driver in use: firewire_ohci

04:00.1 IDE interface: VIA Technologies, Inc. VT6415 PATA IDE Host
Controller (rev a0) (prog-if 85 [Master SecO PriO])
Subsystem: VIA Technologies, Inc. VT6415 PATA IDE Host Controller

Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0
Interrupt: pin A routed to IRQ 17
Region 0: I/O ports at 1410 [size=8]
Region 1: I/O ports at 1420 [size=4]
Region 2: I/O ports at 1418 [size=8]
Region 3: I/O ports at 1424 [size=4]
Region 4: I/O ports at 1400 [size=16]

[virtual] Expansion ROM at f0100000 [disabled] [size=64K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [70] MSI: Enable- Count=1/1 Maskable+ 64bit+
Address: 0000000000000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [90] Express (v1) Legacy Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us

ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes

DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <1us, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [130 v1] Device Serial Number 00-30-67-ff-ff-6a-f4-9b
Kernel driver in use: pata_via


 [7.6.] Attached devices:
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKX-0 Rev: 15.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
[X.]
I've found the issue reported many other places but couldn't find it on LKML...

http://fedoraforum.org/forum/showthread.php?t=298336
http://ubuntuforums.org/showthread.php?t=2216779

Thanks!
Bryan
