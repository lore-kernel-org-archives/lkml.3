Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab3DEJsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:48:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39817 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3DEJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:48:36 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <515E9DC5.4050402@jp.fujitsu.com>
Date: Fri, 05 Apr 2013 18:47:49 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] THP: fix comment about memory barrier
References: <1365149799-839-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1365149799-839-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/05 17:16), Minchan Kim wrote:
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
>          	*A = a;
>          	LOCK
>          	UNLOCK
>          	*B = b;
> 
> 	may occur as:
> 
>          	LOCK, STORE *B, STORE *A, UNLOCK
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

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



