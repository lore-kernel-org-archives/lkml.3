Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab3CGGCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:02:04 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49075 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab3CGGCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:02:02 -0500
X-Sasl-enc: +6iD/WldGhTJeGzNWLw2kmrE4XzVuduX5S8lXlLoT9B/ 1362636118
Date: Thu, 7 Mar 2013 14:02:30 +0800
From: Greg Kroah-Hartman <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
Message-ID: <20130307060230.GA31738@kroah.com>
References: <20130307052854.GA23745@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307052854.GA23745@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 12:28:54AM -0500, Dave Jones wrote:
> general protection fault: 0000 [#1] PREEMPT SMP 
> Modules linked in: vmw_vsock_vmci_transport vmw_vmci vsock bnep fuse rfcomm hidp l2tp_ppp l2tp_core 8021q garp mrp dlci pppoe pppox ppp_generic slhc scsi_transport_iscsi rose caif_socket caif can_raw bridge af_key can_bcm llc2 stp can netrom phonet af_rxrpc nfnetlink ipt_ULOG x25 rds irda crc_ccitt ax25 ipx p8023 p8022 decnet atm appletalk psnap llc nfc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm btusb snd_page_alloc bluetooth snd_timer snd microcode rfkill usb_debug serio_raw pcspkr edac_core soundcore vhost_net tun r8169 macvtap macvlan mii kvm_amd kvm
> CPU 0 
> Pid: 23476, comm: trinity-child1 Not tainted 3.9.0-rc1+ #69 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
> RIP: 0010:[<ffffffff812356b7>]  [<ffffffff812356b7>] sysfs_find_dirent+0x47/0xf0
> RSP: 0018:ffff88000585bd68  EFLAGS: 00010202
> RAX: 0000000094be55f6 RBX: 6b6b6b6b6b6b6b6b RCX: 000000006b6b6b6b
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff88000585bd88 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 000000000029c161
> R13: ffff8800a8918288 R14: 0000000000000000 R15: 0000000000000009
> FS:  00007fa12651e740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000010 CR3: 000000001a128000 CR4: 00000000000007f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process trinity-child1 (pid: 23476, threadinfo ffff88000585a000, task ffff8800cd454920)
> Stack:
>  ffff880128edc1e8 ffff8800a8918250 fffffffffffffffe ffff88012265f430
>  ffff88000585bdb8 ffffffff812357cd ffff8800a8918250 ffff8801226514d0
>  ffff88000585bf38 0000000000000000 ffff88000585bde8 ffffffff811bb30d
> Call Trace:
>  [<ffffffff812357cd>] sysfs_lookup+0x6d/0xe0
>  [<ffffffff811bb30d>] lookup_real+0x1d/0x60
>  [<ffffffff811bb528>] __lookup_hash+0x38/0x50
>  [<ffffffff811bb559>] lookup_hash+0x19/0x20
>  [<ffffffff811be993>] kern_path_create+0x93/0x170
>  [<ffffffff811bce46>] ? getname_flags.part.32+0x86/0x150
>  [<ffffffff811beaba>] user_path_create+0x4a/0x70
>  [<ffffffff811c1a09>] sys_mkdirat+0x39/0xe0
>  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
> Code: 00 48 8b 9f 88 00 00 00 f6 c4 0f 0f 95 c0 48 85 f6 0f 95 c2 38 d0 75 79 4c 89 ee 4c 89 f7 e8 91 ef ff ff 41 89 c4 48 85 db 74 1d <8b> 4b 28 41 39 cc 74 21 44 89 e0 29 c8 83 f8 00 7c 2c 74 45 48 
> RIP  [<ffffffff812356b7>] sysfs_find_dirent+0x47/0xf0
>  RSP <ffff88000585bd68>
> ---[ end trace 4ba97703eaafbb8b ]---

Any hint as to what was happening here when this crashed?

thanks,

greg k-h
