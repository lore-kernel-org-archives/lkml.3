Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaELU2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:28:19 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48842 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaELU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:28:17 -0400
Date: Mon, 12 May 2014 13:28:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm, compaction: properly signal and act upon lock and
 need_sched() contention
In-Reply-To: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1405121326080.961@chino.kir.corp.google.com>
References: <20140508051747.GA9161@js1304-P5Q-DELUXE> <1399904111-23520-1-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Vlastimil Babka wrote:

> diff --git a/mm/compaction.c b/mm/compaction.c
> index 83ca6f9..b34ab7c 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -222,6 +222,27 @@ static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
>  	return true;
>  }
>  
> +/*
> + * Similar to compact_checklock_irqsave() (see its comment) for places where
> + * a zone lock is not concerned.
> + *
> + * Returns false when compaction should abort.
> + */

I think we should have some sufficient commentary in the code that 
describes why we do this.

> +static inline bool compact_check_resched(struct compact_control *cc)
> +{

I'm not sure that compact_check_resched() is the appropriate name.  Sure, 
it specifies what the current implementation is, but what it's really 
actually doing is determining when compaction should abort prematurely.

Something like compact_should_abort()?
