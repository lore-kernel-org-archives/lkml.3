Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbaGQPTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:19:23 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48727 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaGQPTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:19:20 -0400
Message-ID: <53C7E974.7080001@gmail.com>
Date: Thu, 17 Jul 2014 18:19:16 +0300
From: Timofey Titovets <nefelim4ag@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: minchan@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH v2] zram: auto add/del devices on demand
References: <53C7C131.1060306@gmail.com> <20140717140440.GA1275@swordfish> <53C7DADC.3060508@redhat.com>
In-Reply-To: <53C7DADC.3060508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/17/2014 05:17 PM, Jerome Marchand wrote:
> Looks like it:
>
> $ cat conctest.sh
> #! /bin/sh
>
> modprobe zram
>
> while true; do
>      for i in `seq 1 10`; do
> 	echo 10485760 > /sys/block/zram0/disksize&
> 	echo 1 > /sys/block/zram0/reset&
>      done
> done
> $ sudo ./conctest.sh
>
> [   51.535387] ------------[ cut here ]------------
> [   51.536305] WARNING: CPU: 0 PID: 840 at fs/kernfs/dir.c:1209
> kernfs_remove_by_name_ns+0x95/0xa0()
> [   51.537908] kernfs: can not remove 'max_comp_streams', no directory
> [   51.539089] Modules linked in: zram lz4_compress xt_conntrack
> cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc
> ebtable_filter ebtables ip6_tables iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
> iptable_security iptable_raw ppdev crct10dif_pclmul crc32_pclmul
> crc32c_intel joydev ghash_clmulni_intel microcode serio_raw pcspkr
> virtio_balloon virtio_console parport_pc pvpanic virtio_net parport
> floppy i2c_piix4 nfsd auth_rpcgss nfs_acl lockd sunrpc qxl
> drm_kms_helper ttm virtio_blk drm virtio_pci virtio_ring virtio
> ata_generic pata_acpi
> [   51.550844] CPU: 0 PID: 840 Comm: conc_init.sh Tainted: G      D W
>       3.16.0-rc5-memacct-next-20140715+ #146
> [   51.552606] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   51.553691]  0000000000000009 ffff880078343d20 ffffffff8172d344
> ffff880078343d68
> [   51.555412]  ffff880078343d58 ffffffff8108ad1d 0000000000000000
> ffffffffa0320242
> [   51.557811]  ffffffffa0321058 0000000000000002 ffff880078343f50
> ffff880078343db8
> [   51.559580] Call Trace:
> [   51.560139]  [<ffffffff8172d344>] dump_stack+0x45/0x56
> [   51.561161]  [<ffffffff8108ad1d>] warn_slowpath_common+0x7d/0xa0
> [   51.562333]  [<ffffffff8108ad8c>] warn_slowpath_fmt+0x4c/0x50
> [   51.563445]  [<ffffffff81218196>] ? evict+0x106/0x170
> [   51.564432]  [<ffffffff81275695>] kernfs_remove_by_name_ns+0x95/0xa0
> [   51.565627]  [<ffffffff81277ee9>] remove_files.isra.1+0x39/0x70
> [   51.566753]  [<ffffffff812781f4>] sysfs_remove_group+0x44/0xa0
> [   51.567870]  [<ffffffffa031e058>] destroy_device.isra.17+0x28/0x50
> [zram]
> [   51.569089]  [<ffffffffa031e5d0>] reset_store+0x100/0x140 [zram]
> [   51.570197]  [<ffffffff8146c3e8>] dev_attr_store+0x18/0x30
> [   51.571247]  [<ffffffff81276fd4>] sysfs_kf_write+0x44/0x60
> [   51.572201]  [<ffffffff812768d7>] kernfs_fop_write+0xe7/0x170
> [   51.573283]  [<ffffffff811fbcf7>] vfs_write+0xb7/0x1f0
> [   51.574143]  [<ffffffff811fc8a9>] SyS_write+0x49/0xb0
> [   51.574976]  [<ffffffff8112e724>] ? __audit_syscall_entry+0xb4/0x110
> [   51.576213]  [<ffffffff817362a9>] system_call_fastpath+0x16/0x1b
> [   51.577422] ---[ end trace cdb79035dad379f3 ]---
> [   51.578401] ------------[ cut here ]------------
> [   51.579354] WARNING: CPU: 0 PID: 840 at fs/kernfs/dir.c:1209
> kernfs_remove_by_name_ns+0x95/0xa0()
> [   51.580966] kernfs: can not remove 'comp_algorithm', no directory
> [   51.582108] Modules linked in: zram lz4_compress xt_conntrack
> cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc
> ebtable_filter ebtables ip6_tables iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
> iptable_security iptable_raw ppdev crct10dif_pclmul crc32_pclmul
> crc32c_intel joydev ghash_clmulni_intel microcode serio_raw pcspkr
> virtio_balloon virtio_console parport_pc pvpanic virtio_net parport
> floppy i2c_piix4 nfsd auth_rpcgss nfs_acl lockd sunrpc qxl
> drm_kms_helper ttm virtio_blk drm virtio_pci virtio_ring virtio
> ata_generic pata_acpi
> [   51.597177] CPU: 0 PID: 840 Comm: conc_init.sh Tainted: G      D W
>       3.16.0-rc5-memacct-next-20140715+ #146
> [   51.598549] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   51.599661]  0000000000000009 ffff880078343d20 ffffffff8172d344
> ffff880078343d68
> [   51.601519]  ffff880078343d58 ffffffff8108ad1d 0000000000000000
> ffffffffa0320233
> [   51.603362]  ffffffffa0321058 0000000000000002 ffff880078343f50
> ffff880078343db8
> [   51.604913] Call Trace:
> [   51.605444]  [<ffffffff8172d344>] dump_stack+0x45/0x56
> [   51.606537]  [<ffffffff8108ad1d>] warn_slowpath_common+0x7d/0xa0
> [   51.607507]  [<ffffffff8108ad8c>] warn_slowpath_fmt+0x4c/0x50
> [   51.608582]  [<ffffffff81218196>] ? evict+0x106/0x170
> [   51.609423]  [<ffffffff81275695>] kernfs_remove_by_name_ns+0x95/0xa0
> [   51.610436]  [<ffffffff81277ee9>] remove_files.isra.1+0x39/0x70
> [   51.611408]  [<ffffffff812781f4>] sysfs_remove_group+0x44/0xa0
> [   51.612431]  [<ffffffffa031e058>] destroy_device.isra.17+0x28/0x50
> [zram]
> [   51.613214]  [<ffffffffa031e5d0>] reset_store+0x100/0x140 [zram]
> [   51.613928]  [<ffffffff8146c3e8>] dev_attr_store+0x18/0x30
> [   51.614634]  [<ffffffff81276fd4>] sysfs_kf_write+0x44/0x60
> [   51.615387]  [<ffffffff812768d7>] kernfs_fop_write+0xe7/0x170
> [   51.616246]  [<ffffffff811fbcf7>] vfs_write+0xb7/0x1f0
> [   51.619107]  [<ffffffff811fc8a9>] SyS_write+0x49/0xb0
> [   51.620063]  [<ffffffff8112e724>] ? __audit_syscall_entry+0xb4/0x110
> [   51.622071]  [<ffffffff817362a9>] system_call_fastpath+0x16/0x1b
> [   51.623256] ---[ end trace cdb79035dad379f4 ]---
>
> And lots more of similar messages.
>
> Jerome
>

Thanks for catching, i try fix it and resend patch.
