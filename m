Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3LAKxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 05:53:55 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64186 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3LAKxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 05:53:51 -0500
Message-ID: <1385895217.3994.2.camel@phoenix>
Subject: BUG: sleeping function called from invalid context at
 kernel/locking/mutex.c:616
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sun, 01 Dec 2013 18:53:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I got below messages while booting.
Testing on a nommu platform with 3.13.0-rc2 + patches for this SoC.

VFS: Mounted root (jffs2 filesystem) on device 31:1.
devtmpfs: mounted
Freeing unused kernel memory: 92K (003a4000 - 003bb000)
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:616
in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper
1 lock held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<0006ea10>] prepare_bprm_creds+0x30/0x6c
CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc2-00080-g2f56e18-dirty #1987
Backtrace: 
[<0000b1e8>] (dump_backtrace+0x0/0x108) from [<0000b37c>] (show_stack+0x18/0x1c)
 r6:00000000 r5:0147abb8 r4:01c38000 r3:00200140
[<0000b364>] (show_stack+0x0/0x1c) from [<002c8f28>] (dump_stack+0x20/0x28)
[<002c8f08>] (dump_stack+0x0/0x28) from [<0002e3dc>] (__might_sleep+0xf0/0x110)
[<0002e2ec>] (__might_sleep+0x0/0x110) from [<002cc5ec>] (mutex_lock_nested+0x2c/0x2e4)
 r4:0147abb8
[<002cc5c0>] (mutex_lock_nested+0x0/0x2e4) from [<000bf9bc>] (jffs2_readpage+0x28/0x4c)
 r8:00100100 r7:00000002 r6:00810640 r5:0147abb8 r4:00810640
[<000bf994>] (jffs2_readpage+0x0/0x4c) from [<000584f0>] (__do_page_cache_readahead+0x1fc/0x260)
 r5:00000004 r4:0147ad2c
[<000582f4>] (__do_page_cache_readahead+0x0/0x260) from [<000587cc>] (ra_submit+0x2c/0x34)
[<000587a0>] (ra_submit+0x0/0x34) from [<00058ae0>] (ondemand_readahead+0x30c/0x330)
[<000587d4>] (ondemand_readahead+0x0/0x330) from [<00058c0c>] (page_cache_sync_readahead+0x60/0x68)
[<00058bac>] (page_cache_sync_readahead+0x0/0x68) from [<00050f5c>] (generic_file_aio_read+0x2e0/0x768)
 r5:00000000 r4:00000001
[<00050c7c>] (generic_file_aio_read+0x0/0x768) from [<00069300>] (do_sync_read+0x88/0xd0)
[<00069278>] (do_sync_read+0x0/0xd0) from [<00069b84>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e59200 r5:01c39ef8 r4:01c0fc40
[<00069ad8>] (vfs_read+0x0/0xf4) from [<0006e528>] (kernel_read+0x34/0x64)
 r7:003568ab r6:00000000 r5:01c0fc40 r4:01c39ef8
[<0006e4f4>] (kernel_read+0x0/0x64) from [<0006e660>] (prepare_binprm+0x108/0x114)
 r5:01c38000 r4:01e59200
[<0006e558>] (prepare_binprm+0x0/0x114) from [<0006ed50>] (do_execve+0x278/0x560)
 r4:01e59200
[<0006ead8>] (do_execve+0x0/0x560) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c5adc>] (kernel_init+0x98/0x104)
 r5:002c5a44 r4:003e33c0
[<002c5a44>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:80000002
BUG: scheduling while atomic: swapper/1/0x00000003
4 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<0006ea10>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000bf9bc>] jffs2_readpage+0x28/0x4c
 #2:  (&flash->lock){......}, at: [<00158154>] m25p80_read+0xb4/0x134
 #3:  (lock){......}, at: [<00158b0c>] spi_write_then_read+0x38/0x158
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc2-00080-g2f56e18-dirty #1987
Backtrace: 
[<0000b1e8>] (dump_backtrace+0x0/0x108) from [<0000b37c>] (show_stack+0x18/0x1c)
 r6:003c9ce8 r5:00000000 r4:01c30000 r3:00200140
[<0000b364>] (show_stack+0x0/0x1c) from [<002c8f28>] (dump_stack+0x20/0x28)
[<002c8f08>] (dump_stack+0x0/0x28) from [<002c7984>] (__schedule_bug+0x58/0x70)
[<002c792c>] (__schedule_bug+0x0/0x70) from [<002cad30>] (__schedule+0x58/0x390)
 r5:01c38000 r4:01c30000
[<002cacd8>] (__schedule+0x0/0x390) from [<002cb174>] (schedule+0x88/0x8c)
[<002cb0ec>] (schedule+0x0/0x8c) from [<002ca738>] (schedule_timeout+0x20/0x15c)
[<002ca718>] (schedule_timeout+0x0/0x15c) from [<002cb80c>] (wait_for_common+0xe0/0x178)
 r8:01c38000 r7:00000002 r6:01c398e4 r5:01c398e0 r4:7fffffff
[<002cb72c>] (wait_for_common+0x0/0x178) from [<002cb8bc>] (wait_for_completion+0x18/0x1c)
[<002cb8a4>] (wait_for_completion+0x0/0x1c) from [<00158a80>] (__spi_sync+0xbc/0xe0)
[<001589c4>] (__spi_sync+0x0/0xe0) from [<00158ad0>] (spi_sync+0x14/0x18)
[<00158abc>] (spi_sync+0x0/0x18) from [<00158bd4>] (spi_write_then_read+0x100/0x158)
[<00158ad4>] (spi_write_then_read+0x0/0x158) from [<00157084>] (read_sr+0x34/0x5c)
[<00157050>] (read_sr+0x0/0x5c) from [<00157724>] (wait_till_ready+0x24/0x70)
 r5:ffffab54 r4:003c89d0
[<00157700>] (wait_till_ready+0x0/0x70) from [<0015815c>] (m25p80_read+0xbc/0x134)
 r6:01cdd814 r5:01c39ab8 r4:01cdd860 r3:01c38000
[<001580a0>] (m25p80_read+0x0/0x134) from [<00152650>] (part_read+0x64/0xac)
[<001525ec>] (part_read+0x0/0xac) from [<0014f814>] (mtd_read+0x90/0xc8)
 r7:01c39c04 r6:01e26400 r4:001fe33c
[<0014f784>] (mtd_read+0x0/0xc8) from [<000cf110>] (jffs2_flash_read+0x48/0x220)
 r9:019b2000 r8:01e55c10 r7:00000044 r6:01c39c04 r5:00001cc4
r4:01e56400
[<000cf0c8>] (jffs2_flash_read+0x0/0x220) from [<000c0d8c>] (jffs2_read_dnode+0x68/0x460)
[<000c0d24>] (jffs2_read_dnode+0x0/0x460) from [<000c1280>] (jffs2_read_inode_range+0xfc/0x15c)
[<000c1184>] (jffs2_read_inode_range+0x0/0x15c) from [<000bf5d8>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000bf568>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000bf980>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:00810640 r5:0147abb8 r4:00810640
[<000bf96c>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000bf9cc>] (jffs2_readpage+0x38/0x4c)
 r5:0147abb8 r4:00810640
[<000bf994>] (jffs2_readpage+0x0/0x4c) from [<000584f0>] (__do_page_cache_readahead+0x1fc/0x260)
 r5:00000004 r4:0147ad2c
[<000582f4>] (__do_page_cache_readahead+0x0/0x260) from [<000587cc>] (ra_submit+0x2c/0x34)
[<000587a0>] (ra_submit+0x0/0x34) from [<00058ae0>] (ondemand_readahead+0x30c/0x330)
[<000587d4>] (ondemand_readahead+0x0/0x330) from [<00058c0c>] (page_cache_sync_readahead+0x60/0x68)
[<00058bac>] (page_cache_sync_readahead+0x0/0x68) from [<00050f5c>] (generic_file_aio_read+0x2e0/0x768)
 r5:00000000 r4:00000001
[<00050c7c>] (generic_file_aio_read+0x0/0x768) from [<00069300>] (do_sync_read+0x88/0xd0)
[<00069278>] (do_sync_read+0x0/0xd0) from [<00069b84>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e59200 r5:01c39ef8 r4:01c0fc40
[<00069ad8>] (vfs_read+0x0/0xf4) from [<0006e528>] (kernel_read+0x34/0x64)
 r7:003568ab r6:00000000 r5:01c0fc40 r4:01c39ef8
[<0006e4f4>] (kernel_read+0x0/0x64) from [<0006e660>] (prepare_binprm+0x108/0x114)
 r5:01c38000 r4:01e59200
[<0006e558>] (prepare_binprm+0x0/0x114) from [<0006ed50>] (do_execve+0x278/0x560)
 r4:01e59200
[<0006ead8>] (do_execve+0x0/0x560) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c5adc>] (kernel_init+0x98/0x104)
 r5:002c5a44 r4:003e33c0
[<002c5a44>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:80000002
BUG: scheduling while atomic: jffs2_gcd_mtd1/35/0x00000002
3 locks held by jffs2_gcd_mtd1/35:
 #0:  (&c->alloc_sem){......}, at: [<000c8b88>] jffs2_garbage_collect_pass+0x24/0x794
 #1:  (&f->sem#2){......}, at: [<000c4914>] jffs2_do_crccheck_inode+0x4c/0xa0
 #2:  (&flash->lock){......}, at: [<00158154>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 35 Comm: jffs2_gcd_mtd1 Tainted: G        W    3.13.0-rc2-00080-g2f56e18-dirty #1987
Backtrace: 
[<0000b1e8>] (dump_backtrace+0x0/0x108) from [<0000b37c>] (show_stack+0x18/0x1c)
 r6:003c9ce8 r5:00000000 r4:01cf9d80 r3:00208040
[<0000b364>] (show_stack+0x0/0x1c) from [<002c8f28>] (dump_stack+0x20/0x28)
[<002c8f08>] (dump_stack+0x0/0x28) from [<002c7984>] (__schedule_bug+0x58/0x70)
[<002c792c>] (__schedule_bug+0x0/0x70) from [<002cad30>] (__schedule+0x58/0x390)
 r5:01e72000 r4:01cf9d80
[<002cacd8>] (__schedule+0x0/0x390) from [<002cb174>] (schedule+0x88/0x8c)
[<002cb0ec>] (schedule+0x0/0x8c) from [<002cb314>] (schedule_preempt_disabled+0x28/0x38)
[<002cb2ec>] (schedule_preempt_disabled+0x0/0x38) from [<002cc76c>] (mutex_lock_nested+0x1ac/0x2e4)
 r4:01cdd814 r3:00000001
[<002cc5c0>] (mutex_lock_nested+0x0/0x2e4) from [<00158154>] (m25p80_read+0xb4/0x134)
 r8:00000028 r7:00000232 r6:01cdd814 r5:01e73bf8 r4:01cdd860
[<001580a0>] (m25p80_read+0x0/0x134) from [<00152650>] (part_read+0x64/0xac)
[<001525ec>] (part_read+0x0/0xac) from [<0014f814>] (mtd_read+0x90/0xc8)
 r7:01e73d7c r6:01e26400 r4:0017c594
[<0014f784>] (mtd_read+0x0/0xc8) from [<000cf110>] (jffs2_flash_read+0x48/0x220)
 r9:00000008 r8:01e56c00 r7:00000028 r6:01e73d7c r5:01e56400
r4:01e56400
[<000cf0c8>] (jffs2_flash_read+0x0/0x220) from [<000c2964>] (jffs2_do_read_inode_internal+0x1b8/0x1ebc)
[<000c27ac>] (jffs2_do_read_inode_internal+0x0/0x1ebc) from [<000c4928>] (jffs2_do_crccheck_inode+0x60/0xa0)
[<000c48c8>] (jffs2_do_crccheck_inode+0x0/0xa0) from [<000c8cfc>] (jffs2_garbage_collect_pass+0x198/0x794)
 r6:01c56060 r5:01e565d8 r4:01e56400
[<000c8b64>] (jffs2_garbage_collect_pass+0x0/0x794) from [<000ca7dc>] (jffs2_garbage_collect_thread+0x138/0x170)
[<000ca6a4>] (jffs2_garbage_collect_thread+0x0/0x170) from [<00028618>] (kthread+0xcc/0xe0)
[<0002854c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002854c r4:01e5e020
BUG: scheduling while atomic: spi0/27/0x00000005
no locks held by spi0/27.
Modules linked in:
CPU: 0 PID: 27 Comm: spi0 Tainted: G        W    3.13.0-rc2-00080-g2f56e18-dirty #1987
Backtrace: 
[<0000b1e8>] (dump_backtrace+0x0/0x108) from [<0000b37c>] (show_stack+0x18/0x1c)
 r6:003c9ce8 r5:00000000 r4:01cf8000 r3:00208040
[<0000b364>] (show_stack+0x0/0x1c) from [<002c8f28>] (dump_stack+0x20/0x28)
[<002c8f08>] (dump_stack+0x0/0x28) from [<002c7984>] (__schedule_bug+0x58/0x70)
[<002c792c>] (__schedule_bug+0x0/0x70) from [<002cad30>] (__schedule+0x58/0x390)
 r5:01e1e000 r4:01cf8000
[<002cacd8>] (__schedule+0x0/0x390) from [<002cb174>] (schedule+0x88/0x8c)
[<002cb0ec>] (schedule+0x0/0x8c) from [<00028450>] (kthread_worker_fn+0xd8/0xe4)
[<00028378>] (kthread_worker_fn+0x0/0xe4) from [<00028618>] (kthread+0xcc/0xe0)
 r8:00000000 r7:00028378 r6:01cdd5dc r5:00000000 r4:01e19ae0
r3:01e1e000
[<0002854c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002854c r4:01e19ae0
BUG: scheduling while atomic: swapper/1/0x00000006
3 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<0006ea10>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000bf9bc>] jffs2_readpage+0x28/0x4c
 #2:  (&flash->lock){......}, at: [<00158154>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc2-00080-g2f56e18-dirty #1987
Backtrace: 
[<0000b1e8>] (dump_backtrace+0x0/0x108) from [<0000b37c>] (show_stack+0x18/0x1c)
 r6:003c9ce8 r5:00000000 r4:01c30000 r3:00200140
[<0000b364>] (show_stack+0x0/0x1c) from [<002c8f28>] (dump_stack+0x20/0x28)
[<002c8f08>] (dump_stack+0x0/0x28) from [<002c7984>] (__schedule_bug+0x58/0x70)
[<002c792c>] (__schedule_bug+0x0/0x70) from [<002cad30>] (__schedule+0x58/0x390)
 r5:01c38000 r4:01c30000
[<002cacd8>] (__schedule+0x0/0x390) from [<002cb174>] (schedule+0x88/0x8c)
[<002cb0ec>] (schedule+0x0/0x8c) from [<002ca738>] (schedule_timeout+0x20/0x15c)
[<002ca718>] (schedule_timeout+0x0/0x15c) from [<002cb80c>] (wait_for_common+0xe0/0x178)
 r8:01c38000 r7:00000002 r6:01c399dc r5:01c399d8 r4:7fffffff
[<002cb72c>] (wait_for_common+0x0/0x178) from [<002cb8bc>] (wait_for_completion+0x18/0x1c)
[<002cb8a4>] (wait_for_completion+0x0/0x1c) from [<00158a80>] (__spi_sync+0xbc/0xe0)
[<001589c4>] (__spi_sync+0x0/0xe0) from [<00158ad0>] (spi_sync+0x14/0x18)
[<00158abc>] (spi_sync+0x0/0x18) from [<0015819c>] (m25p80_read+0xfc/0x134)
[<001580a0>] (m25p80_read+0x0/0x134) from [<00152650>] (part_read+0x64/0xac)
[<001525ec>] (part_read+0x0/0xac) from [<0014f814>] (mtd_read+0x90/0xc8)
 r7:01c39c04 r6:01e26400 r4:001fe33c
[<0014f784>] (mtd_read+0x0/0xc8) from [<000cf110>] (jffs2_flash_read+0x48/0x220)
 r9:019b2000 r8:01e55c10 r7:00000044 r6:01c39c04 r5:00001cc4
r4:01e56400
[<000cf0c8>] (jffs2_flash_read+0x0/0x220) from [<000c0d8c>] (jffs2_read_dnode+0x68/0x460)
[<000c0d24>] (jffs2_read_dnode+0x0/0x460) from [<000c1280>] (jffs2_read_inode_range+0xfc/0x15c)
[<000c1184>] (jffs2_read_inode_range+0x0/0x15c) from [<000bf5d8>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000bf568>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000bf980>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:00810640 r5:0147abb8 r4:00810640
[<000bf96c>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000bf9cc>] (jffs2_readpage+0x38/0x4c)
 r5:0147abb8 r4:00810640
[<000bf994>] (jffs2_readpage+0x0/0x4c) from [<000584f0>] (__do_page_cache_readahead+0x1fc/0x260)
 r5:00000004 r4:0147ad2c
[<000582f4>] (__do_page_cache_readahead+0x0/0x260) from [<000587cc>] (ra_submit+0x2c/0x34)
[<000587a0>] (ra_submit+0x0/0x34) from [<00058ae0>] (ondemand_readahead+0x30c/0x330)
[<000587d4>] (ondemand_readahead+0x0/0x330) from [<00058c0c>] (page_cache_sync_readahead+0x60/0x68)
[<00058bac>] (page_cache_sync_readahead+0x0/0x68) from [<00050f5c>] (generic_file_aio_read+0x2e0/0x768)
 r5:00000000 r4:00000001
[<00050c7c>] (generic_file_aio_read+0x0/0x768) from [<00069300>] (do_sync_read+0x88/0xd0)
[<00069278>] (do_sync_read+0x0/0xd0) from [<00069b84>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e59200 r5:01c39ef8 r4:01c0fc40
[<00069ad8>] (vfs_read+0x0/0xf4) from [<0006e528>] (kernel_read+0x34/0x64)
 r7:003568ab r6:00000000 r5:01c0fc40 r4:01c39ef8
[<0006e4f4>] (kernel_read+0x0/0x64) from [<0006e660>] (prepare_binprm+0x108/0x114)
 r5:01c38000 r4:01e59200
[<0006e558>] (prepare_binprm+0x0/0x114) from [<0006ed50>] (do_execve+0x278/0x560)
 r4:01e59200
[<0006ead8>] (do_execve+0x0/0x560) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c5adc>] (kernel_init+0x98/0x104)
 r5:002c5a44 r4:003e33c0
[<002c5a44>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:80000002
BUG: scheduling while atomic: spi0/27/0x00000009
no locks held by spi0/27.
Modules linked in:
CPU: 0 PID: 27 Comm: spi0 Tainted: G        W    3.13.0-rc2-00080-g2f56e18-dirty #1987
Backtrace: 
[<0000b1e8>] (dump_backtrace+0x0/0x108) from [<0000b37c>] (show_stack+0x18/0x1c)
 r6:003c9ce8 r5:00000000 r4:01cf8000 r3:00208040
[<0000b364>] (show_stack+0x0/0x1c) from [<002c8f28>] (dump_stack+0x20/0x28)
[<002c8f08>] (dump_stack+0x0/0x28) from [<002c7984>] (__schedule_bug+0x58/0x70)
[<002c792c>] (__schedule_bug+0x0/0x70) from [<002cad30>] (__schedule+0x58/0x390)
 r5:01e1e000 r4:01cf8000
[<002cacd8>] (__schedule+0x0/0x390) from [<002cb174>] (schedule+0x88/0x8c)
[<002cb0ec>] (schedule+0x0/0x8c) from [<00028450>] (kthread_worker_fn+0xd8/0xe4)
[<00028378>] (kthread_worker_fn+0x0/0xe4) from [<00028618>] (kthread+0xcc/0xe0)
 r8:00000000 r7:00028378 r6:01cdd5dc r5:00000000 r4:01e19ae0
r3:01e1e000
[<0002854c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002854c r4:01e19ae0
......


