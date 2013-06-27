Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3F0RBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:01:05 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:42752 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3F0RBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:01:01 -0400
X-ASG-Debug-ID: 1372352460-0421b5021f95c50001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Thu, 27 Jun 2013 13:00:58 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Dave Jones <davej@redhat.com>, Chris Mason <chris.mason@fusionio.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs triggered lockdep WARN.
Message-ID: <20130627170058.GS4288@localhost.localdomain>
X-ASG-Orig-Subj: Re: btrfs triggered lockdep WARN.
References: <20130627145824.GA21540@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130627145824.GA21540@redhat.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1372352460
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.135132
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:58:24AM -0400, Dave Jones wrote:
> Another bug caused by this script. https://github.com/kernelslacker/io-tests/blob/master/setup.sh
> 
> WARNING: at kernel/lockdep.c:708 __lock_acquire+0x183b/0x1b70()
> Modules linked in: sctp lec bridge 8021q garp stp mrp fuse dlci tun bnep hidp rfcomm l2tp_ppp l2tp_netlink l2tp_core vmw_vsock_vmci_transport vmw_vmci vsock cmtp kernelcapi nfnetlink ipt_ULOG scsi_transport_iscsi rose phonet rds irda nfc ipx p8023 p8022 netrom af_key can_raw ax25 llc2 af_802154 x25 pppoe caif_socket pppox can_bcm caif ppp_generic slhc crc_ccitt atm appletalk af_rxrpc psnap llc can btrfs kvm_amd kvm snd_hda_codec_realtek snd_hda_intel btusb snd_hda_codec xor bluetooth raid6_pq serio_raw snd_pcm microcode pcspkr libcrc32c zlib_deflate snd_page_alloc snd_timer snd rfkill edac_core soundcore r8169 mii sr_mod cdrom pata_atiixp radeon backlight drm_kms_helper ttm
> CPU: 3 PID: 2340684 Comm: rm Not tainted 3.10.0-rc7+ #8 
> Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
>  ffffffff819fb83b ffff88010a751aa0 ffffffff816aed7b ffff88010a751ad8
>  ffffffff810432b0 0000000000000002 ffffffff8253e3d0 ffff88002e1a9810
>  00017ee5aac67d60 0000000000000000 ffff88010a751ae8 ffffffff8104339a
> Call Trace:
>  [<ffffffff816aed7b>] dump_stack+0x19/0x1b
>  [<ffffffff810432b0>] warn_slowpath_common+0x70/0xa0
>  [<ffffffff8104339a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff810ba40b>] __lock_acquire+0x183b/0x1b70
>  [<ffffffff81333bd0>] ? delay_tsc+0x90/0xe0
>  [<ffffffff810baee3>] lock_acquire+0x93/0x1e0
>  [<ffffffffa040f937>] ? btrfs_try_tree_write_lock+0x47/0xc0 [btrfs]
>  [<ffffffff816b6c11>] _raw_write_lock+0x41/0x80
>  [<ffffffffa040f937>] ? btrfs_try_tree_write_lock+0x47/0xc0 [btrfs]
>  [<ffffffffa040f937>] btrfs_try_tree_write_lock+0x47/0xc0 [btrfs]
>  [<ffffffffa03b4bad>] btrfs_search_slot+0x80d/0x950 [btrfs]
>  [<ffffffffa03cd3a6>] btrfs_del_inode_ref+0x76/0x3b0 [btrfs]
>  [<ffffffffa03f3469>] ? release_extent_buffer+0xb9/0xe0 [btrfs]
>  [<ffffffffa03f9aaf>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
>  [<ffffffffa03e0091>] __btrfs_unlink_inode+0x181/0x390 [btrfs]
>  [<ffffffffa03e2e17>] btrfs_unlink_inode+0x27/0x50 [btrfs]
>  [<ffffffffa03e2ead>] btrfs_unlink+0x6d/0xc0 [btrfs]
>  [<ffffffff811bfb60>] vfs_unlink+0xa0/0x110
>  [<ffffffff811bfd47>] do_unlinkat+0x177/0x230
>  [<ffffffff810b8815>] ? trace_hardirqs_on_caller+0x115/0x1e0
>  [<ffffffff810b88ed>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8100f525>] ? syscall_trace_enter+0x25/0x290
>  [<ffffffff811c274b>] SyS_unlinkat+0x1b/0x40
>  [<ffffffff816bf394>] tracesys+0xdd/0xe2
> ---[ end trace 9d90045eda25c268 ]---
> 
> That WARN is..
> 
>  704                         /*
>  705                          * Huh! same key, different name? Did someone trample
>  706                          * on some memory? We're most confused.
>  707                          */
>  708                         WARN_ON_ONCE(class->name != lock->name);
> 
> 
> Most confusing indeed.

There is a bugzilla opened for this, could you try the patch that's in the bz
and see if you still hit it?

https://bugzilla.kernel.org/show_bug.cgi?id=59061

Thanks,

Josef
