Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3IWCaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:30:11 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63643 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3IWCaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:30:10 -0400
MIME-Version: 1.0
Date: Sun, 22 Sep 2013 22:30:08 -0400
Message-ID: <CAHFgRy86OnOTorc8FPza4Vk4bnQL-J4JZho-GL2HZV=nCfYDRw@mail.gmail.com>
Subject: Linus GIT - kernel BUG at include/linux/scatterlist.h:115! CPU: 1
 PID: 1203 Comm: apparmor_parser Not tainted 3.12.0-rc1+
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   27.190017] kernel BUG at include/linux/scatterlist.h:115!
[   27.190017] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   27.190017] Modules linked in: mxm_wmi iwldvm mac80211 iwlwifi
cfg80211 snd_hda_intel(+) snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss hwmon snd_pcm ttm snd_seq_dummy snd_page_alloc
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_timer
i915(+) snd i2c_algo_bit drm_kms_helper wmi ac drm soundcore evdev
mac_hid i2c_core battery acpi_cpufreq ehci_pci(+) ehci_hcd asus_laptop
rfkill intel_agp intel_gtt agpgart processor sr_mod cdrom atl1c
uhci_hcd thermal
[   27.190017] CPU: 1 PID: 1203 Comm: apparmor_parser Not tainted 3.12.0-rc1+ #8
[   27.190017] Hardware name: ASUSTeK Computer Inc.         UL50VT
         /UL50VT    , BIOS 217     03/01/2010
[   27.190017] task: ffff8800bd99ea80 ti: ffff8800baf5a000 task.ti:
ffff8800baf5a000
[   27.190017] RIP: 0010:[<ffffffff811f9e71>]  [<ffffffff811f9e71>]
sg_set_buf+0x20/0x7e
[   27.190017] RSP: 0018:ffff8800baf5bcf8  EFLAGS: 00010246
[   27.190017] RAX: 0000000000000000 RBX: ffff8800baf5bd70 RCX: 0000000000000024
[   27.190017] RDX: 0000000000000410 RSI: ffffc900108ca010 RDI: 00004100108ca010
[   27.190017] RBP: ffff8800baf5bd18 R08: ffff880138eec290 R09: 0000000000000000
[   27.190017] R10: ffff880138ee2148 R11: 0000000000000e12 R12: ffffc900108ca010
[   27.190017] R13: 0000000000008649 R14: ffffc900108ca010 R15: ffff880138ee0000
[   27.190017] FS:  00007f96aaf6c740(0000) GS:ffff88013f300000(0000)
knlGS:0000000000000000
[   27.190017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.190017] CR2: 00007f96aaf5d00f CR3: 00000000b9e7a000 CR4: 00000000000407e0
[   27.190017] Stack:
[   27.190017]  ffff8800b9d55520 ffff8800baf5bd70 0000000000008649
ffffc900108ca010
[   27.190017]  ffff8800baf5bdb8 ffffffff811f9f50 ffffffff811f3eef
0000000538ee8000
[   27.190017]  ffff880138c42000 ffff880000000000 0000000087654321
ffffea0002ebd6c0
[   27.190017] Call Trace:
[   27.190017]  [<ffffffff811f9f50>] aa_calc_profile_hash+0x75/0x11d
[   27.190017]  [<ffffffff811f3eef>] ? __aa_kvmalloc+0x39/0x51
[   27.190017]  [<ffffffff811f7e34>] aa_unpack+0x929/0x969
[   27.190017]  [<ffffffff811f6a21>] aa_replace_profiles+0x38/0x57c
[   27.190017]  [<ffffffff811f249b>] profile_replace+0x35/0x4c
[   27.190017]  [<ffffffff81121477>] vfs_write+0xad/0x113
[   27.190017]  [<ffffffff81121add>] SyS_write+0x44/0x7a
[   27.190017]  [<ffffffff8145f3e2>] system_call_fastpath+0x16/0x1b
[   27.190017] Code: 66 89 45 fc e8 6a fc ff ff c9 c3 55 48 89 e5 41
56 41 55 41 89 d5 41 54 49 89 f4 53 48 89 fb 48 89 f7 e8 1b 9e e3 ff
84 c0 75 02 <0f> 0b 4c 89 e7 45 89 e6 e8 96 9e e3 ff 48 8b 53 08 41 81
e6 ff
[   27.190017] RIP  [<ffffffff811f9e71>] sg_set_buf+0x20/0x7e
[   27.190017]  RSP <ffff8800baf5bcf8>
