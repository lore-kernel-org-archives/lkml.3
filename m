Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162654Ab3DETw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:52:28 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34830 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162587Ab3DETw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:52:27 -0400
Date: Fri, 5 Apr 2013 12:52:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] THP: fix comment about memory barrier
In-Reply-To: <1365149799-839-1-git-send-email-minchan@kernel.org>
Message-ID: <alpine.DEB.2.02.1304051252100.21173@chino.kir.corp.google.com>
References: <1365149799-839-1-git-send-email-minchan@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013, Minchan Kim wrote:

> Now, memory barrier in __do_huge_pmd_anonymous_page doesn't work.
> Because lru_cache_add_lru uses pagevec so it could miss spinlock
> easily so above rule was broken so user might see inconsistent data.
> 
> I was not first person who pointed out the problem. Mel and Peter
> pointed out a few months ago and Peter pointed out further that
> even spin_lock/unlock can't make sure it.
> http://marc.info/?t=134333512700004
> 
> 	In particular:
> 
>         	*A = a;
>         	LOCK
>         	UNLOCK
>         	*B = b;
> 
> 	may occur as:
> 
>         	LOCK, STORE *B, STORE *A, UNLOCK
> 
> At last, Hugh pointed out that even we don't need memory barrier
> in there because __SetPageUpdate already have done it from
> Nick's [1] explicitly.
> 
> So this patch fixes comment on THP and adds same comment for
> do_anonymous_page, too because everybody except Hugh was missing
> that. It means we needs COMMENT about that.
> 
> [1] 0ed361dec "mm: fix PageUptodate data race"
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
