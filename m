Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab3GCSnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:43:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45382 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab3GCSmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:42:51 -0400
Date: Wed, 3 Jul 2013 20:42:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] mm: numa: Scan pages with elevated page_mapcount
Message-ID: <20130703184213.GE18898@dyad.programming.kicks-ass.net>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-13-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372861300-9973-13-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 03:21:39PM +0100, Mel Gorman wrote:
> @@ -1587,10 +1588,11 @@ int migrate_misplaced_page(struct page *page, int node)
>  	LIST_HEAD(migratepages);
>  
>  	/*
> +	 * Don't migrate file pages that are mapped in multiple processes
> +	 * with execute permissions as they are probably shared libraries.
>  	 */
> +	if (page_mapcount(page) != 1 && page_is_file_cache(page) &&
> +	    (vma->vm_flags & VM_EXEC))
>  		goto out;

So we will migrate DSOs that are mapped but once. That's fair enough I suppose.
