Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaEUF5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:57:38 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34934 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaEUF5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:57:36 -0400
MIME-Version: 1.0
Date: Tue, 20 May 2014 22:57:35 -0700
Message-ID: <CAKx2Y1mzLesGFYz30fH8xCZTkvNGPUNYkHptYLYq_hVExoh_8g@mail.gmail.com>
Subject: rmmod thermal, unable to handle kernel NULL pointer dereference
From: Kui Zhang <kuizhang@gmail.com>
To: aaron.lu@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get following error when rmmod thermal.

rmmod  thermal
Killed

[ 1207.313060] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[ 1207.313460] IP: [<ffffffff816bb906>] _raw_spin_lock_irq+0x6/0x30
[ 1207.313858] PGD 0
[ 1207.314256] Oops: 0002 [#1] SMP
[ 1207.314658] Modules linked in: thermal(-) ntfs vfat msdos fat cpuid
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat ipt_REJECT xt_CHECKSUM
iptable_mangle xt_tcpudp bridge stp target_core_mod configfs
ebtable_nat ebtables drbd lru_cache scsi_transport_iscsi xt_conntrack
ip6table_filter ip6_tables iptable_filter ip_tables nf_conntrack_ipv4
nf_defrag_ipv4 xt_state x_tables nf_conntrack dm_multipath dm_mod arc4
tifm_7xx1 coretemp tifm_core hwmon iwl3945 iwlegacy mac80211 cfg80211
tpm_infineon tpm fuse snd_hda_intel snd_hda_controller
snd_hda_codec_idt snd_hda_codec_generic snd_hda_codec snd_hwdep
snd_pcm snd_timer snd soundcore usb_storage raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor xor async_tx
raid6_pq raid1 raid0 multipath linear md_mod sky2 firewire_ohci sr_mod
cdrom firewire_core crc_itu_t uhci_hcd [last unloaded: thermal]
[ 1207.316991] CPU: 1 PID: 22792 Comm: rmmod Tainted: G        W
3.15.0-rc5+ #2
[ 1207.316991] task: ffff88006e712100 ti: ffff880075c28000 task.ti:
ffff880075c28000
[ 1207.316991] RIP: 0010:[<ffffffff816bb906>]  [<ffffffff816bb906>]
_raw_spin_lock_irq+0x6/0x30
[ 1207.316991] RSP: 0018:ffff880075c29da8  EFLAGS: 00010006
[ 1207.316991] RAX: 0000000000000100 RBX: ffff88006e414990 RCX: 0000000000000002
[ 1207.316991] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 0000000000000000
[ 1207.316991] RBP: 0000000000000001 R08: 0000000000016280 R09: ffff8800c7b16280
[ 1207.316991] R10: ffffffff8135a910 R11: ffffea0003062240 R12: 0000000000000002
[ 1207.316991] R13: 0000000000000001 R14: ffff88006e415e00 R15: 0000000000000000
[ 1207.316991] FS:  00007f265711f740(0000) GS:ffff8800c7b00000(0000)
knlGS:0000000000000000
[ 1207.316991] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1207.316991] CR2: 0000000000000000 CR3: 000000008aecd000 CR4: 00000000000007e0
[ 1207.316991] Stack:
[ 1207.316991]  ffffffff8109152b 00ff8800c2e2d670 ffff88006e414a00
ffff88006e415e00
[ 1207.316991]  ffff880075c29e90 ffff88006e415e70 ffff88006e415e20
0000000000000002
[ 1207.316991]  ffff880075c29e20 ffffffff810917b7 ffff880075c29e28
0000000000000000
[ 1207.316991] Call Trace:
[ 1207.316991]  [<ffffffff8109152b>] ? flush_workqueue_prep_pwqs+0x5b/0x180
[ 1207.316991]  [<ffffffff810917b7>] ? flush_workqueue+0x167/0x5a0
[ 1207.316991]  [<ffffffff81350000>] ? fbcon_switch+0x570/0x580
[ 1207.316991]  [<ffffffff81350000>] ? fbcon_switch+0x570/0x580
[ 1207.316991]  [<ffffffffa0506a38>] ? acpi_thermal_remove+0x23/0x94 [thermal]
[ 1207.316991]  [<ffffffff8135ccfd>] ? acpi_device_remove+0x74/0x91
[ 1207.316991]  [<ffffffff8150df65>] ? __device_release_driver+0x75/0xf0
[ 1207.316991]  [<ffffffff8150e690>] ? driver_detach+0xa0/0xb0
[ 1207.316991]  [<ffffffff8150dc13>] ? bus_remove_driver+0x43/0xa0
[ 1207.316991]  [<ffffffff810da6db>] ? SyS_delete_module+0x11b/0x1a0
[ 1207.316991]  [<ffffffff816bc600>] ? tracesys+0x7e/0xe6
[ 1207.316991]  [<ffffffff816bc663>] ? tracesys+0xe1/0xe6
[ 1207.316991] Code: 0f 1f 44 00 00 8d 8a 00 01 00 00 89 d0 f0 66 0f
b1 0f 66 39 d0 75 e5 b8 01 00 00 00 c3 0f 1f 84 00 00 00 00 00 fa b8
00 01 00 00 <f0> 66 0f c1 07 0f b6 d4 38 c2 75 03 c3 f3 90 0f b6 07 38
d0 75
[ 1207.316991] RIP  [<ffffffff816bb906>] _raw_spin_lock_irq+0x6/0x30
[ 1207.316991]  RSP <ffff880075c29da8>
[ 1207.316991] CR2: 0000000000000000
[ 1207.316991] ---[ end trace 45b9cde975015a9d ]---


when try again:

rmmod thermal
rmmod: ERROR: ../libkmod/libkmod-module.c:764
kmod_module_remove_module() could not remove 'thermal': Device or
resource busy
rmmod: ERROR: could not remove module thermal: Device or resource busy


The problem seem to have started after: commit
a59ffb2062df3a5c346dbed931fa1e587fd0f0f3


Thanks
Kui.Z
