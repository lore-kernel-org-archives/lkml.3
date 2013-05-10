Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3EJJwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:52:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3EJJwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:52:16 -0400
Date: Fri, 10 May 2013 10:52:12 +0100
From: Mel Gorman <mgorman@suse.de>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: riel@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] COMPACTION: bugfix of improper cache flush in MIGRATION
 code.
Message-ID: <20130510095212.GM11497@suse.de>
References: <20130509001821.15951.98705.stgit@linux-yegoshin>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130509001821.15951.98705.stgit@linux-yegoshin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 05:18:21PM -0700, Leonid Yegoshin wrote:
> Page 'new' during MIGRATION can't be flushed by flush_cache_page().
> Using flush_cache_page(vma, addr, pfn) is justified only if
> page is already placed in process page table, and that is done right
> after flush_cache_page(). But without it the arch function has
> no knowledge of process PTE and does nothing.
> 
> Besides that, flush_cache_page() flushes an application cache,
> kernel has a different page virtual address and dirtied it.
> 
> Replace it with flush_dcache_page(new) which is a proper usage.
> 
> Old page is flushed in try_to_unmap_one() before MIGRATION.
> 
> This bug takes place in Sead3 board with M14Kc MIPS CPU without
> cache aliasing (but Harvard arch - separate I and D cache)
> in tight memory environment (128MB) each 1-3days on SOAK test.
> It fails in cc1 during kernel build (SIGILL, SIGBUS, SIGSEG) if
> CONFIG_COMPACTION is switched ON.
> 
> Author: Leonid Yegoshin <yegoshin@mips.com>
> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
