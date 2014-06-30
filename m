Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaF3WAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:00:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaF3WAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:00:37 -0400
Date: Mon, 30 Jun 2014 23:00:33 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] shmem: fix init_page_accessed use to stop !PageLRU
 bug
Message-ID: <20140630220033.GS10819@suse.de>
References: <alpine.LSU.2.11.1406301405230.1096@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1406301405230.1096@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 02:08:11PM -0700, Hugh Dickins wrote:
> Under shmem swapping load, I sometimes hit the VM_BUG_ON_PAGE(!PageLRU)
> in isolate_lru_pages() at mm/vmscan.c:1281!
> 
> Commit 2457aec63745 ("mm: non-atomically mark page accessed during page
> cache allocation where possible") looks like interrupted work-in-progress.
> 
> mm/filemap.c's call to init_page_accessed() is fine, but not mm/shmem.c's
> - shmem_write_begin() is clearly wrong to use it after shmem_getpage(),
> when the page is always visible in radix_tree, and often already on LRU.
> 
> Revert change to shmem_write_begin(), and use init_page_accessed() or
> mark_page_accessed() appropriately for SGP_WRITE in shmem_getpage_gfp().
> 
> SGP_WRITE also covers shmem_symlink(), which did not mark_page_accessed()
> before; but since many other filesystems use [__]page_symlink(), which did
> and does mark the page accessed, consider this as rectifying an oversight.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
