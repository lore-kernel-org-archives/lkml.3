Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaIFPpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:45:46 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:40461 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaIFPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:45:44 -0400
Date: Sat, 6 Sep 2014 08:45:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linuxfoundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 5: build failure due to 'mm: introduce
 dump_vma'
Message-ID: <20140906154535.GA14790@roeck-us.net>
References: <20140905165052.GF29327@sirena.org.uk>
 <20140906154309.GB25739@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906154309.GB25739@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 08:43:09AM -0700, Guenter Roeck wrote:
> I see the following build failure in next-20140905.
> 
> Guenter
> 
> ---
> 
> Building tile:tilegx_defconfig ... failed

Also:

Building powerpc:allmodconfig ... failed
Building powerpc:ppc6xx_defconfig ... failed

with the same error.

> --------------
> Error log:
> mm/page_alloc.c: In function 'dump_vma':
> mm/page_alloc.c:6742:46: error: 'pgprot_t' has no member named 'pgprot'
> make[1]: *** [mm/page_alloc.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [mm] Error 2
> make: *** Waiting for unfinished jobs....
> --------------
> 
> bisect results:
> 
> d1305f0fa17f1d3e659a8aa2134610a1a6884f77 is the first bad commit
> commit d1305f0fa17f1d3e659a8aa2134610a1a6884f77
> Author: Sasha Levin <sasha.levin@oracle.com>
> Date:   Fri Sep 5 16:58:49 2014 +0100
> 
>     mm: introduce dump_vma
>     
>     Introduce a helper to dump information about a VMA, this also makes
>     dump_page_flags more generic and re-uses that so the output looks very
>     similar to dump_page:
>     
>     [   61.903437] vma ffff88070f88be00 start 00007fff25970000 end 00007fff25992000
>     [   61.903437] next ffff88070facd600 prev ffff88070face400 mm ffff88070fade000
>     [   61.903437] prot 8000000000000025 anon_vma ffff88070fa1e200 vm_ops           (null)
>     [   61.903437] pgoff 7ffffffdd file           (null) private_data           (null)
>     [   61.909129] flags: 0x100173(read|write|mayread|maywrite|mayexec|growsdown|account)
>     
>     Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>     Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>     Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>     Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
>     Cc: Rik van Riel <riel@redhat.com>
>     Cc: Mel Gorman <mgorman@suse.de>
>     Cc: Michal Hocko <mhocko@suse.cz>
>     Cc: Hugh Dickins <hughd@google.com>
>     Cc: Vlastimil Babka <vbabka@suse.cz>
>     Cc: Michel Lespinasse <walken@google.com>
>     Cc: Minchan Kim <minchan@kernel.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> 
> ---
> bisect log:
> 
> # bad: [92d88cb068a5dc66d53ef017999b2419b125f764] Add linux-next specific files for 20140905
> # good: [69e273c0b0a3c337a521d083374c918dc52c666f] Linux 3.17-rc3
> git bisect start 'HEAD' 'v3.17-rc3'
> # good: [9ecc6d43871f92e01c8aafa9563538ed92825778] Merge remote-tracking branch 'drm/drm-next'
> git bisect good 9ecc6d43871f92e01c8aafa9563538ed92825778
> # good: [578445255f94602a32d2a05f38c983319e2e2c0c] Merge remote-tracking branch 'usb-gadget/next'
> git bisect good 578445255f94602a32d2a05f38c983319e2e2c0c
> # good: [db1afd18e9cddffd957abea6287a6eae9edbeccc] staging: vt6655: replace typedef struct tagSCTS_FB with struct vnt_cts_fb
> git bisect good db1afd18e9cddffd957abea6287a6eae9edbeccc
> # good: [4b3423832f2d1cbb988b18c96d39474029a6156b] Merge remote-tracking branch 'llvmlinux/for-next'
> git bisect good 4b3423832f2d1cbb988b18c96d39474029a6156b
> # bad: [d1305f0fa17f1d3e659a8aa2134610a1a6884f77] mm: introduce dump_vma
> git bisect bad d1305f0fa17f1d3e659a8aa2134610a1a6884f77
> # good: [1eb2bc2558fecb3eb78114dbcc433d0e2e390372] mm/slab: move cache_flusharray() out of unlikely.text section
> git bisect good 1eb2bc2558fecb3eb78114dbcc433d0e2e390372
> # good: [1d414c4d9f077af5dd20135f135a498176b564a5] mm, compaction: skip buddy pages by their order in the migrate scanner
> git bisect good 1d414c4d9f077af5dd20135f135a498176b564a5
> # good: [05e2a5f419c0c5888bce1aeda4ffe89f7657e0a6] mempolicy: fix show_numa_map() vs exec() + do_set_mempolicy() race
> git bisect good 05e2a5f419c0c5888bce1aeda4ffe89f7657e0a6
> # good: [41da4bf4788f47cb1f0801562e378e549c7b350a] selftests/vm/transhuge-stress: stress test for memory compaction
> git bisect good 41da4bf4788f47cb1f0801562e378e549c7b350a
> # good: [6dd0fc5ec52ec2a0ae3a1c4e6816434c18052420] mm/balloon_compaction: general cleanup
> git bisect good 6dd0fc5ec52ec2a0ae3a1c4e6816434c18052420
> # good: [ada687f364aa0ffaebe5a66bd0b89af97e53a587] mm-balloon_compaction-general-cleanup-checkpatch-fixes
> git bisect good ada687f364aa0ffaebe5a66bd0b89af97e53a587
> # good: [834259904e3b9a9fd6409b9a38aa608158467822] mm/slab.c: use __seq_open_private() instead of seq_open()
> git bisect good 834259904e3b9a9fd6409b9a38aa608158467822
> # first bad commit: [d1305f0fa17f1d3e659a8aa2134610a1a6884f77] mm: introduce dump_vma
