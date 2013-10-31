Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3JaN7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:59:40 -0400
Received: from nebula.mojo.cc ([46.4.89.19]:40639 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab3JaN7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:59:36 -0400
X-Greylist: delayed 1560 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2013 09:59:35 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Oct 2013 14:34:04 +0100
From: emanoil.kotsev@fincom.at
To: linux-kernel@vger.kernel.org
Subject: kernel 3.11.6 general protection fault
Message-ID: <dde3e0830b01db7868cc14a6d99f11a6@fincom.at>
User-Agent: Roundcube Webmail/0.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi and I'm sorry to bother you, but since few weeks I'm watching more 
often youtube videos and it happened that my notebook (Dell D520 - see 
below) with debian stable (wheeze) is getting regular "general 
protection fault"s.
I was thinking this has something related to a bug fixed in intel drm in 
3.11.6, so I switched from previously used 3.11.5 to 3.11.6, but issue 
is persistent and can be reproduced by simply starting youtube with some 
longer lasting videos. At some point of time (sooner or later) the 
problem appers.
Now as you can see from the logs below it stucks on different places and 
I'm totally inexperienced in kernel debugging, so I hope someone here 
could help me stabalize the system.
I also tried with much older kernel 3.3.8, but with same results.

In my opinion the problem should be somewhere between kernel - X11 
(i915/drm) - firefox - flash player

As matter of fact it does not seem to be something youtube specific, but 
rather flashplayer

I have seen drm and swapper mentioned in the logs, but again as I'm not 
experienced I would be glad if someone could give me at least an advise 
what to do next

------- cut --------
Oct 20 02:17:14 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="3909" x-info="http://www.rsyslog.com"] 
rsyslogd was HUPed
Oct 20 02:22:56 maistor kernel: perf samples too long (5008 > 5000), 
lowering kernel.perf_event_max_sample_rate to 25000
Oct 20 02:37:01 maistor kernel: general protection fault: 0000 [#1] 
PREEMPT SMP
Oct 20 02:37:01 maistor kernel: Modules linked in: snd_hrtimer nfsv3 
nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter ip_table
s x_tables cpufreq_ondemand cpufreq_powersave cpufreq_performance 
cpufreq_stats cpufreq_conservative parport_pc ppdev lp parport bnep 
rfcomm bluetooth crc16 acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_
msghandler binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
snd_usb_audio snd_hda_codec_idt snd_usbmidi_lib snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm uvcvideo 
videobuf2_vmallo
c videobuf2_memops videobuf2_core videodev media snd_seq_dummy 
snd_page_alloc snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi 
arc4 iwl3945 iwlegacy acpi_cpufreq snd_seq mac80211 cfg80211 mperf 
dell_wmi
  snd_seq_device snd_timer rfkill joydev irda snd iTCO_wdt 
iTCO_vendor_support rtc_cmos lpc_ich processor evdev i2c_i801 dcdbas 
sparse_keymap wmi yenta_socket ehci_pci 8250 pcmcia_rsrc serial_c
Oct 20 02:37:01 maistor kernel: ore crc_ccitt soundcore battery ac 
sha256_ssse3 sha256_generic cbc hid_generic usbhid hid loop dm_crypt 
dm_mod sg i915 sd_mod cfbfillrect cfbimgblt firewire_ohci sr_mod cdrom 
fi
rewire_core crc_itu_t b44 ssb mmc_core thermal mii pcmcia pcmcia_core 
video button i2c_algo_bit cfbcopyarea drm_kms_helper drm i2c_core 
thermal_sys freq_table uhci_hcd ehci_hcd intel_agp intel_gtt agpgart 
usbc
ore usb_common
Oct 20 02:37:01 maistor kernel: CPU: 0 PID: 5952 Comm: Socket Thread 
Tainted: P             3.11.6eko2 #1
Oct 20 02:37:01 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 02:37:01 maistor kernel: task: ffff88004f658cf0 ti: 
ffff88005c4a0000 task.ti: ffff88005c4a0000
Oct 20 02:37:01 maistor kernel: RIP: 0010:[<ffffffff813e0f08>]  
[<ffffffff813e0f08>] _raw_spin_lock_irqsave+0x18/0x40
Oct 20 02:37:01 maistor kernel: RSP: 0018:ffff88005c4a1ad0  EFLAGS: 
00010002
Oct 20 02:37:01 maistor kernel: RAX: 0000000000000296 RBX: 
ffff88005c4a1e18 RCX: dead000000200200
Oct 20 02:37:01 maistor kernel: RDX: 0000000000000100 RSI: 
ffff88005c4a1e18 RDI: fcff880037dd5dc0
Oct 20 02:37:01 maistor kernel: RBP: fcff880037dd5dc0 R08: 
0000000000000001 R09: 0000000000000000
Oct 20 02:37:01 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: 0000000000000000
Oct 20 02:37:01 maistor kernel: R13: ffff88005c4a1c98 R14: 
0000000000000000 R15: ffff88005c4a1bdc
Oct 20 02:37:01 maistor kernel: FS:  00007ffc37eff700(0000) 
GS:ffff88007f400000(0000) knlGS:0000000000000000
Oct 20 02:37:01 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 02:37:01 maistor kernel: CR2: 00007ffc22f17000 CR3: 
0000000058ce8000 CR4: 00000000000007f0
Oct 20 02:37:01 maistor kernel: Stack:
Oct 20 02:37:01 maistor kernel: ffffffff8105ce49 ffff8800603de800 
0000000000000006 ffff88005c4a1e08
Oct 20 02:37:01 maistor kernel: ffffffff8111e94c ffff88005c4a1bd4 
ffff88005c4a1bdc 0000000000000000
Oct 20 02:37:01 maistor kernel: 0000000000000001 0000000000000000 
ffffffff8111fa9a 0000000000000b68
Oct 20 02:37:01 maistor kernel: Call Trace:
Oct 20 02:37:01 maistor kernel: [<ffffffff8105ce49>] ? 
remove_wait_queue+0x19/0x60
Oct 20 02:37:01 maistor kernel: [<ffffffff8111e94c>] ? 
poll_freewait+0x3c/0xb0
Oct 20 02:37:01 maistor kernel: [<ffffffff8111fa9a>] ? 
do_sys_poll+0x11a/0x530
Oct 20 02:37:01 maistor kernel: [<ffffffff8132cb02>] ? 
release_sock+0xd2/0x150
Oct 20 02:37:01 maistor kernel: [<ffffffff8137d627>] ? 
tcp_recvmsg+0x447/0xdd0
Oct 20 02:37:01 maistor kernel: [<ffffffff8111e8a0>] ? 
__pollwait+0x110/0x110
Oct 20 02:37:01 maistor kernel: [<ffffffff8111e8a0>] ? 
__pollwait+0x110/0x110
Oct 20 02:37:01 maistor kernel: [<ffffffff8111e8a0>] ? 
__pollwait+0x110/0x110
Oct 20 02:37:01 maistor kernel: [<ffffffff8111e8a0>] ? 
__pollwait+0x110/0x110
Oct 20 02:37:01 maistor kernel: [<ffffffff8111e8a0>] ? 
__pollwait+0x110/0x110
Oct 20 02:37:01 maistor kernel: [<ffffffff8111e8a0>] ? 
__pollwait+0x110/0x110
Oct 20 02:37:01 maistor kernel: [<ffffffff8111e8a0>] ? 
__pollwait+0x110/0x110
Oct 20 02:37:01 maistor kernel: [<ffffffff8108343d>] ? 
ktime_get_ts+0x3d/0xe0
Oct 20 02:37:01 maistor kernel: [<ffffffff8111eb24>] ? 
poll_select_set_timeout+0x64/0x80
Oct 20 02:37:01 maistor kernel: [<ffffffff8111ff7b>] ? 
SyS_poll+0x6b/0x100
Oct 20 02:37:01 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 02:37:01 maistor kernel: Code: 38 d0 75 f7 c3 66 66 66 66 66 2e 
0f 1f 84 00 00 00 00 00 9c 58 fa 65 48 8b 14 25 70 b8 00 00 83 82 44 e0 
ff ff 01 ba 00 01 00 00 <f0> 66 0f c1 17 0f b6 ce 38 d1 74 0d 0f 1
f 40 00 f3 90 0f b6 17
Oct 20 02:37:01 maistor kernel: RSP <ffff88005c4a1ad0>
Oct 20 02:37:01 maistor kernel: ---[ end trace 22c0a8471ddbea44 ]---
Oct 20 02:37:01 maistor kernel: note: Socket Thread[5952] exited with 
preempt_count 1
Oct 20 10:45:41 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.

------- cut --------



------- cut --------
Oct 20 14:54:13 maistor kernel: ip_tables: (C) 2000-2006 Netfilter Core 
Team
Oct 20 14:54:14 maistor kernel: nf_conntrack version 0.5.0 (16384 
buckets, 65536 max)
Oct 20 14:54:16 maistor kernel: RPC: Registered named UNIX socket 
transport module.
Oct 20 14:54:16 maistor kernel: RPC: Registered udp transport module.
Oct 20 14:54:16 maistor kernel: RPC: Registered tcp transport module.
Oct 20 14:54:16 maistor kernel: RPC: Registered tcp NFSv4.1 backchannel 
transport module.
Oct 20 14:54:17 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 20 14:55:09 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:55:41 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 14:56:54 maistor kernel: perf samples too long (2503 > 2500), 
lowering kernel.perf_event_max_sample_rate to 50000
Oct 20 15:03:24 maistor kernel: perf samples too long (5020 > 5000), 
lowering kernel.perf_event_max_sample_rate to 25000
Oct 20 17:12:23 maistor kernel: CE: hpet increased min_delta_ns to 20113 
nsec
Oct 20 19:04:53 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 19:04:53 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 19:04:53 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 19:04:53 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 20 23:34:00 maistor kernel: general protection fault: 0000 [#1] 
PREEMPT SMP
Oct 20 23:34:00 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
nfsv3 nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defr
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter 
ip_tables x_tables bnep rfcomm bluetooth crc16 ppdev lp parport 
snd_hrtimer acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler
binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 snd_usb_audio 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi
uvcvideo snd_pcm_oss snd_mixer_oss snd_pcm dell_wmi i2c_i801 snd_seq 
iTCO_wdt iTCO_vendor_support sparse_keymap acpi_cpufreq yenta_socket 
lpc_ich irda arc4 videobuf2_vmalloc videobuf2_memops iwl3945 videobuf2_
core videodev iwlegacy mac80211 media mperf pcmcia_rsrc snd_page_alloc 
snd_seq_device snd_timer joydev snd rtc_cmos processor cfg80211 rfkill 
soundcore ehci_pci 8250 ac evdev battery wmi dcdba
Oct 20 23:34:00 maistor kernel: s crc_ccitt serial_core sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod i915 
cfbfillrect cfbimgblt sg b44 ssb mmc_core sr_mod cdrom mii pcmcia pcmcia
_core firewire_ohci video firewire_core crc_itu_t button i2c_algo_bit 
uhci_hcd ehci_hcd sd_mod thermal cfbcopyarea usbcore drm_kms_helper 
intel_agp intel_gtt usb_common drm agpgart i2c_core thermal_sys freq_ta
ble [last unloaded: parport_pc]
Oct 20 23:34:00 maistor kernel: CPU: 0 PID: 14534 Comm: plugin-containe 
Tainted: P             3.11.6eko2 #1
Oct 20 23:34:00 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 23:34:00 maistor kernel: task: ffff88004d5c06a0 ti: 
ffff880078ab4000 task.ti: ffff880078ab4000
Oct 20 23:34:00 maistor kernel: RIP: 0010:[<ffffffff811f4f43>]  
[<ffffffff811f4f43>] plist_add+0x63/0x110
Oct 20 23:34:00 maistor kernel: RSP: 0018:ffff880078ab5c78  EFLAGS: 
00010246
Oct 20 23:34:00 maistor kernel: RAX: feffffff816ab7b8 RBX: 
ffff880078ab5d68 RCX: feffffff816ab7b8
Oct 20 23:34:00 maistor kernel: RDX: 0000000000000000 RSI: 
0000000000000000 RDI: 0000000000000064
Oct 20 23:34:00 maistor kernel: RBP: ffffffff816ab7d0 R08: 
0000000002450080 R09: 0000000000000000
Oct 20 23:34:00 maistor kernel: R10: 0000000000000000 R11: 
0000000000000246 R12: ffff880078ab5d80
Oct 20 23:34:00 maistor kernel: R13: ffffffff816ab7d0 R14: 
ffff880078ab5d70 R15: ffff88004d5c06a0
Oct 20 23:34:00 maistor kernel: FS:  00007f961f166700(0000) 
GS:ffff88007f400000(0000) knlGS:0000000000000000
Oct 20 23:34:00 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 23:34:00 maistor kernel: CR2: 00007f68cb9cc000 CR3: 
0000000027966000 CR4: 00000000000007f0
Oct 20 23:34:00 maistor kernel: Stack:
Oct 20 23:34:00 maistor kernel: ffff880078ab5d68 ffff88004d5c06a0 
0000000000000000 ffff880078ab5d80
Oct 20 23:34:00 maistor kernel: ffffffff816ab7c8 ffffffff8108d15e 
ffff88007bda7388 0000000000000000
Oct 20 23:34:00 maistor kernel: ffff880078ab5d68 0000000000000000 
0000000000000000 0000000000000000
Oct 20 23:34:00 maistor kernel: Call Trace:
Oct 20 23:34:00 maistor kernel: [<ffffffff8108d15e>] ? 
futex_wait_queue_me+0x7e/0x150
Oct 20 23:34:00 maistor kernel: [<ffffffff8108dcdf>] ? 
futex_wait+0x15f/0x260
Oct 20 23:34:00 maistor kernel: [<ffffffff8106852a>] ? 
try_to_wake_up+0x1ba/0x290
Oct 20 23:34:00 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 20 23:34:00 maistor kernel: [<ffffffff8106ae75>] ? 
sched_clock_local+0x15/0x80
Oct 20 23:34:00 maistor kernel: [<ffffffff8108f911>] ? 
do_futex+0x131/0xb20
Oct 20 23:34:00 maistor kernel: [<ffffffff8106f66a>] ? 
pick_next_task_fair+0x6a/0x1a0
Oct 20 23:34:00 maistor kernel: [<ffffffff81064e12>] ? 
finish_task_switch+0x52/0xc0
Oct 20 23:34:00 maistor kernel: [<ffffffff813df6d1>] ? 
__schedule+0x261/0x7a0
Oct 20 23:34:00 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 20 23:34:00 maistor kernel: [<ffffffff813e1816>] ? 
retint_kernel+0x26/0x30
Oct 20 23:34:00 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 23:34:00 maistor kernel: Code: 3b 73 08 0f 85 98 00 00 00 49 8b 
4d 00 49 39 cd 74 4d 48 83 e9 18 8b 3b 31 f6 48 89 c8 eb 0c 66 0f 1f 84 
00 00 00 00 00 48 89 d0 <3b> 38 7c 69 48 8b 50 08 48 89 c6 48 83 e
a 08 48 39 d1 75 e9 48
Oct 20 23:34:00 maistor kernel: RSP <ffff880078ab5c78>
Oct 20 23:34:00 maistor kernel: ---[ end trace 658d614b0e5e9a64 ]---
Oct 20 23:34:00 maistor kernel: note: plugin-containe[14534] exited with 
preempt_count 1
Oct 20 23:34:24 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
nfsv3 nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defr
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter 
ip_tables x_tables bnep rfcomm bluetooth crc16 ppdev lp parport 
snd_hrtimer acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler
binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 snd_usb_audio 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi
uvcvideo snd_pcm_oss snd_mixer_oss snd_pcm dell_wmi i2c_i801 snd_seq 
iTCO_wdt iTCO_vendor_support sparse_keymap acpi_cpufreq yenta_socket 
lpc_ich irda arc4 videobuf2_vmalloc videobuf2_memops iwl3945 videobuf2_
core videodev iwlegacy mac80211 media mperf pcmcia_rsrc snd_page_alloc 
snd_seq_device snd_timer joydev snd rtc_cmos processor cfg80211 rfkill 
soundcore ehci_pci 8250 ac evdev battery wmi dcdba
Oct 20 23:34:24 maistor kernel: s crc_ccitt serial_core sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod i915 
cfbfillrect cfbimgblt sg b44 ssb mmc_core sr_mod cdrom mii pcmcia pcmcia
_core firewire_ohci video firewire_core crc_itu_t button i2c_algo_bit 
uhci_hcd ehci_hcd sd_mod thermal cfbcopyarea usbcore drm_kms_helper 
intel_agp intel_gtt usb_common drm agpgart i2c_core thermal_sys freq_ta
ble [last unloaded: parport_pc]
Oct 20 23:34:24 maistor kernel: CPU: 1 PID: 14535 Comm: plugin-containe 
Tainted: P      D      3.11.6eko2 #1
Oct 20 23:34:24 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 23:34:24 maistor kernel: task: ffff88007bda7340 ti: 
ffff88007a05c000 task.ti: ffff88007a05c000
Oct 20 23:34:24 maistor kernel: RIP: 0010:[<ffffffff813e0ed8>]  
[<ffffffff813e0ed8>] _raw_spin_lock+0x28/0x40
Oct 20 23:34:24 maistor kernel: RSP: 0018:ffff88007a05dd40  EFLAGS: 
00000297
Oct 20 23:34:24 maistor kernel: RAX: 0000000000000065 RBX: 
0000000000000000 RCX: 000000002fbfa04c
Oct 20 23:34:24 maistor kernel: RDX: 0000000000000066 RSI: 
00000000cad85966 RDI: ffffffff816ab7c8
Oct 20 23:34:24 maistor kernel: RBP: ffffffff816ab7c8 R08: 
00000000829f6041 R09: ffff88007a05def8
Oct 20 23:34:24 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: 0000000000000000
Oct 20 23:34:24 maistor kernel: R13: ffff88007ba00d38 R14: 
ffffffff8108d1be R15: ffff88007bda7340
Oct 20 23:34:24 maistor kernel: FS:  00007f962f973700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 20 23:34:24 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 23:34:24 maistor kernel: CR2: ffffffffff600400 CR3: 
0000000027966000 CR4: 00000000000007e0
Oct 20 23:34:24 maistor kernel: Stack:
Oct 20 23:34:24 maistor kernel: ffffffff8108e690 ffff88007ba00cf0 
ffffffff8108d8d6 0000000000000246
Oct 20 23:34:24 maistor kernel: 00007f9634436b08 00007f9634436adc 
ffff880000000000 ffff88007a05ddd0
Oct 20 23:34:24 maistor kernel: 0000000000000000 000000007fffffff 
0000000000000001 0000000000000001
Oct 20 23:34:24 maistor kernel: Call Trace:
Oct 20 23:34:24 maistor kernel: [<ffffffff8108e690>] ? 
futex_requeue+0x3d0/0x8f0
Oct 20 23:34:24 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 20 23:34:24 maistor kernel: [<ffffffff8108f8ab>] ? 
do_futex+0xcb/0xb20
Oct 20 23:34:24 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 20 23:34:24 maistor kernel: [<ffffffff813e1816>] ? 
retint_kernel+0x26/0x30
Oct 20 23:34:24 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 23:34:24 maistor kernel: Code: 90 90 90 65 48 8b 04 25 70 b8 00 
00 83 80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 
10 0f 1f 80 00 00 00 00 <f3> 90 0f b6 07 38 d0 75 f7 c3 66 66 66 6
6 66 2e 0f 1f 84 00 00
Oct 20 23:34:52 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
nfsv3 nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defr
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter 
ip_tables x_tables bnep rfcomm bluetooth crc16 ppdev lp parport 
snd_hrtimer acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler
binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 snd_usb_audio 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi
uvcvideo snd_pcm_oss snd_mixer_oss snd_pcm dell_wmi i2c_i801 snd_seq 
iTCO_wdt iTCO_vendor_support sparse_keymap acpi_cpufreq yenta_socket 
lpc_ich irda arc4 videobuf2_vmalloc videobuf2_memops iwl3945 videobuf2_
core videodev iwlegacy mac80211 media mperf pcmcia_rsrc snd_page_alloc 
snd_seq_device snd_timer joydev snd rtc_cmos processor cfg80211 rfkill 
soundcore ehci_pci 8250 ac evdev battery wmi dcdba
Oct 20 23:34:52 maistor kernel: s crc_ccitt serial_core sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod i915 
cfbfillrect cfbimgblt sg b44 ssb mmc_core sr_mod cdrom mii pcmcia pcmcia
_core firewire_ohci video firewire_core crc_itu_t button i2c_algo_bit 
uhci_hcd ehci_hcd sd_mod thermal cfbcopyarea usbcore drm_kms_helper 
intel_agp intel_gtt usb_common drm agpgart i2c_core thermal_sys freq_ta
ble [last unloaded: parport_pc]
Oct 20 23:34:52 maistor kernel: CPU: 1 PID: 14535 Comm: plugin-containe 
Tainted: P      D      3.11.6eko2 #1
Oct 20 23:34:52 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 23:34:52 maistor kernel: task: ffff88007bda7340 ti: 
ffff88007a05c000 task.ti: ffff88007a05c000
Oct 20 23:34:52 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 20 23:34:52 maistor kernel: RSP: 0018:ffff88007a05dd40  EFLAGS: 
00000297
Oct 20 23:34:52 maistor kernel: RAX: 0000000000000065 RBX: 
0000000000000000 RCX: 000000002fbfa04c
Oct 20 23:34:52 maistor kernel: RDX: 0000000000000066 RSI: 
00000000cad85966 RDI: ffffffff816ab7c8
Oct 20 23:34:52 maistor kernel: RBP: ffffffff816ab7c8 R08: 
00000000829f6041 R09: ffff88007a05def8
Oct 20 23:34:52 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: 0000000000000000
Oct 20 23:34:52 maistor kernel: R13: ffff88007ba00d38 R14: 
ffffffff8108d1be R15: ffff88007bda7340
Oct 20 23:34:52 maistor kernel: FS:  00007f962f973700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 20 23:34:52 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 23:34:52 maistor kernel: CR2: ffffffffff600400 CR3: 
0000000027966000 CR4: 00000000000007e0
Oct 20 23:34:52 maistor kernel: Stack:
Oct 20 23:34:52 maistor kernel: ffffffff8108e690 ffff88007ba00cf0 
ffffffff8108d8d6 0000000000000246
Oct 20 23:34:52 maistor kernel: 00007f9634436b08 00007f9634436adc 
ffff880000000000 ffff88007a05ddd0
Oct 20 23:34:52 maistor kernel: 0000000000000000 000000007fffffff 
0000000000000001 0000000000000001
Oct 20 23:34:52 maistor kernel: Call Trace:
Oct 20 23:34:52 maistor kernel: [<ffffffff8108e690>] ? 
futex_requeue+0x3d0/0x8f0
Oct 20 23:34:52 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 20 23:34:52 maistor kernel: [<ffffffff8108f8ab>] ? 
do_futex+0xcb/0xb20
Oct 20 23:34:52 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 20 23:34:52 maistor kernel: [<ffffffff813e1816>] ? 
retint_kernel+0x26/0x30
Oct 20 23:34:52 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 23:34:52 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 20 23:35:20 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
nfsv3 nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defr
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter 
ip_tables x_tables bnep rfcomm bluetooth crc16 ppdev lp parport 
snd_hrtimer acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler
binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 snd_usb_audio 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi
uvcvideo snd_pcm_oss snd_mixer_oss snd_pcm dell_wmi i2c_i801 snd_seq 
iTCO_wdt iTCO_vendor_support sparse_keymap acpi_cpufreq yenta_socket 
lpc_ich irda arc4 videobuf2_vmalloc videobuf2_memops iwl3945 videobuf2_
core videodev iwlegacy mac80211 media mperf pcmcia_rsrc snd_page_alloc 
snd_seq_device snd_timer joydev snd rtc_cmos processor cfg80211 rfkill 
soundcore ehci_pci 8250 ac evdev battery wmi dcdba
Oct 20 23:35:20 maistor kernel: s crc_ccitt serial_core sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod i915 
cfbfillrect cfbimgblt sg b44 ssb mmc_core sr_mod cdrom mii pcmcia pcmcia
_core firewire_ohci video firewire_core crc_itu_t button i2c_algo_bit 
uhci_hcd ehci_hcd sd_mod thermal cfbcopyarea usbcore drm_kms_helper 
intel_agp intel_gtt usb_common drm agpgart i2c_core thermal_sys freq_ta
ble [last unloaded: parport_pc]
Oct 20 23:35:20 maistor kernel: CPU: 1 PID: 14535 Comm: plugin-containe 
Tainted: P      D      3.11.6eko2 #1
Oct 20 23:35:20 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 23:35:20 maistor kernel: task: ffff88007bda7340 ti: 
ffff88007a05c000 task.ti: ffff88007a05c000
Oct 20 23:35:20 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 20 23:35:20 maistor kernel: RSP: 0018:ffff88007a05dd40  EFLAGS: 
00000297
Oct 20 23:35:20 maistor kernel: RAX: 0000000000000065 RBX: 
0000000000000000 RCX: 000000002fbfa04c
Oct 20 23:35:20 maistor kernel: RDX: 0000000000000066 RSI: 
00000000cad85966 RDI: ffffffff816ab7c8
Oct 20 23:35:20 maistor kernel: RBP: ffffffff816ab7c8 R08: 
00000000829f6041 R09: ffff88007a05def8
Oct 20 23:35:20 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: 0000000000000000
Oct 20 23:35:20 maistor kernel: R13: ffff88007ba00d38 R14: 
ffffffff8108d1be R15: ffff88007bda7340
Oct 20 23:35:20 maistor kernel: FS:  00007f962f973700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 20 23:35:20 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 23:35:20 maistor kernel: CR2: ffffffffff600400 CR3: 
0000000027966000 CR4: 00000000000007e0
Oct 20 23:35:20 maistor kernel: Stack:
Oct 20 23:35:20 maistor kernel: ffffffff8108e690 ffff88007ba00cf0 
ffffffff8108d8d6 0000000000000246
Oct 20 23:35:20 maistor kernel: 00007f9634436b08 00007f9634436adc 
ffff880000000000 ffff88007a05ddd0
Oct 20 23:35:20 maistor kernel: 0000000000000000 000000007fffffff 
0000000000000001 0000000000000001
Oct 20 23:35:20 maistor kernel: Call Trace:
Oct 20 23:35:20 maistor kernel: [<ffffffff8108e690>] ? 
futex_requeue+0x3d0/0x8f0
Oct 20 23:35:20 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 20 23:35:20 maistor kernel: [<ffffffff8108f8ab>] ? 
do_futex+0xcb/0xb20
Oct 20 23:35:20 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 20 23:35:20 maistor kernel: [<ffffffff813e1816>] ? 
retint_kernel+0x26/0x30
Oct 20 23:35:20 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 23:35:20 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 20 23:35:48 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
nfsv3 nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defr
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter 
ip_tables x_tables bnep rfcomm bluetooth crc16 ppdev lp parport 
snd_hrtimer acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler
binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 snd_usb_audio 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi
uvcvideo snd_pcm_oss snd_mixer_oss snd_pcm dell_wmi i2c_i801 snd_seq 
iTCO_wdt iTCO_vendor_support sparse_keymap acpi_cpufreq yenta_socket 
lpc_ich irda arc4 videobuf2_vmalloc videobuf2_memops iwl3945 videobuf2_
core videodev iwlegacy mac80211 media mperf pcmcia_rsrc snd_page_alloc 
snd_seq_device snd_timer joydev snd rtc_cmos processor cfg80211 rfkill 
soundcore ehci_pci 8250 ac evdev battery wmi dcdba
Oct 20 23:35:48 maistor kernel: s crc_ccitt serial_core sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod i915 
cfbfillrect cfbimgblt sg b44 ssb mmc_core sr_mod cdrom mii pcmcia pcmcia
_core firewire_ohci video firewire_core crc_itu_t button i2c_algo_bit 
uhci_hcd ehci_hcd sd_mod thermal cfbcopyarea usbcore drm_kms_helper 
intel_agp intel_gtt usb_common drm agpgart i2c_core thermal_sys freq_ta
ble [last unloaded: parport_pc]
Oct 20 23:35:48 maistor kernel: CPU: 1 PID: 14535 Comm: plugin-containe 
Tainted: P      D      3.11.6eko2 #1
Oct 20 23:35:48 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 23:35:48 maistor kernel: task: ffff88007bda7340 ti: 
ffff88007a05c000 task.ti: ffff88007a05c000
Oct 20 23:35:48 maistor kernel: RIP: 0010:[<ffffffff813e0edd>]  
[<ffffffff813e0edd>] _raw_spin_lock+0x2d/0x40
Oct 20 23:35:48 maistor kernel: RSP: 0018:ffff88007a05dd40  EFLAGS: 
00000297
Oct 20 23:35:48 maistor kernel: RAX: 0000000000000065 RBX: 
0000000000000000 RCX: 000000002fbfa04c
Oct 20 23:35:48 maistor kernel: RDX: 0000000000000066 RSI: 
00000000cad85966 RDI: ffffffff816ab7c8
Oct 20 23:35:48 maistor kernel: RBP: ffffffff816ab7c8 R08: 
00000000829f6041 R09: ffff88007a05def8
Oct 20 23:35:48 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: 0000000000000000
Oct 20 23:35:48 maistor kernel: R13: ffff88007ba00d38 R14: 
ffffffff8108d1be R15: ffff88007bda7340
Oct 20 23:35:48 maistor kernel: FS:  00007f962f973700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 20 23:35:48 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 23:35:48 maistor kernel: CR2: ffffffffff600400 CR3: 
0000000027966000 CR4: 00000000000007e0
Oct 20 23:35:48 maistor kernel: Stack:
Oct 20 23:35:48 maistor kernel: ffffffff8108e690 ffff88007ba00cf0 
ffffffff8108d8d6 0000000000000246
Oct 20 23:35:48 maistor kernel: 00007f9634436b08 00007f9634436adc 
ffff880000000000 ffff88007a05ddd0
Oct 20 23:35:48 maistor kernel: 0000000000000000 000000007fffffff 
0000000000000001 0000000000000001
Oct 20 23:35:48 maistor kernel: Call Trace:
Oct 20 23:35:48 maistor kernel: [<ffffffff8108e690>] ? 
futex_requeue+0x3d0/0x8f0
Oct 20 23:35:48 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 20 23:35:48 maistor kernel: [<ffffffff8108f8ab>] ? 
do_futex+0xcb/0xb20
Oct 20 23:35:48 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 20 23:35:48 maistor kernel: [<ffffffff813e1816>] ? 
retint_kernel+0x26/0x30
Oct 20 23:35:48 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 23:35:48 maistor kernel: Code: 8b 04 25 70 b8 00 00 83 80 44 e0 
ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 1f 80 00 
00 00 00 f3 90 0f b6 07 <38> d0 75 f7 c3 66 66 66 66 66 2e 0f 1f 8
4 00 00 00 00 00 9c 58
Oct 20 23:36:16 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
nfsv3 nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defr
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter 
ip_tables x_tables bnep rfcomm bluetooth crc16 ppdev lp parport 
snd_hrtimer acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler
binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 snd_usb_audio 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi
uvcvideo snd_pcm_oss snd_mixer_oss snd_pcm dell_wmi i2c_i801 snd_seq 
iTCO_wdt iTCO_vendor_support sparse_keymap acpi_cpufreq yenta_socket 
lpc_ich irda arc4 videobuf2_vmalloc videobuf2_memops iwl3945 videobuf2_
core videodev iwlegacy mac80211 media mperf pcmcia_rsrc snd_page_alloc 
snd_seq_device snd_timer joydev snd rtc_cmos processor cfg80211 rfkill 
soundcore ehci_pci 8250 ac evdev battery wmi dcdba
Oct 20 23:36:16 maistor kernel: s crc_ccitt serial_core sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod i915 
cfbfillrect cfbimgblt sg b44 ssb mmc_core sr_mod cdrom mii pcmcia pcmcia
_core firewire_ohci video firewire_core crc_itu_t button i2c_algo_bit 
uhci_hcd ehci_hcd sd_mod thermal cfbcopyarea usbcore drm_kms_helper 
intel_agp intel_gtt usb_common drm agpgart i2c_core thermal_sys freq_ta
ble [last unloaded: parport_pc]
Oct 20 23:36:16 maistor kernel: CPU: 1 PID: 14535 Comm: plugin-containe 
Tainted: P      D      3.11.6eko2 #1
Oct 20 23:36:16 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 23:36:16 maistor kernel: task: ffff88007bda7340 ti: 
ffff88007a05c000 task.ti: ffff88007a05c000
Oct 20 23:36:16 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 20 23:36:16 maistor kernel: RSP: 0018:ffff88007a05dd40  EFLAGS: 
00000297
Oct 20 23:36:16 maistor kernel: RAX: 0000000000000065 RBX: 
0000000000000000 RCX: 000000002fbfa04c
Oct 20 23:36:16 maistor kernel: RDX: 0000000000000066 RSI: 
00000000cad85966 RDI: ffffffff816ab7c8
Oct 20 23:36:16 maistor kernel: RBP: ffffffff816ab7c8 R08: 
00000000829f6041 R09: ffff88007a05def8
Oct 20 23:36:16 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: 0000000000000000
Oct 20 23:36:16 maistor kernel: R13: ffff88007ba00d38 R14: 
ffffffff8108d1be R15: ffff88007bda7340
Oct 20 23:36:16 maistor kernel: FS:  00007f962f973700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 20 23:36:16 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 23:36:16 maistor kernel: CR2: ffffffffff600400 CR3: 
0000000027966000 CR4: 00000000000007e0
Oct 20 23:36:16 maistor kernel: Stack:
Oct 20 23:36:16 maistor kernel: ffffffff8108e690 ffff88007ba00cf0 
ffffffff8108d8d6 0000000000000246
Oct 20 23:36:16 maistor kernel: 00007f9634436b08 00007f9634436adc 
ffff880000000000 ffff88007a05ddd0
Oct 20 23:36:16 maistor kernel: 0000000000000000 000000007fffffff 
0000000000000001 0000000000000001
Oct 20 23:36:16 maistor kernel: Call Trace:
Oct 20 23:36:16 maistor kernel: [<ffffffff8108e690>] ? 
futex_requeue+0x3d0/0x8f0
Oct 20 23:36:16 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 20 23:36:16 maistor kernel: [<ffffffff8108f8ab>] ? 
do_futex+0xcb/0xb20
Oct 20 23:36:16 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 20 23:36:16 maistor kernel: [<ffffffff813e1816>] ? 
retint_kernel+0x26/0x30
Oct 20 23:36:16 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 23:36:16 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 20 23:36:44 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
nfsv3 nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defr
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter 
ip_tables x_tables bnep rfcomm bluetooth crc16 ppdev lp parport 
snd_hrtimer acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler
binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 snd_usb_audio 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi
uvcvideo snd_pcm_oss snd_mixer_oss snd_pcm dell_wmi i2c_i801 snd_seq 
iTCO_wdt iTCO_vendor_support sparse_keymap acpi_cpufreq yenta_socket 
lpc_ich irda arc4 videobuf2_vmalloc videobuf2_memops iwl3945 videobuf2_
core videodev iwlegacy mac80211 media mperf pcmcia_rsrc snd_page_alloc 
snd_seq_device snd_timer joydev snd rtc_cmos processor cfg80211 rfkill 
soundcore ehci_pci 8250 ac evdev battery wmi dcdba
Oct 20 23:36:44 maistor kernel: s crc_ccitt serial_core sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod i915 
cfbfillrect cfbimgblt sg b44 ssb mmc_core sr_mod cdrom mii pcmcia pcmcia
_core firewire_ohci video firewire_core crc_itu_t button i2c_algo_bit 
uhci_hcd ehci_hcd sd_mod thermal cfbcopyarea usbcore drm_kms_helper 
intel_agp intel_gtt usb_common drm agpgart i2c_core thermal_sys freq_ta
ble [last unloaded: parport_pc]
Oct 20 23:36:44 maistor kernel: CPU: 1 PID: 14535 Comm: plugin-containe 
Tainted: P      D      3.11.6eko2 #1
Oct 20 23:36:44 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 23:36:44 maistor kernel: task: ffff88007bda7340 ti: 
ffff88007a05c000 task.ti: ffff88007a05c000
Oct 20 23:36:44 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 20 23:36:44 maistor kernel: RSP: 0018:ffff88007a05dd40  EFLAGS: 
00000297
Oct 20 23:36:44 maistor kernel: RAX: 0000000000000065 RBX: 
0000000000000000 RCX: 000000002fbfa04c
Oct 20 23:36:44 maistor kernel: RDX: 0000000000000066 RSI: 
00000000cad85966 RDI: ffffffff816ab7c8
Oct 20 23:36:44 maistor kernel: RBP: ffffffff816ab7c8 R08: 
00000000829f6041 R09: ffff88007a05def8
Oct 20 23:36:44 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: 0000000000000000
Oct 20 23:36:44 maistor kernel: R13: ffff88007ba00d38 R14: 
ffffffff8108d1be R15: ffff88007bda7340
Oct 20 23:36:44 maistor kernel: FS:  00007f962f973700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 20 23:36:44 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 23:36:44 maistor kernel: CR2: ffffffffff600400 CR3: 
0000000027966000 CR4: 00000000000007e0
Oct 20 23:36:44 maistor kernel: Stack:
Oct 20 23:36:44 maistor kernel: ffffffff8108e690 ffff88007ba00cf0 
ffffffff8108d8d6 0000000000000246
Oct 20 23:36:44 maistor kernel: 00007f9634436b08 00007f9634436adc 
ffff880000000000 ffff88007a05ddd0
Oct 20 23:36:44 maistor kernel: 0000000000000000 000000007fffffff 
0000000000000001 0000000000000001
Oct 20 23:36:44 maistor kernel: Call Trace:
Oct 20 23:36:44 maistor kernel: [<ffffffff8108e690>] ? 
futex_requeue+0x3d0/0x8f0
Oct 20 23:36:44 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 20 23:36:44 maistor kernel: [<ffffffff8108f8ab>] ? 
do_futex+0xcb/0xb20
Oct 20 23:36:44 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 20 23:36:44 maistor kernel: [<ffffffff813e1816>] ? 
retint_kernel+0x26/0x30
Oct 20 23:36:44 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 23:36:44 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 20 23:37:12 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
nfsv3 nfs_acl nfs lockd sunrpc iptable_nat nf_conntrack_ipv4 nf_defr
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter 
ip_tables x_tables bnep rfcomm bluetooth crc16 ppdev lp parport 
snd_hrtimer acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler
binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 snd_usb_audio 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi
uvcvideo snd_pcm_oss snd_mixer_oss snd_pcm dell_wmi i2c_i801 snd_seq 
iTCO_wdt iTCO_vendor_support sparse_keymap acpi_cpufreq yenta_socket 
lpc_ich irda arc4 videobuf2_vmalloc videobuf2_memops iwl3945 videobuf2_
core videodev iwlegacy mac80211 media mperf pcmcia_rsrc snd_page_alloc 
snd_seq_device snd_timer joydev snd rtc_cmos processor cfg80211 rfkill 
soundcore ehci_pci 8250 ac evdev battery wmi dcdba
Oct 20 23:37:12 maistor kernel: s crc_ccitt serial_core sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod i915 
cfbfillrect cfbimgblt sg b44 ssb mmc_core sr_mod cdrom mii pcmcia pcmcia
_core firewire_ohci video firewire_core crc_itu_t button i2c_algo_bit 
uhci_hcd ehci_hcd sd_mod thermal cfbcopyarea usbcore drm_kms_helper 
intel_agp intel_gtt usb_common drm agpgart i2c_core thermal_sys freq_ta
ble [last unloaded: parport_pc]
Oct 20 23:37:12 maistor kernel: CPU: 1 PID: 14535 Comm: plugin-containe 
Tainted: P      D      3.11.6eko2 #1
Oct 20 23:37:12 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 20 23:37:12 maistor kernel: task: ffff88007bda7340 ti: 
ffff88007a05c000 task.ti: ffff88007a05c000
Oct 20 23:37:12 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 20 23:37:12 maistor kernel: RSP: 0018:ffff88007a05dd40  EFLAGS: 
00000297
Oct 20 23:37:12 maistor kernel: RAX: 0000000000000065 RBX: 
0000000000000000 RCX: 000000002fbfa04c
Oct 20 23:37:12 maistor kernel: RDX: 0000000000000066 RSI: 
00000000cad85966 RDI: ffffffff816ab7c8
Oct 20 23:37:12 maistor kernel: RBP: ffffffff816ab7c8 R08: 
00000000829f6041 R09: ffff88007a05def8
Oct 20 23:37:12 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: 0000000000000000
Oct 20 23:37:12 maistor kernel: R13: ffff88007ba00d38 R14: 
ffffffff8108d1be R15: ffff88007bda7340
Oct 20 23:37:12 maistor kernel: FS:  00007f962f973700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 20 23:37:12 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 20 23:37:12 maistor kernel: CR2: ffffffffff600400 CR3: 
0000000027966000 CR4: 00000000000007e0
Oct 20 23:37:12 maistor kernel: Stack:
Oct 20 23:37:12 maistor kernel: ffffffff8108e690 ffff88007ba00cf0 
ffffffff8108d8d6 0000000000000246
Oct 20 23:37:12 maistor kernel: 00007f9634436b08 00007f9634436adc 
ffff880000000000 ffff88007a05ddd0
Oct 20 23:37:12 maistor kernel: 0000000000000000 000000007fffffff 
0000000000000001 0000000000000001
Oct 20 23:37:12 maistor kernel: Call Trace:
Oct 20 23:37:12 maistor kernel: [<ffffffff8108e690>] ? 
futex_requeue+0x3d0/0x8f0
Oct 20 23:37:12 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 20 23:37:12 maistor kernel: [<ffffffff8108f8ab>] ? 
do_futex+0xcb/0xb20
Oct 20 23:37:12 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 20 23:37:12 maistor kernel: [<ffffffff813e1816>] ? 
retint_kernel+0x26/0x30
Oct 20 23:37:12 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 20 23:37:12 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 20 23:43:10 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.
Oct 20 23:43:10 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="3912" x-info="http://www.rsyslog.com"] start

------- cut --------



------- cut --------
Oct 21 10:42:26 maistor kernel: IPv6: ADDRCONF(NETDEV_CHANGE): eth0: 
link becomes ready
Oct 21 10:42:26 maistor kernel: fuse init (API version 7.22)
Oct 21 10:42:27 maistor kernel: input: ACPI Virtual Keyboard Device as 
/devices/virtual/input/input17
Oct 21 10:42:27 maistor kernel: ipmi message handler version 39.2
Oct 21 10:42:27 maistor kernel: acpi_i2c: module license 'unspecified' 
taints kernel.
Oct 21 10:42:27 maistor kernel: Disabling lock debugging due to kernel 
taint
Oct 21 10:42:27 maistor kernel: acpi_i2c: Unknown symbol i2c_new_device 
(err 0)
Oct 21 10:42:27 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_get_resources (err 0)
Oct 21 10:42:27 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_resource_interrupt (err 0)
Oct 21 10:42:27 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_free_resource_list (err 0)
Oct 21 10:42:32 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 21 10:42:32 maistor /usr/sbin/gpm[4155]: *** info 
[daemon/startup.c(131)]:
Oct 21 10:42:32 maistor /usr/sbin/gpm[4155]: Started gpm successfully. 
Entered daemon mode.
Oct 21 10:42:33 maistor kernel: ------------[ cut here ]------------
Oct 21 10:42:33 maistor kernel: WARNING: CPU: 0 PID: 4002 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 21 10:42:33 maistor kernel: pipe state doesn't match!
Oct 21 10:42:33 maistor kernel: Modules linked in: acpi_pad 
custom_method sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput 
fuse af_packet ipv6 firewire_sbp2 snd_hda_codec_idt snd_hda_intel 
snd_hda_co
dec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm snd_page_alloc 
iwl3945 snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event 
snd_rawmidi iwlegacy mac80211 snd_seq iTCO_wdt iTCO_vendor_support 
cfg80211
  lpc_ich snd_seq_device snd_timer acpi_cpufreq i2c_i801 dell_wmi 
sparse_keymap mperf yenta_socket ehci_pci dcdbas wmi snd rtc_cmos joydev 
evdev rfkill 8250 processor pcmcia_rsrc serial_core soundcore irda crc_
ccitt battery ac sha256_ssse3 sha256_generic cbc hid_generic usbhid hid 
loop dm_crypt dm_mod sg i915 cfbfillrect cfbimgblt b44 ssb firewire_ohci 
mmc_core mii pcmcia sd_mod pcmcia_core sr_mod cdrom firewire_cor
e crc_itu_t i2c_algo_bit cfbcopyarea drm_kms_helper uhci_hcd ehci_hcd 
video drm usbcore usb_common thermal button i2c_core thermal_sys 
freq_table intel_agp intel_gtt agpgart
Oct 21 10:42:33 maistor kernel: CPU: 0 PID: 4002 Comm: Xorg Tainted: P   
           3.11.6eko2 #1
Oct 21 10:42:33 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 21 10:42:33 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff880037a61888
Oct 21 10:42:33 maistor kernel: ffffffff8103f561 ffff880079c0b6d8 
ffff880037a61900 ffff88003767b000
Oct 21 10:42:33 maistor kernel: 0000000000000001 ffff88003767b488 
ffffffff8103f645 ffffffffa0309ea2
Oct 21 10:42:33 maistor kernel: Call Trace:
Oct 21 10:42:33 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 21 10:42:33 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 21 10:42:33 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 21 10:42:33 maistor kernel: [<ffffffffa02b76ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 21 10:42:33 maistor kernel: [<ffffffffa02c1eed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 21 10:42:33 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 21 10:42:33 maistor kernel: [<ffffffffa02c23cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 21 10:42:33 maistor kernel: [<ffffffffa02c2b8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 21 10:42:33 maistor kernel: [<ffffffffa0123505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 21 10:42:33 maistor kernel: [<ffffffffa0125378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 21 10:42:33 maistor kernel: [<ffffffffa01161ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 21 10:42:33 maistor kernel: [<ffffffffa0125260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 21 10:42:33 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 21 10:42:33 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 21 10:42:33 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 21 10:42:33 maistor kernel: ---[ end trace c2feca391c032963 ]---
Oct 21 10:42:33 maistor /usr/sbin/gpm[4155]: *** info [mice.c(2059)]:
Oct 21 10:42:33 maistor /usr/sbin/gpm[4155]: Detected EXPS/2 protocol 
mouse.
Oct 21 10:42:35 maistor kernel: Bluetooth: Core ver 2.16
Oct 21 10:42:35 maistor kernel: NET: Registered protocol family 31
Oct 21 10:42:35 maistor kernel: Bluetooth: HCI device and connection 
manager initialized
Oct 21 10:42:35 maistor kernel: Bluetooth: HCI socket layer initialized
Oct 21 10:42:35 maistor kernel: Bluetooth: L2CAP socket layer 
initialized
Oct 21 10:42:35 maistor kernel: Bluetooth: SCO socket layer initialized
Oct 21 10:42:35 maistor kernel: Bluetooth: RFCOMM TTY layer initialized
Oct 21 10:42:35 maistor kernel: Bluetooth: RFCOMM socket layer 
initialized
Oct 21 10:42:35 maistor kernel: Bluetooth: RFCOMM ver 1.11
Oct 21 10:42:35 maistor kernel: Bluetooth: BNEP (Ethernet Emulation) ver 
1.3
Oct 21 10:42:35 maistor kernel: Bluetooth: BNEP filters: protocol 
multicast
Oct 21 10:42:35 maistor kernel: Bluetooth: BNEP socket layer initialized
Oct 21 10:42:36 maistor kernel: lp: driver loaded but no devices found
Oct 21 10:42:36 maistor kernel: ppdev: user-space parallel port driver
Oct 21 10:42:39 maistor kernel: ip_tables: (C) 2000-2006 Netfilter Core 
Team
Oct 21 10:42:39 maistor kernel: nf_conntrack version 0.5.0 (16384 
buckets, 65536 max)
Oct 21 10:42:45 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 21 10:42:45 maistor kernel: ------------[ cut here ]------------
Oct 21 10:42:45 maistor kernel: WARNING: CPU: 1 PID: 4002 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 21 10:42:45 maistor kernel: pipe state doesn't match!
Oct 21 10:42:45 maistor kernel: Modules linked in: xt_state xt_tcpudp 
ipt_REJECT xt_limit iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables 
x_
tables cpufreq_ondemand cpufreq_powersave cpufreq_performance 
cpufreq_stats cpufreq_conservative parport_pc ppdev lp parport bnep 
rfcomm bluetooth crc16 acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msgh
andler binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss arc4 snd_pcm snd_page_alloc iwl3945 snd_seq_dummy 
snd_seq_oss snd_s
eq_midi snd_seq_midi_event snd_rawmidi iwlegacy mac80211 snd_seq 
iTCO_wdt iTCO_vendor_support cfg80211 lpc_ich snd_seq_device snd_timer 
acpi_cpufreq i2c_i801 dell_wmi sparse_keymap mperf yenta_socket ehci_pci
dcdbas wmi snd rtc_cmos joydev evdev rfkill 8250 processor pcmcia_rsrc 
serial_core soundcore irda crc_ccitt battery ac sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_m
Oct 21 10:42:45 maistor kernel: od sg i915 cfbfillrect cfbimgblt b44 ssb 
firewire_ohci mmc_core mii pcmcia sd_mod pcmcia_core sr_mod cdrom 
firewire_core crc_itu_t i2c_algo_bit cfbcopyarea drm_kms_helper uhci_h
cd ehci_hcd video drm usbcore usb_common thermal button i2c_core 
thermal_sys freq_table intel_agp intel_gtt agpgart
Oct 21 10:42:45 maistor kernel: CPU: 1 PID: 4002 Comm: Xorg Tainted: P   
      W    3.11.6eko2 #1
Oct 21 10:42:45 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 21 10:42:45 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff880037a61888
Oct 21 10:42:45 maistor kernel: ffffffff8103f561 ffff880079c0b6d8 
ffff880037a61900 ffff88003767b000
Oct 21 10:42:45 maistor kernel: 0000000000000001 ffff88003767b488 
ffffffff8103f645 ffffffffa0309ea2
Oct 21 10:42:45 maistor kernel: Call Trace:
Oct 21 10:42:45 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 21 10:42:45 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 21 10:42:45 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 21 10:42:45 maistor kernel: [<ffffffffa02b76ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 21 10:42:45 maistor kernel: [<ffffffffa02c1eed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 21 10:42:45 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 21 10:42:45 maistor kernel: [<ffffffffa02c23cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 21 10:42:45 maistor kernel: [<ffffffffa02c2b8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 21 10:42:45 maistor kernel: [<ffffffffa0123505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 21 10:42:45 maistor kernel: [<ffffffffa0125378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 21 10:42:45 maistor kernel: [<ffffffffa01161ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 21 10:42:45 maistor kernel: [<ffffffffa0125260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 21 10:42:45 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 21 10:42:45 maistor kernel: [<ffffffff810424d5>] ? 
do_setitimer+0x1b5/0x1e0
Oct 21 10:42:45 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 21 10:42:45 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 21 10:42:45 maistor kernel: ---[ end trace c2feca391c032964 ]---
Oct 21 10:43:37 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 21 10:52:16 maistor kernel: perf samples too long (2515 > 2500), 
lowering kernel.perf_event_max_sample_rate to 50000
Oct 21 11:24:54 maistor kernel: perf samples too long (5006 > 5000), 
lowering kernel.perf_event_max_sample_rate to 25000
Oct 21 16:28:48 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 21 16:28:48 maistor shutdown[20229]: shutting down for system halt
Oct 21 17:57:29 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.
------- cut --------


------- cut --------
Oct 22 11:24:19 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 22 11:24:20 maistor kernel: ------------[ cut here ]------------
Oct 22 11:24:20 maistor kernel: WARNING: CPU: 1 PID: 4129 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 22 11:24:20 maistor kernel: pipe state doesn't match!
Oct 22 11:24:20 maistor kernel: Modules linked in: parport_pc ppdev lp 
parport bnep rfcomm bluetooth crc16 acpi_pad custom_method sbs sbshc fan 
acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6
firewire_sbp2 snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep 
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy acpi_cpufreq 
snd_page_alloc snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi 
snd_seq
  iTCO_wdt iTCO_vendor_support lpc_ich i2c_i801 mperf processor 
yenta_socket pcmcia_rsrc ehci_pci snd_seq_device snd_timer joydev snd 
rtc_cmos arc4 evdev dcdbas iwl3945 dell_wmi sparse_keymap wmi iwlegacy 
mac80
211 cfg80211 soundcore irda rfkill 8250 battery serial_core crc_ccitt ac 
sha256_ssse3 sha256_generic cbc hid_generic usbhid hid loop dm_crypt 
dm_mod b44 sg ssb firewire_ohci mmc_core mii i915 cfbfillrect cfbim
gblt pcmcia firewire_core crc_itu_t sr_mod cdrom pcmcia_core sd_mod 
i2c_algo_bit cfbcopyarea drm_kms_helper thermal drm i2c_core video 
thermal_sys freq_table button intel_agp intel_gtt agpgart
Oct 22 11:24:20 maistor kernel: uhci_hcd ehci_hcd usbcore usb_common
Oct 22 11:24:20 maistor kernel: CPU: 1 PID: 4129 Comm: Xorg Tainted: P   
           3.11.6eko2 #1
Oct 22 11:24:20 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 22 11:24:20 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff88007987b888
Oct 22 11:24:20 maistor kernel: ffffffff8103f561 ffff8800370296d8 
ffff88007987b900 ffff88003777f800
Oct 22 11:24:20 maistor kernel: 0000000000000001 ffff88003777fc88 
ffffffff8103f645 ffffffffa01acea2
Oct 22 11:24:20 maistor kernel: Call Trace:
Oct 22 11:24:20 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 22 11:24:20 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 22 11:24:20 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 22 11:24:20 maistor kernel: [<ffffffffa015a6ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 22 11:24:20 maistor kernel: [<ffffffffa0164eed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 22 11:24:20 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 22 11:24:20 maistor kernel: [<ffffffffa01653cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 22 11:24:20 maistor kernel: [<ffffffffa0165b8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 22 11:24:20 maistor kernel: [<ffffffffa010b505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 22 11:24:20 maistor kernel: [<ffffffffa010d378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 22 11:24:20 maistor kernel: [<ffffffffa00fe1ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 22 11:24:20 maistor kernel: [<ffffffffa010d260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 22 11:24:20 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 22 11:24:20 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 22 11:24:20 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 22 11:24:20 maistor kernel: ---[ end trace f2415c1ac45d1672 ]---
Oct 22 11:24:26 maistor kernel: ip_tables: (C) 2000-2006 Netfilter Core 
Team
Oct 22 11:24:27 maistor kernel: nf_conntrack version 0.5.0 (16384 
buckets, 65536 max)
Oct 22 11:24:29 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 22 11:24:30 maistor kernel: ------------[ cut here ]------------
Oct 22 11:24:30 maistor kernel: WARNING: CPU: 1 PID: 4129 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 22 11:24:30 maistor kernel: pipe state doesn't match!
Oct 22 11:24:30 maistor kernel: Modules linked in: xt_state xt_tcpudp 
ipt_REJECT xt_limit iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables 
x_
tables cpufreq_ondemand cpufreq_powersave cpufreq_performance 
cpufreq_stats cpufreq_conservative parport_pc ppdev lp parport bnep 
rfcomm bluetooth crc16 acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msgh
andler binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy acpi_cpufreq snd_page_alloc 
snd_seq_oss snd_s
eq_midi snd_seq_midi_event snd_rawmidi snd_seq iTCO_wdt 
iTCO_vendor_support lpc_ich i2c_i801 mperf processor yenta_socket 
pcmcia_rsrc ehci_pci snd_seq_device snd_timer joydev snd rtc_cmos arc4 
evdev dcdbas iwl
3945 dell_wmi sparse_keymap wmi iwlegacy mac80211 cfg80211 soundcore 
irda rfkill 8250 battery serial_core crc_ccitt ac sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_m
Oct 22 11:24:30 maistor kernel: od b44 sg ssb firewire_ohci mmc_core mii 
i915 cfbfillrect cfbimgblt pcmcia firewire_core crc_itu_t sr_mod cdrom 
pcmcia_core sd_mod i2c_algo_bit cfbcopyarea drm_kms_helper therma
l drm i2c_core video thermal_sys freq_table button intel_agp intel_gtt 
agpgart uhci_hcd ehci_hcd usbcore usb_common
Oct 22 11:24:30 maistor kernel: CPU: 1 PID: 4129 Comm: Xorg Tainted: P   
      W    3.11.6eko2 #1
Oct 22 11:24:30 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 22 11:24:30 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff88007987b888
Oct 22 11:24:30 maistor kernel: ffffffff8103f561 ffff8800370296d8 
ffff88007987b900 ffff88003777f800
Oct 22 11:24:30 maistor kernel: 0000000000000001 ffff88003777fc88 
ffffffff8103f645 ffffffffa01acea2
Oct 22 11:24:30 maistor kernel: Call Trace:
Oct 22 11:24:30 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 22 11:24:30 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 22 11:24:30 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 22 11:24:30 maistor kernel: [<ffffffffa015a6ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 22 11:24:30 maistor kernel: [<ffffffffa0164eed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 22 11:24:30 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 22 11:24:30 maistor kernel: [<ffffffffa01653cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 22 11:24:30 maistor kernel: [<ffffffffa0165b8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 22 11:24:30 maistor kernel: [<ffffffffa010b505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 22 11:24:30 maistor kernel: [<ffffffffa010d378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 22 11:24:30 maistor kernel: [<ffffffffa00fe1ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 22 11:24:30 maistor kernel: [<ffffffffa010d260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 22 11:24:30 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 22 11:24:30 maistor kernel: [<ffffffff810424d5>] ? 
do_setitimer+0x1b5/0x1e0
Oct 22 11:24:30 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 22 11:24:30 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 22 11:24:30 maistor kernel: ---[ end trace f2415c1ac45d1673 ]---
Oct 22 11:25:26 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 22 11:31:59 maistor kernel: perf samples too long (2513 > 2500), 
lowering kernel.perf_event_max_sample_rate to 50000
Oct 22 11:52:19 maistor kernel: perf samples too long (5007 > 5000), 
lowering kernel.perf_event_max_sample_rate to 25000
Oct 22 16:14:34 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 22 16:14:34 maistor shutdown[12735]: shutting down for system halt
------- cut --------


------- cut --------
Oct 23 11:09:06 maistor kernel: Bluetooth: BNEP socket layer initialized
Oct 23 11:09:07 maistor kernel: lp: driver loaded but no devices found
Oct 23 11:09:07 maistor kernel: ppdev: user-space parallel port driver
Oct 23 11:09:07 maistor /usr/sbin/gpm[4567]: *** info 
[daemon/startup.c(131)]:
Oct 23 11:09:07 maistor /usr/sbin/gpm[4567]: Started gpm successfully. 
Entered daemon mode.
Oct 23 11:09:08 maistor /usr/sbin/gpm[4567]: *** info [mice.c(2059)]:
Oct 23 11:09:08 maistor /usr/sbin/gpm[4567]: Detected EXPS/2 protocol 
mouse.
Oct 23 11:09:09 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 23 11:09:10 maistor kernel: ------------[ cut here ]------------
Oct 23 11:09:10 maistor kernel: WARNING: CPU: 1 PID: 4197 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 23 11:09:10 maistor kernel: pipe state doesn't match!
Oct 23 11:09:10 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad cus
tom_method sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput 
fuse af_packet ipv6 firewire_sbp2 snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_pcm 
s
nd_page_alloc snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi 
iTCO_wdt iTCO_vendor_support lpc_ich snd_seq i2c_i801 snd_seq_device 
yenta_socket pcmcia_rsrc acpi_cpufreq arc4 snd_timer iwl3945 snd iwleg
acy mac80211 cfg80211 rfkill ehci_pci dcdbas 8250 serial_core mperf 
dell_wmi sparse_keymap processor soundcore irda rtc_cmos crc_ccitt 
joydev wmi evdev battery ac sha256_ssse3 sha256_generic cbc hid_generic 
us
bhid hid loop dm_crypt dm_mod sg i915 cfbfillrect cfbimgblt sr_mod cdrom 
sd_mod thermal video firewire_ohci firewire_core crc_itu_t button 
i2c_algo_bit cfbcopyarea drm_kms_helper b44 ssb mmc_c
Oct 23 11:09:10 maistor kernel: ore mii pcmcia uhci_hcd ehci_hcd 
pcmcia_core drm i2c_core thermal_sys freq_table usbcore usb_common 
intel_agp intel_gtt agpgart
Oct 23 11:09:10 maistor kernel: CPU: 1 PID: 4197 Comm: Xorg Tainted: P   
           3.11.6eko2 #1
Oct 23 11:09:10 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 23 11:09:10 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff880037de7888
Oct 23 11:09:10 maistor kernel: ffffffff8103f561 ffff8800377036d8 
ffff880037de7900 ffff8800376e6800
Oct 23 11:09:10 maistor kernel: 0000000000000001 ffff8800376e6c88 
ffffffff8103f645 ffffffffa0309ea2
Oct 23 11:09:10 maistor kernel: Call Trace:
Oct 23 11:09:10 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 23 11:09:10 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 23 11:09:10 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 23 11:09:10 maistor kernel: [<ffffffffa02b76ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 23 11:09:10 maistor kernel: [<ffffffffa02c1eed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 23 11:09:10 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 23 11:09:10 maistor kernel: [<ffffffffa02c23cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 23 11:09:10 maistor kernel: [<ffffffffa02c2b8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 23 11:09:10 maistor kernel: [<ffffffffa00ef505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 23 11:09:10 maistor kernel: [<ffffffffa00f1378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 23 11:09:10 maistor kernel: [<ffffffffa00e21ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 23 11:09:10 maistor kernel: [<ffffffffa00f1260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 23 11:09:10 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 23 11:09:10 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 23 11:09:10 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 23 11:09:10 maistor kernel: ---[ end trace 76847971172ca7f5 ]---
Oct 23 11:09:15 maistor kernel: ip_tables: (C) 2000-2006 Netfilter Core 
Team
Oct 23 11:09:15 maistor kernel: nf_conntrack version 0.5.0 (16384 
buckets, 65536 max)
Oct 23 11:09:18 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 23 11:09:18 maistor kernel: ------------[ cut here ]------------
Oct 23 11:09:18 maistor kernel: WARNING: CPU: 1 PID: 4197 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 23 11:09:18 maistor kernel: pipe state doesn't match!
Oct 23 11:09:18 maistor kernel: Modules linked in: xt_state xt_tcpudp 
ipt_REJECT xt_limit iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables 
x_
tables cpufreq_ondemand cpufreq_powersave cpufreq_performance 
cpufreq_stats cpufreq_conservative parport_pc ppdev lp parport bnep 
rfcomm bluetooth crc16 acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msgh
andler binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_seq_dummy snd_pcm snd_page_alloc snd_seq_oss 
snd_seq_midi snd_s
eq_midi_event snd_rawmidi iTCO_wdt iTCO_vendor_support lpc_ich snd_seq 
i2c_i801 snd_seq_device yenta_socket pcmcia_rsrc acpi_cpufreq arc4 
snd_timer iwl3945 snd iwlegacy mac80211 cfg80211 rfkill ehci_pci dcdbas
  8250 serial_core mperf dell_wmi sparse_keymap processor soundcore irda 
rtc_cmos crc_ccitt joydev wmi evdev battery ac sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_m
Oct 23 11:09:18 maistor kernel: od sg i915 cfbfillrect cfbimgblt sr_mod 
cdrom sd_mod thermal video firewire_ohci firewire_core crc_itu_t button 
i2c_algo_bit cfbcopyarea drm_kms_helper b44 ssb mmc_core mii pcmc
ia uhci_hcd ehci_hcd pcmcia_core drm i2c_core thermal_sys freq_table 
usbcore usb_common intel_agp intel_gtt agpgart
Oct 23 11:09:18 maistor kernel: CPU: 1 PID: 4197 Comm: Xorg Tainted: P   
      W    3.11.6eko2 #1
Oct 23 11:09:18 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 23 11:09:18 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff880037de7888
Oct 23 11:09:18 maistor kernel: ffffffff8103f561 ffff8800377036d8 
ffff880037de7900 ffff8800376e6800
Oct 23 11:09:18 maistor kernel: 0000000000000001 ffff8800376e6c88 
ffffffff8103f645 ffffffffa0309ea2
Oct 23 11:09:18 maistor kernel: Call Trace:
Oct 23 11:09:18 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 23 11:09:18 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 23 11:09:18 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 23 11:09:18 maistor kernel: [<ffffffffa02b76ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 23 11:09:18 maistor kernel: [<ffffffffa02c1eed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 23 11:09:18 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 23 11:09:18 maistor kernel: [<ffffffffa02c23cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 23 11:09:18 maistor kernel: [<ffffffffa02c2b8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 23 11:09:18 maistor kernel: [<ffffffffa00ef505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 23 11:09:18 maistor kernel: [<ffffffffa00f1378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 23 11:09:18 maistor kernel: [<ffffffffa00e21ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 23 11:09:18 maistor kernel: [<ffffffffa00f1260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 23 11:09:18 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 23 11:09:18 maistor kernel: [<ffffffff810424d5>] ? 
do_setitimer+0x1b5/0x1e0
Oct 23 11:09:18 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 23 11:09:18 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 23 11:09:18 maistor kernel: ---[ end trace 76847971172ca7f6 ]---
Oct 23 11:10:10 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 23 11:22:16 maistor kernel: perf samples too long (2505 > 2500), 
lowering kernel.perf_event_max_sample_rate to 50000
Oct 23 11:54:56 maistor kernel: perf samples too long (5006 > 5000), 
lowering kernel.perf_event_max_sample_rate to 25000
Oct 23 15:43:35 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 23 15:43:35 maistor shutdown[10945]: shutting down for system halt
Oct 23 16:45:13 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.
Oct 23 16:45:13 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="3952" x-info="http://www.rsyslog.com"] start
------- cut --------



------- cut --------
Oct 24 11:00:06 maistor kernel: input: ACPI Virtual Keyboard Device as 
/devices/virtual/input/input17
Oct 24 11:00:07 maistor kernel: ipmi message handler version 39.2
Oct 24 11:00:07 maistor kernel: acpi_i2c: module license 'unspecified' 
taints kernel.
Oct 24 11:00:07 maistor kernel: Disabling lock debugging due to kernel 
taint
Oct 24 11:00:07 maistor kernel: acpi_i2c: Unknown symbol i2c_new_device 
(err 0)
Oct 24 11:00:07 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_get_resources (err 0)
Oct 24 11:00:07 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_resource_interrupt (err 0)
Oct 24 11:00:07 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_free_resource_list (err 0)
Oct 24 11:00:12 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 24 11:00:12 maistor /usr/sbin/gpm[4121]: *** info 
[daemon/startup.c(131)]:
Oct 24 11:00:12 maistor /usr/sbin/gpm[4121]: Started gpm successfully. 
Entered daemon mode.
Oct 24 11:00:12 maistor kernel: ------------[ cut here ]------------
Oct 24 11:00:12 maistor kernel: WARNING: CPU: 0 PID: 3981 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 24 11:00:12 maistor kernel: pipe state doesn't match!
Oct 24 11:00:12 maistor kernel: Modules linked in: acpi_pad 
custom_method sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput 
fuse af_packet ipv6 firewire_sbp2 arc4 iwl3945 iwlegacy mac80211 
snd_hda_cod
ec_idt cfg80211 snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_codec 
snd_hwdep lpc_ich snd_pcm_oss snd_mixer_oss snd_pcm acpi_cpufreq 
snd_page_alloc snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_even
t snd_rawmidi snd_seq yenta_socket pcmcia_rsrc i2c_i801 rfkill dcdbas 
dell_wmi mperf sparse_keymap snd_seq_device snd_timer snd irda processor 
ehci_pci joydev soundcore 8250 wmi evdev battery rtc_cmos crc_ccit
t ac serial_core sha256_ssse3 sha256_generic cbc hid_generic usbhid hid 
loop dm_crypt dm_mod sg sr_mod cdrom firewire_ohci sd_mod firewire_core 
b44 ssb crc_itu_t i915 mmc_core mii pcmcia cfbfillrect cfbimgblt
pcmcia_core thermal i2c_algo_bit cfbcopyarea drm_kms_helper drm i2c_core 
video thermal_sys freq_table uhci_hcd ehci_hcd usbcore usb_common 
intel_agp intel_gtt agpgart button
Oct 24 11:00:12 maistor kernel: CPU: 0 PID: 3981 Comm: Xorg Tainted: P   
           3.11.6eko2 #1
Oct 24 11:00:12 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 24 11:00:12 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff88007c041888
Oct 24 11:00:12 maistor kernel: ffffffff8103f561 ffff8800377ad6d8 
ffff88007c041900 ffff8800375ff000
Oct 24 11:00:12 maistor kernel: 0000000000000001 ffff8800375ff488 
ffffffff8103f645 ffffffffa01f4ea2
Oct 24 11:00:12 maistor kernel: Call Trace:
Oct 24 11:00:12 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 24 11:00:12 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 24 11:00:12 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 24 11:00:12 maistor kernel: [<ffffffffa01a26ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 24 11:00:12 maistor kernel: [<ffffffffa01aceed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 24 11:00:12 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 24 11:00:12 maistor kernel: [<ffffffffa01ad3cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 24 11:00:12 maistor kernel: [<ffffffffa01adb8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 24 11:00:12 maistor kernel: [<ffffffffa00d4505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 24 11:00:12 maistor kernel: [<ffffffffa00d6378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 24 11:00:12 maistor kernel: [<ffffffffa00c71ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 24 11:00:12 maistor kernel: [<ffffffffa00d6260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 24 11:00:12 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 24 11:00:12 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 24 11:00:12 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 24 11:00:12 maistor kernel: ---[ end trace 1160e9453740fd6a ]---
Oct 24 11:00:13 maistor /usr/sbin/gpm[4121]: *** info [mice.c(2059)]:
Oct 24 11:00:13 maistor /usr/sbin/gpm[4121]: Detected EXPS/2 protocol 
mouse.
Oct 24 11:00:14 maistor kernel: lp: driver loaded but no devices found
Oct 24 11:00:14 maistor kernel: ppdev: user-space parallel port driver
Oct 24 11:00:15 maistor kernel: Bluetooth: Core ver 2.16
Oct 24 11:00:15 maistor kernel: NET: Registered protocol family 31
Oct 24 11:00:15 maistor kernel: Bluetooth: HCI device and connection 
manager initialized
Oct 24 11:00:15 maistor kernel: Bluetooth: HCI socket layer initialized
Oct 24 11:00:15 maistor kernel: Bluetooth: L2CAP socket layer 
initialized
Oct 24 11:00:15 maistor kernel: Bluetooth: SCO socket layer initialized
Oct 24 11:00:15 maistor kernel: Bluetooth: RFCOMM TTY layer initialized
Oct 24 11:00:15 maistor kernel: Bluetooth: RFCOMM socket layer 
initialized
Oct 24 11:00:15 maistor kernel: Bluetooth: RFCOMM ver 1.11
Oct 24 11:00:15 maistor kernel: Bluetooth: BNEP (Ethernet Emulation) ver 
1.3
Oct 24 11:00:15 maistor kernel: Bluetooth: BNEP filters: protocol 
multicast
Oct 24 11:00:15 maistor kernel: Bluetooth: BNEP socket layer initialized
Oct 24 11:00:22 maistor kernel: ip_tables: (C) 2000-2006 Netfilter Core 
Team
Oct 24 11:00:23 maistor kernel: nf_conntrack version 0.5.0 (16384 
buckets, 65536 max)
Oct 24 11:00:23 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 24 11:00:23 maistor kernel: ------------[ cut here ]------------
Oct 24 11:00:23 maistor kernel: WARNING: CPU: 1 PID: 3981 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 24 11:00:23 maistor kernel: pipe state doesn't match!
Oct 24 11:00:23 maistor kernel: Modules linked in: iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
iptable_mangle iptable_filter ip_tables x_tables bnep rfcomm bluetooth 
crc16 parp
ort_pc ppdev lp parport acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
arc4 iwl3945 iwlegacy mac80211 snd_hda_codec_idt cfg80211 snd_hda_int
el iTCO_wdt iTCO_vendor_support snd_hda_codec snd_hwdep lpc_ich 
snd_pcm_oss snd_mixer_oss snd_pcm acpi_cpufreq snd_page_alloc 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_rawmidi 
snd_seq yenta
_socket pcmcia_rsrc i2c_i801 rfkill dcdbas dell_wmi mperf sparse_keymap 
snd_seq_device snd_timer snd irda processor ehci_pci joydev soundcore 
8250 wmi evdev battery rtc_cmos crc_ccitt ac serial_core sha256_sss
e3 sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod sg 
sr_mod cdrom firewire_ohci sd_mod firewire_core b44 ssb crc_itu_t i915 
mmc_core mii pcmcia cfbfillrect cfbimgblt pcmcia_cor
Oct 24 11:00:23 maistor kernel: e thermal i2c_algo_bit cfbcopyarea 
drm_kms_helper drm i2c_core video thermal_sys freq_table uhci_hcd 
ehci_hcd usbcore usb_common intel_agp intel_gtt agpgart button
Oct 24 11:00:23 maistor kernel: CPU: 1 PID: 3981 Comm: Xorg Tainted: P   
      W    3.11.6eko2 #1
Oct 24 11:00:23 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 24 11:00:23 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff88007c041888
Oct 24 11:00:23 maistor kernel: ffffffff8103f561 ffff8800377ad6d8 
ffff88007c041900 ffff8800375ff000
Oct 24 11:00:23 maistor kernel: 0000000000000001 ffff8800375ff488 
ffffffff8103f645 ffffffffa01f4ea2
Oct 24 11:00:23 maistor kernel: Call Trace:
Oct 24 11:00:23 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 24 11:00:23 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 24 11:00:23 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 24 11:00:23 maistor kernel: [<ffffffffa01a26ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 24 11:00:23 maistor kernel: [<ffffffffa01aceed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 24 11:00:23 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 24 11:00:23 maistor kernel: [<ffffffffa01ad3cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 24 11:00:23 maistor kernel: [<ffffffffa01adb8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 24 11:00:23 maistor kernel: [<ffffffffa00d4505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 24 11:00:23 maistor kernel: [<ffffffffa00d6378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 24 11:00:23 maistor kernel: [<ffffffffa00c71ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 24 11:00:23 maistor kernel: [<ffffffffa00d6260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 24 11:00:23 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 24 11:00:23 maistor kernel: [<ffffffff810424d5>] ? 
do_setitimer+0x1b5/0x1e0
Oct 24 11:00:23 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 24 11:00:23 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 24 11:00:23 maistor kernel: ---[ end trace 1160e9453740fd6b ]---
Oct 24 11:00:47 maistor vmnet-natd: RTM_NEWLINK: name:eth0 index:2 
flags:0x00011043
Oct 24 11:00:47 maistor vmnet-natd: RTM_NEWLINK: name:wlan0 index:3 
flags:0x00001002
Oct 24 11:00:47 maistor vmnet-natd: RTM_NEWROUTE: index:2
Oct 24 11:00:47 maistor vmnet-natd: RTM_NEWADDR: index:2, 
addr:10.146.8.120
Oct 24 11:00:47 maistor kernel: userif-3: sent link down event.
Oct 24 11:00:47 maistor kernel: userif-3: sent link up 
event.<7>/dev/vmnet: open called by PID 5927 (vmnet-netifup)
Oct 24 11:01:18 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 24 11:05:21 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="3837" x-info="http://www.rsyslog.com"] 
rsyslogd was HUPed
Oct 24 11:08:41 maistor kernel: perf samples too long (2504 > 2500), 
lowering kernel.perf_event_max_sample_rate to 50000
Oct 24 11:55:12 maistor kernel: perf samples too long (5004 > 5000), 
lowering kernel.perf_event_max_sample_rate to 25000
Oct 24 14:11:54 maistor kernel: INFO: NMI handler 
(perf_event_nmi_handler) took too long to run: 2.004 msecs
Oct 24 17:45:31 maistor shutdown[13485]: shutting down for system halt
Oct 24 17:45:31 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 25 00:26:00 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.

------- cut --------



------- cut --------
ct 25 12:55:40 maistor kernel: acpi_i2c: module license 'unspecified' 
taints kernel.
Oct 25 12:55:40 maistor kernel: Disabling lock debugging due to kernel 
taint
Oct 25 12:55:40 maistor kernel: acpi_i2c: Unknown symbol i2c_new_device 
(err 0)
Oct 25 12:55:40 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_get_resources (err 0)
Oct 25 12:55:40 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_resource_interrupt (err 0)
Oct 25 12:55:40 maistor kernel: acpi_i2c: Unknown symbol 
acpi_dev_free_resource_list (err 0)
Oct 25 12:55:44 maistor /usr/sbin/gpm[4096]: *** info 
[daemon/startup.c(131)]:
Oct 25 12:55:44 maistor /usr/sbin/gpm[4096]: Started gpm successfully. 
Entered daemon mode.
Oct 25 12:55:44 maistor /usr/sbin/gpm[4096]: *** info [mice.c(2059)]:
Oct 25 12:55:44 maistor /usr/sbin/gpm[4096]: Detected EXPS/2 protocol 
mouse.
Oct 25 12:55:48 maistor kernel: Bluetooth: Core ver 2.16
Oct 25 12:55:48 maistor kernel: NET: Registered protocol family 31
Oct 25 12:55:48 maistor kernel: Bluetooth: HCI device and connection 
manager initialized
Oct 25 12:55:48 maistor kernel: Bluetooth: HCI socket layer initialized
Oct 25 12:55:48 maistor kernel: Bluetooth: L2CAP socket layer 
initialized
Oct 25 12:55:48 maistor kernel: Bluetooth: SCO socket layer initialized
Oct 25 12:55:48 maistor kernel: Bluetooth: RFCOMM TTY layer initialized
Oct 25 12:55:48 maistor kernel: Bluetooth: RFCOMM socket layer 
initialized
Oct 25 12:55:48 maistor kernel: Bluetooth: RFCOMM ver 1.11
Oct 25 12:55:48 maistor kernel: Bluetooth: BNEP (Ethernet Emulation) ver 
1.3
Oct 25 12:55:48 maistor kernel: Bluetooth: BNEP filters: protocol 
multicast
Oct 25 12:55:48 maistor kernel: Bluetooth: BNEP socket layer initialized
Oct 25 12:55:48 maistor kernel: lp: driver loaded but no devices found
Oct 25 12:55:48 maistor kernel: ppdev: user-space parallel port driver
Oct 25 12:55:49 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 25 12:55:49 maistor kernel: ------------[ cut here ]------------
Oct 25 12:55:49 maistor kernel: WARNING: CPU: 0 PID: 4564 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 25 12:55:49 maistor kernel: pipe state doesn't match!
Oct 25 12:55:49 maistor kernel: Modules linked in: cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad cus
tom_method sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput 
fuse af_packet ipv6 firewire_sbp2 snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm 
snd_seq_du
mmy i2c_i801 snd_page_alloc dell_wmi sparse_keymap snd_seq_oss 
snd_seq_midi yenta_socket pcmcia_rsrc iTCO_wdt iTCO_vendor_support 
lpc_ich snd_seq_midi_event iwl3945 snd_rawmidi acpi_cpufreq iwlegacy 
mac80211 c
fg80211 rfkill ehci_pci dcdbas wmi snd_seq 8250 snd_seq_device snd_timer 
mperf serial_core rtc_cmos joydev snd irda processor soundcore crc_ccitt 
evdev battery ac sha256_ssse3 sha256_generic cbc hid_generic us
bhid hid loop dm_crypt dm_mod sg b44 ssb sr_mod cdrom firewire_ohci i915 
mmc_core mii pcmcia cfbfillrect pcmcia_core cfbimgblt firewire_core 
crc_itu_t sd_mod thermal uhci_hcd i2c_algo_bit cfbc
Oct 25 12:55:49 maistor kernel: opyarea ehci_hcd usbcore usb_common 
video intel_agp intel_gtt drm_kms_helper drm agpgart i2c_core 
thermal_sys freq_table button
Oct 25 12:55:49 maistor kernel: CPU: 0 PID: 4564 Comm: Xorg Tainted: P   
           3.11.6eko2 #1
Oct 25 12:55:49 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 25 12:55:49 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff88007b907888
Oct 25 12:55:49 maistor kernel: ffffffff8103f561 ffff880037b126d8 
ffff88007b907900 ffff88003757c800
Oct 25 12:55:49 maistor kernel: 0000000000000001 ffff88003757cc88 
ffffffff8103f645 ffffffffa0242ea2
Oct 25 12:55:49 maistor kernel: Call Trace:
Oct 25 12:55:49 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 25 12:55:49 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 25 12:55:49 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 25 12:55:49 maistor kernel: [<ffffffffa01f06ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 25 12:55:49 maistor kernel: [<ffffffffa01faeed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 25 12:55:49 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 25 12:55:49 maistor kernel: [<ffffffffa01fb3cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 25 12:55:49 maistor kernel: [<ffffffffa01fbb8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 25 12:55:49 maistor kernel: [<ffffffffa0040505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 25 12:55:49 maistor kernel: [<ffffffffa0042378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 25 12:55:49 maistor kernel: [<ffffffffa00331ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 25 12:55:49 maistor kernel: [<ffffffffa0042260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 25 12:55:49 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 25 12:55:49 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 25 12:55:49 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 25 12:55:49 maistor kernel: ---[ end trace 5db1216e0a02dfbd ]---
Oct 25 12:55:51 maistor kernel: ip_tables: (C) 2000-2006 Netfilter Core 
Team
Oct 25 12:55:51 maistor kernel: nf_conntrack version 0.5.0 (16384 
buckets, 65536 max)
Oct 25 12:56:01 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 25 12:56:01 maistor kernel: ------------[ cut here ]------------
Oct 25 12:56:01 maistor kernel: WARNING: CPU: 1 PID: 4564 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 
[i915]()
Oct 25 12:56:01 maistor kernel: pipe state doesn't match!
Oct 25 12:56:01 maistor kernel: Modules linked in: xt_state xt_tcpudp 
ipt_REJECT xt_limit iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables 
x_
tables cpufreq_ondemand cpufreq_powersave cpufreq_performance 
cpufreq_stats cpufreq_conservative parport_pc ppdev lp parport bnep 
rfcomm bluetooth crc16 acpi_pad custom_method sbs sbshc fan acpi_ipmi 
ipmi_msgh
andler binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss arc4 snd_pcm snd_seq_dummy i2c_i801 snd_page_alloc 
dell_wmi sparse_
keymap snd_seq_oss snd_seq_midi yenta_socket pcmcia_rsrc iTCO_wdt 
iTCO_vendor_support lpc_ich snd_seq_midi_event iwl3945 snd_rawmidi 
acpi_cpufreq iwlegacy mac80211 cfg80211 rfkill ehci_pci dcdbas wmi 
snd_seq 8
250 snd_seq_device snd_timer mperf serial_core rtc_cmos joydev snd irda 
processor soundcore crc_ccitt evdev battery ac sha256_ssse3 
sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_m
Oct 25 12:56:01 maistor kernel: od sg b44 ssb sr_mod cdrom firewire_ohci 
i915 mmc_core mii pcmcia cfbfillrect pcmcia_core cfbimgblt firewire_core 
crc_itu_t sd_mod thermal uhci_hcd i2c_algo_bit cfbcopyarea ehci
_hcd usbcore usb_common video intel_agp intel_gtt drm_kms_helper drm 
agpgart i2c_core thermal_sys freq_table button
Oct 25 12:56:01 maistor kernel: CPU: 1 PID: 4564 Comm: Xorg Tainted: P   
      W    3.11.6eko2 #1
Oct 25 12:56:01 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 25 12:56:01 maistor kernel: 0000000000000000 0000000000000009 
ffffffff813db19f ffff88007b907888
Oct 25 12:56:01 maistor kernel: ffffffff8103f561 ffff880037b126d8 
ffff88007b907900 ffff88003757c800
Oct 25 12:56:01 maistor kernel: 0000000000000001 ffff88003757cc88 
ffffffff8103f645 ffffffffa0242ea2
Oct 25 12:56:01 maistor kernel: Call Trace:
Oct 25 12:56:01 maistor kernel: [<ffffffff813db19f>] ? 
dump_stack+0x50/0x80
Oct 25 12:56:01 maistor kernel: [<ffffffff8103f561>] ? 
warn_slowpath_common+0x81/0xb0
Oct 25 12:56:01 maistor kernel: [<ffffffff8103f645>] ? 
warn_slowpath_fmt+0x45/0x50
Oct 25 12:56:01 maistor kernel: [<ffffffffa01f06ff>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Oct 25 12:56:01 maistor kernel: [<ffffffffa01faeed>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Oct 25 12:56:01 maistor kernel: [<ffffffff811fa769>] ? 
snprintf+0x39/0x40
Oct 25 12:56:01 maistor kernel: [<ffffffffa01fb3cd>] ? 
intel_set_mode+0x1d/0x30 [i915]
Oct 25 12:56:01 maistor kernel: [<ffffffffa01fbb8a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Oct 25 12:56:01 maistor kernel: [<ffffffffa0040505>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Oct 25 12:56:01 maistor kernel: [<ffffffffa0042378>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Oct 25 12:56:01 maistor kernel: [<ffffffffa00331ad>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 25 12:56:01 maistor kernel: [<ffffffffa0042260>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Oct 25 12:56:01 maistor kernel: [<ffffffff8111d97b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 25 12:56:01 maistor kernel: [<ffffffff810424d5>] ? 
do_setitimer+0x1b5/0x1e0
Oct 25 12:56:01 maistor kernel: [<ffffffff8111de6d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 25 12:56:01 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 25 12:56:01 maistor kernel: ---[ end trace 5db1216e0a02dfbe ]---
Oct 25 12:56:15 maistor vmnet-natd: RTM_NEWLINK: name:eth0 index:2 
flags:0x00011043
Oct 25 12:56:15 maistor vmnet-natd: RTM_NEWLINK: name:wlan0 index:3 
flags:0x00001002
Oct 25 12:56:15 maistor vmnet-natd: RTM_NEWROUTE: index:2
Oct 25 12:56:15 maistor vmnet-natd: RTM_NEWADDR: index:2, 
addr:10.146.8.71
Oct 25 12:56:15 maistor kernel: userif-3: sent link down event.
Oct 25 12:56:15 maistor kernel: userif-3: sent link up 
event.<7>/dev/vmnet: open called by PID 5755 (vmnet-netifup)
Oct 25 12:56:52 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 25 13:05:04 maistor kernel: perf samples too long (2501 > 2500), 
lowering kernel.perf_event_max_sample_rate to 50000

------- cut --------



------- cut --------
Oct 26 21:50:29 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 26 21:50:29 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 26 21:50:29 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 26 21:50:29 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 26 21:57:03 maistor kernel: general protection fault: 0000 [#1] 
PREEMPT SMP
Oct 26 21:57:03 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
snd_hrtimer vmci(O) vmmon(O) nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad 
custom_m
ethod sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse 
af_packet ipv6 firewire_sbp2 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core videodev snd_usb_audio media snd_usbmidi_lib snd_hd
a_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_page_alloc snd_seq_oss 
snd_seq_midi snd_seq_midi_event acpi_cpufreq snd_rawmidi mperf snd_seq 
arc4 yenta_so
cket pcmcia_rsrc iTCO_wdt iTCO_vendor_support iwl3945 iwlegacy lpc_ich 
mac80211 8250 i2c_i801 processor dcdbas dell_wmi sparse_keymap wmi 
snd_seq_device snd_timer joydev snd rtc_cmos battery e
Oct 26 21:57:03 maistor kernel: vdev cfg80211 rfkill ehci_pci 
serial_core ac irda soundcore crc_ccitt sha256_ssse3 sha256_generic cbc 
hid_generic usbhid hid loop dm_crypt dm_mod sg firewire_ohci sr_mod 
firewir
e_core crc_itu_t b44 ssb cdrom mmc_core mii pcmcia pcmcia_core i915 
sd_mod uhci_hcd ehci_hcd cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea 
drm_kms_helper usbcore drm usb_common i2c_core intel_agp intel_gtt ag
pgart thermal video thermal_sys freq_table button
Oct 26 21:57:03 maistor kernel: CPU: 0 PID: 30118 Comm: plugin-containe 
Tainted: P           O 3.11.6eko2 #1
Oct 26 21:57:03 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 26 21:57:03 maistor kernel: task: ffff88004d977990 ti: 
ffff88005a4ca000 task.ti: ffff88005a4ca000
Oct 26 21:57:03 maistor kernel: RIP: 0010:[<ffffffff811f4f43>]  
[<ffffffff811f4f43>] plist_add+0x63/0x110
Oct 26 21:57:03 maistor kernel: RSP: 0018:ffff88005a4cbc78  EFLAGS: 
00010246
Oct 26 21:57:03 maistor kernel: RAX: feffffff816abdb8 RBX: 
ffff88005a4cbd68 RCX: feffffff816abdb8
Oct 26 21:57:03 maistor kernel: RDX: 0000000000000000 RSI: 
0000000000000000 RDI: 0000000000000064
Oct 26 21:57:03 maistor kernel: RBP: ffffffff816abdd0 R08: 
000000009cd9ad6a R09: 0000000000000000
Oct 26 21:57:03 maistor kernel: R10: 0000000000000000 R11: 
0000000000000246 R12: ffff88005a4cbd80
Oct 26 21:57:03 maistor kernel: R13: ffffffff816abdd0 R14: 
ffff88005a4cbd70 R15: ffff88004d977990
Oct 26 21:57:03 maistor kernel: FS:  00007f259933b700(0000) 
GS:ffff88007f400000(0000) knlGS:0000000000000000
Oct 26 21:57:03 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 26 21:57:03 maistor kernel: CR2: 00007f2599339ef8 CR3: 
0000000037f6c000 CR4: 00000000000007f0
Oct 26 21:57:03 maistor kernel: Stack:
Oct 26 21:57:03 maistor kernel: ffff88005a4cbd68 ffff88004d977990 
0000000000000000 ffff88005a4cbd80
Oct 26 21:57:03 maistor kernel: ffffffff816abdc8 ffffffff8108d15e 
ffffffff81595ec0 0000000000000000
Oct 26 21:57:03 maistor kernel: ffff88005a4cbd68 0000000000000000 
0000000000000000 0000000000000000
Oct 26 21:57:03 maistor kernel: Call Trace:
Oct 26 21:57:03 maistor kernel: [<ffffffff8108d15e>] ? 
futex_wait_queue_me+0x7e/0x150
Oct 26 21:57:03 maistor kernel: [<ffffffff8108dcdf>] ? 
futex_wait+0x15f/0x260
Oct 26 21:57:03 maistor kernel: [<ffffffff8106852a>] ? 
try_to_wake_up+0x1ba/0x290
Oct 26 21:57:03 maistor kernel: [<ffffffff8108d8d6>] ? 
get_futex_key+0x136/0x280
Oct 26 21:57:03 maistor kernel: [<ffffffff8106ae75>] ? 
sched_clock_local+0x15/0x80
Oct 26 21:57:03 maistor kernel: [<ffffffff8108f911>] ? 
do_futex+0x131/0xb20
Oct 26 21:57:03 maistor kernel: [<ffffffff8106f66a>] ? 
pick_next_task_fair+0x6a/0x1a0
Oct 26 21:57:03 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 26 21:57:03 maistor kernel: [<ffffffff81064e12>] ? 
finish_task_switch+0x52/0xc0
Oct 26 21:57:03 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 26 21:57:03 maistor kernel: Code: 3b 73 08 0f 85 98 00 00 00 49 8b 
4d 00 49 39 cd 74 4d 48 83 e9 18 8b 3b 31 f6 48 89 c8 eb 0c 66 0f 1f 84 
00 00 00 00 00 48 89 d0 <3b> 38 7c 69 48 8b 50 08 48 89 c6 48 83 e
a 08 48 39 d1 75 e9 48
Oct 26 21:57:03 maistor kernel: RSP <ffff88005a4cbc78>
Oct 26 21:57:03 maistor kernel: ---[ end trace 47d602375d08e7ec ]---
Oct 26 21:57:03 maistor kernel: note: plugin-containe[30118] exited with 
preempt_count 1
Oct 26 21:57:27 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
snd_hrtimer vmci(O) vmmon(O) nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad 
custom_m
ethod sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse 
af_packet ipv6 firewire_sbp2 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core videodev snd_usb_audio media snd_usbmidi_lib snd_hd
a_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_page_alloc snd_seq_oss 
snd_seq_midi snd_seq_midi_event acpi_cpufreq snd_rawmidi mperf snd_seq 
arc4 yenta_so
cket pcmcia_rsrc iTCO_wdt iTCO_vendor_support iwl3945 iwlegacy lpc_ich 
mac80211 8250 i2c_i801 processor dcdbas dell_wmi sparse_keymap wmi 
snd_seq_device snd_timer joydev snd rtc_cmos battery e
Oct 26 21:57:27 maistor kernel: vdev cfg80211 rfkill ehci_pci 
serial_core ac irda soundcore crc_ccitt sha256_ssse3 sha256_generic cbc 
hid_generic usbhid hid loop dm_crypt dm_mod sg firewire_ohci sr_mod 
firewir
e_core crc_itu_t b44 ssb cdrom mmc_core mii pcmcia pcmcia_core i915 
sd_mod uhci_hcd ehci_hcd cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea 
drm_kms_helper usbcore drm usb_common i2c_core intel_agp intel_gtt ag
pgart thermal video thermal_sys freq_table button
Oct 26 21:57:27 maistor kernel: CPU: 1 PID: 30117 Comm: plugin-containe 
Tainted: P      D    O 3.11.6eko2 #1
Oct 26 21:57:27 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 26 21:57:27 maistor kernel: task: ffff8800077ee6a0 ti: 
ffff880056bbe000 task.ti: ffff880056bbe000
Oct 26 21:57:27 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 26 21:57:27 maistor kernel: RSP: 0018:ffff880056bbfe10  EFLAGS: 
00000287
Oct 26 21:57:27 maistor kernel: RAX: 00000000000000ef RBX: 
0000000000000001 RCX: 00000000f00154d7
Oct 26 21:57:27 maistor kernel: RDX: 00000000000000f0 RSI: 
00000000a2bea905 RDI: ffffffff816abdc8
Oct 26 21:57:27 maistor kernel: RBP: 0000000000000000 R08: 
000000001cc7fb39 R09: 0000000000000001
Oct 26 21:57:27 maistor kernel: R10: 0000000000000000 R11: 
0000000000000283 R12: 00007f258c8a58d0
Oct 26 21:57:27 maistor kernel: R13: ffff880056bbfd70 R14: 
ffff880056bbfd70 R15: 0000000000000064
Oct 26 21:57:27 maistor kernel: FS:  00007f25a357b700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 26 21:57:27 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 26 21:57:27 maistor kernel: CR2: 00000000009b40e0 CR3: 
0000000037f6c000 CR4: 00000000000007e0
Oct 26 21:57:27 maistor kernel: Stack:
Oct 26 21:57:27 maistor kernel: ffffffff8108fd0d 0000000000000000 
0000000000000029 0000000000000006
Oct 26 21:57:27 maistor kernel: 00007f258b4e0000 ffff880000000000 
ffffffff816ab738 ffff880000000000
Oct 26 21:57:27 maistor kernel: 0000000100000004 00007f258c87904c 
0000000100000000 ffffffff00000001
Oct 26 21:57:27 maistor kernel: Call Trace:
Oct 26 21:57:27 maistor kernel: [<ffffffff8108fd0d>] ? 
do_futex+0x52d/0xb20
Oct 26 21:57:27 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 26 21:57:27 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 26 21:57:27 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 26 21:57:55 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
snd_hrtimer vmci(O) vmmon(O) nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad 
custom_m
ethod sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse 
af_packet ipv6 firewire_sbp2 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core videodev snd_usb_audio media snd_usbmidi_lib snd_hd
a_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_page_alloc snd_seq_oss 
snd_seq_midi snd_seq_midi_event acpi_cpufreq snd_rawmidi mperf snd_seq 
arc4 yenta_so
cket pcmcia_rsrc iTCO_wdt iTCO_vendor_support iwl3945 iwlegacy lpc_ich 
mac80211 8250 i2c_i801 processor dcdbas dell_wmi sparse_keymap wmi 
snd_seq_device snd_timer joydev snd rtc_cmos battery e
Oct 26 21:57:55 maistor kernel: vdev cfg80211 rfkill ehci_pci 
serial_core ac irda soundcore crc_ccitt sha256_ssse3 sha256_generic cbc 
hid_generic usbhid hid loop dm_crypt dm_mod sg firewire_ohci sr_mod 
firewir
e_core crc_itu_t b44 ssb cdrom mmc_core mii pcmcia pcmcia_core i915 
sd_mod uhci_hcd ehci_hcd cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea 
drm_kms_helper usbcore drm usb_common i2c_core intel_agp intel_gtt ag
pgart thermal video thermal_sys freq_table button
Oct 26 21:57:55 maistor kernel: CPU: 1 PID: 30117 Comm: plugin-containe 
Tainted: P      D    O 3.11.6eko2 #1
Oct 26 21:57:55 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 26 21:57:55 maistor kernel: task: ffff8800077ee6a0 ti: 
ffff880056bbe000 task.ti: ffff880056bbe000
Oct 26 21:57:55 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 26 21:57:55 maistor kernel: RSP: 0018:ffff880056bbfe10  EFLAGS: 
00000287
Oct 26 21:57:55 maistor kernel: RAX: 00000000000000ef RBX: 
0000000000000001 RCX: 00000000f00154d7
Oct 26 21:57:55 maistor kernel: RDX: 00000000000000f0 RSI: 
00000000a2bea905 RDI: ffffffff816abdc8
Oct 26 21:57:55 maistor kernel: RBP: 0000000000000000 R08: 
000000001cc7fb39 R09: 0000000000000001
Oct 26 21:57:55 maistor kernel: R10: 0000000000000000 R11: 
0000000000000283 R12: 00007f258c8a58d0
Oct 26 21:57:55 maistor kernel: R13: ffff880056bbfd70 R14: 
ffff880056bbfd70 R15: 0000000000000064
Oct 26 21:57:55 maistor kernel: FS:  00007f25a357b700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 26 21:57:55 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 26 21:57:55 maistor kernel: CR2: 00000000009b40e0 CR3: 
0000000037f6c000 CR4: 00000000000007e0
Oct 26 21:57:55 maistor kernel: Stack:
Oct 26 21:57:55 maistor kernel: ffffffff8108fd0d 0000000000000000 
0000000000000029 0000000000000006
Oct 26 21:57:55 maistor kernel: 00007f258b4e0000 ffff880000000000 
ffffffff816ab738 ffff880000000000
Oct 26 21:57:55 maistor kernel: 0000000100000004 00007f258c87904c 
0000000100000000 ffffffff00000001
Oct 26 21:57:55 maistor kernel: Call Trace:
Oct 26 21:57:55 maistor kernel: [<ffffffff8108fd0d>] ? 
do_futex+0x52d/0xb20
Oct 26 21:57:55 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 26 21:57:55 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 26 21:57:55 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 26 21:58:23 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
snd_hrtimer vmci(O) vmmon(O) nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad 
custom_m
ethod sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse 
af_packet ipv6 firewire_sbp2 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core videodev snd_usb_audio media snd_usbmidi_lib snd_hd
a_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_page_alloc snd_seq_oss 
snd_seq_midi snd_seq_midi_event acpi_cpufreq snd_rawmidi mperf snd_seq 
arc4 yenta_so
cket pcmcia_rsrc iTCO_wdt iTCO_vendor_support iwl3945 iwlegacy lpc_ich 
mac80211 8250 i2c_i801 processor dcdbas dell_wmi sparse_keymap wmi 
snd_seq_device snd_timer joydev snd rtc_cmos battery e
Oct 26 21:58:23 maistor kernel: vdev cfg80211 rfkill ehci_pci 
serial_core ac irda soundcore crc_ccitt sha256_ssse3 sha256_generic cbc 
hid_generic usbhid hid loop dm_crypt dm_mod sg firewire_ohci sr_mod 
firewir
e_core crc_itu_t b44 ssb cdrom mmc_core mii pcmcia pcmcia_core i915 
sd_mod uhci_hcd ehci_hcd cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea 
drm_kms_helper usbcore drm usb_common i2c_core intel_agp intel_gtt ag
pgart thermal video thermal_sys freq_table button
Oct 26 21:58:23 maistor kernel: CPU: 1 PID: 30117 Comm: plugin-containe 
Tainted: P      D    O 3.11.6eko2 #1
Oct 26 21:58:23 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 26 21:58:23 maistor kernel: task: ffff8800077ee6a0 ti: 
ffff880056bbe000 task.ti: ffff880056bbe000
Oct 26 21:58:23 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 26 21:58:23 maistor kernel: RSP: 0018:ffff880056bbfe10  EFLAGS: 
00000287
Oct 26 21:58:23 maistor kernel: RAX: 00000000000000ef RBX: 
0000000000000001 RCX: 00000000f00154d7
Oct 26 21:58:23 maistor kernel: RDX: 00000000000000f0 RSI: 
00000000a2bea905 RDI: ffffffff816abdc8
Oct 26 21:58:23 maistor kernel: RBP: 0000000000000000 R08: 
000000001cc7fb39 R09: 0000000000000001
Oct 26 21:58:23 maistor kernel: R10: 0000000000000000 R11: 
0000000000000283 R12: 00007f258c8a58d0
Oct 26 21:58:23 maistor kernel: R13: ffff880056bbfd70 R14: 
ffff880056bbfd70 R15: 0000000000000064
Oct 26 21:58:23 maistor kernel: FS:  00007f25a357b700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 26 21:58:23 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 26 21:58:23 maistor kernel: CR2: 00000000009b40e0 CR3: 
0000000037f6c000 CR4: 00000000000007e0
Oct 26 21:58:23 maistor kernel: Stack:
Oct 26 21:58:23 maistor kernel: ffffffff8108fd0d 0000000000000000 
0000000000000029 0000000000000006
Oct 26 21:58:23 maistor kernel: 00007f258b4e0000 ffff880000000000 
ffffffff816ab738 ffff880000000000
Oct 26 21:58:23 maistor kernel: 0000000100000004 00007f258c87904c 
0000000100000000 ffffffff00000001
Oct 26 21:58:23 maistor kernel: Call Trace:
Oct 26 21:58:23 maistor kernel: [<ffffffff8108fd0d>] ? 
do_futex+0x52d/0xb20
Oct 26 21:58:23 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 26 21:58:23 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 26 21:58:23 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 26 21:58:51 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
snd_hrtimer vmci(O) vmmon(O) nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad 
custom_m
ethod sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse 
af_packet ipv6 firewire_sbp2 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core videodev snd_usb_audio media snd_usbmidi_lib snd_hd
a_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_page_alloc snd_seq_oss 
snd_seq_midi snd_seq_midi_event acpi_cpufreq snd_rawmidi mperf snd_seq 
arc4 yenta_so
cket pcmcia_rsrc iTCO_wdt iTCO_vendor_support iwl3945 iwlegacy lpc_ich 
mac80211 8250 i2c_i801 processor dcdbas dell_wmi sparse_keymap wmi 
snd_seq_device snd_timer joydev snd rtc_cmos battery e
Oct 26 21:58:51 maistor kernel: vdev cfg80211 rfkill ehci_pci 
serial_core ac irda soundcore crc_ccitt sha256_ssse3 sha256_generic cbc 
hid_generic usbhid hid loop dm_crypt dm_mod sg firewire_ohci sr_mod 
firewir
e_core crc_itu_t b44 ssb cdrom mmc_core mii pcmcia pcmcia_core i915 
sd_mod uhci_hcd ehci_hcd cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea 
drm_kms_helper usbcore drm usb_common i2c_core intel_agp intel_gtt ag
pgart thermal video thermal_sys freq_table button
Oct 26 21:58:51 maistor kernel: CPU: 1 PID: 30117 Comm: plugin-containe 
Tainted: P      D    O 3.11.6eko2 #1
Oct 26 21:58:51 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 26 21:58:51 maistor kernel: task: ffff8800077ee6a0 ti: 
ffff880056bbe000 task.ti: ffff880056bbe000
Oct 26 21:58:51 maistor kernel: RIP: 0010:[<ffffffff813e0edf>]  
[<ffffffff813e0edf>] _raw_spin_lock+0x2f/0x40
Oct 26 21:58:51 maistor kernel: RSP: 0018:ffff880056bbfe10  EFLAGS: 
00000287
Oct 26 21:58:51 maistor kernel: RAX: 00000000000000ef RBX: 
0000000000000001 RCX: 00000000f00154d7
Oct 26 21:58:51 maistor kernel: RDX: 00000000000000f0 RSI: 
00000000a2bea905 RDI: ffffffff816abdc8
Oct 26 21:58:51 maistor kernel: RBP: 0000000000000000 R08: 
000000001cc7fb39 R09: 0000000000000001
Oct 26 21:58:51 maistor kernel: R10: 0000000000000000 R11: 
0000000000000283 R12: 00007f258c8a58d0
Oct 26 21:58:51 maistor kernel: R13: ffff880056bbfd70 R14: 
ffff880056bbfd70 R15: 0000000000000064
Oct 26 21:58:51 maistor kernel: FS:  00007f25a357b700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 26 21:58:51 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 26 21:58:51 maistor kernel: CR2: 00000000009b40e0 CR3: 
0000000037f6c000 CR4: 00000000000007e0
Oct 26 21:58:51 maistor kernel: Stack:
Oct 26 21:58:51 maistor kernel: ffffffff8108fd0d 0000000000000000 
0000000000000029 0000000000000006
Oct 26 21:58:51 maistor kernel: 00007f258b4e0000 ffff880000000000 
ffffffff816ab738 ffff880000000000
Oct 26 21:58:51 maistor kernel: 0000000100000004 00007f258c87904c 
0000000100000000 ffffffff00000001
Oct 26 21:58:51 maistor kernel: Call Trace:
Oct 26 21:58:51 maistor kernel: [<ffffffff8108fd0d>] ? 
do_futex+0x52d/0xb20
Oct 26 21:58:51 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 26 21:58:51 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 26 21:58:51 maistor kernel: Code: 25 70 b8 00 00 83 80 44 e0 ff ff 
01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 1f 80 00 00 00 
00 f3 90 0f b6 07 38 d0 <75> f7 c3 66 66 66 66 66 2e 0f 1f 84 00 0
0 00 00 00 9c 58 fa 65
Oct 26 21:59:19 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
snd_hrtimer vmci(O) vmmon(O) nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad 
custom_m
ethod sbs sbshc fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse 
af_packet ipv6 firewire_sbp2 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core videodev snd_usb_audio media snd_usbmidi_lib snd_hd
a_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_page_alloc snd_seq_oss 
snd_seq_midi snd_seq_midi_event acpi_cpufreq snd_rawmidi mperf snd_seq 
arc4 yenta_so
cket pcmcia_rsrc iTCO_wdt iTCO_vendor_support iwl3945 iwlegacy lpc_ich 
mac80211 8250 i2c_i801 processor dcdbas dell_wmi sparse_keymap wmi 
snd_seq_device snd_timer joydev snd rtc_cmos battery e
Oct 26 21:59:19 maistor kernel: vdev cfg80211 rfkill ehci_pci 
serial_core ac irda soundcore crc_ccitt sha256_ssse3 sha256_generic cbc 
hid_generic usbhid hid loop dm_crypt dm_mod sg firewire_ohci sr_mod 
firewir
e_core crc_itu_t b44 ssb cdrom mmc_core mii pcmcia pcmcia_core i915 
sd_mod uhci_hcd ehci_hcd cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea 
drm_kms_helper usbcore drm usb_common i2c_core intel_agp intel_gtt ag
pgart thermal video thermal_sys freq_table button
Oct 26 21:59:19 maistor kernel: CPU: 1 PID: 30117 Comm: plugin-containe 
Tainted: P      D    O 3.11.6eko2 #1
Oct 26 21:59:19 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 26 21:59:19 maistor kernel: task: ffff8800077ee6a0 ti: 
ffff880056bbe000 task.ti: ffff880056bbe000
Oct 26 21:59:19 maistor kernel: RIP: 0010:[<ffffffff813e0eda>]  
[<ffffffff813e0eda>] _raw_spin_lock+0x2a/0x40
Oct 26 21:59:19 maistor kernel: RSP: 0018:ffff880056bbfe10  EFLAGS: 
00000287
Oct 26 21:59:19 maistor kernel: RAX: 00000000000000ef RBX: 
0000000000000001 RCX: 00000000f00154d7
Oct 26 21:59:19 maistor kernel: RDX: 00000000000000f0 RSI: 
00000000a2bea905 RDI: ffffffff816abdc8
Oct 26 21:59:19 maistor kernel: RBP: 0000000000000000 R08: 
000000001cc7fb39 R09: 0000000000000001
Oct 26 21:59:19 maistor kernel: R10: 0000000000000000 R11: 
0000000000000283 R12: 00007f258c8a58d0
Oct 26 21:59:19 maistor kernel: R13: ffff880056bbfd70 R14: 
ffff880056bbfd70 R15: 0000000000000064
Oct 26 21:59:19 maistor kernel: FS:  00007f25a357b700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 26 21:59:19 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 26 21:59:19 maistor kernel: CR2: 00000000009b40e0 CR3: 
0000000037f6c000 CR4: 00000000000007e0
Oct 26 21:59:19 maistor kernel: Stack:
Oct 26 21:59:19 maistor kernel: ffffffff8108fd0d 0000000000000000 
0000000000000029 0000000000000006
Oct 26 21:59:19 maistor kernel: 00007f258b4e0000 ffff880000000000 
ffffffff816ab738 ffff880000000000
Oct 26 21:59:19 maistor kernel: 0000000100000004 00007f258c87904c 
0000000100000000 ffffffff00000001
Oct 26 21:59:19 maistor kernel: Call Trace:
Oct 26 21:59:19 maistor kernel: [<ffffffff8108fd0d>] ? 
do_futex+0x52d/0xb20
Oct 26 21:59:19 maistor kernel: [<ffffffff8109039f>] ? 
SyS_futex+0x9f/0x1d0
Oct 26 21:59:19 maistor kernel: [<ffffffff813e1e56>] ? 
system_call_fastpath+0x1a/0x1f
Oct 26 21:59:19 maistor kernel: Code: 90 65 48 8b 04 25 70 b8 00 00 83 
80 44 e0 ff ff 01 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 10 0f 
1f 80 00 00 00 00 f3 90 <0f> b6 07 38 d0 75 f7 c3 66 66 66 66 66 2
e 0f 1f 84 00 00 00 00
Oct 26 22:04:04 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.
Oct 26 22:04:04 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="3903" x-info="http://www.rsyslog.com"] start

------- cut --------



------- cut --------
Oct 15 20:16:16 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 15 20:16:45 maistor kernel: general protection fault: 0000 [#1] 
PREEMPT SMP
Oct 15 20:16:45 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
vmci(O) vmmon(O) snd_hrtimer nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad sbs 
sbsh
c fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6 
firewire_sbp2 uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core 
videodev snd_usb_audio snd_usbmidi_lib media snd_hda_codec_idt sn
d_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_page_alloc snd_seq_oss snd_seq_midi snd_seq_midi_event 
arc4 snd_rawmidi iTCO_wdt iTCO_vendor_support iwl3945 iwlegacy snd
_seq mac80211 8250 cfg80211 lpc_ich acpi_cpufreq mperf dcdbas ehci_pci 
yenta_socket pcmcia_rsrc joydev serial_core snd_seq_device snd_timer 
rtc_cmos snd rfkill i2c_i801 dell_wmi sparse_keymap
Oct 15 20:16:45 maistor kernel: ac processor evdev wmi battery irda 
soundcore crc_ccitt sha256_ssse3 sha256_generic cbc hid_generic usbhid 
hid loop dm_crypt dm_mod i915 cfbfillrect cfbimgblt sg b44 sd_mod fire
wire_ohci ssb firewire_core crc_itu_t sr_mod cdrom thermal video 
mmc_core mii pcmcia pcmcia_core button i2c_algo_bit cfbcopyarea 
drm_kms_helper uhci_hcd ehci_hcd drm i2c_core thermal_sys freq_table 
intel_agp i
ntel_gtt hwmon agpgart usbcore usb_common
Oct 15 20:16:45 maistor kernel: CPU: 0 PID: 4058 Comm: Xorg Tainted: P   
         O 3.10.9eko2 #4
Oct 15 20:16:45 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 15 20:16:45 maistor kernel: task: ffff8800378c3340 ti: 
ffff88007c0a0000 task.ti: ffff88007c0a0000
Oct 15 20:16:45 maistor kernel: RIP: 0010:[<ffffffff81043a0e>]  
[<ffffffff81043a0e>] lock_timer_base.isra.29+0x1e/0x70
Oct 15 20:16:45 maistor kernel: RSP: 0018:ffff88007c0a1b88  EFLAGS: 
00010296
Oct 15 20:16:45 maistor kernel: RAX: ffff88007c0a1fd8 RBX: 
fcff88007c0a1c10 RCX: 0000000000000000
Oct 15 20:16:45 maistor kernel: RDX: 0000000000000000 RSI: 
ffff88007c0a1bc0 RDI: fcff88007c0a1c28
Oct 15 20:16:45 maistor kernel: RBP: fcff88007c0a1c10 R08: 
ffff88007c0a0000 R09: 0000000000000000
Oct 15 20:16:45 maistor kernel: R10: ffff88007f40ed40 R11: 
0000000000000004 R12: fcff88007c0a1c28
Oct 15 20:16:45 maistor kernel: R13: ffff88007c0a1bc0 R14: 
0000000000000000 R15: 000000000005694d
Oct 15 20:16:45 maistor kernel: FS:  00007f9bf3584880(0000) 
GS:ffff88007f400000(0000) knlGS:0000000000000000
Oct 15 20:16:45 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 15 20:16:45 maistor kernel: CR2: 00007f99154dc000 CR3: 
00000000796f9000 CR4: 00000000000007f0
Oct 15 20:16:45 maistor kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct 15 20:16:45 maistor kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct 15 20:16:45 maistor kernel: Stack:
Oct 15 20:16:45 maistor kernel: 0000000000000246 fcff88007c0a1c10 
fcff88007c0a1c10 ffffffff8168ba00
Oct 15 20:16:45 maistor kernel: 000000010014295f ffffffff81043e7f 
0000000000000286 fcff88007c0a1c10
Oct 15 20:16:45 maistor kernel: ffffffff8168ba00 fcff88007c0a1c10 
ffffffff8168ba00 ffffffff81043f1a
Oct 15 20:16:45 maistor kernel: Call Trace:
Oct 15 20:16:45 maistor kernel: [<ffffffff81043e7f>] ? 
try_to_del_timer_sync+0x1f/0x70
Oct 15 20:16:45 maistor kernel: [<ffffffff81043f1a>] ? 
del_timer_sync+0x4a/0x60
Oct 15 20:16:45 maistor kernel: [<ffffffff813ce662>] ? 
schedule_timeout+0x132/0x1e0
Oct 15 20:16:45 maistor kernel: [<ffffffff810435e0>] ? 
usleep_range+0x40/0x40
Oct 15 20:16:45 maistor kernel: [<ffffffffa0290459>] ? 
__wait_seqno+0x3e9/0x4d0 [i915]
Oct 15 20:16:45 maistor kernel: [<ffffffff813cf1ae>] ? 
__mutex_lock_interruptible_slowpath+0x24e/0x3d0
Oct 15 20:16:45 maistor kernel: [<ffffffff810570c0>] ? 
abort_exclusive_wait+0xb0/0xb0
Oct 15 20:16:45 maistor kernel: [<ffffffffa0294ca8>] ? 
i915_gem_throttle_ioctl+0x108/0x170 [i915]
Oct 15 20:16:45 maistor kernel: [<ffffffffa00eb1bd>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Oct 15 20:16:45 maistor kernel: [<ffffffffa0294ba0>] ? 
i915_gem_busy_ioctl+0x120/0x120 [i915]
Oct 15 20:16:45 maistor kernel: [<ffffffff810ff50a>] ? 
do_sync_read+0x6a/0xa0
Oct 15 20:16:45 maistor kernel: [<ffffffff8111101b>] ? 
do_vfs_ioctl+0x8b/0x530
Oct 15 20:16:45 maistor kernel: [<ffffffff8105987b>] ? 
hrtimer_try_to_cancel+0x3b/0x80
Oct 15 20:16:45 maistor kernel: [<ffffffff81044a12>] ? 
recalc_sigpending+0x12/0x50
Oct 15 20:16:45 maistor kernel: [<ffffffff810455c0>] ? 
__set_task_blocked+0x30/0x80
Oct 15 20:16:45 maistor kernel: [<ffffffff8103c955>] ? 
do_setitimer+0x1b5/0x1e0
Oct 15 20:16:45 maistor kernel: [<ffffffff8111150d>] ? 
SyS_ioctl+0x4d/0xa0
Oct 15 20:16:45 maistor kernel: [<ffffffff813d2716>] ? 
system_call_fastpath+0x1a/0x1f
Oct 15 20:16:45 maistor kernel: Code: ff 66 66 66 2e 0f 1f 84 00 00 00 
00 00 48 83 ec 28 4c 89 64 24 18 49 89 fc 4c 89 6c 24 20 49 89 f5 48 89 
5c 24 08 48 89 6c 24 10 <49> 8b 1c 24 48 89 dd 48 83 e5 fc 74 39 4
8 89 ef e8 6d dd 38 00
Oct 15 20:16:45 maistor kernel: RSP <ffff88007c0a1b88>
Oct 15 20:16:45 maistor kernel: ---[ end trace 7cbdcbbdb0f7f408 ]---
Oct 15 20:16:49 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 15 20:16:49 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 15 20:16:51 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 15 20:17:38 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 15 20:17:38 maistor shutdown[6601]: shutting down for system reboot
Oct 15 20:18:31 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.
Oct 15 20:18:31 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="3866" x-info="http://www.rsyslog.com"] start

------- cut --------

------- cut --------
Oct 17 10:16:40 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 10:40:44 maistor kernel: stack segment: 0000 [#1] PREEMPT SMP
Oct 17 10:40:44 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
vmci(O) snd_hrtimer vmmon(O) cpufreq_ondemand cpufreq_powersave 
cpufreq_performance cpufreq_stats cpufreq_conservative nfsv3 nfs_acl nfs 
loc
kd sunrpc iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables x_tables 
bnep rfcomm bluetooth crc16 parport_pc ppdev lp parport acpi_pad sbs 
sbsh
c fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6 
firewire_sbp2 uvcvideo snd_hda_codec_idt snd_hda_intel videobuf2_vmalloc 
videobuf2_memops videobuf2_core snd_hda_codec videodev media snd_
usb_audio snd_usbmidi_lib snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_page_alloc snd_seq_oss acpi_cpufreq snd_seq_midi 
snd_seq_midi_event arc4 snd_rawmidi 8250 mperf iTCO_wdt iTCO_vendor_supp
ort iwl3945 iwlegacy mac80211 lpc_ich cfg80211 rfkill irda yenta_socket 
pcmcia_rsrc snd_seq joydev serial_core snd_seq_device snd_timer rtc_cmos 
processor i2c_i801 dell_wmi sparse_keymap dcdba
Oct 17 10:40:44 maistor kernel: s wmi snd battery ac crc_ccitt ehci_pci 
evdev soundcore sha256_ssse3 sha256_generic cbc hid_generic usbhid hid 
loop dm_crypt dm_mod i915 cfbfillrect cfbimgblt thermal firewire_o
hci firewire_core crc_itu_t sg b44 ssb mmc_core mii pcmcia pcmcia_core 
video button uhci_hcd i2c_algo_bit ehci_hcd sr_mod cdrom cfbcopyarea 
sd_mod usbcore usb_common drm_kms_helper intel_agp drm intel_gtt agpg
art i2c_core thermal_sys freq_table hwmon
Oct 17 10:40:44 maistor kernel: CPU: 1 PID: 6417 Comm: plugin-containe 
Tainted: P           O 3.10.9eko2 #4
Oct 17 10:40:44 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 17 10:40:44 maistor kernel: task: ffff8800672b7990 ti: 
ffff88007a0c8000 task.ti: ffff88007a0c8000
Oct 17 10:40:44 maistor kernel: RIP: 0010:[<ffffffff810597a8>]  
[<ffffffff810597a8>] lock_hrtimer_base.isra.32+0x18/0x60
Oct 17 10:40:44 maistor kernel: RSP: 0000:ffff88007a0c9e58  EFLAGS: 
00010292
Oct 17 10:40:44 maistor kernel: RAX: 0000000000000000 RBX: 
fdff88007a0c9ef0 RCX: 0000000000000000
Oct 17 10:40:44 maistor kernel: RDX: ffff88007a0c9fd8 RSI: 
ffff88007a0c9e80 RDI: fdff88007a0c9f20
Oct 17 10:40:44 maistor kernel: RBP: fdff88007a0c9f20 R08: 
ffff88007a0c8000 R09: 0000000000000001
Oct 17 10:40:44 maistor kernel: R10: 00000000000000b0 R11: 
0000000000000001 R12: ffff88007a0c9e80
Oct 17 10:40:44 maistor kernel: R13: 0000000000000000 R14: 
0000000000000000 R15: 00007f8655eda640
Oct 17 10:40:44 maistor kernel: FS:  00007f8657ffd700(0000) 
GS:ffff88007f500000(0000) knlGS:0000000000000000
Oct 17 10:40:44 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 17 10:40:44 maistor kernel: CR2: 00000000014b21b0 CR3: 
0000000032eee000 CR4: 00000000000007e0
Oct 17 10:40:44 maistor kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct 17 10:40:44 maistor kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct 17 10:40:44 maistor kernel: Stack:
Oct 17 10:40:44 maistor kernel: fdff88007a0c9ef0 ffff8800672b7990 
ffff8800672b7990 ffffffff81059857
Oct 17 10:40:44 maistor kernel: ffff88007a0c9fd8 fdff88007a0c9ef0 
ffff8800672b7990 fdff88007a0c9ef0
Oct 17 10:40:44 maistor kernel: ffff8800672b7990 ffffffff810598da 
fdff88007a0c9ef0 ffffffff813cf8d9
Oct 17 10:40:44 maistor kernel: Call Trace:
Oct 17 10:40:44 maistor kernel: [<ffffffff81059857>] ? 
hrtimer_try_to_cancel+0x17/0x80
Oct 17 10:40:44 maistor kernel: [<ffffffff810598da>] ? 
hrtimer_cancel+0x1a/0x30
Oct 17 10:40:44 maistor kernel: [<ffffffff813cf8d9>] ? 
do_nanosleep+0xa9/0xe0
Oct 17 10:40:44 maistor kernel: [<ffffffff8105a40d>] ? 
hrtimer_nanosleep+0xfd/0x130
Oct 17 10:40:44 maistor kernel: [<ffffffff8105a39d>] ? 
hrtimer_nanosleep+0x8d/0x130
Oct 17 10:40:44 maistor kernel: [<ffffffff81059520>] ? 
update_rmtp+0x60/0x60
Oct 17 10:40:44 maistor kernel: [<ffffffff8105a495>] ? 
SyS_nanosleep+0x55/0x70
Oct 17 10:40:44 maistor kernel: [<ffffffff813d2716>] ? 
system_call_fastpath+0x1a/0x1f
Oct 17 10:40:44 maistor kernel: Code: 0d 57 52 00 01 48 8b 43 38 eb a0 
0f 1f 84 00 00 00 00 00 48 83 ec 18 48 89 6c 24 08 48 89 fd 4c 89 64 24 
10 49 89 f4 48 89 1c 24 <48> 8b 5d 00 48 85 db 74 33 48 8b 3b e8 d
7 7f 37 00 49 89 04 24
Oct 17 10:40:44 maistor kernel: RSP <ffff88007a0c9e58>
Oct 17 10:40:44 maistor kernel: ---[ end trace 119c4612add7f90c ]---
Oct 17 10:40:44 maistor kernel: note: plugin-containe[6417] exited with 
preempt_count 1
Oct 17 12:01:43 maistor kernel: 6:3:1: cannot get freq at ep 0x84

------- cut --------

------- cut --------
ct 17 12:52:00 maistor kernel: ppdev: user-space parallel port driver
Oct 17 12:52:01 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 12:52:09 maistor kernel: ip_tables: (C) 2000-2006 Netfilter Core 
Team
Oct 17 12:52:09 maistor kernel: nf_conntrack version 0.5.0 (16384 
buckets, 65536 max)
Oct 17 12:52:09 maistor kernel: RPC: Registered named UNIX socket 
transport module.
Oct 17 12:52:09 maistor kernel: RPC: Registered udp transport module.
Oct 17 12:52:09 maistor kernel: RPC: Registered tcp transport module.
Oct 17 12:52:09 maistor kernel: RPC: Registered tcp NFSv4.1 backchannel 
transport module.
Oct 17 12:52:10 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 12:52:28 maistor vmnet-natd: RTM_NEWLINK: name:eth0 index:2 
flags:0x00011043
Oct 17 12:52:28 maistor vmnet-natd: RTM_NEWLINK: name:wlan0 index:3 
flags:0x00001002
Oct 17 12:52:28 maistor vmnet-natd: RTM_NEWROUTE: index:2
Oct 17 12:52:28 maistor vmnet-natd: RTM_NEWADDR: index:2, 
addr:192.168.40.80
Oct 17 12:52:28 maistor kernel: userif-3: sent link down event.
Oct 17 12:52:28 maistor kernel: userif-3: sent link up 
event.<7>/dev/vmnet: open called by PID 5726 (vmnet-netifup)
Oct 17 12:52:59 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 12:53:24 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:24 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:24 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:24 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:25 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:25 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:25 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:25 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:25 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:25 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 12:53:25 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 13:16:14 maistor kernel: PGD 4d2c7067 PUD 4d2c9067 PMD 0
Oct 17 13:16:14 maistor kernel: Oops: 0000 [#1] PREEMPT SMP
Oct 17 13:16:14 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
vmci(O) vmmon(O) snd_hrtimer nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad sbs 
sbsh
c fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6 
firewire_sbp2 uvcvideo videobuf2_vmalloc snd_usb_audio videobuf2_memops 
videobuf2_core videodev media snd_hda_codec_idt snd_usbmidi_lib sn
d_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_pcm_oss 
snd_mixer_oss snd_pcm snd_page_alloc snd_seq_oss snd_seq_midi 
snd_seq_midi_event acpi_cpufreq iTCO_wdt iTCO_vendor_support arc4 
lpc_ich snd_rawmidi
  mperf iwl3945 ehci_pci iwlegacy mac80211 i2c_i801 snd_seq yenta_socket 
pcmcia_rsrc dell_wmi sparse_keymap joydev cfg80211 processor rfkill 
snd_seq_device snd_timer snd evdev dcdbas wmi batter
Oct 17 13:16:14 maistor kernel: y irda crc_ccitt 8250 rtc_cmos 
serial_core ac soundcore sha256_ssse3 sha256_generic cbc hid_generic 
usbhid hid loop dm_crypt dm_mod sg i915 cfbfillrect cfbimgblt sr_mod 
cdrom sd
_mod b44 ssb firewire_ohci mmc_core mii firewire_core crc_itu_t pcmcia 
pcmcia_core video thermal i2c_algo_bit cfbcopyarea button uhci_hcd 
ehci_hcd drm_kms_helper drm usbcore intel_agp intel_gtt agpgart i2c_cor
e thermal_sys freq_table hwmon usb_common
Oct 17 13:16:14 maistor kernel: CPU: 0 PID: 6108 Comm: kmix Tainted: P   
         O 3.10.9eko2 #4
Oct 17 13:16:14 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 17 13:16:14 maistor kernel: task: ffff8800536546a0 ti: 
ffff8800523d2000 task.ti: ffff8800523d2000
Oct 17 13:16:14 maistor kernel: RIP: 0010:[<ffffffff810f6122>]  
[<ffffffff810f6122>] kfree+0x72/0xe0
Oct 17 13:16:14 maistor kernel: RSP: 0018:ffff8800523d3d78  EFLAGS: 
00010046
Oct 17 13:16:14 maistor kernel: RAX: 00000000fffffff2 RBX: 
ffff8800523d3de8 RCX: 4000000000000000
Oct 17 13:16:14 maistor kernel: RDX: 0000000000000000 RSI: 
ffff8800523d3e18 RDI: 0000000000000000
Oct 17 13:16:14 maistor kernel: RBP: 0000000000000286 R08: 
0000000000000000 R09: 0000000000000000
Oct 17 13:16:14 maistor kernel: R10: 0000000000000000 R11: 
0000000000000000 R12: ffff8800523d3de8
Oct 17 13:16:14 maistor kernel: R13: 0000000001442620 R14: 
feff8800523d3de8 R15: 00000000014427a8
Oct 17 13:16:14 maistor kernel: FS:  00007fa58d14a760(0000) 
GS:ffff88007f400000(0000) knlGS:0000000000000000
Oct 17 13:16:14 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Oct 17 13:16:14 maistor kernel: CR2: 0000000000000080 CR3: 
000000004d2cf000 CR4: 00000000000007f0
Oct 17 13:16:14 maistor kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct 17 13:16:14 maistor kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct 17 13:16:14 maistor kernel: Stack:
Oct 17 13:16:14 maistor kernel: ffff8800523d3de8 0000000000000008 
0000000000000000 ffffffff8111297b
Oct 17 13:16:14 maistor kernel: ffff880037a6a400 0000000d523d3e00 
0000000001442930 ffff8800523d3f28
Oct 17 13:16:14 maistor kernel: ffff8800523d3de8 ffff8800523d3df0 
ffff8800523d3df8 ffff8800523d3e00
Oct 17 13:16:14 maistor kernel: Call Trace:
Oct 17 13:16:14 maistor kernel: [<ffffffff8111297b>] ? 
core_sys_select+0x15b/0x300
Oct 17 13:16:14 maistor kernel: [<ffffffff813153c6>] ? 
SyS_recvfrom+0xe6/0x190
Oct 17 13:16:14 maistor kernel: [<ffffffff813d03cb>] ? 
__schedule+0x25b/0x790
Oct 17 13:16:14 maistor kernel: [<ffffffff810795fd>] ? 
ktime_get_ts+0x3d/0xe0
Oct 17 13:16:14 maistor kernel: [<ffffffff81112174>] ? 
poll_select_set_timeout+0x64/0x80
Oct 17 13:16:14 maistor kernel: [<ffffffff81112bd5>] ? 
SyS_select+0xb5/0x110
Oct 17 13:16:14 maistor kernel: [<ffffffff813d2716>] ? 
system_call_fastpath+0x1a/0x1f
Oct 17 13:16:14 maistor kernel: Code: 48 c1 e2 06 48 29 ca 48 b9 00 00 
00 00 00 ea ff ff 48 01 ca 48 8b 0a 80 e5 80 75 6f 48 8b 7a 30 65 8b 14 
25 1c b0 00 00 48 63 d2 <48> 8b 9c d7 80 00 00 00 8b 43 04 39 03 7
3 45 66 66 66 66 90 8b
Oct 17 13:16:14 maistor kernel: RSP <ffff8800523d3d78>
Oct 17 13:16:14 maistor kernel: CR2: 0000000000000080
Oct 17 13:16:14 maistor kernel: ---[ end trace 544e1a4bf550f3b4 ]---
Oct 17 13:17:33 maistor kernel: ------------[ cut here ]------------
Oct 17 13:17:33 maistor kernel: WARNING: at kernel/workqueue.c:1434 
__queue_delayed_work+0x122/0x190()
Oct 17 13:17:33 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
vmci(O) vmmon(O) snd_hrtimer nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad sbs 
sbsh
c fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6 
firewire_sbp2 uvcvideo videobuf2_vmalloc snd_usb_audio videobuf2_memops 
videobuf2_core videodev media snd_hda_codec_idt snd_usbmidi_lib sn
d_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_pcm_oss 
snd_mixer_oss snd_pcm snd_page_alloc snd_seq_oss snd_seq_midi 
snd_seq_midi_event acpi_cpufreq iTCO_wdt iTCO_vendor_support arc4 
lpc_ich snd_rawmidi
  mperf iwl3945 ehci_pci iwlegacy mac80211 i2c_i801 snd_seq yenta_socket 
pcmcia_rsrc dell_wmi sparse_keymap joydev cfg80211 processor rfkill 
snd_seq_device snd_timer snd evdev dcdbas wmi batter
Oct 17 13:17:33 maistor kernel: y irda crc_ccitt 8250 rtc_cmos 
serial_core ac soundcore sha256_ssse3 sha256_generic cbc hid_generic 
usbhid hid loop dm_crypt dm_mod sg i915 cfbfillrect cfbimgblt sr_mod 
cdrom sd
_mod b44 ssb firewire_ohci mmc_core mii firewire_core crc_itu_t pcmcia 
pcmcia_core video thermal i2c_algo_bit cfbcopyarea button uhci_hcd 
ehci_hcd drm_kms_helper drm usbcore intel_agp intel_gtt agpgart i2c_cor
e thermal_sys freq_table hwmon usb_common
Oct 17 13:17:33 maistor kernel: CPU: 1 PID: 20690 Comm: udisks-daemon 
Tainted: P      D    O 3.10.9eko2 #4
Oct 17 13:17:33 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 17 13:17:33 maistor kernel: ffffffff813ccef0 0000000000000000 
ffffffff8103687a 0000000000000002
Oct 17 13:17:33 maistor kernel: ffff88007c861400 ffff88007a354c48 
ffff88007c861400 0000000000000000
Oct 17 13:17:33 maistor kernel: ffffffff8104f8f2 0000000000000000 
ffff88007a354c28 0000000000000000
Oct 17 13:17:33 maistor kernel: Call Trace:
Oct 17 13:17:33 maistor kernel: [<ffffffff813ccef0>] ? 
dump_stack+0xd/0x17
Oct 17 13:17:33 maistor kernel: [<ffffffff8103687a>] ? 
warn_slowpath_common+0x6a/0xa0
Oct 17 13:17:33 maistor kernel: [<ffffffff8104f8f2>] ? 
__queue_delayed_work+0x122/0x190
Oct 17 13:17:33 maistor kernel: [<ffffffff81051117>] ? 
mod_delayed_work_on+0x57/0x90
Oct 17 13:17:33 maistor kernel: [<ffffffff811cde8f>] ? 
disk_flush_events+0x6f/0x90
Oct 17 13:17:33 maistor kernel: [<ffffffff811334e0>] ? 
blkdev_put+0x40/0x150
Oct 17 13:17:33 maistor kernel: [<ffffffff81133610>] ? 
blkdev_close+0x20/0x30
Oct 17 13:17:33 maistor kernel: [<ffffffff811014bc>] ? __fput+0xac/0x240
Oct 17 13:17:33 maistor kernel: [<ffffffff8105372f>] ? 
task_work_run+0x8f/0xd0
Oct 17 13:17:33 maistor kernel: [<ffffffff813d29a2>] ? 
int_signal+0x12/0x17
Oct 17 13:17:33 maistor kernel: ---[ end trace 544e1a4bf550f3b5 ]---
Oct 17 13:17:33 maistor kernel: ------------[ cut here ]------------
Oct 17 13:17:33 maistor kernel: WARNING: at kernel/workqueue.c:1365 
__queue_work+0x189/0x2a0()
Oct 17 13:17:33 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
vmci(O) vmmon(O) snd_hrtimer nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad sbs 
sbsh
c fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6 
firewire_sbp2 uvcvideo videobuf2_vmalloc snd_usb_audio videobuf2_memops 
videobuf2_core videodev media snd_hda_codec_idt snd_usbmidi_lib sn
d_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy snd_pcm_oss 
snd_mixer_oss snd_pcm snd_page_alloc snd_seq_oss snd_seq_midi 
snd_seq_midi_event acpi_cpufreq iTCO_wdt iTCO_vendor_support arc4 
lpc_ich snd_rawmidi
  mperf iwl3945 ehci_pci iwlegacy mac80211 i2c_i801 snd_seq yenta_socket 
pcmcia_rsrc dell_wmi sparse_keymap joydev cfg80211 processor rfkill 
snd_seq_device snd_timer snd evdev dcdbas wmi batter
Oct 17 13:17:33 maistor kernel: y irda crc_ccitt 8250 rtc_cmos 
serial_core ac soundcore sha256_ssse3 sha256_generic cbc hid_generic 
usbhid hid loop dm_crypt dm_mod sg i915 cfbfillrect cfbimgblt sr_mod 
cdrom sd
_mod b44 ssb firewire_ohci mmc_core mii firewire_core crc_itu_t pcmcia 
pcmcia_core video thermal i2c_algo_bit cfbcopyarea button uhci_hcd 
ehci_hcd drm_kms_helper drm usbcore intel_agp intel_gtt agpgart i2c_cor
e thermal_sys freq_table hwmon usb_common
Oct 17 13:17:33 maistor kernel: CPU: 1 PID: 20690 Comm: udisks-daemon 
Tainted: P      D W  O 3.10.9eko2 #4
Oct 17 13:17:33 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 17 13:17:33 maistor kernel: ffffffff813ccef0 0000000000000000 
ffffffff8103687a ffff88007f514c00
Oct 17 13:17:33 maistor kernel: ffff88007a354c28 0000000000000000 
ffff88007c861400 0000000000000002
Oct 17 13:17:33 maistor kernel: ffffffff8104f569 0000000000000002 
0000000000000000 ffff88007a354c28
Oct 17 13:17:33 maistor kernel: Call Trace:
Oct 17 13:17:33 maistor kernel: [<ffffffff813ccef0>] ? 
dump_stack+0xd/0x17
Oct 17 13:17:33 maistor kernel: [<ffffffff8103687a>] ? 
warn_slowpath_common+0x6a/0xa0
Oct 17 13:17:33 maistor kernel: [<ffffffff8104f569>] ? 
__queue_work+0x189/0x2a0
Oct 17 13:17:33 maistor kernel: [<ffffffff81051117>] ? 
mod_delayed_work_on+0x57/0x90
Oct 17 13:17:33 maistor kernel: [<ffffffff811cde8f>] ? 
disk_flush_events+0x6f/0x90
Oct 17 13:17:33 maistor kernel: [<ffffffff811334e0>] ? 
blkdev_put+0x40/0x150
Oct 17 13:17:33 maistor kernel: [<ffffffff81133610>] ? 
blkdev_close+0x20/0x30
Oct 17 13:17:33 maistor kernel: [<ffffffff811014bc>] ? __fput+0xac/0x240
Oct 17 13:17:33 maistor kernel: [<ffffffff8105372f>] ? 
task_work_run+0x8f/0xd0
Oct 17 13:17:33 maistor kernel: [<ffffffff813d29a2>] ? 
int_signal+0x12/0x17
Oct 17 13:17:33 maistor kernel: ---[ end trace 544e1a4bf550f3b6 ]---
Oct 17 13:43:19 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.
Oct 17 13:43:19 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="3919" x-info="http://www.rsyslog.com"] start

------- cut --------

------- cut --------
Oct 17 13:47:48 maistor kernel: 6:3:1: cannot get freq at ep 0x84
Oct 17 13:56:58 maistor kernel: ------------[ cut here ]------------
Oct 17 13:56:58 maistor kernel: WARNING: at kernel/workqueue.c:1365 
__queue_work+0x189/0x2a0()
Oct 17 13:56:58 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
snd_hrtimer vmci(O) vmmon(O) nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad sbs 
sbsh
c fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6 
firewire_sbp2 snd_hda_codec_idt uvcvideo videobuf2_vmalloc 
videobuf2_memops videobuf2_core videodev snd_hda_intel snd_hda_codec 
snd_usb_au
dio snd_usbmidi_lib media snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_page_alloc snd_seq_oss snd_seq_midi snd_seq_midi_event 
snd_rawmidi acpi_cpufreq mperf snd_seq processor snd_seq_device iT
CO_wdt snd_timer iTCO_vendor_support snd ehci_pci arc4 iwl3945 lpc_ich 
iwlegacy mac80211 cfg80211 yenta_socket pcmcia_rsrc joydev rtc_cmos 
i2c_i801 dell_wmi sparse_keymap dcdbas wmi rfkill evd
Oct 17 13:56:58 maistor kernel: ev 8250 battery ac serial_core irda 
soundcore crc_ccitt sha256_ssse3 sha256_generic cbc hid_generic usbhid 
hid loop dm_crypt dm_mod sg sr_mod cdrom i915 cfbfillrect cfbimgblt th
ermal sd_mod firewire_ohci b44 ssb firewire_core video i2c_algo_bit 
button crc_itu_t cfbcopyarea mmc_core mii pcmcia pcmcia_core 
drm_kms_helper drm uhci_hcd ehci_hcd i2c_core usbcore thermal_sys 
freq_table hwm
on usb_common intel_agp intel_gtt agpgart
Oct 17 13:56:58 maistor kernel: CPU: 1 PID: 13731 Comm: plugin-containe 
Tainted: P           O 3.10.9eko2 #4
Oct 17 13:56:58 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 17 13:56:58 maistor kernel: ffffffff813ccef0 0000000000000000 
ffffffff8103687a ffff88007f514900
Oct 17 13:56:58 maistor kernel: ffff88007f512608 ffff88007f511080 
ffff88007c861c00 0000000000000001
Oct 17 13:56:58 maistor kernel: ffffffff8104f569 0000000000011800 
ffff88005159ffd8 0000000000000100
Oct 17 13:56:58 maistor kernel: Call Trace:
Oct 17 13:56:58 maistor kernel: <IRQ>  [<ffffffff813ccef0>] ? 
dump_stack+0xd/0x17
Oct 17 13:56:58 maistor kernel: [<ffffffff8103687a>] ? 
warn_slowpath_common+0x6a/0xa0
Oct 17 13:56:58 maistor kernel: [<ffffffff8104f569>] ? 
__queue_work+0x189/0x2a0
Oct 17 13:56:58 maistor kernel: [<ffffffff8104f680>] ? 
__queue_work+0x2a0/0x2a0
Oct 17 13:56:58 maistor kernel: [<ffffffff8104377a>] ? 
call_timer_fn.isra.28+0x2a/0x90
Oct 17 13:56:58 maistor kernel: [<ffffffff8104f680>] ? 
__queue_work+0x2a0/0x2a0
Oct 17 13:56:58 maistor kernel: [<ffffffff81043901>] ? 
run_timer_softirq+0x121/0x210
Oct 17 13:56:58 maistor kernel: [<ffffffff8103db96>] ? 
__do_softirq+0xd6/0x1a0
Oct 17 13:56:58 maistor kernel: [<ffffffff8103dd7e>] ? 
irq_exit+0x7e/0xa0
Oct 17 13:56:58 maistor kernel: [<ffffffff810245d8>] ? 
smp_apic_timer_interrupt+0x68/0xa0
Oct 17 13:56:58 maistor kernel: [<ffffffff813d340a>] ? 
apic_timer_interrupt+0x6a/0x70
Oct 17 13:56:58 maistor kernel: <EOI>  [<ffffffff813d2716>] ? 
system_call_fastpath+0x1a/0x1f
Oct 17 13:56:58 maistor kernel: ---[ end trace 6aca29c2a451f918 ]---
Oct 17 13:57:04 maistor kernel: general protection fault: 0000 [#1] 
PREEMPT SMP
Oct 17 13:57:04 maistor kernel: Modules linked in: vmnet(O) vsock(O) 
snd_hrtimer vmci(O) vmmon(O) nfsv3 nfs_acl nfs lockd sunrpc iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt
able_mangle iptable_filter ip_tables x_tables cpufreq_ondemand 
cpufreq_powersave cpufreq_performance cpufreq_stats cpufreq_conservative 
parport_pc ppdev lp parport bnep rfcomm bluetooth crc16 acpi_pad sbs 
sbsh
c fan acpi_ipmi ipmi_msghandler binfmt_misc uinput fuse af_packet ipv6 
firewire_sbp2 snd_hda_codec_idt uvcvideo videobuf2_vmalloc 
videobuf2_memops videobuf2_core videodev snd_hda_intel snd_hda_codec 
snd_usb_au
dio snd_usbmidi_lib media snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_page_alloc snd_seq_oss snd_seq_midi snd_seq_midi_event 
snd_rawmidi acpi_cpufreq mperf snd_seq processor snd_seq_device iT
CO_wdt snd_timer iTCO_vendor_support snd ehci_pci arc4 iwl3945 lpc_ich 
iwlegacy mac80211 cfg80211 yenta_socket pcmcia_rsrc joydev rtc_cmos 
i2c_i801 dell_wmi sparse_keymap dcdbas wmi rfkill evd
Oct 17 13:57:04 maistor kernel: ev 8250 battery ac serial_core irda 
soundcore crc_ccitt sha256_ssse3 sha256_generic cbc hid_generic usbhid 
hid loop dm_crypt dm_mod sg sr_mod cdrom i915 cfbfillrect cfbimgblt th
ermal sd_mod firewire_ohci b44 ssb firewire_core video i2c_algo_bit 
button crc_itu_t cfbcopyarea mmc_core mii pcmcia pcmcia_core 
drm_kms_helper drm uhci_hcd ehci_hcd i2c_core usbcore thermal_sys 
freq_table hwm
on usb_common intel_agp intel_gtt agpgart
Oct 17 13:57:04 maistor kernel: CPU: 0 PID: 4494 Comm: Xorg Tainted: P   
      W  O 3.10.9eko2 #4
Oct 17 13:57:04 maistor kernel: Hardware name: Dell Inc. Latitude D520   
                 /0NF743, BIOS A04 12/18/2006
Oct 17 13:57:04 maistor kernel: task: ffff88007ca13340 ti: 
ffff88007bec2000 task.ti: ffff88007bec2000
Oct 17 13:57:04 maistor kernel: RIP: 0010:[<ffffffff8111279e>]  
[<ffffffff8111279e>] do_select+0x60e/0x690
Oct 17 13:57:04 maistor kernel: RSP: 0018:ffff88007bec3d90  EFLAGS: 
00010296
Oct 17 13:57:04 maistor kernel: RAX: 0000000000000001 RBX: 
ffff88007bec3de8 RCX: ffffea000113ef50
Oct 17 13:57:04 maistor kernel: RDX: ffff88007f4145e0 RSI: 
0000000000000003 RDI: 0000000000000004
Oct 17 13:57:04 maistor kernel: RBP: 0000000000000010 R08: 
0000000000000000 R09: ffff88007f2d1fe0
Oct 17 13:57:04 maistor kernel: R10: 000000000000007c R11: 
0000000000000000 R12: 0000000000000010
Oct 17 13:57:04 maistor kernel: R13: 00007f946c6aee00 R14: 
ffff88007bec3de8 R15: 00007fff72c76350
Oct 17 13:57:04 maistor kernel: FS:  00007f946c265880(0000) 
GS:ffff88007f400000(0000) knlGS:0000000000000000
Oct 17 13:57:04 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 17 13:57:04 maistor kernel: CR2: 00007f067f2b1000 CR3: 
000000007b650000 CR4: 00000000000007f0
Oct 17 13:57:04 maistor kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct 17 13:57:04 maistor kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct 17 13:57:04 maistor kernel: Stack:
Oct 17 13:57:04 maistor kernel: fcffffff81112a3a 0000000000000001 
00000080a02e2cec 0000000000000000
Oct 17 13:57:04 maistor kernel: ffff88007bec3f28 ffff88007bec3de8 
ffff88007bec3df8 ffff88007bec3e08
Oct 17 13:57:04 maistor kernel: ffff88007bec3e18 ffff88007bec3e28 
ffff88007bec3e38 ffffffffff000e4a
Oct 17 13:57:04 maistor kernel: Call Trace:
Oct 17 13:57:04 maistor kernel: [<ffffffff810795fd>] ? 
ktime_get_ts+0x3d/0xe0
Oct 17 13:57:04 maistor kernel: [<ffffffff81112174>] ? 
poll_select_set_timeout+0x64/0x80
Oct 17 13:57:04 maistor kernel: [<ffffffff81112bd5>] ? 
SyS_select+0xb5/0x110
Oct 17 13:57:04 maistor kernel: [<ffffffff813d2716>] ? 
system_call_fastpath+0x1a/0x1f
Oct 17 13:57:04 maistor kernel: Code: ff c7 44 24 34 00 00 00 00 48 8d 
bc 24 d0 00 00 00 e8 d7 f7 ff ff 8b 44 24 34 48 81 c4 48 03 00 00 5b 5d 
41 5c 41 5d 41 5e 41 5f <c3> 48 8b bc 24 a0 00 00 00 e8 64 f8 ff f
f c6 84 24 bf 00 00 00
Oct 17 13:57:04 maistor kernel: RSP <ffff88007bec3d90>
Oct 17 13:57:04 maistor kernel: ---[ end trace 6aca29c2a451f919 ]---
Oct 17 13:57:05 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 13:57:09 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 13:57:11 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 13:57:53 maistor kernel: usb 5-4: new high-speed USB device 
number 8 using ehci-pci
Oct 17 13:57:53 maistor kernel: usb 5-4: New USB device found, 
idVendor=08ec, idProduct=0015
Oct 17 13:57:53 maistor kernel: usb 5-4: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
Oct 17 13:57:53 maistor kernel: usb 5-4: Product: DT Elite HS 2.0
Oct 17 13:57:53 maistor kernel: usb 5-4: Manufacturer: Kingston
Oct 17 13:57:53 maistor kernel: usb 5-4: SerialNumber: 08603170F003B898
Oct 17 13:57:54 maistor mtp-probe: checking bus 5, device 8: 
"/sys/devices/pci0000:00/0000:00:1d.7/usb5/5-4"
Oct 17 13:57:54 maistor mtp-probe: bus: 5, device: 8 was not an MTP 
device
Oct 17 13:57:54 maistor kernel: usb-storage 5-4:1.0: USB Mass Storage 
device detected
Oct 17 13:57:54 maistor kernel: scsi2 : usb-storage 5-4:1.0
Oct 17 13:57:54 maistor kernel: usbcore: registered new interface driver 
usb-storage
Oct 17 13:57:55 maistor kernel: scsi 2:0:0:0: Direct-Access     Kingston 
DT Elite HS 2.0  5.06 PQ: 0 ANSI: 0 CCS
Oct 17 13:57:55 maistor kernel: sd 2:0:0:0: Attached scsi generic sg2 
type 0
Oct 17 13:57:55 maistor kernel: sd 2:0:0:0: [sdb] 2027519 512-byte 
logical blocks: (1.03 GB/989 MiB)
Oct 17 13:57:55 maistor kernel: sd 2:0:0:0: [sdb] Write Protect is off
Oct 17 13:57:55 maistor kernel: sdb: sdb1
Oct 17 13:57:55 maistor kernel: sd 2:0:0:0: [sdb] Attached SCSI 
removable disk
Oct 17 13:58:03 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 13:58:04 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 13:58:05 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 13:58:14 maistor kernel: [drm] Setting output timings on SDVOB 
failed
Oct 17 13:58:14 maistor shutdown[17510]: shutting down for system reboot
Oct 17 14:29:05 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.
Oct 17 14:29:05 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="4008" x-info="http://www.rsyslog.com"] start


------- cut --------

------- cut --------
Oct 17 14:30:40 maistor kernel: 7:3:1: cannot get freq at ep 0x84
Oct 17 14:40:36 maistor kernel: general protection fault: 0000 [#1] 
PREEMPT SMP
Oct 17 14:40:36 maistor kernel: CPU 0
Oct 17 14:40:36 maistor kernel: Modules linked in: snd_hrtimer nfs lockd 
nfs_acl sunrpc iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack 
nf_defrag_ipv4 acpi_cpufreq mperf iptable_mangle iptable_filter ip_tabl
es x_tables cpufreq_ondemand cpufreq_powersave cpufreq_performance 
cpufreq_stats freq_table cpufreq_conservative parport_pc ppdev lp 
parport bnep rfcomm bluetooth crc16 acpi_ipmi ipmi_msghandler acpi_pad 
sbs s
bshc pci_slot fan binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
uvcvideo videobuf2_core snd_usb_audio videodev snd_usbmidi_lib 
v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_memops snd_hda_codec_idt 
sn
d_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi yenta_socket snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcmcia_rsrc 
iTCO_wd
t iTCO_vendor_support arc4 iwl3945 iwlegacy mac80211 soundcore cfg80211 
rfkill i2c_i801 8250_pnp dell_wmi sparse_keymap processor snd_page_alloc 
wmi dcdbas rtc_cmos 8250 evdev joydev battery a
Oct 17 14:40:36 maistor kernel: c serial_core sha256_generic cryptd 
aes_x86_64 aes_generic cbc usbhid hid loop dm_crypt dm_mod usb_storage 
usb_libusual uas i915 cfbfillrect cfbimgblt thermal sd_mod sg sr_mod c
drom firewire_ohci firewire_core crc_itu_t b44 ssb mmc_core mii video 
uhci_hcd pcmcia pcmcia_core ehci_hcd button cfbcopyarea i2c_algo_bit 
drm_kms_helper usbcore intel_agp intel_gtt drm usb_common agpgart i2c_
core thermal_sys hwmon [last unloaded: scsi_wait_scan]
Oct 17 14:40:36 maistor kernel:
Oct 17 14:40:36 maistor kernel: Pid: 6082, comm: firefox Not tainted 
3.3.8eko2 #4 Dell Inc. Latitude D520                   /0NF743
Oct 17 14:40:36 maistor kernel: RIP: 0010:[<ffffffff8117076f>]  
[<ffffffff8117076f>] plist_del+0x3b/0x66
Oct 17 14:40:36 maistor kernel: RSP: 0018:ffff880032025ce0  EFLAGS: 
00010246
Oct 17 14:40:36 maistor kernel: RAX: ffff880032131cf0 RBX: 
ffff8800322212f0 RCX: fcff880032131cf0
Oct 17 14:40:36 maistor kernel: RDX: ffff880032131cf0 RSI: 
ffffffff8150f338 RDI: ffff880032131ce8
Oct 17 14:40:36 maistor kernel: RBP: ffff880032131ce8 R08: 
fcff880032131cf0 R09: ffff880032025f08
Oct 17 14:40:36 maistor kernel: R10: 000000007fffffff R11: 
0000000000000283 R12: ffffffff8150f330
Oct 17 14:40:36 maistor kernel: R13: ffffffff8150fdf8 R14: 
0000000000000000 R15: 0000000000000000
Oct 17 14:40:36 maistor kernel: FS:  00007fc2ec3e4740(0000) 
GS:ffff88007f400000(0000) knlGS:0000000000000000
Oct 17 14:40:36 maistor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 17 14:40:36 maistor kernel: CR2: 00002ac4fd23b000 CR3: 
000000003221e000 CR4: 00000000000006f0
Oct 17 14:40:36 maistor kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct 17 14:40:36 maistor kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct 17 14:40:36 maistor kernel: Process firefox (pid: 6082, threadinfo 
ffff880032024000, task ffff8800320cb2b0)
Oct 17 14:40:36 maistor kernel: Stack:
Oct 17 14:40:36 maistor kernel: ffffffff8105f7cd 0000000000000000 
0000000000000000 ffff880032131ce8
Oct 17 14:40:36 maistor kernel: ffffffff81060d51 00000000525fdac4 
ffff880032025d58 ffff880000000001
Oct 17 14:40:36 maistor kernel: 0000000055aa3e58 ffffffff8150f320 
0000000100000001 ffffffff8150f338
Oct 17 14:40:36 maistor kernel: Call Trace:
Oct 17 14:40:36 maistor kernel: [<ffffffff8105f7cd>] ? 
wake_futex+0x16/0x45
Oct 17 14:40:36 maistor kernel: [<ffffffff81060d51>] ? 
futex_requeue+0x4a2/0x690
Oct 17 14:40:36 maistor kernel: [<ffffffff81061042>] ? 
do_futex+0x103/0x8be
Oct 17 14:40:36 maistor kernel: [<ffffffff810c303e>] ? 
do_sync_read+0xb1/0xea
Oct 17 14:40:36 maistor kernel: [<ffffffff81253289>] ? 
sys_recvfrom+0x113/0x12b
Oct 17 14:40:36 maistor kernel: [<ffffffff81061927>] ? 
sys_futex+0x12a/0x142
Oct 17 14:40:36 maistor kernel: [<ffffffff810c3b56>] ? 
sys_read+0x62/0x6e
Oct 17 14:40:36 maistor kernel: [<ffffffff812eafa2>] ? 
system_call_fastpath+0x16/0x1b
Oct 17 14:40:36 maistor kernel: Code: 18 48 39 f0 74 1d 48 8b 48 f0 48 
8d 70 f0 48 39 f1 75 10 49 89 48 08 4c 89 40 f0 48 89 50 f8 48 89 4f 08 
48 8b 4f 08 48 8b 47 10 <48> 89 41 08 48 89 08 48 89 57 08 48 89 5
7 10 48 8b 4f 18 48 8b
Oct 17 14:40:36 maistor kernel: RSP <ffff880032025ce0>
Oct 17 14:40:36 maistor kernel: ---[ end trace a3d22cd9bf0e297f ]---
Oct 17 14:40:36 maistor kernel: note: firefox[6082] exited with 
preempt_count 2
Oct 17 14:40:50 maistor shutdown[18878]: shutting down for system reboot
Oct 17 14:42:34 maistor kernel: imklog 5.8.11, log source = /proc/kmsg 
started.
Oct 17 14:42:34 maistor rsyslogd: [origin software="rsyslogd" 
swVersion="5.8.11" x-pid="3911" x-info="http://www.rsyslog.com"] start

------- cut --------


Thanks in advance and kind regards
