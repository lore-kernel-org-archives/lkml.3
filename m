Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab3DZOIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:08:50 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:37288 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751090Ab3DZOIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:08:49 -0400
Message-ID: <517A8A6F.2030104@newflow.co.uk>
Date: Fri, 26 Apr 2013 15:08:47 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        dedekind1@gmail.com, adrian.hunter@intel.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: BUG: spinlock lockup suspected on CPU#0, flush-ubifs_0_0/844
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've encountered a lockup on ubifs ... any ideas ?

# ifup eth1
[ 3451.254040] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[ 3451.262627] pgd = cf468000
[ 3451.265489] [00000000] *pgd=8f48c831, *pte=00000000, *ppte=00000000
[ 3451.272146] Internal error: Oops: 80000007 [#2] ARM
[ 3451.277312] CPU: 0    Tainted: G      D       (3.9.0-rc8-00020-g6e8f1be-dirty #210)
[ 3451.285411] PC is at 0x0
[ 3451.288105] LR is at pagevec_lru_move_fn+0x90/0xe4
[ 3451.293172] pc : [<00000000>]    lr : [<c00a00b8>]    psr: 600000b3
[ 3451.293172] sp : cf479df4  ip : 00000040  fp : 00000000
[ 3451.305311] r10: c05d8ebc  r9 : c0d09e00  r8 : 0000030c
[ 3451.310834] r7 : c05b72e8  r6 : 60000013  r5 : 00000002  r4 : c05d8ebc
[ 3451.317736] r3 : 00000001  r2 : cf478000  r1 : c05d90f0  r0 : c0d09e00
[ 3451.324639] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA Thumb  Segment user
[ 3451.332460] Control: 10c5387d  Table: 8f468019  DAC: 00000015
[ 3451.338535] Process sh (pid: 913, stack limit = 0xcf478238)
[ 3451.344427] Stack: (0xcf479df4 to 0xcf47a000)
[ 3451.349036] 9de0:                                              c05b72dc c009f51c 00000001
[ 3451.357688] 9e00: cf478000 00000001 c05b729c c05b729c cf4813e8 cf411680 cf481658 b6fbc000
[ 3451.366340] 9e20: cf411684 c00a032c cf481808 cf481650 cf481808 c00a0390 b6fbc000 c00b54a0
[ 3451.374992] 9e40: cf4414c0 cf481650 cf4116d8 c041d164 60000113 cf4116dc 60000113 cf4116dc
[ 3451.383644] 9e60: cf478000 cf479fb0 b6fbb2b0 c041d260 cf4116fc 00000817 cf411680 cf481808
[ 3451.392295] 9e80: cf411680 cf481808 cf411680 b6fc0000 b6fbc000 cf481650 cf481808 c00b7294
[ 3451.400948] 9ea0: b6fc0000 00000000 cf478000 cf4813e8 00000001 cf481820 b6fbc000 cf481660
[ 3451.409598] 9ec0: b6fc0000 cf411680 00004000 cf478000 cf411684 c00b7980 cf478000 60000093
[ 3451.418249] 9ee0: 00000001 b6fbc000 00000032 cf4116d8 bea3d23c 00000000 00000073 00000000
[ 3451.426901] 9f00: 00000000 00004000 beffc000 00000003 cf478000 00000000 cf411680 00004000
[ 3451.435552] 9f20: 00000032 cf479f84 00000004 c00b7f20 000b6fbc c041d260 c0590b64 cf4116dc
[ 3451.444203] 9f40: cf4116d8 00000073 00100100 00000000 00000000 00000003 00003710 b6fbc000
[ 3451.452855] 9f60: 00000032 cf4116d8 bea3d23c c00a92c4 00000032 000b6fbc cf479f84 c00b6790
[ 3451.461506] 9f80: ffffffff 00000000 ffffffff 00000000 b6fbc000 000000c0 c00142e8 cf478000
[ 3451.470157] 9fa0: 00000000 c0014140 00000032 00000000 b6fbc000 00003710 00000003 00000032
[ 3451.478808] 9fc0: ffffffff 00000000 b6fbc000 000000c0 b6fcdf74 b6f73000 00000003 bea3d23c
[ 3451.487460] 9fe0: b6fcb0b4 bea3d0f8 b6fba000 b6fc3af8 20000010 b6fbc000 00000000 00000000
[ 3451.496127] [<c00a00b8>] (pagevec_lru_move_fn+0x90/0xe4) from [<cf481808>] (0xcf481808)


[ 3485.901588] BUG: spinlock lockup suspected on CPU#0, flush-ubifs_0_0/844
[ 3485.908722]  lock: contig_page_data+0x214/0x9c4, .magic: dead4ead, .owner: sh/913, .owner_cpu: 0
[ 3485.918048] [<c0019c5c>] (unwind_backtrace+0x0/0x138) from [<c01f10a0>] (do_raw_spin_lock+0x110/0x154)
[ 3485.927916] [<c01f10a0>] (do_raw_spin_lock+0x110/0x154) from [<c041d164>] (_raw_spin_lock_irqsave+0x4c/0x58)
[ 3485.938326] [<c041d164>] (_raw_spin_lock_irqsave+0x4c/0x58) from [<c00a00a0>] (pagevec_lru_move_fn+0x78/0xe4)
[ 3485.948819] [<c00a00a0>] (pagevec_lru_move_fn+0x78/0xe4) from [<c00a032c>] (lru_add_drain_cpu+0x68/0xc0)
[ 3485.958853] [<c00a032c>] (lru_add_drain_cpu+0x68/0xc0) from [<c00a0390>] (lru_add_drain+0xc/0x10)
[ 3485.968244] [<c00a0390>] (lru_add_drain+0xc/0x10) from [<c00a03a0>] (__pagevec_release+0xc/0x24)
[ 3485.977543] [<c00a03a0>] (__pagevec_release+0xc/0x24) from [<c009e3f0>] (write_cache_pages+0x2d0/0x3c0)
[ 3485.987484] [<c009e3f0>] (write_cache_pages+0x2d0/0x3c0) from [<c009e524>] (generic_writepages+0x44/0x60)
[ 3485.997620] [<c009e524>] (generic_writepages+0x44/0x60) from [<c00eb788>] (__writeback_single_inode+0x28/0xf4)
[ 3486.008206] [<c00eb788>] (__writeback_single_inode+0x28/0xf4) from [<c00ebee8>] (writeback_sb_inodes+0x21c/0x3b4)
[ 3486.019069] [<c00ebee8>] (writeback_sb_inodes+0x21c/0x3b4) from [<c00ec0f4>] (__writeback_inodes_wb+0x74/0xb0)
[ 3486.029654] [<c00ec0f4>] (__writeback_inodes_wb+0x74/0xb0) from [<c00ec4e8>] (wb_writeback+0x218/0x228)
[ 3486.039597] [<c00ec4e8>] (wb_writeback+0x218/0x228) from [<c00ec898>] (wb_do_writeback+0x1f8/0x208)
[ 3486.049172] [<c00ec898>] (wb_do_writeback+0x1f8/0x208) from [<c00ec934>] (bdi_writeback_thread+0x8c/0x160)
[ 3486.059401] [<c00ec934>] (bdi_writeback_thread+0x8c/0x160) from [<c0056fd0>] (kthread+0xa8/0xb4)
[ 3486.068714] [<c0056fd0>] (kthread+0xa8/0xb4) from [<c00141f0>] (ret_from_fork+0x14/0x24)

