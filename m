Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbbAJUXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 15:23:05 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:57492 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbAJUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 15:23:00 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jan 2015 15:22:59 EST
Message-ID: <54B188BF.3020304@googlemail.com>
Date: Sat, 10 Jan 2015 20:17:03 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: BUG in 3.19.0-rc3+
Content-Type: multipart/mixed;
 boundary="------------050400050004060909020503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050400050004060909020503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I'm getting a bug a BUG report from a kernel built from a pull (earlier today) of the current development kernel
(running git describe gives v3.19-rc3-169-geb74926). So that I have useable wireless networking, I have also applied the
latest seven iwlwifi patches from the wireless-drivers git tree. Prior to today's pull, I was not seeing anything
unusual in dmesg.

The BUG reported is as follows:

Jan 10 19:41:32 laptop kernel: ------------[ cut here ]------------
Jan 10 19:41:32 laptop kernel: kernel BUG at mm/rmap.c:399!
Jan 10 19:41:32 laptop kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Jan 10 19:41:32 laptop kernel: Modules linked in: rfcomm snd_hda_codec_via iwlmvm coretemp snd_hda_codec_hdmi
snd_hda_codec_generic snd_hda_intel mac80211 hwmon snd_hda_controller x86_pkg_temp_thermal acpi_cpufreq iwlwifi cfg80211
snd_hda_codec snd_hwdep
Jan 10 19:41:32 laptop kernel: CPU: 1 PID: 353 Comm: fc-cache Not tainted 3.19.0-rc3+ #42
Jan 10 19:41:32 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ
                       , BIOS 1.03.05 02/26/2014
Jan 10 19:41:32 laptop kernel: task: ffff8800da98c5c0 ti: ffff880408dd4000 task.ti: ffff880408dd4000
Jan 10 19:41:32 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:41:33 laptop kernel: RSP: 0018:ffff880408dd7d88  EFLAGS: 00010286
Jan 10 19:41:33 laptop kernel: RAX: ffff88040b79e150 RBX: ffff88040b79e140 RCX: 00000000ffffffff
Jan 10 19:41:33 laptop kernel: RDX: ffffffff00000001 RSI: ffff880409f04360 RDI: ffff880409f04320
Jan 10 19:41:33 laptop kernel: RBP: ffff88040cb13278 R08: 0000000000000000 R09: ffff88040d801c00
Jan 10 19:41:33 laptop kernel: R10: ffff88041fa546e0 R11: ffff88040b79e160 R12: ffff880409f04320
Jan 10 19:41:33 laptop kernel: R13: ffff88040cb13278 R14: ffff88040cb13288 R15: ffff88040cb13210
Jan 10 19:41:33 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fa40000(0000) knlGS:0000000000000000
Jan 10 19:41:33 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 10 19:41:33 laptop kernel: CR2: 00000000f722c8d4 CR3: 00000004082a8000 CR4: 00000000001407e0
Jan 10 19:41:33 laptop kernel: Stack:
Jan 10 19:41:33 laptop kernel:  ffff88040d6cfbd8 ffff88040d6cfba0 ffff88040cecd160 ffff88040cb13210
Jan 10 19:41:33 laptop kernel:  ffff88040cbbb630 00000000f7151000 ffff880408dd7e28 0000000000000000
Jan 10 19:41:33 laptop kernel:  0000000000000000 ffffffff810e3633 0000000000000000 0000000000000000
Jan 10 19:41:33 laptop kernel: Call Trace:
Jan 10 19:41:33 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
Jan 10 19:41:34 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
Jan 10 19:41:34 laptop kernel:  [<ffffffff8103980d>] ? __do_page_fault+0x17d/0x4b0
Jan 10 19:41:34 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
Jan 10 19:41:34 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
Jan 10 19:41:34 laptop kernel:  [<ffffffff8111fe89>] ? mntput_no_expire+0x9/0x140
Jan 10 19:41:34 laptop kernel:  [<ffffffff8105ca1c>] ? task_work_run+0xbc/0xf0
Jan 10 19:41:34 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
Jan 10 19:41:34 laptop kernel:  [<ffffffff81047dcf>] ? SyS_exit_group+0xf/0x10
Jan 10 19:41:34 laptop kernel:  [<ffffffff815e0f9f>] ? sysenter_dispatch+0x7/0x1e
Jan 10 19:41:34 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74
54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00
Jan 10 19:41:34 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:41:34 laptop kernel:  RSP <ffff880408dd7d88>
Jan 10 19:41:34 laptop kernel: ---[ end trace 4aa713b2a9aa664b ]---
Jan 10 19:41:34 laptop kernel: Fixing recursive fault but reboot is needed!
Jan 10 19:41:34 laptop kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Jan 10 19:41:34 laptop kernel: ------------[ cut here ]------------
Jan 10 19:41:35 laptop kernel: kernel BUG at mm/rmap.c:399!
Jan 10 19:41:35 laptop kernel: invalid opcode: 0000 [#2] PREEMPT SMP
Jan 10 19:41:35 laptop kernel: Modules linked in: iptable_filter xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack rfcomm snd_hda_codec_via iwlmvm coretemp
snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel mac80211 hwmon snd_hda_controller x86_pkg_temp_thermal
acpi_cpufreq iwlwifi cfg80211 snd_hda_codec snd_hwdep
Jan 10 19:41:35 laptop kernel: CPU: 0 PID: 678 Comm: krootimage Tainted: G      D        3.19.0-rc3+ #42
Jan 10 19:41:35 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ
                       , BIOS 1.03.05 02/26/2014
Jan 10 19:41:35 laptop kernel: task: ffff880408de26c0 ti: ffff880409fcc000 task.ti: ffff880409fcc000
Jan 10 19:41:35 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:41:35 laptop kernel: RSP: 0018:ffff880409fcfd88  EFLAGS: 00010286
Jan 10 19:41:35 laptop kernel: RAX: ffff880408370d90 RBX: ffff880408370d80 RCX: 00000000ffffffff
Jan 10 19:41:35 laptop kernel: RDX: ffffffff00000001 RSI: ffff88040b61b400 RDI: ffff88040b61b3c0
Jan 10 19:41:35 laptop kernel: RBP: ffff88040dade1c8 R08: 0000000000000000 R09: ffff88040d801c00
Jan 10 19:41:35 laptop kernel: R10: ffff88041fa146e0 R11: ffff880408370da0 R12: ffff88040b61b3c0
Jan 10 19:41:35 laptop kernel: R13: ffff88040dade1c8 R14: ffff88040dade1d8 R15: ffff88040dade160
Jan 10 19:41:35 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fa00000(0000) knlGS:0000000000000000
Jan 10 19:41:35 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 10 19:41:36 laptop kernel: CR2: 00000000f60bf064 CR3: 0000000408c75000 CR4: 00000000001407f0
Jan 10 19:41:36 laptop kernel: Stack:
Jan 10 19:41:36 laptop kernel:  ffff88040accf828 ffff88040accf7f0 0000000000000000 ffff88040dade160
Jan 10 19:41:36 laptop kernel:  ffff88040cabb420 00000000f5878000 ffff880409fcfe28 0000000000000000
Jan 10 19:41:36 laptop kernel:  0000000000000000 ffffffff810e3633 0000000000000000 0000000000000000
Jan 10 19:41:36 laptop kernel: Call Trace:
Jan 10 19:41:36 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
Jan 10 19:41:36 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
Jan 10 19:41:36 laptop kernel:  [<ffffffff8103980d>] ? __do_page_fault+0x17d/0x4b0
Jan 10 19:41:36 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
Jan 10 19:41:36 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
Jan 10 19:41:36 laptop kernel:  [<ffffffff8111fe89>] ? mntput_no_expire+0x9/0x140
Jan 10 19:41:36 laptop kernel:  [<ffffffff8105ca1c>] ? task_work_run+0xbc/0xf0
Jan 10 19:41:36 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
Jan 10 19:41:36 laptop kernel:  [<ffffffff81047dcf>] ? SyS_exit_group+0xf/0x10
Jan 10 19:41:37 laptop kernel:  [<ffffffff815e0f9f>] ? sysenter_dispatch+0x7/0x1e
Jan 10 19:41:37 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74
54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00
Jan 10 19:41:37 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:41:37 laptop kernel:  RSP <ffff880409fcfd88>
Jan 10 19:41:37 laptop kernel: ---[ end trace 4aa713b2a9aa664c ]---
Jan 10 19:41:37 laptop kernel: Fixing recursive fault but reboot is needed!
Jan 10 19:41:37 laptop kernel: Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Jan 10 19:41:37 laptop kernel: Bluetooth: HIDP socket layer initialized
Jan 10 19:41:37 laptop kernel: hid-generic 0005:0A5C:0001.0001: unknown main item tag 0x0
Jan 10 19:41:37 laptop kernel: input: Bluetooth 3.0 mouse as
/devices/pci0000:00/0000:00:14.0/usb1/1-7/1-7:1.0/bluetooth/hci0/hci0:256/0005:0A5C:0001.0001/input/input10
Jan 10 19:41:37 laptop kernel: hid-generic 0005:0A5C:0001.0001: input: BLUETOOTH HID v1.29 Mouse [Bluetooth 3.0 mouse]
on 80:19:34:5a:67:51
Jan 10 19:41:37 laptop kernel: ------------[ cut here ]------------
Jan 10 19:41:37 laptop kernel: kernel BUG at mm/rmap.c:399!
Jan 10 19:41:37 laptop kernel: invalid opcode: 0000 [#3] PREEMPT SMP
Jan 10 19:41:37 laptop kernel: Modules linked in: hidp iptable_filter xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack rfcomm snd_hda_codec_via iwlmvm coretemp
snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel mac80211 hwmon snd_hda_controller x86_pkg_temp_thermal
acpi_cpufreq iwlwifi cfg80211 snd_hda_codec snd_hwdep
Jan 10 19:41:37 laptop kernel: CPU: 0 PID: 677 Comm: kdm_greet Tainted: G      D        3.19.0-rc3+ #42
Jan 10 19:41:37 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ
                       , BIOS 1.03.05 02/26/2014
Jan 10 19:41:38 laptop kernel: task: ffff880408de0000 ti: ffff8804083a4000 task.ti: ffff8804083a4000
Jan 10 19:41:38 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:41:38 laptop kernel: RSP: 0018:ffff8804083a7d88  EFLAGS: 00210286
Jan 10 19:41:38 laptop kernel: RAX: ffff88040b5b7610 RBX: ffff88040b5b7600 RCX: 00000000ffffffff
Jan 10 19:41:38 laptop kernel: RDX: ffffffff00000001 RSI: ffff88040b59f590 RDI: ffff88040b59f550
Jan 10 19:41:38 laptop kernel: RBP: ffff88040b5978a8 R08: 0000000000000000 R09: ffff88040d801c00
Jan 10 19:41:38 laptop kernel: R10: ffff88041fa146e0 R11: ffff88040b5b7620 R12: ffff88040b59f550
Jan 10 19:41:38 laptop kernel: R13: ffff88040b5978a8 R14: ffff88040b5978b8 R15: ffff88040b597840
Jan 10 19:41:38 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fa00000(0000) knlGS:0000000000000000
Jan 10 19:41:38 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 10 19:41:38 laptop kernel: CR2: 00000000f6547064 CR3: 0000000408c6a000 CR4: 00000000001407f0
Jan 10 19:41:38 laptop kernel: Stack:
Jan 10 19:41:38 laptop kernel:  ffff88040d6cfbd8 ffff88040d6cfba0 ffff88040b5978f0 ffff88040b597840
Jan 10 19:41:38 laptop kernel:  ffff88040b597a50 00000000f5916000 ffff8804083a7e28 0000000000000000
Jan 10 19:41:38 laptop kernel:  0000000000000000 ffffffff810e3633 0000000000000000 0000000000000000
Jan 10 19:41:39 laptop kernel: Call Trace:
Jan 10 19:41:39 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
Jan 10 19:41:39 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
Jan 10 19:41:39 laptop kernel:  [<ffffffff8103980d>] ? __do_page_fault+0x17d/0x4b0
Jan 10 19:41:39 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
Jan 10 19:41:39 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
Jan 10 19:41:39 laptop kernel:  [<ffffffff8111fe89>] ? mntput_no_expire+0x9/0x140
Jan 10 19:41:39 laptop kernel:  [<ffffffff81094b80>] ? __getnstimeofday64+0x30/0xc0
Jan 10 19:41:39 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
Jan 10 19:41:39 laptop kernel:  [<ffffffff81047dcf>] ? SyS_exit_group+0xf/0x10
Jan 10 19:41:39 laptop kernel:  [<ffffffff815e0f9f>] ? sysenter_dispatch+0x7/0x1e
Jan 10 19:41:39 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74
54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00
Jan 10 19:41:39 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:41:39 laptop kernel:  RSP <ffff8804083a7d88>
Jan 10 19:41:39 laptop kernel: ---[ end trace 4aa713b2a9aa664d ]---
Jan 10 19:41:40 laptop kernel: Fixing recursive fault but reboot is needed!
Jan 10 19:41:40 laptop kernel: ------------[ cut here ]------------
Jan 10 19:41:40 laptop kernel: kernel BUG at mm/rmap.c:399!
Jan 10 19:41:40 laptop kernel: invalid opcode: 0000 [#4] PREEMPT SMP
Jan 10 19:41:40 laptop kernel: Modules linked in: hidp iptable_filter xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack rfcomm snd_hda_codec_via iwlmvm coretemp
snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel mac80211 hwmon snd_hda_controller x86_pkg_temp_thermal
acpi_cpufreq iwlwifi cfg80211 snd_hda_codec snd_hwdep
Jan 10 19:41:40 laptop kernel: CPU: 3 PID: 671 Comm: X Tainted: G      D        3.19.0-rc3+ #42
Jan 10 19:41:40 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ
                       , BIOS 1.03.05 02/26/2014
Jan 10 19:41:40 laptop kernel: task: ffff880408de4d80 ti: ffff880408350000 task.ti: ffff880408350000
Jan 10 19:41:40 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:41:40 laptop kernel: RSP: 0018:ffff880408353be8  EFLAGS: 00213286
Jan 10 19:41:40 laptop kernel: RAX: ffff88040daf29d0 RBX: ffff88040daf29c0 RCX: 00000000ffffffff
Jan 10 19:41:40 laptop kernel: RDX: ffffffff00000001 RSI: ffff88040cafc8b0 RDI: ffff88040cafc870
Jan 10 19:41:40 laptop kernel: RBP: ffff88040cb9ed78 R08: 0000000000000000 R09: ffff88040d801c00
Jan 10 19:41:40 laptop kernel: R10: ffff88041fad46e0 R11: ffff88040daf29e0 R12: ffff88040cafc870
Jan 10 19:41:40 laptop kernel: R13: ffff88040cb9ed78 R14: ffff88040cb9ed88 R15: ffff88040cb9ed10
Jan 10 19:41:40 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fac0000(0000) knlGS:0000000000000000
Jan 10 19:41:41 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 10 19:41:41 laptop kernel: CR2: 000000000879946c CR3: 00000000017f5000 CR4: 00000000001407e0
Jan 10 19:41:41 laptop kernel: Stack:
Jan 10 19:41:41 laptop kernel:  ffff88040accf828 ffff88040accf7f0 0000000000000000 ffff88040cb9ed10
Jan 10 19:41:41 laptop kernel:  ffff88040cbd7630 00000000f51f6000 ffff880408353c88 0000000000000000
Jan 10 19:41:41 laptop kernel:  0000000000000000 ffffffff810e3633 ffff880408353e50 0000000000000000
Jan 10 19:41:41 laptop kernel: Call Trace:
Jan 10 19:41:41 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
Jan 10 19:41:41 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
Jan 10 19:41:41 laptop kernel:  [<ffffffff8122b111>] ? timerqueue_del+0x21/0x70
Jan 10 19:41:41 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
Jan 10 19:41:41 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
Jan 10 19:41:41 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
Jan 10 19:41:41 laptop kernel:  [<ffffffff81051384>] ? get_signal+0x274/0x660
Jan 10 19:41:42 laptop kernel:  [<ffffffff8100249e>] ? do_signal+0x1e/0x7c0
Jan 10 19:41:42 laptop kernel:  [<ffffffff8100da31>] ? __restore_xstate_sig+0x271/0x680
Jan 10 19:41:42 laptop kernel:  [<ffffffff810527f6>] ? compat_SyS_sigaltstack+0xc6/0x1a0
Jan 10 19:41:42 laptop kernel:  [<ffffffff81002c9d>] ? do_notify_resume+0x5d/0x80
Jan 10 19:41:42 laptop kernel:  [<ffffffff815df818>] ? int_signal+0x12/0x17
Jan 10 19:41:42 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74
54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00
Jan 10 19:41:42 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:41:42 laptop kernel:  RSP <ffff880408353be8>
Jan 10 19:41:42 laptop kernel: ---[ end trace 4aa713b2a9aa664e ]---
Jan 10 19:41:42 laptop kernel: Fixing recursive fault but reboot is needed!

I won't get time tonight, but I can bisect it tomorrow, so this is just a heads up in case the problem (and fix) jumps
out at anyone.  Before I bisect I'll build and run a kernel without the iwlwifi patches.

I've attached the full kernel log file for that boot.

Chris

--------------050400050004060909020503
Content-Type: text/x-log;
 name="kernel-bug.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel-bug.log"

Jan 10 19:38:38 laptop kernel: klogd 1.5.0, log source = /proc/kmsg started.
Jan 10 19:38:38 laptop kernel: Inspecting /boot/System.map-3.19.0-rc3+
Jan 10 19:38:38 laptop kernel: Cannot find map file.
Jan 10 19:38:38 laptop kernel: Loaded 29757 symbols from 17 modules.
Jan 10 19:38:38 laptop kernel: Initializing cgroup subsys cpu
Jan 10 19:38:38 laptop kernel: Linux version 3.19.0-rc3+ (chris@laptop) (gcc version 4.9.3 20150107 (prerelease) (GCC) ) #42 SMP PREEMPT Sat Jan 10 16:02:22 GMT 2015
Jan 10 19:38:38 laptop kernel: Command line: root=/dev/sda2 ro resume=/dev/sda6
Jan 10 19:38:38 laptop kernel: e820: BIOS-provided physical RAM map:
Jan 10 19:38:38 laptop kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
Jan 10 19:38:38 laptop kernel: BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x0000000000100000-0x00000000d7216fff] usable
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000d7217000-0x00000000d721dfff] ACPI NVS
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000d721e000-0x00000000d7a0cfff] usable
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000d7a0d000-0x00000000d7ca1fff] reserved
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000d7ca2000-0x00000000db4dffff] usable
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000db4e0000-0x00000000db82dfff] reserved
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000db82e000-0x00000000db88afff] usable
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000db88b000-0x00000000db9bcfff] ACPI NVS
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000db9bd000-0x00000000dbffefff] reserved
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000dbfff000-0x00000000dbffffff] usable
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000dd000000-0x00000000df1fffff] reserved
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
Jan 10 19:38:39 laptop kernel: BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
Jan 10 19:38:40 laptop kernel: BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
Jan 10 19:38:40 laptop kernel: BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
Jan 10 19:38:40 laptop kernel: BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
Jan 10 19:38:40 laptop kernel: BIOS-e820: [mem 0x0000000100000000-0x000000041fdfffff] usable
Jan 10 19:38:40 laptop kernel: NX (Execute Disable) protection: active
Jan 10 19:38:40 laptop kernel: SMBIOS 2.7 present.
Jan 10 19:38:40 laptop kernel: DMI: Notebook                         W65_67SZ                        /W65_67SZ                        , BIOS 1.03.05 02/26/2014
Jan 10 19:38:40 laptop kernel: e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
Jan 10 19:38:40 laptop kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
Jan 10 19:38:40 laptop kernel: AGP: No AGP bridge found
Jan 10 19:38:40 laptop kernel: e820: last_pfn = 0x41fe00 max_arch_pfn = 0x400000000
Jan 10 19:38:40 laptop kernel: MTRR default type: uncachable
Jan 10 19:38:40 laptop kernel: MTRR fixed ranges enabled:
Jan 10 19:38:40 laptop kernel:   00000-9FFFF write-back
Jan 10 19:38:40 laptop kernel:   A0000-BFFFF uncachable
Jan 10 19:38:40 laptop kernel:   C0000-CFFFF write-protect
Jan 10 19:38:40 laptop kernel:   D0000-E7FFF uncachable
Jan 10 19:38:40 laptop kernel:   E8000-FFFFF write-protect
Jan 10 19:38:41 laptop kernel: MTRR variable ranges enabled:
Jan 10 19:38:41 laptop kernel:   0 base 0000000000 mask 7C00000000 write-back
Jan 10 19:38:41 laptop kernel:   1 base 0400000000 mask 7FE0000000 write-back
Jan 10 19:38:41 laptop kernel:   2 base 00E0000000 mask 7FE0000000 uncachable
Jan 10 19:38:41 laptop kernel:   3 base 00DE000000 mask 7FFE000000 uncachable
Jan 10 19:38:41 laptop kernel:   4 base 00DD000000 mask 7FFF000000 uncachable
Jan 10 19:38:41 laptop kernel:   5 base 041FE00000 mask 7FFFE00000 uncachable
Jan 10 19:38:41 laptop kernel:   6 disabled
Jan 10 19:38:41 laptop kernel:   7 disabled
Jan 10 19:38:41 laptop kernel:   8 disabled
Jan 10 19:38:41 laptop kernel:   9 disabled
Jan 10 19:38:41 laptop kernel: PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
Jan 10 19:38:41 laptop kernel: e820: update [mem 0xdd000000-0xffffffff] usable ==> reserved
Jan 10 19:38:41 laptop kernel: e820: last_pfn = 0xdc000 max_arch_pfn = 0x400000000
Jan 10 19:38:42 laptop kernel: found SMP MP-table at [mem 0x000fd820-0x000fd82f] mapped at [ffff8800000fd820]
Jan 10 19:38:42 laptop kernel: Base memory trampoline at [ffff880000097000] 97000 size 24576
Jan 10 19:38:42 laptop kernel: Using GB pages for direct mapping
Jan 10 19:38:42 laptop kernel: init_memory_mapping: [mem 0x00000000-0x000fffff]
Jan 10 19:38:42 laptop kernel:  [mem 0x00000000-0x000fffff] page 4k
Jan 10 19:38:42 laptop kernel: BRK [0x019bc000, 0x019bcfff] PGTABLE
Jan 10 19:38:42 laptop kernel: BRK [0x019bd000, 0x019bdfff] PGTABLE
Jan 10 19:38:42 laptop kernel: BRK [0x019be000, 0x019befff] PGTABLE
Jan 10 19:38:42 laptop kernel: init_memory_mapping: [mem 0x41fc00000-0x41fdfffff]
Jan 10 19:38:42 laptop kernel:  [mem 0x41fc00000-0x41fdfffff] page 2M
Jan 10 19:38:42 laptop kernel: BRK [0x019bf000, 0x019bffff] PGTABLE
Jan 10 19:38:43 laptop kernel: init_memory_mapping: [mem 0x41c000000-0x41fbfffff]
Jan 10 19:38:43 laptop kernel:  [mem 0x41c000000-0x41fbfffff] page 2M
Jan 10 19:38:43 laptop kernel: init_memory_mapping: [mem 0x400000000-0x41bffffff]
Jan 10 19:38:43 laptop kernel:  [mem 0x400000000-0x41bffffff] page 2M
Jan 10 19:38:43 laptop kernel: init_memory_mapping: [mem 0x00100000-0xd7216fff]
Jan 10 19:38:43 laptop kernel:  [mem 0x00100000-0x001fffff] page 4k
Jan 10 19:38:43 laptop kernel:  [mem 0x00200000-0x3fffffff] page 2M
Jan 10 19:38:43 laptop kernel:  [mem 0x40000000-0xbfffffff] page 1G
Jan 10 19:38:43 laptop kernel:  [mem 0xc0000000-0xd71fffff] page 2M
Jan 10 19:38:43 laptop kernel:  [mem 0xd7200000-0xd7216fff] page 4k
Jan 10 19:38:43 laptop kernel: init_memory_mapping: [mem 0xd721e000-0xd7a0cfff]
Jan 10 19:38:43 laptop kernel:  [mem 0xd721e000-0xd73fffff] page 4k
Jan 10 19:38:43 laptop kernel:  [mem 0xd7400000-0xd79fffff] page 2M
Jan 10 19:38:43 laptop kernel:  [mem 0xd7a00000-0xd7a0cfff] page 4k
Jan 10 19:38:44 laptop kernel: BRK [0x019c0000, 0x019c0fff] PGTABLE
Jan 10 19:38:44 laptop kernel: init_memory_mapping: [mem 0xd7ca2000-0xdb4dffff]
Jan 10 19:38:44 laptop kernel:  [mem 0xd7ca2000-0xd7dfffff] page 4k
Jan 10 19:38:44 laptop kernel:  [mem 0xd7e00000-0xdb3fffff] page 2M
Jan 10 19:38:44 laptop kernel:  [mem 0xdb400000-0xdb4dffff] page 4k
Jan 10 19:38:44 laptop kernel: BRK [0x019c1000, 0x019c1fff] PGTABLE
Jan 10 19:38:44 laptop kernel: init_memory_mapping: [mem 0xdb82e000-0xdb88afff]
Jan 10 19:38:44 laptop kernel:  [mem 0xdb82e000-0xdb88afff] page 4k
Jan 10 19:38:44 laptop kernel: init_memory_mapping: [mem 0xdbfff000-0xdbffffff]
Jan 10 19:38:44 laptop kernel:  [mem 0xdbfff000-0xdbffffff] page 4k
Jan 10 19:38:44 laptop kernel: init_memory_mapping: [mem 0x100000000-0x3ffffffff]
Jan 10 19:38:45 laptop kernel:  [mem 0x100000000-0x3ffffffff] page 1G
Jan 10 19:38:45 laptop kernel: ACPI: Early table checksum verification disabled
Jan 10 19:38:45 laptop kernel: ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
Jan 10 19:38:45 laptop kernel: ACPI: XSDT 0x00000000DB993088 00008C (v01 ALASKA A M I    01072009 AMI  00010013)
Jan 10 19:38:45 laptop kernel: ACPI: FACP 0x00000000DB99FEA8 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
Jan 10 19:38:45 laptop kernel: ACPI: DSDT 0x00000000DB9931A8 00CCFA (v02 ALASKA A M I    00000024 INTL 20091112)
Jan 10 19:38:45 laptop kernel: ACPI: FACS 0x00000000DB9BB080 000040
Jan 10 19:38:45 laptop kernel: ACPI: APIC 0x00000000DB99FFB8 000092 (v03 ALASKA A M I    01072009 AMI  00010013)
Jan 10 19:38:46 laptop kernel: ACPI: FPDT 0x00000000DB9A0050 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
Jan 10 19:38:46 laptop kernel: ACPI: ASF! 0x00000000DB9A0098 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
Jan 10 19:38:46 laptop kernel: ACPI: SSDT 0x00000000DB9A0140 000F92 (v01 TrmRef PtidDevc 00001000 INTL 20091112)
Jan 10 19:38:46 laptop kernel: ACPI: SSDT 0x00000000DB9A10D8 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
Jan 10 19:38:46 laptop kernel: ACPI: SSDT 0x00000000DB9A1618 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20051117)
Jan 10 19:38:46 laptop kernel: ACPI: MCFG 0x00000000DB9A20F0 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
Jan 10 19:38:46 laptop kernel: ACPI: HPET 0x00000000DB9A2130 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
Jan 10 19:38:46 laptop kernel: ACPI: SSDT 0x00000000DB9A2168 000315 (v01 SataRe SataTabl 00001000 INTL 20091112)
Jan 10 19:38:47 laptop kernel: ACPI: SSDT 0x00000000DB9A2480 001BFB (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
Jan 10 19:38:47 laptop kernel: ACPI: SSDT 0x00000000DB9A4080 000EA8 (v01 SgRef  SgPeg    00001000 INTL 20091112)
Jan 10 19:38:47 laptop kernel: ACPI: DMAR 0x00000000DB9A4F28 000090 (v01 INTEL  HSW      00000001 INTL 00000001)
Jan 10 19:38:47 laptop kernel: ACPI: Local APIC address 0xfee00000
Jan 10 19:38:47 laptop kernel:  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040f400000-ffff88041f3fffff] on node 0
Jan 10 19:38:47 laptop kernel: Zone ranges:
Jan 10 19:38:47 laptop kernel:   DMA      [mem 0x00001000-0x00ffffff]
Jan 10 19:38:47 laptop kernel:   DMA32    [mem 0x01000000-0xffffffff]
Jan 10 19:38:47 laptop kernel:   Normal   [mem 0x100000000-0x41fdfffff]
Jan 10 19:38:47 laptop kernel: Movable zone start for each node
Jan 10 19:38:47 laptop kernel: Early memory node ranges
Jan 10 19:38:47 laptop kernel:   node   0: [mem 0x00001000-0x0009cfff]
Jan 10 19:38:48 laptop kernel:   node   0: [mem 0x00100000-0xd7216fff]
Jan 10 19:38:48 laptop kernel:   node   0: [mem 0xd721e000-0xd7a0cfff]
Jan 10 19:38:48 laptop kernel:   node   0: [mem 0xd7ca2000-0xdb4dffff]
Jan 10 19:38:48 laptop kernel:   node   0: [mem 0xdb82e000-0xdb88afff]
Jan 10 19:38:48 laptop kernel:   node   0: [mem 0xdbfff000-0xdbffffff]
Jan 10 19:38:48 laptop kernel:   node   0: [mem 0x100000000-0x41fdfffff]
Jan 10 19:38:48 laptop kernel: Initmem setup node 0 [mem 0x00001000-0x41fdfffff]
Jan 10 19:38:48 laptop kernel: On node 0 totalpages: 4173886
Jan 10 19:38:48 laptop kernel:   DMA zone: 64 pages used for memmap
Jan 10 19:38:48 laptop kernel:   DMA zone: 21 pages reserved
Jan 10 19:38:48 laptop kernel:   DMA zone: 3996 pages, LIFO batch:0
Jan 10 19:38:48 laptop kernel:   DMA32 zone: 13963 pages used for memmap
Jan 10 19:38:48 laptop kernel:   DMA32 zone: 893602 pages, LIFO batch:31
Jan 10 19:38:49 laptop kernel:   Normal zone: 51192 pages used for memmap
Jan 10 19:38:49 laptop kernel:   Normal zone: 3276288 pages, LIFO batch:31
Jan 10 19:38:49 laptop kernel: Reserving Intel graphics stolen memory at 0xdd200000-0xdf1fffff
Jan 10 19:38:49 laptop kernel: ACPI: PM-Timer IO Port: 0x1808
Jan 10 19:38:49 laptop kernel: ACPI: Local APIC address 0xfee00000
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
Jan 10 19:38:49 laptop kernel: ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
Jan 10 19:38:50 laptop kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jan 10 19:38:50 laptop kernel: IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Jan 10 19:38:50 laptop kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jan 10 19:38:50 laptop kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Jan 10 19:38:50 laptop kernel: ACPI: IRQ0 used by override.
Jan 10 19:38:50 laptop kernel: ACPI: IRQ9 used by override.
Jan 10 19:38:50 laptop kernel: Using ACPI (MADT) for SMP configuration information
Jan 10 19:38:50 laptop kernel: ACPI: HPET id: 0x8086a701 base: 0xfed00000
Jan 10 19:38:50 laptop kernel: smpboot: Allowing 8 CPUs, 0 hotplug CPUs
Jan 10 19:38:50 laptop kernel: PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
Jan 10 19:38:50 laptop kernel: PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
Jan 10 19:38:50 laptop kernel: PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
Jan 10 19:38:50 laptop kernel: PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
Jan 10 19:38:50 laptop kernel: PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
Jan 10 19:38:50 laptop kernel: PM: Registered nosave memory: [mem 0xd7217000-0xd721dfff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xd7a0d000-0xd7ca1fff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xdb4e0000-0xdb82dfff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xdb88b000-0xdb9bcfff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xdb9bd000-0xdbffefff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xdc000000-0xdcffffff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xdd000000-0xdf1fffff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xdf200000-0xf7ffffff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
Jan 10 19:38:51 laptop kernel: PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
Jan 10 19:38:52 laptop kernel: PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
Jan 10 19:38:52 laptop kernel: PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
Jan 10 19:38:52 laptop kernel: e820: [mem 0xdf200000-0xf7ffffff] available for PCI devices
Jan 10 19:38:52 laptop kernel: setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
Jan 10 19:38:52 laptop kernel: PERCPU: Embedded 28 pages/cpu @ffff88041fa00000 s75328 r8192 d31168 u262144
Jan 10 19:38:52 laptop kernel: pcpu-alloc: s75328 r8192 d31168 u262144 alloc=1*2097152
Jan 10 19:38:52 laptop kernel: pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Jan 10 19:38:52 laptop kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4108646
Jan 10 19:38:52 laptop kernel: Kernel command line: root=/dev/sda2 ro resume=/dev/sda6
Jan 10 19:38:52 laptop kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Jan 10 19:38:52 laptop kernel: Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Jan 10 19:38:52 laptop kernel: Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Jan 10 19:38:52 laptop kernel: xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
Jan 10 19:38:52 laptop kernel: AGP: Checking aperture...
Jan 10 19:38:53 laptop kernel: AGP: No AGP bridge found
Jan 10 19:38:53 laptop kernel: Memory: 16331624K/16695544K available (6031K kernel code, 559K rwdata, 2036K rodata, 784K init, 508K bss, 363920K reserved, 0K cma-reserved)
Jan 10 19:38:53 laptop kernel: SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Jan 10 19:38:53 laptop kernel: Preemptible hierarchical RCU implementation.
Jan 10 19:38:53 laptop kernel: ^ICONFIG_RCU_FANOUT set to non-default value of 32
Jan 10 19:38:53 laptop kernel: NR_IRQS:4352 nr_irqs:488 16
Jan 10 19:38:53 laptop kernel: Console: colour VGA+ 80x25
Jan 10 19:38:53 laptop kernel: console [tty0] enabled
Jan 10 19:38:53 laptop kernel: hpet clockevent registered
Jan 10 19:38:53 laptop kernel: tsc: Fast TSC calibration using PIT
Jan 10 19:38:53 laptop kernel: tsc: Detected 2494.376 MHz processor
Jan 10 19:38:53 laptop kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.75 BogoMIPS (lpj=9977504)
Jan 10 19:38:53 laptop kernel: pid_max: default: 32768 minimum: 301
Jan 10 19:38:53 laptop kernel: ACPI: Core revision 20141107
Jan 10 19:38:53 laptop kernel: ACPI: All ACPI Tables successfully acquired
Jan 10 19:38:54 laptop kernel: Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
Jan 10 19:38:54 laptop kernel: Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
Jan 10 19:38:54 laptop kernel: CPU: Physical Processor ID: 0
Jan 10 19:38:54 laptop kernel: CPU: Processor Core ID: 0
Jan 10 19:38:54 laptop kernel: ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
Jan 10 19:38:54 laptop kernel: ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
Jan 10 19:38:54 laptop kernel: mce: CPU supports 9 MCE banks
Jan 10 19:38:54 laptop kernel: CPU0: Thermal monitoring enabled (TM1)
Jan 10 19:38:54 laptop kernel: Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Jan 10 19:38:54 laptop kernel: Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
Jan 10 19:38:54 laptop kernel: Freeing SMP alternatives memory: 24K (ffffffff81935000 - ffffffff8193b000)
Jan 10 19:38:54 laptop kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 10 19:38:54 laptop kernel: smpboot: CPU0: Intel(R) Core(TM) i7-4710MQ CPU @ 2.50GHz (fam: 06, model: 3c, stepping: 03)
Jan 10 19:38:54 laptop kernel: TSC deadline timer enabled
Jan 10 19:38:55 laptop kernel: Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
Jan 10 19:38:55 laptop kernel: ... version:                3
Jan 10 19:38:55 laptop kernel: ... bit width:              48
Jan 10 19:38:55 laptop kernel: ... generic registers:      4
Jan 10 19:38:55 laptop kernel: ... value mask:             0000ffffffffffff
Jan 10 19:38:55 laptop kernel: ... max period:             0000ffffffffffff
Jan 10 19:38:55 laptop kernel: ... fixed-purpose events:   3
Jan 10 19:38:55 laptop kernel: ... event mask:             000000070000000f
Jan 10 19:38:55 laptop kernel: x86: Booting SMP configuration:
Jan 10 19:38:55 laptop kernel: .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
Jan 10 19:38:55 laptop kernel: x86: Booted up 1 node, 8 CPUs
Jan 10 19:38:55 laptop kernel: smpboot: Total of 8 processors activated (39910.01 BogoMIPS)
Jan 10 19:38:55 laptop kernel: devtmpfs: initialized
Jan 10 19:38:55 laptop kernel: PM: Registering ACPI NVS region [mem 0xd7217000-0xd721dfff] (28672 bytes)
Jan 10 19:38:55 laptop kernel: PM: Registering ACPI NVS region [mem 0xdb88b000-0xdb9bcfff] (1253376 bytes)
Jan 10 19:38:55 laptop kernel: NET: Registered protocol family 16
Jan 10 19:38:55 laptop kernel: cpuidle: using governor ladder
Jan 10 19:38:55 laptop kernel: cpuidle: using governor menu
Jan 10 19:38:55 laptop kernel: ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Jan 10 19:38:55 laptop kernel: ACPI: bus type PCI registered
Jan 10 19:38:55 laptop kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Jan 10 19:38:55 laptop kernel: PCI: Using configuration type 1 for base access
Jan 10 19:38:56 laptop kernel: ACPI: Added _OSI(Module Device)
Jan 10 19:38:56 laptop kernel: ACPI: Added _OSI(Processor Device)
Jan 10 19:38:56 laptop kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
Jan 10 19:38:56 laptop kernel: ACPI: Added _OSI(Processor Aggregator Device)
Jan 10 19:38:56 laptop kernel: ACPI: Executed 1 blocks of module-level executable AML code
Jan 10 19:38:56 laptop kernel: [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
Jan 10 19:38:56 laptop kernel: ACPI: Dynamic OEM Table Load:
Jan 10 19:38:56 laptop kernel: ACPI: SSDT 0xFFFF88040DB83400 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
Jan 10 19:38:56 laptop kernel: ACPI: Dynamic OEM Table Load:
Jan 10 19:38:56 laptop kernel: ACPI: SSDT 0xFFFF88040DB8A000 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
Jan 10 19:38:57 laptop kernel: ACPI: Dynamic OEM Table Load:
Jan 10 19:38:57 laptop kernel: ACPI: SSDT 0xFFFF88040DB72C00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
Jan 10 19:38:57 laptop kernel: ACPI: Interpreter enabled
Jan 10 19:38:57 laptop kernel: ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20141107/hwxface-580)
Jan 10 19:38:57 laptop kernel: ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
Jan 10 19:38:57 laptop kernel: ACPI: (supports S0 S3 S4 S5)
Jan 10 19:38:57 laptop kernel: ACPI: Using IOAPIC for interrupt routing
Jan 10 19:38:57 laptop kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jan 10 19:38:57 laptop kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
Jan 10 19:38:57 laptop kernel: acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments]
Jan 10 19:38:58 laptop kernel: acpi PNP0A08:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
Jan 10 19:38:58 laptop kernel: PCI host bridge to bus 0000:00
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [bus 00-3e]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
Jan 10 19:38:58 laptop kernel: pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeafffff]
Jan 10 19:38:58 laptop kernel: pci 0000:00:00.0: [8086:0c04] type 00 class 0x060000
Jan 10 19:38:58 laptop kernel: pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
Jan 10 19:38:58 laptop kernel: pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Jan 10 19:38:58 laptop kernel: pci 0000:00:01.0: System wakeup disabled by ACPI
Jan 10 19:38:58 laptop kernel: pci 0000:00:02.0: [8086:0416] type 00 class 0x030000
Jan 10 19:38:58 laptop kernel: pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
Jan 10 19:38:58 laptop kernel: pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
Jan 10 19:38:58 laptop kernel: pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
Jan 10 19:38:58 laptop kernel: pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
Jan 10 19:38:58 laptop kernel: pci 0000:00:03.0: reg 0x10: [mem 0xf7f14000-0xf7f17fff 64bit]
Jan 10 19:38:58 laptop kernel: pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
Jan 10 19:38:58 laptop kernel: pci 0000:00:14.0: reg 0x10: [mem 0xf7f00000-0xf7f0ffff 64bit]
Jan 10 19:38:58 laptop kernel: pci 0000:00:14.0: PME# supported from D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:14.0: System wakeup disabled by ACPI
Jan 10 19:38:59 laptop kernel: pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
Jan 10 19:38:59 laptop kernel: pci 0000:00:16.0: reg 0x10: [mem 0xf7f1e000-0xf7f1e00f 64bit]
Jan 10 19:38:59 laptop kernel: pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
Jan 10 19:38:59 laptop kernel: pci 0000:00:1a.0: reg 0x10: [mem 0xf7f1c000-0xf7f1c3ff]
Jan 10 19:38:59 laptop kernel: pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:1a.0: System wakeup disabled by ACPI
Jan 10 19:38:59 laptop kernel: pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
Jan 10 19:38:59 laptop kernel: pci 0000:00:1b.0: reg 0x10: [mem 0xf7f10000-0xf7f13fff 64bit]
Jan 10 19:38:59 laptop kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:1b.0: System wakeup disabled by ACPI
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.0: System wakeup disabled by ACPI
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.1: System wakeup disabled by ACPI
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.2: System wakeup disabled by ACPI
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:1c.3: System wakeup disabled by ACPI
Jan 10 19:38:59 laptop kernel: pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
Jan 10 19:38:59 laptop kernel: pci 0000:00:1d.0: reg 0x10: [mem 0xf7f1b000-0xf7f1b3ff]
Jan 10 19:38:59 laptop kernel: pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
Jan 10 19:38:59 laptop kernel: pci 0000:00:1d.0: System wakeup disabled by ACPI
Jan 10 19:38:59 laptop kernel: pci 0000:00:1f.0: [8086:8c49] type 00 class 0x060100
Jan 10 19:38:59 laptop kernel: pci 0000:00:1f.2: [8086:8c03] type 00 class 0x010601
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.2: reg 0x24: [mem 0xf7f1a000-0xf7f1a7ff]
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.2: PME# supported from D3hot
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.3: reg 0x10: [mem 0xf7f19000-0xf7f190ff 64bit]
Jan 10 19:39:00 laptop kernel: pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
Jan 10 19:39:00 laptop kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
Jan 10 19:39:00 laptop kernel: acpiphp: Slot [1] registered
Jan 10 19:39:00 laptop kernel: pci 0000:00:1c.0: PCI bridge to [bus 02]
Jan 10 19:39:00 laptop kernel: pci 0000:03:00.0: [10ec:5229] type 00 class 0xff0000
Jan 10 19:39:00 laptop kernel: pci 0000:03:00.0: reg 0x10: [mem 0xf7e00000-0xf7e00fff]
Jan 10 19:39:00 laptop kernel: pci 0000:03:00.0: supports D1 D2
Jan 10 19:39:00 laptop kernel: pci 0000:03:00.0: PME# supported from D1 D2 D3hot
Jan 10 19:39:00 laptop kernel: pci 0000:03:00.0: System wakeup disabled by ACPI
Jan 10 19:39:01 laptop kernel: pci 0000:00:1c.1: PCI bridge to [bus 03]
Jan 10 19:39:01 laptop kernel: pci 0000:00:1c.1:   bridge window [mem 0xf7e00000-0xf7efffff]
Jan 10 19:39:01 laptop kernel: pci 0000:04:00.0: [8086:08b1] type 00 class 0x028000
Jan 10 19:39:01 laptop kernel: pci 0000:04:00.0: reg 0x10: [mem 0xf7d00000-0xf7d01fff 64bit]
Jan 10 19:39:01 laptop kernel: pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
Jan 10 19:39:01 laptop kernel: pci 0000:04:00.0: System wakeup disabled by ACPI
Jan 10 19:39:01 laptop kernel: pci 0000:00:1c.2: PCI bridge to [bus 04]
Jan 10 19:39:01 laptop kernel: pci 0000:00:1c.2:   bridge window [mem 0xf7d00000-0xf7dfffff]
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.0: [10ec:5289] type 00 class 0xff0000
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.0: reg 0x10: [mem 0xf7c00000-0xf7c0ffff]
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.0: supports D1 D2
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.0: System wakeup disabled by ACPI
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.2: [10ec:8168] type 00 class 0x020000
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.2: reg 0x10: [io  0xe000-0xe0ff]
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.2: reg 0x18: [mem 0xf0004000-0xf0004fff 64bit pref]
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.2: reg 0x20: [mem 0xf0000000-0xf0003fff 64bit pref]
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.2: supports D1 D2
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.2: PME# supported from D0 D1 D2 D3hot D3cold
Jan 10 19:39:01 laptop kernel: pci 0000:05:00.2: System wakeup disabled by ACPI
Jan 10 19:39:01 laptop kernel: pci 0000:00:1c.3: PCI bridge to [bus 05]
Jan 10 19:39:01 laptop kernel: pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
Jan 10 19:39:01 laptop kernel: pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
Jan 10 19:39:01 laptop kernel: pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
Jan 10 19:39:01 laptop kernel: pci_bus 0000:00: on NUMA node 0
Jan 10 19:39:01 laptop kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
Jan 10 19:39:01 laptop kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 10 11 12 14 15)
Jan 10 19:39:01 laptop kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
Jan 10 19:39:01 laptop kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
Jan 10 19:39:01 laptop kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Jan 10 19:39:01 laptop kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Jan 10 19:39:02 laptop kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
Jan 10 19:39:02 laptop kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
Jan 10 19:39:02 laptop kernel: ACPI: Enabled 4 GPEs in block 00 to 3F
Jan 10 19:39:02 laptop kernel: ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
Jan 10 19:39:02 laptop kernel: vgaarb: setting as boot device: PCI:0000:00:02.0
Jan 10 19:39:02 laptop kernel: vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Jan 10 19:39:02 laptop kernel: vgaarb: loaded
Jan 10 19:39:02 laptop kernel: vgaarb: bridge control possible 0000:00:02.0
Jan 10 19:39:02 laptop kernel: SCSI subsystem initialized
Jan 10 19:39:02 laptop kernel: libata version 3.00 loaded.
Jan 10 19:39:02 laptop kernel: ACPI: bus type USB registered
Jan 10 19:39:02 laptop kernel: usbcore: registered new interface driver usbfs
Jan 10 19:39:02 laptop kernel: usbcore: registered new interface driver hub
Jan 10 19:39:02 laptop kernel: usbcore: registered new device driver usb
Jan 10 19:39:02 laptop kernel: Linux video capture interface: v2.00
Jan 10 19:39:02 laptop kernel: Advanced Linux Sound Architecture Driver Initialized.
Jan 10 19:39:02 laptop kernel: PCI: Using ACPI for IRQ routing
Jan 10 19:39:02 laptop kernel: PCI: pci_cache_line_size set to 64 bytes
Jan 10 19:39:02 laptop kernel: e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
Jan 10 19:39:02 laptop kernel: e820: reserve RAM buffer [mem 0xd7217000-0xd7ffffff]
Jan 10 19:39:02 laptop kernel: e820: reserve RAM buffer [mem 0xd7a0d000-0xd7ffffff]
Jan 10 19:39:02 laptop kernel: e820: reserve RAM buffer [mem 0xdb4e0000-0xdbffffff]
Jan 10 19:39:02 laptop kernel: e820: reserve RAM buffer [mem 0xdb88b000-0xdbffffff]
Jan 10 19:39:02 laptop kernel: e820: reserve RAM buffer [mem 0x41fe00000-0x41fffffff]
Jan 10 19:39:02 laptop kernel: Bluetooth: Core ver 2.20
Jan 10 19:39:02 laptop kernel: NET: Registered protocol family 31
Jan 10 19:39:02 laptop kernel: Bluetooth: HCI device and connection manager initialized
Jan 10 19:39:02 laptop kernel: Bluetooth: HCI socket layer initialized
Jan 10 19:39:02 laptop kernel: Bluetooth: L2CAP socket layer initialized
Jan 10 19:39:03 laptop kernel: Bluetooth: SCO socket layer initialized
Jan 10 19:39:03 laptop kernel: Switched to clocksource hpet
Jan 10 19:39:03 laptop kernel: pnp: PnP ACPI init
Jan 10 19:39:03 laptop kernel: system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0x0680-0x069f] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0xffff] has been reserved
Jan 10 19:39:03 laptop last message repeated 2 times
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0x1c00-0x1cfe] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0x1d00-0x1dfe] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0x1e00-0x1efe] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0x1f00-0x1ffe] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0x1800-0x18fe] could not be reserved
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0x164e-0x164f] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:01: [io  0x3322-0x3323] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 10 19:39:03 laptop kernel: pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
Jan 10 19:39:03 laptop kernel: system 00:03: [io  0x1854-0x1857] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
Jan 10 19:39:03 laptop kernel: pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (active)
Jan 10 19:39:03 laptop kernel: pnp 00:05: Plug and Play ACPI device, IDs SYN1212 PNP0f13 (active)
Jan 10 19:39:03 laptop kernel: system 00:06: [io  0x04d0-0x04d1] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 10 19:39:03 laptop kernel: system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
Jan 10 19:39:03 laptop kernel: system 00:07: [mem 0xfed90000-0xfed93fff] has been reserved
Jan 10 19:39:04 laptop kernel: system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
Jan 10 19:39:04 laptop kernel: system 00:07: [mem 0xff000000-0xffffffff] has been reserved
Jan 10 19:39:04 laptop kernel: system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
Jan 10 19:39:04 laptop kernel: system 00:07: [mem 0xf7ffe000-0xf7ffefff] has been reserved
Jan 10 19:39:04 laptop kernel: system 00:07: [mem 0xf7fe0000-0xf7fe0fff] has been reserved
Jan 10 19:39:04 laptop kernel: system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 10 19:39:04 laptop kernel: pnp: PnP ACPI: found 8 devices
Jan 10 19:39:04 laptop kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.0: PCI bridge to [bus 02]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.1: PCI bridge to [bus 03]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.1:   bridge window [mem 0xf7e00000-0xf7efffff]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.2: PCI bridge to [bus 04]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.2:   bridge window [mem 0xf7d00000-0xf7dfffff]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.3: PCI bridge to [bus 05]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
Jan 10 19:39:04 laptop kernel: pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:00: resource 13 [mem 0xdf200000-0xfeafffff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:03: resource 1 [mem 0xf7e00000-0xf7efffff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:04: resource 1 [mem 0xf7d00000-0xf7dfffff]
Jan 10 19:39:04 laptop kernel: pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
Jan 10 19:39:05 laptop kernel: pci_bus 0000:05: resource 1 [mem 0xf7c00000-0xf7cfffff]
Jan 10 19:39:05 laptop kernel: pci_bus 0000:05: resource 2 [mem 0xf0000000-0xf00fffff 64bit pref]
Jan 10 19:39:05 laptop kernel: NET: Registered protocol family 2
Jan 10 19:39:05 laptop kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Jan 10 19:39:05 laptop kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jan 10 19:39:05 laptop kernel: TCP: Hash tables configured (established 131072 bind 65536)
Jan 10 19:39:05 laptop kernel: TCP: reno registered
Jan 10 19:39:05 laptop kernel: UDP hash table entries: 8192 (order: 6, 262144 bytes)
Jan 10 19:39:05 laptop kernel: UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
Jan 10 19:39:05 laptop kernel: NET: Registered protocol family 1
Jan 10 19:39:05 laptop kernel: pci 0000:00:02.0: Video device with shadowed ROM
Jan 10 19:39:05 laptop kernel: PCI: CLS 64 bytes, default 64
Jan 10 19:39:05 laptop kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Jan 10 19:39:05 laptop kernel: software IO TLB [mem 0xd3217000-0xd7217000] (64MB) mapped at [ffff8800d3217000-ffff8800d7216fff]
Jan 10 19:39:05 laptop kernel: RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
Jan 10 19:39:05 laptop kernel: microcode: CPU0 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:05 laptop kernel: microcode: CPU1 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:05 laptop kernel: microcode: CPU2 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:05 laptop kernel: microcode: CPU3 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:05 laptop kernel: microcode: CPU4 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:05 laptop kernel: microcode: CPU5 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:05 laptop kernel: microcode: CPU6 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:05 laptop kernel: microcode: CPU7 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:05 laptop kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jan 10 19:39:05 laptop kernel: futex hash table entries: 2048 (order: 5, 131072 bytes)
Jan 10 19:39:05 laptop kernel: fuse init (API version 7.23)
Jan 10 19:39:05 laptop kernel: io scheduler noop registered
Jan 10 19:39:05 laptop kernel: io scheduler cfq registered (default)
Jan 10 19:39:05 laptop kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jan 10 19:39:05 laptop kernel: intel_idle: MWAIT substates: 0x42120
Jan 10 19:39:06 laptop kernel: intel_idle: v0.4 model 0x3C
Jan 10 19:39:06 laptop kernel: intel_idle: lapic_timer_reliable_states 0xffffffff
Jan 10 19:39:06 laptop kernel: ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
Jan 10 19:39:06 laptop kernel: ACPI: AC Adapter [AC] (on-line)
Jan 10 19:39:06 laptop kernel: input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Jan 10 19:39:06 laptop kernel: ACPI: Power Button [PWRB]
Jan 10 19:39:06 laptop kernel: input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
Jan 10 19:39:06 laptop kernel: ACPI: Sleep Button [SLPB]
Jan 10 19:39:06 laptop kernel: input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
Jan 10 19:39:06 laptop kernel: ACPI: Lid Switch [LID0]
Jan 10 19:39:06 laptop kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Jan 10 19:39:06 laptop kernel: ACPI: Power Button [PWRF]
Jan 10 19:39:06 laptop kernel: thermal LNXTHERM:00: registered as thermal_zone0
Jan 10 19:39:06 laptop kernel: ACPI: Thermal Zone [TZ0] (14 C)
Jan 10 19:39:06 laptop kernel: ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
Jan 10 19:39:06 laptop kernel: ACPI: Battery Slot [BAT0] (battery present)
Jan 10 19:39:06 laptop kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Jan 10 19:39:06 laptop kernel: Linux agpgart interface v0.103
Jan 10 19:39:06 laptop kernel: [drm] Initialized drm 1.1.0 20060810
Jan 10 19:39:06 laptop kernel: [drm] Memory usable by graphics device = 2048M
Jan 10 19:39:06 laptop kernel: [drm] Replacing VGA console driver
Jan 10 19:39:06 laptop kernel: Console: switching to colour dummy device 80x25
Jan 10 19:39:06 laptop kernel: [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
Jan 10 19:39:06 laptop kernel: [drm] Driver supports precise vblank timestamp query.
Jan 10 19:39:06 laptop kernel: vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Jan 10 19:39:06 laptop kernel: ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Jan 10 19:39:07 laptop kernel: input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
Jan 10 19:39:07 laptop kernel: [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
Jan 10 19:39:07 laptop kernel: rtsx_pci 0000:03:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 0, pci->irq = 17
Jan 10 19:39:07 laptop kernel: rtsx_pci 0000:05:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 0, pci->irq = 16
Jan 10 19:39:07 laptop kernel: ahci 0000:00:1f.2: version 3.0
Jan 10 19:39:07 laptop kernel: ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
Jan 10 19:39:07 laptop kernel: ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x25 impl SATA mode
Jan 10 19:39:07 laptop kernel: ahci 0000:00:1f.2: flags: 64bit ncq stag led clo pio slum part ems sxs apst 
Jan 10 19:39:07 laptop kernel: scsi host0: ahci
Jan 10 19:39:07 laptop kernel: scsi host1: ahci
Jan 10 19:39:07 laptop kernel: scsi host2: ahci
Jan 10 19:39:07 laptop kernel: scsi host3: ahci
Jan 10 19:39:07 laptop kernel: scsi host4: ahci
Jan 10 19:39:07 laptop kernel: scsi host5: ahci
Jan 10 19:39:07 laptop kernel: ata1: SATA max UDMA/133 abar m2048@0xf7f1a000 port 0xf7f1a100 irq 19
Jan 10 19:39:07 laptop kernel: ata2: DUMMY
Jan 10 19:39:07 laptop kernel: ata3: SATA max UDMA/133 abar m2048@0xf7f1a000 port 0xf7f1a200 irq 19
Jan 10 19:39:07 laptop kernel: ata4: DUMMY
Jan 10 19:39:07 laptop kernel: ata5: DUMMY
Jan 10 19:39:07 laptop kernel: ata6: SATA max UDMA/133 abar m2048@0xf7f1a000 port 0xf7f1a380 irq 19
Jan 10 19:39:07 laptop kernel: fbcon: inteldrmfb (fb0) is primary device
Jan 10 19:39:07 laptop kernel: xhci_hcd 0000:00:14.0: xHCI Host Controller
Jan 10 19:39:07 laptop kernel: xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
Jan 10 19:39:07 laptop kernel: xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
Jan 10 19:39:07 laptop kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Jan 10 19:39:07 laptop kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 10 19:39:07 laptop kernel: usb usb1: Product: xHCI Host Controller
Jan 10 19:39:07 laptop kernel: usb usb1: Manufacturer: Linux 3.19.0-rc3+ xhci-hcd
Jan 10 19:39:07 laptop kernel: usb usb1: SerialNumber: 0000:00:14.0
Jan 10 19:39:07 laptop kernel: hub 1-0:1.0: USB hub found
Jan 10 19:39:08 laptop kernel: hub 1-0:1.0: 14 ports detected
Jan 10 19:39:08 laptop kernel: xhci_hcd 0000:00:14.0: xHCI Host Controller
Jan 10 19:39:08 laptop kernel: xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
Jan 10 19:39:08 laptop kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
Jan 10 19:39:08 laptop kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 10 19:39:08 laptop kernel: usb usb2: Product: xHCI Host Controller
Jan 10 19:39:08 laptop kernel: usb usb2: Manufacturer: Linux 3.19.0-rc3+ xhci-hcd
Jan 10 19:39:08 laptop kernel: usb usb2: SerialNumber: 0000:00:14.0
Jan 10 19:39:08 laptop kernel: hub 2-0:1.0: USB hub found
Jan 10 19:39:08 laptop kernel: hub 2-0:1.0: 4 ports detected
Jan 10 19:39:08 laptop kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jan 10 19:39:08 laptop kernel: ehci-pci: EHCI PCI platform driver
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1a.0: EHCI Host Controller
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1a.0: debug port 2
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7f1c000
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Jan 10 19:39:08 laptop kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
Jan 10 19:39:08 laptop kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 10 19:39:08 laptop kernel: usb usb3: Product: EHCI Host Controller
Jan 10 19:39:08 laptop kernel: usb usb3: Manufacturer: Linux 3.19.0-rc3+ ehci_hcd
Jan 10 19:39:08 laptop kernel: usb usb3: SerialNumber: 0000:00:1a.0
Jan 10 19:39:08 laptop kernel: hub 3-0:1.0: USB hub found
Jan 10 19:39:08 laptop kernel: hub 3-0:1.0: 2 ports detected
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1d.0: EHCI Host Controller
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1d.0: debug port 2
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7f1b000
Jan 10 19:39:08 laptop kernel: ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Jan 10 19:39:08 laptop kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
Jan 10 19:39:09 laptop kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jan 10 19:39:09 laptop kernel: usb usb4: Product: EHCI Host Controller
Jan 10 19:39:09 laptop kernel: usb usb4: Manufacturer: Linux 3.19.0-rc3+ ehci_hcd
Jan 10 19:39:09 laptop kernel: usb usb4: SerialNumber: 0000:00:1d.0
Jan 10 19:39:09 laptop kernel: hub 4-0:1.0: USB hub found
Jan 10 19:39:09 laptop kernel: hub 4-0:1.0: 2 ports detected
Jan 10 19:39:09 laptop kernel: uhci_hcd: USB Universal Host Controller Interface driver
Jan 10 19:39:09 laptop kernel: usbcore: registered new interface driver usb-storage
Jan 10 19:39:09 laptop kernel: usbcore: registered new interface driver ums-realtek
Jan 10 19:39:09 laptop kernel: i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:SYNM] at 0x60,0x64 irq 1,12
Jan 10 19:39:09 laptop kernel: i8042: Detected active multiplexing controller, rev 1.1
Jan 10 19:39:09 laptop kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 10 19:39:09 laptop kernel: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Jan 10 19:39:09 laptop kernel: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Jan 10 19:39:09 laptop kernel: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Jan 10 19:39:09 laptop kernel: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Jan 10 19:39:09 laptop kernel: mousedev: PS/2 mouse device common for all mice
Jan 10 19:39:09 laptop kernel: rtc_cmos 00:02: RTC can wake from S4
Jan 10 19:39:09 laptop kernel: rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
Jan 10 19:39:09 laptop kernel: rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
Jan 10 19:39:09 laptop kernel: i2c /dev entries driver
Jan 10 19:39:09 laptop kernel: ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20141107/utaddress-258)
Jan 10 19:39:09 laptop kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Jan 10 19:39:09 laptop kernel: usbcore: registered new interface driver uvcvideo
Jan 10 19:39:09 laptop kernel: USB Video Class driver (1.1.1)
Jan 10 19:39:09 laptop kernel: usbcore: registered new interface driver btusb
Jan 10 19:39:09 laptop kernel: Driver 'mmcblk' needs updating - please use bus_type methods
Jan 10 19:39:09 laptop kernel: usbcore: registered new interface driver usbhid
Jan 10 19:39:10 laptop kernel: usbhid: USB HID core driver
Jan 10 19:39:10 laptop kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Jan 10 19:39:10 laptop kernel: TCP: cubic registered
Jan 10 19:39:10 laptop kernel: NET: Registered protocol family 17
Jan 10 19:39:10 laptop kernel: NET: Registered protocol family 15
Jan 10 19:39:10 laptop kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
Jan 10 19:39:10 laptop kernel: registered taskstats version 1
Jan 10 19:39:10 laptop kernel: rtc_cmos 00:02: setting system clock to 2015-01-10 19:38:27 UTC (1420918707)
Jan 10 19:39:10 laptop kernel: usb 1-7: new full-speed USB device number 2 using xhci_hcd
Jan 10 19:39:10 laptop kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jan 10 19:39:10 laptop kernel: ata1.00: ATAPI: TSSTcorp CDDVDW SN-208FB, SB00, max UDMA/100
Jan 10 19:39:10 laptop kernel: usb 3-1: new high-speed USB device number 2 using ehci-pci
Jan 10 19:39:10 laptop kernel: ata1.00: configured for UDMA/100
Jan 10 19:39:10 laptop kernel: usb 4-1: new high-speed USB device number 2 using ehci-pci
Jan 10 19:39:10 laptop kernel: usb 1-7: New USB device found, idVendor=8087, idProduct=07dc
Jan 10 19:39:10 laptop kernel: usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jan 10 19:39:10 laptop kernel: Bluetooth: hci0: read Intel version: 3707100180012d0d00
Jan 10 19:39:10 laptop kernel: bluetooth hci0: Direct firmware load for intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq failed with error -2
Jan 10 19:39:10 laptop kernel: Bluetooth: hci0 failed to open Intel firmware file: intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq(-2)
Jan 10 19:39:10 laptop kernel: bluetooth hci0: Direct firmware load for intel/ibt-hw-37.7.bseq failed with error -2
Jan 10 19:39:10 laptop kernel: Bluetooth: hci0 failed to open default Intel fw file: intel/ibt-hw-37.7.bseq
Jan 10 19:39:10 laptop kernel: usb 3-1: New USB device found, idVendor=8087, idProduct=8008
Jan 10 19:39:10 laptop kernel: usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jan 10 19:39:10 laptop kernel: hub 3-1:1.0: USB hub found
Jan 10 19:39:11 laptop kernel: hub 3-1:1.0: 6 ports detected
Jan 10 19:39:11 laptop kernel: usb 4-1: New USB device found, idVendor=8087, idProduct=8000
Jan 10 19:39:11 laptop kernel: usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jan 10 19:39:11 laptop kernel: hub 4-1:1.0: USB hub found
Jan 10 19:39:11 laptop kernel: hub 4-1:1.0: 8 ports detected
Jan 10 19:39:11 laptop kernel: usb 1-8: new high-speed USB device number 3 using xhci_hcd
Jan 10 19:39:11 laptop kernel: usb 1-8: New USB device found, idVendor=04f2, idProduct=b43b
Jan 10 19:39:11 laptop kernel: usb 1-8: New USB device strings: Mfr=3, Product=1, SerialNumber=2
Jan 10 19:39:11 laptop kernel: usb 1-8: Product: Chicony USB 2.0 Camera
Jan 10 19:39:11 laptop kernel: usb 1-8: Manufacturer: Chicony Electronics Co.,Ltd.
Jan 10 19:39:11 laptop kernel: usb 1-8: SerialNumber: 0x0001
Jan 10 19:39:11 laptop kernel: uvcvideo: Found UVC 1.00 device Chicony USB 2.0 Camera (04f2:b43b)
Jan 10 19:39:11 laptop kernel: tsc: Refined TSC clocksource calibration: 2494.224 MHz
Jan 10 19:39:11 laptop kernel: Console: switching to colour frame buffer device 200x56
Jan 10 19:39:11 laptop kernel: i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
Jan 10 19:39:11 laptop kernel: i915 0000:00:02.0: registered panic notifier
Jan 10 19:39:11 laptop kernel: scsi 0:0:0:0: CD-ROM            TSSTcorp CDDVDW SN-208FB  SB00 PQ: 0 ANSI: 5
Jan 10 19:39:11 laptop kernel: sr 0:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 10 19:39:11 laptop kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Jan 10 19:39:11 laptop kernel: sr 0:0:0:0: Attached scsi CD-ROM sr0
Jan 10 19:39:11 laptop kernel: sr 0:0:0:0: Attached scsi generic sg0 type 5
Jan 10 19:39:11 laptop kernel: ata3: SATA link down (SStatus 0 SControl 300)
Jan 10 19:39:11 laptop kernel: Switched to clocksource tsc
Jan 10 19:39:11 laptop kernel: ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Jan 10 19:39:11 laptop kernel: ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
Jan 10 19:39:11 laptop kernel: ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Jan 10 19:39:11 laptop kernel: ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Jan 10 19:39:11 laptop kernel: ata6.00: ATA-8: HGST HTS541010A9E680, JA0OA560, max UDMA/133
Jan 10 19:39:11 laptop kernel: ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jan 10 19:39:11 laptop kernel: ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
Jan 10 19:39:11 laptop kernel: ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Jan 10 19:39:11 laptop kernel: ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Jan 10 19:39:12 laptop kernel: ata6.00: configured for UDMA/133
Jan 10 19:39:12 laptop kernel: scsi 5:0:0:0: Direct-Access     ATA      HGST HTS541010A9 A560 PQ: 0 ANSI: 5
Jan 10 19:39:12 laptop kernel: sd 5:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Jan 10 19:39:12 laptop kernel: sd 5:0:0:0: Attached scsi generic sg1 type 0
Jan 10 19:39:12 laptop kernel: sd 5:0:0:0: [sda] 4096-byte physical blocks
Jan 10 19:39:12 laptop kernel: sd 5:0:0:0: [sda] Write Protect is off
Jan 10 19:39:12 laptop kernel: sd 5:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 10 19:39:12 laptop kernel: sd 5:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 10 19:39:12 laptop kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
Jan 10 19:39:12 laptop kernel: sd 5:0:0:0: [sda] Attached SCSI disk
Jan 10 19:39:12 laptop kernel: ALSA device list:
Jan 10 19:39:12 laptop kernel:   No soundcards found.
Jan 10 19:39:12 laptop kernel: EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
Jan 10 19:39:12 laptop kernel: VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
Jan 10 19:39:12 laptop kernel: devtmpfs: mounted
Jan 10 19:39:12 laptop kernel: Freeing unused kernel memory: 784K (ffffffff81871000 - ffffffff81935000)
Jan 10 19:39:12 laptop kernel: EXT4-fs (sda2): re-mounted. Opts: (null)
Jan 10 19:39:12 laptop kernel: random: nonblocking pool is initialized
Jan 10 19:39:12 laptop kernel: <30>udevd[155]: starting version 2.1.1
Jan 10 19:39:12 laptop kernel: cfg80211: Calling CRDA to update world regulatory domain
Jan 10 19:39:12 laptop kernel: Intel(R) Wireless WiFi driver for Linux, in-tree:
Jan 10 19:39:12 laptop kernel: Copyright(c) 2003- 2014 Intel Corporation
Jan 10 19:39:12 laptop kernel: iwlwifi 0000:04:00.0: pci_enable_msi failed(0Xffffffda)
Jan 10 19:39:12 laptop kernel: iwlwifi 0000:04:00.0: loaded firmware version 23.11.10.0 op_mode iwlmvm
Jan 10 19:39:12 laptop kernel: sound hdaudioC0D0: autoconfig: line_outs=1 (0x24/0x0/0x0/0x0/0x0) type:speaker
Jan 10 19:39:12 laptop kernel: sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
Jan 10 19:39:12 laptop kernel: sound hdaudioC0D0:    hp_outs=1 (0x25/0x0/0x0/0x0/0x0)
Jan 10 19:39:12 laptop kernel: sound hdaudioC0D0:    mono: mono_out=0x0
Jan 10 19:39:12 laptop kernel: sound hdaudioC0D0:    inputs:
Jan 10 19:39:13 laptop kernel: sound hdaudioC0D0:      Internal Mic=0x30
Jan 10 19:39:13 laptop kernel: sound hdaudioC0D0:      Mic=0x2b
Jan 10 19:39:13 laptop kernel: iwlwifi 0000:04:00.0: Detected Intel(R) Wireless N 7260, REV=0x144
Jan 10 19:39:13 laptop kernel: iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
Jan 10 19:39:13 laptop kernel: iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
Jan 10 19:39:13 laptop kernel: cfg80211: World regulatory domain updated:
Jan 10 19:39:13 laptop kernel: cfg80211:  DFS Master region: unset
Jan 10 19:39:13 laptop kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Jan 10 19:39:13 laptop kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Jan 10 19:39:13 laptop kernel: cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
Jan 10 19:39:13 laptop kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
Jan 10 19:39:13 laptop kernel: iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
Jan 10 19:39:13 laptop kernel: iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
Jan 10 19:39:13 laptop kernel: cfg80211: Calling CRDA for country: GB
Jan 10 19:39:13 laptop kernel: cfg80211: Regulatory domain changed to country: GB
Jan 10 19:39:13 laptop kernel: cfg80211:  DFS Master region: ETSI
Jan 10 19:39:13 laptop kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
Jan 10 19:39:13 laptop kernel: cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
Jan 10 19:39:13 laptop kernel: cfg80211:   (5490000 KHz - 5710000 KHz @ 160000 KHz), (N/A, 2700 mBm), (0 s)
Jan 10 19:39:13 laptop kernel: cfg80211:   (57000000 KHz - 66000000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
Jan 10 19:39:13 laptop kernel: Bluetooth: RFCOMM TTY layer initialized
Jan 10 19:39:13 laptop kernel: Bluetooth: RFCOMM socket layer initialized
Jan 10 19:39:14 laptop kernel: Bluetooth: RFCOMM ver 1.11
Jan 10 19:39:14 laptop kernel: wlan0: authenticate with 00:1f:33:80:09:44
Jan 10 19:39:14 laptop kernel: wlan0: send auth to 00:1f:33:80:09:44 (try 1/3)
Jan 10 19:39:14 laptop kernel: wlan0: authenticated
Jan 10 19:39:14 laptop kernel: iwlwifi 0000:04:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
Jan 10 19:39:14 laptop kernel: wlan0: associate with 00:1f:33:80:09:44 (try 1/3)
Jan 10 19:39:14 laptop kernel: wlan0: RX AssocResp from 00:1f:33:80:09:44 (capab=0x431 status=0 aid=33)
Jan 10 19:39:14 laptop kernel: wlan0: associated
Jan 10 19:39:14 laptop kernel: microcode: CPU0 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:14 laptop kernel: microcode: CPU0 updated to revision 0x1a, date = 2014-05-23
Jan 10 19:39:14 laptop kernel: microcode: CPU1 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:14 laptop kernel: microcode: CPU1 updated to revision 0x1a, date = 2014-05-23
Jan 10 19:39:14 laptop kernel: microcode: CPU2 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:14 laptop kernel: microcode: CPU2 updated to revision 0x1a, date = 2014-05-23
Jan 10 19:39:14 laptop kernel: microcode: CPU3 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:14 laptop kernel: microcode: CPU3 updated to revision 0x1a, date = 2014-05-23
Jan 10 19:39:14 laptop kernel: microcode: CPU4 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:14 laptop kernel: microcode: CPU4 updated to revision 0x1a, date = 2014-05-23
Jan 10 19:39:14 laptop kernel: microcode: CPU5 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:14 laptop kernel: microcode: CPU5 updated to revision 0x1a, date = 2014-05-23
Jan 10 19:39:14 laptop kernel: microcode: CPU6 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:14 laptop kernel: microcode: CPU6 updated to revision 0x1a, date = 2014-05-23
Jan 10 19:39:14 laptop kernel: microcode: CPU7 sig=0x306c3, pf=0x10, revision=0x17
Jan 10 19:39:14 laptop kernel: microcode: CPU7 updated to revision 0x1a, date = 2014-05-23
Jan 10 19:39:14 laptop kernel: EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
Jan 10 19:39:14 laptop kernel: EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
Jan 10 19:39:14 laptop kernel: EXT4-fs (sda10): mounted filesystem with ordered data mode. Opts: (null)
Jan 10 19:39:14 laptop kernel: Adding 16777212k swap on /dev/sda6.  Priority:-1 extents:1 across:16777212k 
Jan 10 19:39:14 laptop kernel: ------------[ cut here ]------------
Jan 10 19:39:14 laptop kernel: kernel BUG at mm/rmap.c:399!
Jan 10 19:39:15 laptop kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Jan 10 19:39:15 laptop kernel: Modules linked in: rfcomm iwlmvm mac80211 snd_hda_codec_via snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel iwlwifi cfg80211 coretemp snd_hda_controller hwmon x86_pkg_temp_thermal snd_hda_codec snd_hwdep acpi_cpufreq
Jan 10 19:39:15 laptop kernel: CPU: 0 PID: 362 Comm: fc-cache Not tainted 3.19.0-rc3+ #42
Jan 10 19:39:15 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ                        , BIOS 1.03.05 02/26/2014
Jan 10 19:39:15 laptop kernel: task: ffff8800dab06c80 ti: ffff88040a784000 task.ti: ffff88040a784000
Jan 10 19:39:15 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:39:15 laptop kernel: RSP: 0018:ffff88040a787d88  EFLAGS: 00010286
Jan 10 19:39:15 laptop kernel: RAX: ffff8800da8fb090 RBX: ffff8800da8fb080 RCX: 00000000ffffffff
Jan 10 19:39:15 laptop kernel: RDX: ffffffff00000001 RSI: ffff8804088a5360 RDI: ffff8804088a5320
Jan 10 19:39:15 laptop kernel: RBP: ffff8800da447b68 R08: 0000000000000000 R09: ffff88040d801c00
Jan 10 19:39:15 laptop kernel: R10: ffff88041fa146e0 R11: ffff8800da8fb0a0 R12: ffff8804088a5320
Jan 10 19:39:15 laptop kernel: R13: ffff8800da447b68 R14: ffff8800da447b78 R15: ffff8800da447b00
Jan 10 19:39:15 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fa00000(0000) knlGS:0000000000000000
Jan 10 19:39:15 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 10 19:39:16 laptop kernel: CR2: 00000000f75dfdc4 CR3: 000000040a73c000 CR4: 00000000001407f0
Jan 10 19:39:16 laptop kernel: Stack:
Jan 10 19:39:16 laptop kernel:  ffff88040d697478 ffff88040d697440 ffff880408892370 ffff8800da447b00
Jan 10 19:39:16 laptop kernel:  ffff880408892790 00000000f7176000 ffff88040a787e28 0000000000000000
Jan 10 19:39:16 laptop kernel:  0000000000000000 ffffffff810e3633 0000000000000000 0000000000000000
Jan 10 19:39:16 laptop kernel: Call Trace:
Jan 10 19:39:16 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
Jan 10 19:39:16 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
Jan 10 19:39:16 laptop kernel:  [<ffffffff8103980d>] ? __do_page_fault+0x17d/0x4b0
Jan 10 19:39:16 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
Jan 10 19:39:16 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
Jan 10 19:39:16 laptop kernel:  [<ffffffff8111fe89>] ? mntput_no_expire+0x9/0x140
Jan 10 19:39:16 laptop kernel:  [<ffffffff8105ca1c>] ? task_work_run+0xbc/0xf0
Jan 10 19:39:16 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
Jan 10 19:39:16 laptop kernel:  [<ffffffff81047dcf>] ? SyS_exit_group+0xf/0x10
Jan 10 19:39:17 laptop kernel:  [<ffffffff815e0f9f>] ? sysenter_dispatch+0x7/0x1e
Jan 10 19:39:17 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74 54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00 
Jan 10 19:39:17 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:39:17 laptop kernel:  RSP <ffff88040a787d88>
Jan 10 19:39:17 laptop kernel: ---[ end trace 0b15d6a845b49cfe ]---
Jan 10 19:39:17 laptop kernel: Fixing recursive fault but reboot is needed!
Jan 10 19:39:17 laptop kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Jan 10 19:39:17 laptop kernel: ------------[ cut here ]------------
Jan 10 19:39:17 laptop kernel: kernel BUG at mm/rmap.c:399!
Jan 10 19:39:17 laptop kernel: invalid opcode: 0000 [#2] PREEMPT SMP 
Jan 10 19:39:17 laptop kernel: Modules linked in: iptable_filter xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack rfcomm iwlmvm mac80211 snd_hda_codec_via snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel iwlwifi cfg80211 coretemp snd_hda_controller hwmon x86_pkg_temp_thermal snd_hda_codec snd_hwdep acpi_cpufreq
Jan 10 19:39:17 laptop kernel: CPU: 5 PID: 686 Comm: krootimage Tainted: G      D        3.19.0-rc3+ #42
Jan 10 19:39:17 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ                        , BIOS 1.03.05 02/26/2014
Jan 10 19:39:17 laptop kernel: task: ffff88040cb59f00 ti: ffff88040b904000 task.ti: ffff88040b904000
Jan 10 19:39:17 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:39:17 laptop kernel: RSP: 0018:ffff88040b907d88  EFLAGS: 00010286
Jan 10 19:39:18 laptop kernel: RAX: ffff8800da84ed90 RBX: ffff8800da84ed80 RCX: 00000000ffffffff
Jan 10 19:39:18 laptop kernel: RDX: ffffffff00000001 RSI: ffff88040caf1ea0 RDI: ffff88040caf1e60
Jan 10 19:39:18 laptop kernel: RBP: ffff88040bb2f3d8 R08: 0000000000000000 R09: ffff88040d801c00
Jan 10 19:39:18 laptop kernel: R10: ffff88041fb546e0 R11: ffff8800da84eda0 R12: ffff88040caf1e60
Jan 10 19:39:18 laptop kernel: R13: ffff88040bb2f3d8 R14: ffff88040bb2f3e8 R15: ffff88040bb2f370
Jan 10 19:39:18 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fb40000(0000) knlGS:0000000000000000
Jan 10 19:39:18 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 10 19:39:18 laptop kernel: CR2: 00000000f614b064 CR3: 000000040bbd4000 CR4: 00000000001407e0
Jan 10 19:39:18 laptop kernel: Stack:
Jan 10 19:39:18 laptop kernel:  ffff8800dad0ed18 ffff8800dad0ece0 0000000000000000 ffff88040bb2f370
Jan 10 19:39:18 laptop kernel:  ffff88040b85d000 00000000f5904000 ffff88040b907e28 0000000000000000
Jan 10 19:39:18 laptop kernel:  0000000000000000 ffffffff810e3633 0000000000000000 0000000000000000
Jan 10 19:39:18 laptop kernel: Call Trace:
Jan 10 19:39:18 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
Jan 10 19:39:19 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
Jan 10 19:39:19 laptop kernel:  [<ffffffff8103980d>] ? __do_page_fault+0x17d/0x4b0
Jan 10 19:39:19 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
Jan 10 19:39:19 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
Jan 10 19:39:19 laptop kernel:  [<ffffffff8111fe89>] ? mntput_no_expire+0x9/0x140
Jan 10 19:39:19 laptop kernel:  [<ffffffff8105ca1c>] ? task_work_run+0xbc/0xf0
Jan 10 19:39:19 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
Jan 10 19:39:19 laptop kernel:  [<ffffffff81047dcf>] ? SyS_exit_group+0xf/0x10
Jan 10 19:39:19 laptop kernel:  [<ffffffff815e0f9f>] ? sysenter_dispatch+0x7/0x1e
Jan 10 19:39:19 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74 54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00 
Jan 10 19:39:19 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:39:19 laptop kernel:  RSP <ffff88040b907d88>
Jan 10 19:39:19 laptop kernel: ---[ end trace 0b15d6a845b49cff ]---
Jan 10 19:39:19 laptop kernel: Fixing recursive fault but reboot is needed!
Jan 10 19:39:21 laptop kernel: ------------[ cut here ]------------
Jan 10 19:39:21 laptop kernel: kernel BUG at mm/rmap.c:399!
Jan 10 19:39:21 laptop kernel: invalid opcode: 0000 [#3] PREEMPT SMP 
Jan 10 19:39:22 laptop kernel: Modules linked in: iptable_filter xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack rfcomm iwlmvm mac80211 snd_hda_codec_via snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel iwlwifi cfg80211 coretemp snd_hda_controller hwmon x86_pkg_temp_thermal snd_hda_codec snd_hwdep acpi_cpufreq
Jan 10 19:39:22 laptop kernel: CPU: 0 PID: 685 Comm: kdm_greet Tainted: G      D        3.19.0-rc3+ #42
Jan 10 19:39:22 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ                        , BIOS 1.03.05 02/26/2014
Jan 10 19:39:22 laptop kernel: task: ffff880409c4a6c0 ti: ffff88040884c000 task.ti: ffff88040884c000
Jan 10 19:39:22 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:39:22 laptop kernel: RSP: 0018:ffff88040884fd88  EFLAGS: 00210286
Jan 10 19:39:22 laptop kernel: RAX: ffff88040b81dbd0 RBX: ffff88040b81dbc0 RCX: 00000000ffffffff
Jan 10 19:39:22 laptop kernel: RDX: ffffffff00000001 RSI: ffff88040ccc1b80 RDI: ffff88040ccc1b40
Jan 10 19:39:22 laptop kernel: RBP: ffff8800da91be28 R08: 0000000000000000 R09: ffff88040d801c00
Jan 10 19:39:22 laptop kernel: R10: ffff88041fa146e0 R11: ffff88040b81dbe0 R12: ffff88040ccc1b40
Jan 10 19:39:22 laptop kernel: R13: ffff8800da91be28 R14: ffff8800da91be38 R15: ffff8800da91bdc0
Jan 10 19:39:22 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fa00000(0000) knlGS:0000000000000000
Jan 10 19:39:22 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 10 19:39:22 laptop kernel: CR2: 00000000f64ff064 CR3: 0000000409f11000 CR4: 00000000001407f0
Jan 10 19:39:22 laptop kernel: Stack:
Jan 10 19:39:22 laptop kernel:  ffff88040d697478 ffff88040d697440 ffff8800daab86e0 ffff8800da91bdc0
Jan 10 19:39:23 laptop kernel:  ffff8800daab8580 00000000f5c21000 ffff88040884fe28 0000000000000000
Jan 10 19:39:23 laptop kernel:  0000000000000000 ffffffff810e3633 0000000000000000 0000000000000000
Jan 10 19:39:23 laptop kernel: Call Trace:
Jan 10 19:39:23 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
Jan 10 19:39:23 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
Jan 10 19:39:23 laptop kernel:  [<ffffffff8103980d>] ? __do_page_fault+0x17d/0x4b0
Jan 10 19:39:23 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
Jan 10 19:39:23 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
Jan 10 19:39:23 laptop kernel:  [<ffffffff8111fe89>] ? mntput_no_expire+0x9/0x140
Jan 10 19:39:23 laptop kernel:  [<ffffffff8105ca1c>] ? task_work_run+0xbc/0xf0
Jan 10 19:39:23 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
Jan 10 19:39:23 laptop kernel:  [<ffffffff81047dcf>] ? SyS_exit_group+0xf/0x10
Jan 10 19:39:23 laptop kernel:  [<ffffffff815e0f9f>] ? sysenter_dispatch+0x7/0x1e
Jan 10 19:39:23 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74 54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00 
Jan 10 19:39:23 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:39:24 laptop kernel:  RSP <ffff88040884fd88>
Jan 10 19:39:24 laptop kernel: ---[ end trace 0b15d6a845b49d00 ]---
Jan 10 19:39:24 laptop kernel: Fixing recursive fault but reboot is needed!
Jan 10 19:39:30 laptop kernel: Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Jan 10 19:39:30 laptop kernel: Bluetooth: HIDP socket layer initialized
Jan 10 19:39:30 laptop kernel: hid-generic 0005:0A5C:0001.0001: unknown main item tag 0x0
Jan 10 19:39:30 laptop kernel: input: Bluetooth 3.0 mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-7/1-7:1.0/bluetooth/hci0/hci0:256/0005:0A5C:0001.0001/input/input10
Jan 10 19:39:30 laptop kernel: hid-generic 0005:0A5C:0001.0001: input: BLUETOOTH HID v1.29 Mouse [Bluetooth 3.0 mouse] on 80:19:34:5a:67:51
Jan 10 19:39:58 laptop kernel: ------------[ cut here ]------------
Jan 10 19:39:58 laptop kernel: kernel BUG at mm/rmap.c:399!
Jan 10 19:39:58 laptop kernel: invalid opcode: 0000 [#4] PREEMPT SMP 
Jan 10 19:39:58 laptop kernel: Modules linked in: hidp iptable_filter xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack rfcomm iwlmvm mac80211 snd_hda_codec_via snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel iwlwifi cfg80211 coretemp snd_hda_controller hwmon x86_pkg_temp_thermal snd_hda_codec snd_hwdep acpi_cpufreq
Jan 10 19:39:58 laptop kernel: CPU: 4 PID: 678 Comm: X Tainted: G      D        3.19.0-rc3+ #42
Jan 10 19:39:59 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ                        , BIOS 1.03.05 02/26/2014
Jan 10 19:39:59 laptop kernel: task: ffff880409c4dd00 ti: ffff88040b910000 task.ti: ffff88040b910000
Jan 10 19:39:59 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:39:59 laptop kernel: RSP: 0018:ffff88040b913be8  EFLAGS: 00010286
Jan 10 19:39:59 laptop kernel: RAX: ffff88040b989590 RBX: ffff88040b989580 RCX: 00000000ffffffff
Jan 10 19:39:59 laptop kernel: RDX: ffffffff00000001 RSI: ffff8800da4686d0 RDI: ffff8800da468690
Jan 10 19:39:59 laptop kernel: RBP: ffff880409c81f88 R08: 0000000000000000 R09: ffff88040d801c00
Jan 10 19:39:59 laptop kernel: R10: ffff88041fb146e0 R11: ffff88040b9895a0 R12: ffff8800da468690
Jan 10 19:39:59 laptop kernel: R13: ffff880409c81f88 R14: ffff880409c81f98 R15: ffff880409c81f20
Jan 10 19:39:59 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fb00000(0000) knlGS:0000000000000000
Jan 10 19:39:59 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Jan 10 19:39:59 laptop kernel: CR2: 00000000f76f9000 CR3: 00000000017f5000 CR4: 00000000001407e0
Jan 10 19:39:59 laptop kernel: Stack:
Jan 10 19:39:59 laptop kernel:  ffff8800dad0ed18 ffff8800dad0ece0 0000000000000000 ffff880409c81f20
Jan 10 19:39:59 laptop kernel:  ffff880409c81d10 00000000f51ff000 ffff88040b913c88 0000000000000000
Jan 10 19:40:00 laptop kernel:  0000000000000000 ffffffff810e3633 ffff88040b913e50 0000000000000000
Jan 10 19:40:00 laptop kernel: Call Trace:
Jan 10 19:40:00 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
Jan 10 19:40:00 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
Jan 10 19:40:00 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
Jan 10 19:40:00 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
Jan 10 19:40:00 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
Jan 10 19:40:00 laptop kernel:  [<ffffffff81051384>] ? get_signal+0x274/0x660
Jan 10 19:40:00 laptop kernel:  [<ffffffff8100249e>] ? do_signal+0x1e/0x7c0
Jan 10 19:40:00 laptop kernel:  [<ffffffff8100da31>] ? __restore_xstate_sig+0x271/0x680
Jan 10 19:40:00 laptop kernel:  [<ffffffff810527f6>] ? compat_SyS_sigaltstack+0xc6/0x1a0
Jan 10 19:40:00 laptop kernel:  [<ffffffff81002c9d>] ? do_notify_resume+0x5d/0x80
Jan 10 19:40:00 laptop kernel:  [<ffffffff815df818>] ? int_signal+0x12/0x17
Jan 10 19:40:00 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74 54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00 
Jan 10 19:40:00 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
Jan 10 19:40:01 laptop kernel:  RSP <ffff88040b913be8>
Jan 10 19:40:01 laptop kernel: ---[ end trace 0b15d6a845b49d01 ]---
Jan 10 19:40:01 laptop kernel: Fixing recursive fault but reboot is needed!

--------------050400050004060909020503--
