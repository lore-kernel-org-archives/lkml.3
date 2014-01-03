Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaACIjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 03:39:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaACIjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 03:39:49 -0500
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [BUG] Kernel OOPS when reboot if I set reboot=efi,{warm, cold} (and some questions :-)
Date: Fri, 03 Jan 2014 16:39:38 +0800
Message-ID: <8738l5zcfp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy Folks,
  Happy new yeah, happy new bug!
  With a uefi system, I meet following panic when reboot after I adding
  `reboot=efi,warm`
[call trace]:
<0>[  698.736637] reboot: Restarting system
<5>[  698.737407] reboot: machine restart
<1>[  698.738399] BUG: unable to handle kernel paging request at 00000000ded53e60
<1>[  698.738924] IP: [<ffff8800dedb946d>] 0xffff8800dedb946d
<4>[  698.739408] PGD 0 
<4>[  698.739868] Oops: 0000 [#1] SMP 
<4>[  698.740316] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT ipt_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg vfat fat snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel arc4 ath9k snd_hda_codec snd_hwdep ath9k_common ath9k_hw snd_seq snd_seq_device ath3k ath snd_pcm snd_page_alloc mac80211 btusb cfg80211 r8169 snd_timer bluetooth snd rfkill mii soundcore shpchp iTCO_wdt iTCO_vendor_support lpc_ich mfd_core pcspkr microcode dcdbas i2c_i801Panic#2 Part2
<4>[  698.743245]  serio_raw i2c_core video xfs libcrc32c usb_storage sd_mod crc_t10dif crct10dif_common ahci libahci libata dm_mirror dm_region_hash dm_log dm_mod
<4>[  698.744276] CPU: 0 PID: 1939 Comm: reboot Not tainted 3.13.0-rc6+ #10
<4>[  698.744793] Hardware name: Dell Inc. XPS 8500  /0NW73C, BIOS A09 09/05/2012
<4>[  698.745314] task: ffff8800db6fbe30 ti: ffff88003eb86000 task.ti: ffff88003eb86000
<4>[  698.745850] RIP: 0010:[<ffff8800dedb946d>]  [<ffff8800dedb946d>] 0xffff8800dedb946d
<4>[  698.746394] RSP: 0018:ffff88003eb87cb0  EFLAGS: 00010046
<4>[  698.746937] RAX: 00000000ded53e18 RBX: 0000000000000000 RCX: ffff8800dedb9a80
<4>[  698.747494] RDX: ffff8800dedb9c50 RSI: 0000000000000000 RDI: ffff8800dedb9428
<4>[  698.748055] RBP: 0000000000000001 R08: 0000000000000000 R09: ffff88003eb87ce0
<4>[  698.748619] R10: ffffffff81a082c0 R11: ffff88003eb87cf8 R12: 0000000028121969
<4>[  698.749190] R13: 00000000fffffffe R14: 0000000000000cf9 R15: 0000000000000000
<4>[  698.749771] FS:  00007f16f206c880(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
<4>[  698.750364] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  698.750963] CR2: 00000000ded53e60 CR3: 000000003e2d6000 CR4: 00000000001407f0
Panic#2 Part1
<4>[  698.751572] Stack:
<4>[  698.752182]  ffffffff81a082c0 ffff88003eb87d50 0000000000000082 ffffc9000a27fff8
<4>[  698.752816]  ffff88003eb87d00 0000000000000411 0000000000000001 0000000000010000
<4>[  698.753455]  ffff8800dedb9428 ffffffff8105c556 000000004c564c54 0000000000000000
<4>[  698.754097] Call Trace:
<4>[  698.754740]  [<ffffffff8105c556>] ? efi_call4+0x46/0x80
<4>[  698.755398]  [<ffffffff8105bc5c>] ? virt_efi_reset_system+0x2c/0x30
<4>[  698.756062]  [<ffffffff8103f8d5>] ? native_machine_emergency_restart+0x1a5/0x270
<4>[  698.756731]  [<ffffffff810491f0>] ? native_apic_msr_write+0x30/0x40
<4>[  698.757399]  [<ffffffff8104357b>] ? disable_local_APIC+0x4b/0x50
<4>[  698.758059]  [<ffffffff8103f427>] ? native_machine_restart+0x37/0x40
<4>[  698.758719]  [<ffffffff8103f62f>] ? machine_restart+0xf/0x20
<4>[  698.759379]  [<ffffffff8108e865>] ? kernel_restart+0x45/0x60
<4>[  698.760034]  [<ffffffff8108eba9>] ? SYSC_reboot+0x229/0x260
<4>[  698.760685]  [<ffffffff811b5ee9>] ? do_readv_writev+0x169/0x220
<4>[  698.761331]  [<ffffffff811b6c5e>] ? __fput+0x17e/0x260
<4>[  698.761972]  [<ffffffff811b6d8e>] ? ____fput+0xe/0x10
<4>[  698.762609]  [<ffffffff8108ec7e>] ? SyS_reboot+0xe/0x10
<4>[  698.763242]  [<ffffffff815e87e9>] ? system_call_fastpath+0x16/0x1b
<4>[  698.763876] Code: 4d 8d 4b e8 49 89 43 d8 48 8b 05 47 08 00 00 48 8d 15 f8 07 00 00 48 8d 0d 21 06 00 00 bd 01 00 00 00 45 33 c0 49 89 6b e8 33 f6 <ff> 50 48 48 3b c6 40 0f b6 fe 0f 4d fd e8 bd 05 00 00 40 3a c6 
<1>[  698.765285] RIP  [<ffff8800dedb946d>] 0xffff8800dedb946d
<4>[  698.765972]  RSP <ffff88003eb87cb0>
<4>[  698.766647] CR2: 00000000ded53e60
<4>[  698.768462] ---[ end trace b97908aef93ab59d ]---
<0>[  702.809043] Kernel panic - not syncing: Fatal exception


According to Call Trace, the panic happen when call ResetSystem() which
is a uefi run time service. It's seems a asm code in efi_stub_64.S
I disassembly it with crash got following outputs:
crash> dis efi_call4
0xffffffff810518f0 <efi_call4>: mov    %rsp,%rax
[ ... ]
0xffffffff81051918 <efi_call4+40>:      movaps %xmm3,0x30(%rsp)
0xffffffff8105191d <efi_call4+45>:      movaps %xmm4,0x20(%rsp)
0xffffffff81051922 <efi_call4+50>:      movaps %xmm5,0x10(%rsp)
0xffffffff81051927 <efi_call4+55>:      sub    $0x20,%rsp
[ ... ]

So it seems the panic happen when SAVE_XMM? Does SAVE_XMM will trigger
paging? (`unable to handle kernel paging request at 00000000ded53e60`)

in case it's a hardware special issue: My testbed is a DELL xps x8500
And I'll try to test it on another uefi system.
--
Best,
Madper
