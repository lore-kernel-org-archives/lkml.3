Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3LSFbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:31:25 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54602 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3LSFbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:31:23 -0500
Message-ID: <52B28499.1010600@ozlabs.ru>
Date: Thu, 19 Dec 2013 16:31:05 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ext4: crash in ext4_superblock_csum_set
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While debugging some kernel stuff, I got a series crashes and got my root
FS broken, this happens, no big deal. But once I got a file system so
damaged so EXT4 driver crashed on mount, as below. The broken kernel is
quite old and the issue might have been fixed already but I am still
sending it just for the case. Thanks!

Kernel 3.10.0-rc2, gcc version 4.7.3, POWER7 machine.

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc000000000201280
cpu 0x12: Vector: 300 (Data Access) at [c000001f6cd96b20]
    pc: c000000000201280: .ext4_superblock_csum+0x14/0x70
    lr: c000000000201fbc: .ext4_superblock_csum_set+0x28/0x34
    sp: c000001f6cd96da0
   msr: 9000000000009032
   dar: 0
 dsisr: 40000000
  current = 0xc000001f6bc50000
  paca    = 0xc00000000ffe7f00   softe: 0        irq_happened: 0x08
    pid   = 5222, comm = mount
enter ? for help
[c000001f6cd96e30] c000000000201fbc .ext4_superblock_csum_set+0x28/0x34
[c000001f6cd96eb0] c000000000202644 .ext4_commit_super+0x1f0/0x270
[c000001f6cd96f70] c000000000203440 .ext4_error_inode+0x60/0xf0
[c000001f6cd97030] c0000000001f2dbc
.__check_block_validity.constprop.53+0x64/0x7c
[c000001f6cd970c0] c0000000001f31e0 .ext4_map_blocks+0x1d4/0x400
[c000001f6cd971a0] c0000000001f4ac0 ._ext4_get_block+0xcc/0x174
[c000001f6cd97260] c00000000015c6e0 .generic_block_bmap+0x50/0x68
[c000001f6cd97340] c0000000001f233c .ext4_bmap+0x94/0x10c
[c000001f6cd973d0] c0000000001488a4 .bmap+0x34/0x54
[c000001f6cd97440] c00000000023a3d0 .jbd2_journal_bmap+0x28/0xa8
[c000001f6cd974d0] c0000000002356b0 .jread+0x50/0x24c
[c000001f6cd975e0] c000000000235ccc .do_one_pass+0x380/0x9f8
[c000001f6cd97740] c0000000002363c4 .jbd2_journal_recover+0x80/0xf0
[c000001f6cd977e0] c00000000023a1c0 .jbd2_journal_load+0x36c/0x388
[c000001f6cd978b0] c000000000206890 .ext4_fill_super+0x1cd8/0x2968
[c000001f6cd97a00] c00000000013375c .mount_bdev+0x174/0x1f8
[c000001f6cd97ad0] c000000000200824 .ext4_mount+0x18/0x2c
[c000001f6cd97b40] c000000000134284 .mount_fs+0x28/0xc4
[c000001f6cd97bd0] c00000000014e964 .vfs_kern_mount+0x54/0xe8
[c000001f6cd97c80] c000000000150f80 .do_mount+0x804/0x930
[c000001f6cd97d70] c00000000017af74 .compat_sys_mount+0x1d8/0x220
[c000001f6cd97e30] c000000000009ca4 syscall_exit+0x0/0x98
--- Exception: c01 (System Call) at 00000000f7f64ca4
SP (ff9374d0) is in userspace
12:mon>



-- 
Alexey
