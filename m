Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaGYMSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:18:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaGYMSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:18:24 -0400
Date: Fri, 25 Jul 2014 13:18:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH V4 01/15] mm, THP: don't hold mmap_sem in khugepaged when
 allocating THP
Message-ID: <20140725121815.GV10819@suse.de>
References: <1405518503-27687-1-git-send-email-vbabka@suse.cz>
 <1405518503-27687-2-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1405518503-27687-2-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:48:09PM +0200, Vlastimil Babka wrote:
> When allocating huge page for collapsing, khugepaged currently holds mmap_sem
> for reading on the mm where collapsing occurs. Afterwards the read lock is
> dropped before write lock is taken on the same mmap_sem.
> 
> Holding mmap_sem during whole huge page allocation is therefore useless, the
> vma needs to be rechecked after taking the write lock anyway. Furthemore, huge
> page allocation might involve a rather long sync compaction, and thus block
> any mmap_sem writers and i.e. affect workloads that perform frequent m(un)map
> or mprotect oterations.
> 
> This patch simply releases the read lock before allocating a huge page. It
> also deletes an outdated comment that assumed vma must be stable, as it was
> using alloc_hugepage_vma(). This is no longer true since commit 9f1b868a13
> ("mm: thp: khugepaged: add policy for finding target node").
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
