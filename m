Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3LCCDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:03:16 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:45408 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3LCCDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:03:15 -0500
X-AuditID: 9c93017d-b7bb3ae0000068fd-10-529d3be177d8
Date: Tue, 3 Dec 2013 11:05:40 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/9] mm/rmap: extend rmap_walk_xxx() to cope with
 different cases
Message-ID: <20131203020540.GC31168@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1385624926-28883-6-git-send-email-iamjoonsoo.kim@lge.com>
 <1386014982-lfutnpr2-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386014982-lfutnpr2-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:09:42PM -0500, Naoya Horiguchi wrote:
> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > index 0f65686..58624b4 100644
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -239,6 +239,12 @@ struct rmap_walk_control {
> >  	int (*main)(struct page *, struct vm_area_struct *,
> >  					unsigned long, void *);
> >  	void *arg;	/* argument to main function */
> > +	int (*main_done)(struct page *page);	/* check exit condition */
> > +	int (*file_nonlinear)(struct page *, struct address_space *,
> > +					struct vm_area_struct *vma);
> > +	struct anon_vma *(*anon_lock)(struct page *);
> > +	int (*vma_skip)(struct vm_area_struct *, void *);
> 
> Can you add some comments about how these callbacks work and when it
> should be set to for future users?  For example, anon_lock() are
> used to override the default behavior and it's not trivial.

Okay. I will add.

> 
> > +	void *skip_arg;	/* argument to vma_skip function */
> 
> I think that it's better to move this field into the structure pointed
> to by arg (which can be defined by each caller in its own way) and pass
> arg to *vma_skip().

Will do.

Thanks.

> 
> Thanks,
> Naoya Horiguchi
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
