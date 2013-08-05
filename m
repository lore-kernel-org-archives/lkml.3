Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3HEUbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:31:05 -0400
Received: from www17.your-server.de ([213.133.104.17]:38622 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3HEUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:31:02 -0400
Message-ID: <1375734656.2159.1.camel@localhost.localdomain>
Subject: i915_gem_unmap_dma_buf: BUG: unable to handle kernel NULL pointer
 dereference
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 05 Aug 2013 22:30:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[165517.046291] [drm] wait for urb interrupted: ffffffc2 available: 4
[165517.046454] BUG: unable to handle kernel NULL pointer dereference at 0000000000000941
[165517.047217] IP: [<ffffffffa00ddfbf>] i915_gem_unmap_dma_buf+0x2f/0x60 [i915]
[165517.047217] PGD 0 
[165517.047217] Oops: 0000 [#1] SMP 
[165517.047217] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables fuse rfcomm bnep acpi_cpufreq mperf iTCO_wdt coretemp iTCO_vendor_support snd_hda_codec_hdmi acer_wmi uvcvideo kvm_intel sparse_keymap snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_usb_audio kvm snd_usbmidi_lib snd_rawmidi arc4 snd_hwdep snd_seq snd_seq_device iwldvm snd_pcm acerhdf microcode serio_raw i2c_i801 btusb snd_page_alloc bluetooth mac80211 videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media asix snd_timer lpc_ich usbnet mfd_core iwlwifi
[165517.047217]  mii snd soundcore cfg80211 rfkill atl1c wmi nfsd uinput auth_rpcgss nfs_acl lockd sunrpc binfmt_misc dm_crypt udl drm_usb i915 i2c_algo_bit drm_kms_helper usb_storage drm i2c_core video [last unloaded: iptable_mangle]
[165517.047217] CPU: 0 PID: 710 Comm: Xorg Tainted: G          I  3.10.3-300.fc19.x86_64 #1
[165517.047217] Hardware name: Acer Aspire 1810T/JM11-MS, BIOS v1.3310 03/25/2010
[165517.047217] task: ffff8801211c16e0 ti: ffff88011ae8c000 task.ti: ffff88011ae8c000
[165517.047217] RIP: 0010:[<ffffffffa00ddfbf>]  [<ffffffffa00ddfbf>] i915_gem_unmap_dma_buf+0x2f/0x60 [i915]
[165517.047217] RSP: 0018:ffff88011ae8dca8  EFLAGS: 00010293
[165517.047217] RAX: 0000000000000909 RBX: ffff880139755290 RCX: 0000000000000000
[165517.047217] RDX: 0000000000000300 RSI: ffff88010a074000 RDI: ffff880137bcf030
[165517.047217] RBP: ffff88011ae8dcb0 R08: 0000000000000000 R09: 0000000000000000
[165517.047217] R10: ffffffff81ce9e10 R11: ffff88011ae8d90e R12: ffff880139755290
[165517.047217] R13: 0000000000000000 R14: 0000000000000003 R15: ffff88011ae8dd70
[165517.047217] FS:  00007fcd480e9980(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[165517.047217] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[165517.047217] CR2: 0000000000000941 CR3: 0000000001c0c000 CR4: 00000000000407f0
[165517.047217] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[165517.047217] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[165517.047217] Stack:
[165517.047217]  ffff880138c8bd40 ffff88011ae8dcd8 ffffffff813e93fe ffff880138c8bd40
[165517.047217]  ffff880137094020 ffff880137094000 ffff88011ae8dcf8 ffffffffa0036592
[165517.047217]  ffff88012133ee40 ffff880137094020 ffff88011ae8dd10 ffffffffa013a985
[165517.047217] Call Trace:
[165517.047217]  [<ffffffff813e93fe>] dma_buf_unmap_attachment+0x3e/0x60
[165517.047217]  [<ffffffffa0036592>] drm_prime_gem_destroy+0x22/0x40 [drm]
[165517.047217]  [<ffffffffa013a985>] udl_gem_free_object+0x35/0x60 [udl]
[165517.047217]  [<ffffffffa002085a>] drm_gem_object_free+0x2a/0x30 [drm]
[165517.047217]  [<ffffffffa0020d6e>] drm_gem_object_release_handle+0xae/0xd0 [drm]
[165517.047217]  [<ffffffff812e5f94>] idr_for_each+0xa4/0xf0
[165517.047217]  [<ffffffffa0020cc0>] ? drm_gem_handle_delete+0x150/0x150 [drm]
[165517.047217]  [<ffffffffa0021550>] drm_gem_release+0x20/0x30 [drm]
[165517.047217]  [<ffffffffa001fc91>] drm_release+0x551/0x5d0 [drm]
[165517.047217]  [<ffffffff81199101>] __fput+0xe1/0x230
[165517.047217]  [<ffffffff8119930e>] ____fput+0xe/0x10
[165517.047217]  [<ffffffff8107d77c>] task_work_run+0xbc/0xe0
[165517.047217]  [<ffffffff81061bbc>] do_exit+0x2bc/0xa20
[165517.047217]  [<ffffffff8119930e>] ? ____fput+0xe/0x10
[165517.047217]  [<ffffffff8107d764>] ? task_work_run+0xa4/0xe0
[165517.047217]  [<ffffffff8106239f>] do_group_exit+0x3f/0xa0
[165517.047217]  [<ffffffff81062414>] SyS_exit_group+0x14/0x20
[165517.047217]  [<ffffffff81651819>] system_call_fastpath+0x16/0x1b
[165517.047217] Code: 90 55 89 d1 48 89 e5 53 48 8b 7f 08 48 89 f3 8b 56 08 48 8b 36 48 85 ff 74 32 48 8b 87 08 02 00 00 48 85 c0 74 26 83 f9 02 77 2a <48> 8b 40 38 48 85 c0 74 05 45 31 c0 ff d0 48 89 df e8 8b 7b 21 
[165517.047217] RIP  [<ffffffffa00ddfbf>] i915_gem_unmap_dma_buf+0x2f/0x60 [i915]
[165517.047217]  RSP <ffff88011ae8dca8>
[165517.047217] CR2: 0000000000000941
[165517.272860] ---[ end trace f4c350a8f34ab706 ]---
[165517.276318] Fixing recursive fault but reboot is needed!

