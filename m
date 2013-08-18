Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3HROjC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 10:39:02 -0400
Received: from gw1.transmode.se ([195.58.98.146]:59327 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab3HROjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 10:39:00 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Aug 2013 10:39:00 EDT
MIME-Version: 1.0
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: 
References: 
Subject: High load which eventually leads to lockup
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
To: linux-kernel@vger.kernel.org
Message-ID: <OF4D0C0FB6.A839872C-ONC1257BCB.004FDEBA-C1257BCB.004FDEBC@transmode.se>
Date: Sun, 18 Aug 2013 16:32:23 +0200
X-Mailer: Lotus Domino Web Server Release 8.5.3FP1 March 07, 2012
X-MIMETrack: Serialize by Notes Server on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 18/08/2013 16:32:23,
	Serialize complete at 18/08/2013 16:32:23,
	Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 18/08/2013 16:32:23
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last week I have had 4 lockups which required power on/off.
Before getting there I noticed that the machine was getting slow.

top reported high load(5-10) but there was no process consuming CPU except
for migration/0 which were spicing 100% on and off. 
Ping times went up with a factor of 40 too.

Eventually I got a few entries in the kernel log:
Aug 16 12:40:51 gentoo-jocke kernel: Modules linked in: nfnetlink_log nfnetlink bluetooth rfkill sg isofs ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp ip6table_filter ip6_tables iptable_filter ip_tables ebtables x_tables autofs4 nfsd dm_crypt vboxnetadp(O) vboxnetflt(O) vboxdrv(O) usbhid dm_mod kvm_intel kvm snd_hda_codec_hdmi aesni_intel ablk_helper cryptd xts lrw gf128mul snd_hda_codec_realtek ehci_pci ehci_hcd usbcore snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd microcode usb_common radeon e1000e ttm firmware_class ptp pps_core pcspkr
Aug 16 12:40:51 gentoo-jocke kernel: CPU 0 
Aug 16 12:40:51 gentoo-jocke kernel: Pid: 2421, comm: X Tainted: G           O 3.9.11 #1 Hewlett-Packard HP Compaq 8200 Elite CMT PC/1494
Aug 16 12:40:51 gentoo-jocke kernel: RIP: 0010:[<ffffffff815f37e8>]  [<ffffffff815f37e8>] _raw_spin_unlock_irqrestore+0x8/0x10
Aug 16 12:40:51 gentoo-jocke kernel: RSP: 0018:ffff880316aa78c0  EFLAGS: 00000257
Aug 16 12:40:51 gentoo-jocke kernel: RAX: ffff88029afe7040 RBX: 0000000000000001 RCX: ffff88029be89f80
Aug 16 12:40:51 gentoo-jocke kernel: RDX: ffff88031b530200 RSI: 0000000000000257 RDI: 0000000000000257
Aug 16 12:40:51 gentoo-jocke kernel: RBP: ffff88031c2365a8 R08: ffff88031b530201 R09: ffffffff814a7af7
Aug 16 12:40:51 gentoo-jocke kernel: R10: 00000000002992d3 R11: 0000000007fdde90 R12: ffff88032dff0c00
Aug 16 12:40:51 gentoo-jocke kernel: R13: 0000000007fde124 R14: 0000000100400040 R15: 0000000000000009
Aug 16 12:40:51 gentoo-jocke kernel: FS:  00007fdbf897a880(0000) GS:ffff88032dc00000(0000) knlGS:0000000000000000
Aug 16 12:40:51 gentoo-jocke kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 16 12:40:51 gentoo-jocke kernel: CR2: 00000000081341f0 CR3: 00000003168d2000 CR4: 00000000000407f0
Aug 16 12:40:51 gentoo-jocke kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 16 12:40:51 gentoo-jocke kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 16 12:40:51 gentoo-jocke kernel: Process X (pid: 2421, threadinfo ffff880316aa6000, task ffff88031c7e3b10)
Aug 16 12:40:51 gentoo-jocke kernel: Stack:
Aug 16 12:40:51 gentoo-jocke kernel: ffffffff814a7a47 0000000000000001 0000000007fdde8e 00000000000fffff
Aug 16 12:40:51 gentoo-jocke kernel: 00000000000fffff 0000000000000000 0000000000000257 0000000007fde5d2
Aug 16 12:40:51 gentoo-jocke kernel: ffff88029afe7040 0000000000000001 0000007ffffff000 0000000000000001
Aug 16 12:40:51 gentoo-jocke kernel: Call Trace:
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff814a7a47>] ? alloc_iova+0x197/0x270
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff814aa8b3>] ? intel_alloc_iova+0x73/0xf0
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff814ac4bf>] ? __intel_map_single+0x9f/0x1c0
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa009d457>] ? radeon_ttm_tt_populate+0x107/0x2a0 [radeon]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa0075ebf>] ? ttm_tt_bind+0x2f/0x60 [ttm]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa0077ecf>] ? ttm_bo_handle_move_mem+0x5bf/0x660 [ttm]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa007da7a>] ? ttm_bo_man_get_node+0x8a/0xc0 [ttm]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa0078426>] ? ttm_mem_evict_first+0x136/0x180 [ttm]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa0078bea>] ? ttm_bo_mem_space+0x2da/0x3e0 [ttm]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff81108a75>] ? kmem_cache_alloc+0x145/0x180
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa0078e1c>] ? ttm_bo_move_buffer+0x12c/0x140 [ttm]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa0078eb8>] ? ttm_bo_validate+0x88/0x100 [ttm]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa0079210>] ? ttm_bo_init+0x2e0/0x3d0 [ttm]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa009e010>] ? radeon_bo_create+0x190/0x200 [radeon]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa009dce0>] ? radeon_bo_clear_va+0x40/0x40 [radeon]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa00b0925>] ? radeon_gem_object_create+0xa5/0x160 [radeon]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff81066823>] ? __wake_up+0x43/0x70
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa00b0d3d>] ? radeon_gem_create_ioctl+0x6d/0x140 [radeon]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa00b1034>] ? radeon_gem_busy_ioctl+0x94/0x120 [radeon]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff8137591c>] ? drm_ioctl+0x44c/0x4f0
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffffa00b0cd0>] ? radeon_gem_pwrite_ioctl+0x30/0x30 [radeon]
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff81107f31>] ? kmem_cache_free+0x171/0x190
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff81130650>] ? d_kill+0xf0/0x140
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff8112c280>] ? do_vfs_ioctl+0x90/0x540
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff81138016>] ? mnt_get_count+0x46/0x60
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff810655d5>] ? lg_global_unlock+0x45/0x60
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff8105b4ac>] ? task_work_run+0x9c/0xd0
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff8112c7d0>] ? sys_ioctl+0xa0/0xc0
Aug 16 12:40:51 gentoo-jocke kernel: [<ffffffff815f4469>] ? system_call_fastpath+0x16/0x1b
Aug 16 12:40:51 gentoo-jocke kernel: Code: 66 0f c1 07 0f b6 d4 38 c2 74 11 0f 1f 84 00 00 00 00 00 f3 90 0f b6 07 38 d0 75 f7 c3 66 0f 1f 44 00 00 80 07 01 48 89 f7 57 9d <66> 66 90 66 90 c3 66 90 ba ff ff ff ff f0 0f c1 17 83 ea 01 b8 


First I was running kernel 3.9.5, then 3.9.11 and now I am at 3.10.7
running up to date gentoo, gnome2 and I have 2 monitors. 
Got no idea where this is coming from.
 
Jocke