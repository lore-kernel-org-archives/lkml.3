Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3KZJ3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:29:38 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36504 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3KZJ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:29:34 -0500
Message-ID: <1385458169.6721.2.camel@phoenix>
Subject: ARM: nommu: Unable to allocate RAM for process text/data, errno 12
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 26 Nov 2013 17:29:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I got below error messages while starting mdev (busybox).

/ # free
             total         used         free       shared      buffers
Mem:         23628         8924        14704            0           72
-/+ buffers:               8852        14776

/ # exec /sbin/init
Starting logging: OK
Starting mdev...
[  108.537109] chmod: page allocation failure: order:8, mode:0xd0
[  108.543945] CPU: 0 PID: 47 Comm: chmod Not tainted 3.13.0-rc1-00170-g1bab531-dirty #1940
[  108.580078] [<0000c430>] (unwind_backtrace+0x0/0xe0) from [<0000ae58>] (show_stack+0x10/0x14)
[  108.592773] [<0000ae58>] (show_stack+0x10/0x14) from [<00050010>] (warn_alloc_failed+0xf8/0x128)
[  108.605468] [<00050010>] (warn_alloc_failed+0xf8/0x128) from [<00052030>] (__alloc_pages_nodemask+0x64c/0x6c4)
[  108.620117] [<00052030>] (__alloc_pages_nodemask+0x64c/0x6c4) from [<0005f028>] (do_mmap_pgoff+0x5d0/0x9b0)
[  108.633789] [<0005f028>] (do_mmap_pgoff+0x5d0/0x9b0) from [<0005ac04>] (vm_mmap_pgoff+0x64/0x7c)
[  108.647460] [<0005ac04>] (vm_mmap_pgoff+0x64/0x7c) from [<0009e6e8>] (load_flat_binary+0x38c/0xa0c)
[  108.660156] [<0009e6e8>] (load_flat_binary+0x38c/0xa0c) from [<0006bc40>] (search_binary_handler+0x4c/0xa4)
[  108.676757] [<0006bc40>] (search_binary_handler+0x4c/0xa4) from [<0006bfc8>] (do_execve+0x330/0x4e8)
[  108.689453] [<0006bfc8>] (do_execve+0x330/0x4e8) from [<0006c3c4>] (SyS_execve+0x30/0x44)
[  108.701171] [<0006c3c4>] (SyS_execve+0x30/0x44) from [<00008f40>] (ret_fast_syscall+0x0/0x44)
[  108.712890] Mem-info:
[  108.715820] Normal per-cpu:
[  108.720703] CPU    0: hi:    0, btch:   1 usd:   0
[  108.730468] active_anon:0 inactive_anon:0 isolated_anon:0
[  108.730468]  active_file:38 inactive_file:69 isolated_file:0
[  108.730468]  unevictable:3 dirty:7 writeback:0 unstable:0
[  108.730468]  free:2897 slab_reclaimable:171 slab_unreclaimable:436
[  108.730468]  mapped:0 shmem:0 pagetables:0 bounce:0
[  108.730468]  free_cma:0
[  108.767578] Normal free:11588kB min:612kB low:764kB high:916kB active_anon:0kB inactive_anon:0kB active_file:152kB inactive_file:276kB unevictable:o
[  108.810546] lowmem_reserve[]: 0 0
[  108.817382] Normal: 41*4kB (UMR) 30*8kB (UMR) 43*16kB (UM) 22*32kB (UEM) 17*64kB (UEM) 12*128kB (UM) 16*256kB (UEMR) 6*512kB (UM) 0*1024kB 0*2048kBB
[  108.837890] 110 total pagecache pages
[  108.880859] 8192 pages of RAM
[  108.884765] 2923 free pages
[  108.889648] 2285 reserved pages
[  108.893554] 505 slab pages
[  108.896484] 24 pages shared
[  108.902343] 0 pages swap cached
[  108.906249] Allocation of length 774144 from process 47 (chmod) failed
[  108.915039] Normal per-cpu:
[  108.918945] CPU    0: hi:    0, btch:   1 usd:   0
[  108.927734] active_anon:0 inactive_anon:0 isolated_anon:0
[  108.927734]  active_file:38 inactive_file:69 isolated_file:0
[  108.927734]  unevictable:3 dirty:7 writeback:0 unstable:0
[  108.927734]  free:2897 slab_reclaimable:171 slab_unreclaimable:436
[  108.927734]  mapped:0 shmem:0 pagetables:0 bounce:0
[  108.927734]  free_cma:0
[  108.964843] Normal free:11588kB min:612kB low:764kB high:916kB active_anon:0kB inactive_anon:0kB active_file:152kB inactive_file:276kB unevictable:o
[  109.007812] lowmem_reserve[]: 0 0
[  109.012695] Normal: 41*4kB (UMR) 30*8kB (UMR) 43*16kB (UM) 22*32kB (UEM) 17*64kB (UEM) 12*128kB (UM) 16*256kB (UEMR) 6*512kB (UM) 0*1024kB 0*2048kBB
[  109.034179] 110 total pagecache pages
[  109.041015] Unable to allocate RAM for process text/data, errno 12
ILL
[  116.480468] chmod: page allocation failure: order:8, mode:0xd0
[  116.490234] CPU: 0 PID: 49 Comm: chmod Not tainted 3.13.0-rc1-00170-g1bab531-dirty #1940
[  116.502929] [<0000c430>] (unwind_backtrace+0x0/0xe0) from [<0000ae58>] (show_stack+0x10/0x14)
[  116.515624] [<0000ae58>] (show_stack+0x10/0x14) from [<00050010>] (warn_alloc_failed+0xf8/0x128)
[  116.530273] [<00050010>] (warn_alloc_failed+0xf8/0x128) from [<00052030>] (__alloc_pages_nodemask+0x64c/0x6c4)
[  116.543945] [<00052030>] (__alloc_pages_nodemask+0x64c/0x6c4) from [<0005f028>] (do_mmap_pgoff+0x5d0/0x9b0)
[  116.558593] [<0005f028>] (do_mmap_pgoff+0x5d0/0x9b0) from [<0005ac04>] (vm_mmap_pgoff+0x64/0x7c)
[  116.572265] [<0005ac04>] (vm_mmap_pgoff+0x64/0x7c) from [<0009e6e8>] (load_flat_binary+0x38c/0xa0c)
[  116.585937] [<0009e6e8>] (load_flat_binary+0x38c/0xa0c) from [<0006bc40>] (search_binary_handler+0x4c/0xa4)
[  116.599609] [<0006bc40>] (search_binary_handler+0x4c/0xa4) from [<0006bfc8>] (do_execve+0x330/0x4e8)
[  116.614257] [<0006bfc8>] (do_execve+0x330/0x4e8) from [<0006c3c4>] (SyS_execve+0x30/0x44)
[  116.625976] [<0006c3c4>] (SyS_execve+0x30/0x44) from [<00008f40>] (ret_fast_syscall+0x0/0x44)
[  116.637695] Mem-info:
[  116.639648] Normal per-cpu:
[  116.643554] CPU    0: hi:    0, btch:   1 usd:   0
[  116.652343] active_anon:0 inactive_anon:0 isolated_anon:0
[  116.652343]  active_file:36 inactive_file:57 isolated_file:0
[  116.652343]  unevictable:3 dirty:7 writeback:0 unstable:0
[  116.652343]  free:2872 slab_reclaimable:204 slab_unreclaimable:437
[  116.652343]  mapped:0 shmem:0 pagetables:0 bounce:0
[  116.652343]  free_cma:0
[  116.691406] Normal free:11488kB min:612kB low:764kB high:916kB active_anon:0kB inactive_anon:0kB active_file:144kB inactive_file:228kB unevictable:o
[  116.734374] lowmem_reserve[]: 0 0
[  116.738281] Normal: 38*4kB (UEMR) 35*8kB (UEMR) 47*16kB (UEM) 22*32kB (UM) 16*64kB (UEM) 13*128kB (UEM) 15*256kB (UEMR) 6*512kB (UM) 0*1024kB 0*204B
[  116.759765] 96 total pagecache pages
[  116.801757] 8192 pages of RAM
[  116.807617] 2898 free pages
[  116.810546] 2285 reserved pages
[  116.814453] 539 slab pages
[  116.819335] 22 pages shared
[  116.822265] 0 pages swap cached
[  116.828124] Allocation of length 774144 from process 49 (chmod) failed
[  116.834960] Normal per-cpu:
[  116.840820] CPU    0: hi:    0, btch:   1 usd:   0
[  116.847656] active_anon:0 inactive_anon:0 isolated_anon:0
[  116.847656]  active_file:36 inactive_file:57 isolated_file:0
[  116.847656]  unevictable:3 dirty:7 writeback:0 unstable:0
[  116.847656]  free:2872 slab_reclaimable:204 slab_unreclaimable:437
[  116.847656]  mapped:0 shmem:0 pagetables:0 bounce:0
[  116.847656]  free_cma:0
[  116.884765] Normal free:11488kB min:612kB low:764kB high:916kB active_anon:0kB inactive_anon:0kB active_file:144kB inactive_file:228kB unevictable:o
[  116.927734] lowmem_reserve[]: 0 0
[  116.932617] Normal: 38*4kB (UEMR) 35*8kB (UEMR) 47*16kB (UEM) 22*32kB (UM) 16*64kB (UEM) 13*128kB (UEM) 15*256kB (UEMR) 6*512kB (UM) 0*1024kB 0*204B
[  116.953124] 96 total pagecache pages
[  116.959960] Unable to allocate RAM for process text/data, errno 12
ILL

Why it got page allocation failure?
Does that mean it run into OOM?
Seem the system still has enough memory available.

Regards,
Axel


