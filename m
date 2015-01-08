Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbbAHNpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:45:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57824 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbbAHNpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:45:31 -0500
Date: Thu, 8 Jan 2015 13:45:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Langsdorf <mlangsdo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150108134520.GC14200@e104818-lin.cambridge.arm.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
 <54AE7D53.2020305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AE7D53.2020305@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 12:51:31PM +0000, Mark Langsdorf wrote:
> On 01/05/2015 07:46 PM, Linus Torvalds wrote:
> > It's a day delayed - not because of any particular development issues,
> > but simply because I was tiling a bathroom yesterday. But rc3 is out
> > there now, and things have stayed reasonably calm. I really hope that
> > implies that 3.19 is looking good, but it's equally likely that it's
> > just that people are still recovering from the holiday season.
> 
> I'm consistently getting an out of memory killer triggered when
> compiling the kernel (make -j 16 -s) on a 16 core ARM64 system
> with 16 GB of memory. This doesn't happen when running a 3.18
> kernel.
> 
> I'm going to start bisecting the failure now, but here's the crash
> log in case someone can see something obvious in it.
[...]
> [ 1053.968815] active_anon:207417 inactive_anon:25722 isolated_anon:0
> [ 1053.968815]  active_file:1300 inactive_file:21234 isolated_file:0
> [ 1053.968815]  unevictable:0 dirty:0 writeback:0 unstable:0
> [ 1053.968815]  free:1014 slab_reclaimable:1047 slab_unreclaimable:1758
> [ 1053.968815]  mapped:733 shmem:58 pagetables:267 bounce:0
> [ 1053.968815]  free_cma:1
> [ 1054.000398] DMA free:52928kB min:4032kB low:4992kB high:6016kB
> active_anon:3025728kB inactive_anon:612608kB active_file:20992kB
> inactive_file:323072kB unevictable:0kB isolated(anon):0kB
> isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB
> dirty:0kB writeback:0kB mapped:15168kB shmem:1792kB
> slab_reclaimable:26368kB slab_unreclaimable:36160kB kernel_stack:464kB
> pagetables:6976kB unstable:0kB bounce:0kB free_cma:64kB
> writeback_tmp:0kB pages_scanned:26151872 all_unreclaimable? yes
> [ 1054.043628] lowmem_reserve[]: 0 765 765
> [ 1054.047498] Normal free:12032kB min:12224kB low:15232kB high:18304kB
> active_anon:10248960kB inactive_anon:1033728kB active_file:62208kB
> inactive_file:1036032kB unevictable:0kB isolated(anon):0kB
> isolated(file):0kB present:12582912kB managed:12538176kB mlocked:0kB
> dirty:0kB writeback:0kB mapped:31744kB shmem:1920kB
> slab_reclaimable:40640kB slab_unreclaimable:76352kB kernel_stack:2992kB
> pagetables:10112kB unstable:0kB bounce:0kB free_cma:0kB
> writeback_tmp:0kB pages_scanned:82150272 all_unreclaimable? yes
> [ 1054.091760] lowmem_reserve[]: 0 0 0
> [ 1054.095277] DMA: 109*64kB (UR) 53*128kB (R) 8*256kB (R) 0*512kB
> 0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R)
> 0*65536kB = 52672kB
> [ 1054.108621] Normal: 191*64kB (MR) 0*128kB 0*256kB 0*512kB 0*1024kB
> 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 12224kB
> [ 1054.120708] Node 0 hugepages_total=0 hugepages_free=0
> hugepages_surp=0 hugepages_size=524288kB
> [ 1054.129280] 43732 total pagecache pages
> [ 1054.133096] 25736 pages in swap cache
> [ 1054.136739] Swap cache stats: add 27971, delete 2235, find 0/1
> [ 1054.142545] Free swap  = 6598400kB
> [ 1054.145928] Total swap = 8388544kB
> [ 1054.149317] 262112 pages RAM
> [ 1054.152180] 0 pages HighMem/MovableOnly
> [ 1054.155995] 18446744073709544361 pages reserved

This looks weird (pages reserved = -7255).

Can you disable (transparent) huge pages? I don't have any better at the
moment suggestion apart from bisecting.

-- 
Catalin
