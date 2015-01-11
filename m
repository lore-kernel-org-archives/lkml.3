Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbbAKPz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:55:58 -0500
Received: from ares60.inai.de ([5.9.23.85]:55498 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbbAKPz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:55:57 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2015 10:55:56 EST
Date: Sun, 11 Jan 2015 16:49:45 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Bug at 3.19-rc3:mm/rmap.c:399
Message-ID: <alpine.LSU.2.11.1501111645300.17863@nerf60.vanv.qr>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Preliminary report that Linux kernel 3.19-rc3 
[eb74926920cfa756087a82e0b081df837177cb95] gives a bug dump. When 
exiting JOSM (running on openjdk-1.7), the java process would sometimes 
get shot down. Last known good was v3.18.1.

I probably need to turn on some debuginfo… unless you 
beat me to bisecting it.


[x86_64]
[30585.603446] ------------[ cut here ]------------
[30585.603469] kernel BUG at mm/rmap.c:399!
[30585.603483] invalid opcode: 0000 [#1] PREEMPT SMP 
[30585.603502] Modules linked in: ctr ccm af_packet ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_REJECT xt_tcpudp xt_owner xt_multiport xt_conntrack iptable_filter ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack xt_mark iptable_mangle ip_tables x_tables sch_fq_codel ext4 mbcache jbd2 cdc_acm hid_generic usbhid hid arc4 snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep iwlmvm snd_pcm_oss snd_pcm mac80211 i915 snd_seq snd_seq_device i2c_algo_bit snd_timer drm_kms_helper x86_pkg_temp_thermal thinkpad_acpi intel_powerclamp e1000e iwlwifi snd_mixer_oss coretemp drm pcspkr xhci_pci i2c_i801 joydev nvram xhci_hcd ptp serio_raw intel_gtt cfg80211
[30585.603799]  i2c_core lpc_ich rtsx_pci snd pps_core agpgart thermal mfd_core shpchp tpm_tis soundcore wmi processor video tpm battery led_class thermal_sys ac button intel_smartconnect hwmon binfmt_misc efivarfs dm_crypt algif_skcipher af_alg crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel glue_helper lrw ablk_helper cryptd ehci_pci ehci_hcd usbcore usb_common xts gf128mul aes_x86_64 dm_mod sg tcp_veno sony_laptop rfkill
[30585.603969] CPU: 2 PID: 12778 Comm: java Not tainted 3.19.0-rc3+ #16
[30585.603991] Hardware name: LENOVO 20AL00C6GE/20AL00C6GE, BIOS GIET67WW (2.17 ) 01/08/2014
[30585.604019] task: ffff8800d3955190 ti: ffff8801d2a80000 task.ti: ffff8801d2a80000
[30585.604044] RIP: 0010:[<ffffffff810f2af7>]  [<ffffffff810f2af7>] unlink_anon_vmas+0xe9/0x140
[30585.604076] RSP: 0018:ffff8801d2a83b88  EFLAGS: 00010286
[30585.604094] RAX: ffff8801ed517f50 RBX: ffff8801ed517f40 RCX: ffff8801ed517f60
[30585.604118] RDX: ffffffff00000001 RSI: 0000000000000000 RDI: ffff8800d3aa96e0
[30585.604141] RBP: ffff8801d2a83bc8 R08: 00007f523d7be000 R09: ffffea0007b545c0
[30585.604165] R10: 000000000000000d R11: 0000000000015b80 R12: ffff8800b10d49c0
[30585.604188] R13: ffff8800d3aa96e0 R14: ffff8800d3aa96e0 R15: ffff8801ed517f40
[30585.604212] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
[30585.604238] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[30585.604257] CR2: 00007f524b9fa400 CR3: 0000000002a13000 CR4: 00000000001407e0
[30585.604285] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[30585.604323] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[30585.604356] Stack:
[30585.604364]  ffff88021390e900 ffff8800b10d49d0 ffff8801d2a83bc8 ffff8800b10d4958
[30585.604391]  ffff8800b10d4958 0000000000000000 00007f51fd224000 ffff8800b10d4228
[30585.604419]  ffff8801d2a83c18 ffffffff810e7e65 0000000000000000 ffff8801d2a83c28
[30585.604446] Call Trace:
[30585.604459]  [<ffffffff810e7e65>] free_pgtables+0x64/0x9d
[30585.604478]  [<ffffffff810eea35>] exit_mmap+0x78/0x111
[30585.604498]  [<ffffffff814078b5>] ? _raw_spin_unlock_irqrestore+0xe/0x22
[30585.604522]  [<ffffffff8104381d>] mmput+0x56/0xed
[30585.604539]  [<ffffffff81047c8c>] do_exit+0x383/0x8cf
[30585.604558]  [<ffffffff8104ded8>] ? __dequeue_signal+0x1a/0x113
[30585.604578]  [<ffffffff81048244>] do_group_exit+0x3f/0x95
[30585.604597]  [<ffffffff8105050b>] get_signal+0x469/0x49c
[30585.604617]  [<ffffffff810023b4>] do_signal+0x23/0x691
[30585.604635]  [<ffffffff8111c2a4>] ? path_put+0x1a/0x1e
[30585.604653]  [<ffffffff81002a49>] do_notify_resume+0x27/0x5c
[30585.604673]  [<ffffffff814081cf>] int_signal+0x12/0x17
[30585.604690] Code: 7e 08 e8 62 f4 f7 ff 49 8b 44 24 78 4c 8b 20 48 8d 58 f0 49 83 ec 10 48 8d 43 10 48 39 45 c8 74 52 48 8b 7b 08 83 7f 34 00 74 02 <0f> 0b e8 d7 fd ff ff 48 8b 43 18 48 8b 53 10 48 89 df 48 89 42 
[30585.604805] RIP  [<ffffffff810f2af7>] unlink_anon_vmas+0xe9/0x140
[30585.604826]  RSP <ffff8801d2a83b88>
[30585.613469] ---[ end trace 7bc74b6fe917230a ]---
[30585.613471] Fixing recursive fault but reboot is needed!
