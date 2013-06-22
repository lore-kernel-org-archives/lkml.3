Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab3FVLru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 07:47:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43751 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3FVLrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 07:47:48 -0400
Date: Sat, 22 Jun 2013 13:47:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: linux-bcache@vger.kernel.org, koverstreet@google.com
Subject: bcache: order 7 allocation
Message-ID: <20130622114745.GB8075@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm trying to play with bcache, but first surprise was oom in syslog:

Order 7 alocation is pretty big, no?

								Pavel

bcache: register_bdev() registered backing device sda4
bcache: register_bcache() error opening /dev/sdb1: Not a bcache
superblock
bash: page allocation failure: order:7, mode:0x80d0
CPU: 0 PID: 4091 Comm: bash Tainted: G        W    3.10.0-rc6+ #266
Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD3WW (2.14 )
10/04/2007
 00000000 ebaabd5c c09597dc ebaabd8c c02a8550 c0b2b094 f4588950
 00000007
 000080d0 00000000 01000000 c0c7c580 00000001 00000001 00000000
 ebaabe24
 c02a9d36 000080d0 00000007 00000000 c0c7bbc0 00000000 00000001
 ebaabe16
Call Trace:
 [<c09597dc>] dump_stack+0x16/0x18
 [<c02a8550>] warn_alloc_failed+0xc0/0x100
 [<c02a9d36>] __alloc_pages_nodemask+0x4d6/0x6f0
 [<c02a9fc7>] __get_free_pages+0x17/0x30
 [<c06e91c4>] register_cache+0x3e4/0x5d0
 [<c02cff58>] ? cache_alloc_debugcheck_after+0x68/0x220
 [<c02d18aa>] ? kmem_cache_alloc+0xfa/0x100
 [<c06e985f>] ? register_bcache+0x4af/0xc10
 [<c06e987b>] register_bcache+0x4cb/0xc10
 [<c027c086>] ? __lock_acquire+0x386/0xcf0
 [<c0329f63>] ? sysfs_write_file+0x83/0xf0
 [<c06e93b0>] ? register_cache+0x5d0/0x5d0
 [<c0445a10>] kobj_attr_store+0x20/0x30
 [<c0329f79>] sysfs_write_file+0x99/0xf0
 [<c02d6080>] vfs_write+0xb0/0x190
 [<c0329ee0>] ? sysfs_open_file+0x1e0/0x1e0
 [<c02d6251>] SyS_write+0x51/0x90
 [<c095d7f8>] sysenter_do_call+0x12/0x31
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:  20
active_anon:91768 inactive_anon:47794 isolated_anon:0
 active_file:48599 inactive_file:14374 isolated_file:0
 unevictable:4 dirty:111 writeback:0 unstable:0
 free:127541 slab_reclaimable:155598 slab_unreclaimable:22989
 mapped:23527 shmem:24489 pagetables:1391 bounce:0
 free_cma:0
DMA free:1580kB min:4kB low:4kB high:4kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:15992kB managed:1580kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 850 2000 2000
Normal free:55600kB min:3724kB low:4652kB high:5584kB
active_anon:14408kB inactive_anon:14416kB active_file:28384kB
inactive_file:28344kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:892920kB managed:870564kB mlocked:0kB
dirty:408kB writeback:0kB mapped:64kB shmem:17620kB
slab_reclaimable:622392kB slab_unreclaimable:91956kB
kernel_stack:2736kB pagetables:5564kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 9206 9206
HighMem free:452984kB min:512kB low:1772kB high:3032kB
active_anon:352664kB inactive_anon:176844kB active_file:166012kB
inactive_file:29152kB unevictable:16kB isolated(anon):0kB
isolated(file):0kB present:1178440kB managed:1178440kB mlocked:16kB
dirty:36kB writeback:0kB mapped:94044kB shmem:80336kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB (U) 1*8kB (U) 0*16kB 1*32kB (U) 2*64kB (U) 1*128kB (U)
1*256kB (U) 0*512kB 1*1024kB (U) 0*2048kB 0*4096kB = 1580kB
Normal: 12737*4kB (EM) 464*8kB (UEMR) 7*16kB (UMR) 1*32kB (R) 1*64kB
(R) 2*128kB (R) 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB =
55636kB
HighMem: 20470*4kB (UEMR) 17082*8kB (UEMR) 8461*16kB (UEMR) 2331*32kB
(UEMR) 325*64kB (UEMR) 22*128kB (UEMR) 3*256kB (UE) 0*512kB 0*1024kB
0*2048kB 0*4096kB = 452888kB
87500 total pagecache pages
20 pages in swap cache
Swap cache stats: add 863, delete 843, find 13/17
Free swap  = 775840kB
Total swap = 779148kB
521935 pages RAM
294610 pages HighMem
9299 pages reserved
747603 pages shared
322744 pages non-shared
bcache: register_cache() error opening sdb1: cannot allocate memory
bashged:1580kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB
shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
