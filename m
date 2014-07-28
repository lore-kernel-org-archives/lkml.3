Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaG1XjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:39:10 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:50666 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaG1XjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:39:07 -0400
Date: Mon, 28 Jul 2014 16:39:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 01/14] mm, THP: don't hold mmap_sem in khugepaged when
 allocating THP
In-Reply-To: <1406553101-29326-2-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1407281638410.8998@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-2-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Vlastimil Babka wrote:

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
> using alloc_hugepage_vma(). This is no longer true since commit 9f1b868a13ac
> ("mm: thp: khugepaged: add policy for finding target node").
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Acked-by: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>
