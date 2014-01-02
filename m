Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaABJgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:36:45 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:64978 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaABJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:36:42 -0500
Message-ID: <52C5331E.3050304@profitbricks.com>
Date: Thu, 02 Jan 2014 10:36:30 +0100
From: Jack Wang <jinpu.wang@profitbricks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [BUG]NULL pointer dereference at 0000000000000008 __blkdev_put+0x17f/0x1d0
References: <52C19767.60000@profitbricks.com>
In-Reply-To: <52C19767.60000@profitbricks.com>
Content-Type: multipart/mixed;
 boundary="------------050201090205000009030200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050201090205000009030200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/30/2013 04:55 PM, Jack Wang wrote:
> Hi,
> 
> We saw NULL pointer dereference below:
> 
> Dec 28 16:24:26 server kernel: [979193.076399] BUG: unable to handle
> kernel NULL pointer dereference at 0000000000000008
> Dec 28 16:24:26 server kernel: [979193.076401] IP: [<ffffffff8116952f>]
> __blkdev_put+0x17f/0x1d0
> Dec 28 16:24:26 server kernel: [979193.076408] PGD 4bdcaa067 PUD
> 4bdc43067 PMD 0
> Dec 28 16:24:26 server kernel: [979193.076410] Oops: 0000 [#1] SMP
> Dec 28 16:24:26 server kernel: [979193.076412] CPU 6
> Dec 28 16:24:26 server kernel: [979193.076413] Modules linked in: bridge
> stp llc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
> raid1 md_mod dm_round_robin sd_mod crc_t10dif ib_srp scsi_transport_srp
> scsi_tgt xt_ETHOIP6(O) x_tables vhost_net(O) macvtap macvlan tun(O)
> nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 rdma_ucm rdma_cm iw_cm
> ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad ib_qib mlx4_ib ib_mthca
> ib_mad ib_core dm_multipath scsi_dh scsi_mod kvm_amd kvm powernow_k8
> mperf psmouse crc32c_intel microcode tpm_tis tpm tpm_bios serio_raw
> evdev amd64_edac_mod edac_core edac_mce_amd i2c_piix4 button processor
> thermal_sys mlx4_core
> Dec 28 16:24:26 server kernel: [979193.076440]
> Dec 28 16:24:26 server kernel: [979193.076442] Pid: 56544, comm:
> multipath Tainted: G           O 3.4.71-3-pserver #1 Supermicro BHQGE/BHQGE
> Dec 28 16:24:26 server kernel: [979193.076445] RIP:
> 0010:[<ffffffff8116952f>]  [<ffffffff8116952f>] __blkdev_put+0x17f/0x1d0
> Dec 28 16:24:26 server kernel: [979193.076448] RSP:
> 0018:ffff882802f4beb8  EFLAGS: 00010246
> Dec 28 16:24:26 server kernel: [979193.076449] RAX: 0000000000000000
> RBX: ffff881ff78b0d00 RCX: 0000000000000001
> Dec 28 16:24:26 server kernel: [979193.076451] RDX: 0000000000000000
> RSI: 000000000000001d RDI: ffff881ff78b0d18
> Dec 28 16:24:26 server kernel: [979193.076452] RBP: 0000000000000000
> R08: 0000000000000000 R09: 0000000000000000
> Dec 28 16:24:26 server kernel: [979193.076453] R10: 0000000000000000
> R11: 0000000000000246 R12: 000000000000001d
> Dec 28 16:24:26 server kernel: [979193.076455] R13: ffff881ff78b0d18
> R14: ffff8807f9e7f400 R15: ffff8804a8d77710
> Dec 28 16:24:26 server kernel: [979193.076457] FS:
> 00007ff8c80fe7a0(0000) GS:ffff880807d80000(0000) knlGS:0000000000000000
> Dec 28 16:24:26 server kernel: [979193.076458] CS:  0010 DS: 0000 ES:
> 0000 CR0: 0000000080050033
> Dec 28 16:24:26 server kernel: [979193.076460] CR2: 0000000000000008
> CR3: 000000064765f000 CR4: 00000000000407e0
> Dec 28 16:24:26 server kernel: [979193.076461] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Dec 28 16:24:26 server kernel: [979193.076463] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Dec 28 16:24:26 server kernel: [979193.076464] Process multipath (pid:
> 56544, threadinfo ffff882802f4a000, task ffff8828020106d0)
> Dec 28 16:24:26 server kernel: [979193.076466] Stack:
> Dec 28 16:24:26 server kernel: [979193.076466]  0000000000000000
> 0000000000000000 ffff880803cf2580 ffff8804a8d77700
> Dec 28 16:24:26 server kernel: [979193.076468]  0000000000000010
> ffff88100363eff0 ffff881004609b00 ffff882003c20020
> Dec 28 16:24:26 server kernel: [979193.076470]  ffff8804a8d77710
> ffffffff81136bad 00007fffbdc8f420 ffff8804a8d77700
> Dec 28 16:24:26 server kernel: [979193.076472] Call Trace:
> Dec 28 16:24:26 server kernel: [979193.076477]  [<ffffffff81136bad>] ?
> fput+0xdd/0x270
> Dec 28 16:24:26 server kernel: [979193.076479]  [<ffffffff81132f0c>] ?
> filp_close+0x5c/0x90
> Dec 28 16:24:26 server kernel: [979193.076481]  [<ffffffff81132fb1>] ?
> sys_close+0x71/0xc0
> Dec 28 16:24:26 server kernel: [979193.076484]  [<ffffffff816801b9>] ?
> system_call_fastpath+0x16/0x1b
> Dec 28 16:24:26 server kernel: [979193.076486] Code: 8b 5c 24 18 48 8b
> 6c 24 20 4c 8b 64 24 28 4c 8b 6c 24 30 4c 8b 74 24 38 4c 8b 7c 24 40 48
> 83 c4 48 c3 66 90 49 8b 86 48 03 00 00 <48> 8b 40 08 48 85 c0 0f 84 fc
> fe ff ff 44 89 e6 4c 89 f7 ff d0
> Dec 28 16:24:26 server kernel: [979193.076500] RIP  [<ffffffff8116952f>]
> __blkdev_put+0x17f/0x1d0
> Dec 28 16:24:26 server kernel: [979193.076503]  RSP <ffff882802f4beb8>
> Dec 28 16:24:26 server kernel: [979193.076504] CR2: 0000000000000008
> Dec 28 16:24:26 server kernel: [979193.077599] ---[ end trace
> 23f39da823d257f9 ]---
> 
> disassamble results show:
> 1465	static int __blkdev_put(struct block_device *bdev, fmode_t mode,
> int for_part)
> 1466	{
>    0xffffffff81162d10 <+0>:	sub    $0x48,%rsp
>    0xffffffff81162d14 <+4>:	mov    %r13,0x30(%rsp)
>    0xffffffff81162d1d <+13>:	mov    %rbx,0x18(%rsp)
>    0xffffffff81162d22 <+18>:	mov    %rbp,0x20(%rsp)
>    0xffffffff81162d27 <+23>:	mov    %r12,0x28(%rsp)
>    0xffffffff81162d2c <+28>:	mov    %edx,%ebp
>    0xffffffff81162d2e <+30>:	mov    %r14,0x38(%rsp)
>    0xffffffff81162d33 <+35>:	mov    %r15,0x40(%rsp)
>    0xffffffff81162d38 <+40>:	mov    %rdi,%rbx
>    0xffffffff81162d45 <+53>:	mov    %esi,%r12d
> 
> 1467		int ret = 0;
>    0xffffffff81162d8e <+126>:	xor    %ebp,%ebp
> 
> 1468		struct gendisk *disk = bdev->bd_disk;
>    0xffffffff81162d3b <+43>:	mov    0x90(%rdi),%r14
> 
> 1469		struct block_device *victim = NULL;
> 1470	
> 1471		mutex_lock_nested(&bdev->bd_mutex, for_part);
>    0xffffffff81162d19 <+9>:	lea    0x18(%rdi),%r13
> ---Type <return> to continue, or q <return> to quit---
>    0xffffffff81162d42 <+50>:	mov    %r13,%rdi
>    0xffffffff81162d48 <+56>:	callq  0xffffffff8166ece0 <mutex_lock>
> 
> 1472		if (for_part)
>    0xffffffff81162d4d <+61>:	test   %ebp,%ebp
>    0xffffffff81162d4f <+63>:	je     0xffffffff81162d57 <__blkdev_put+71>
> 
> 1473			bdev->bd_part_count--;
>    0xffffffff81162d51 <+65>:	decl   0x88(%rbx)
> 
> 1474	
> 1475		if (!--bdev->bd_openers) {
>    0xffffffff81162d57 <+71>:	mov    0x4(%rbx),%eax
>    0xffffffff81162d5a <+74>:	dec    %eax
>    0xffffffff81162d5c <+76>:	test   %eax,%eax
>    0xffffffff81162d5e <+78>:	mov    %eax,0x4(%rbx)
>    0xffffffff81162d61 <+81>:	jne    0xffffffff81162d8e <__blkdev_put+126>
> 
> 1476			WARN_ON_ONCE(bdev->bd_holders);
>    0xffffffff81162d63 <+83>:	mov    0x58(%rbx),%edx
>    0xffffffff81162d66 <+86>:	test   %edx,%edx
>    0xffffffff81162d68 <+88>:	jne    0xffffffff81162e9b <__blkdev_put+395>
>    0xffffffff81162e9b <+395>:	cmpb   $0x1,0x936b1e(%rip)        #
> 0xffffffff81a999c0 <__warned.29603>
>    0xffffffff81162ea2 <+402>:	je     0xffffffff81162d6e <__blkdev_put+94>
>    0xffffffff81162ea8 <+408>:	mov    $0x5c4,%esi
>    0xffffffff81162ead <+413>:	mov    $0xffffffff8193f5a7,%rdi
>    0xffffffff81162eb4 <+420>:	callq  0xffffffff81036ee0 <warn_slowpath_null>
>    0xffffffff81162eb9 <+425>:	movb   $0x1,0x936b00(%rip)        #
> 0xffffffff81a999c0 <__warned.29603>
>    0xffffffff81162ec0 <+432>:	jmpq   0xffffffff81162d6e <__blkdev_put+94>
>    0xffffffff81162ec5:	data32 nopw %cs:0x0(%rax,%rax,1)
> 
> 1484		}
> 1485		if (bdev->bd_contains == bdev) {
>    0xffffffff81162d90 <+128>:	cmp    %rbx,0x70(%rbx)
>    0xffffffff81162d94 <+132>:	je     0xffffffff81162e78 <__blkdev_put+360>
> 
> 1486			if (disk->fops->release)
> ---Type <return> to continue, or q <return> to quit---
>    0xffffffff81162e78 <+360>:	mov    0x348(%r14),%raxat
>    0xffffffff81162e7f <+367>:	mov    0x8(%rax),%rax
>    0xffffffff81162e83 <+371>:	test   %rax,%rax
>    0xffffffff81162e86 <+374>:	je     0xffffffff81162d9a <__blkdev_put+138>
> 
> 1487				ret = disk->fops->release(disk, mode);
>    0xffffffff81162e8c <+380>:	mov    %r12d,%esi
>    0xffffffff81162e8f <+383>:	mov    %r14,%rdi
>    0xffffffff81162e92 <+386>:	callq  *%rax
>    0xffffffff81162e94 <+388>:	mov    %eax,%ebp
>    0xffffffff81162e96 <+390>:	jmpq   0xffffffff81162d9a <__blkdev_put+138>
> snip
> 
> Bug happened at line 1486, looks disk->fops is NULL here for some
> reason, is it reasonable to add a check like:
> 
> if (disk->fops)
> 	if (disk->fops->release)
> 		ret = disk->fops->release(disk, mode);
> 
> 
> Happy New Year and Best regards:)
> Jack
> 

Ping, could you share opnions on this, attached with patch I proposaled.

Jack

--------------050201090205000009030200
Content-Type: text/x-patch;
 name="0001-fix-null-pointer-dereference-in-__blkdev_put.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-fix-null-pointer-dereference-in-__blkdev_put.patch"

>From 153918f99e45c685700e919a92384395dc18fd5d Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang@profitbricks.com>
Date: Thu, 2 Jan 2014 10:24:29 +0100
Subject: [PATCH] fix null pointer dereference in __blkdev_put We were hit by
 bug below: Dec 28 16:24:26 pserver1812 kernel: [979193.076399] BUG: unable to
 handle kernel NULL pointer dereference at 0000000000000008 Dec 28 16:24:26
 pserver1812 kernel: [979193.076401] IP: [<ffffffff8116952f>]
 __blkdev_put+0x17f/0x1d0 Dec 28 16:24:26 pserver1812 kernel: [979193.076442]
 Pid: 56544, comm: multipath Tainted: G           O 3.4.71-3-pserver #1
 Supermicro BHQGE/BHQGE Dec 28 16:24:26 pserver1812 kernel: [979193.076445]
 RIP: 0010:[<ffffffff8116952f>]  [<ffffffff8116952f>] __blkdev_put+0x17f/0x1d0
 Dec 28 16:24:26 pserver1812 kernel: [979193.076472] Call Trace: Dec 28
 16:24:26 pserver1812 kernel: [979193.076477]  [<ffffffff81136bad>] ?
 fput+0xdd/0x270 Dec 28 16:24:26 pserver1812 kernel: [979193.076479] 
 [<ffffffff81132f0c>] ? filp_close+0x5c/0x90 Dec 28 16:24:26 pserver1812
 kernel: [979193.076481]  [<ffffffff81132fb1>] ? sys_close+0x71/0xc0 Dec 28
 16:24:26 pserver1812 kernel: [979193.076484]  [<ffffffff816801b9>] ?
 system_call_fastpath+0x16/0x1b Dec 28 16:24:26 pserver1812 kernel:
 [979193.076486] Code: 8b 5c 24 18 48 8b 6c 24 20 4c 8b 64 24 28 4c 8b 6c 24
 30 4c 8b 74 24 38 4c 8b 7c 24 40 48 83 c4 48 c3 66 90 49 8b 86 48 03 00 00
 <48> 8b 40 08 48 85 c0 0f 84 fc fe ff ff 44 89 e6 4c 89 f7 ff d0 Dec 28
 16:24:26 pserver1812 kernel: [979193.076500] RIP  [<ffffffff8116952f>]
 __blkdev_put+0x17f/0x1d0 Dec 28 16:24:26 pserver1812 kernel: [979193.076503] 
 RSP <ffff882802f4beb8> Dec 28 16:24:26 pserver1812 kernel: [979193.076504]
 CR2: 0000000000000008 Dec 28 16:24:26 pserver1812 kernel: [979193.077599]
 ---[ end trace 23f39da823d257f9 ]---

Disamble code show null pointer happened in fops, fix by check before use it.

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 fs/block_dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 319d9c7..d3c45b4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1483,8 +1483,9 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 					&default_backing_dev_info);
 	}
 	if (bdev->bd_contains == bdev) {
-		if (disk->fops->release)
-			ret = disk->fops->release(disk, mode);
+		if (disk->fops)
+			if (disk->fops->release)
+				ret = disk->fops->release(disk, mode);
 	}
 	if (!bdev->bd_openers) {
 		struct module *owner = disk->fops->owner;
-- 
1.8.4


--------------050201090205000009030200--
