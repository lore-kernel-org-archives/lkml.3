Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab3DZAVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 20:21:10 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51348 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab3DZAVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 20:21:09 -0400
X-AuditID: 9c930179-b7c28ae0000018a0-24-5179c872455e
Date: Fri, 26 Apr 2013 09:21:07 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] mm, highmem: remove useless virtual variable in
 page_address_map
Message-ID: <20130426002107.GA3075@lge.com>
References: <1366619188-28087-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130425150057.c25220a8f03e068f5bea5d58@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425150057.c25220a8f03e068f5bea5d58@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 03:00:57PM -0700, Andrew Morton wrote:
> On Mon, 22 Apr 2013 17:26:28 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > We can get virtual address without virtual field.
> > So remove it.
> > 
> > ...
> >
> > --- a/mm/highmem.c
> > +++ b/mm/highmem.c
> > @@ -320,7 +320,6 @@ EXPORT_SYMBOL(kunmap_high);
> >   */
> >  struct page_address_map {
> >  	struct page *page;
> > -	void *virtual;
> >  	struct list_head list;
> >  };
> >  
> > @@ -362,7 +361,10 @@ void *page_address(const struct page *page)
> >  
> >  		list_for_each_entry(pam, &pas->lh, list) {
> >  			if (pam->page == page) {
> > -				ret = pam->virtual;
> > +				int nr;
> > +
> > +				nr = pam - page_address_map;
> 
> Doesn't compile.  Presumably you meant page_address_maps.
> 
> I'll drop this - please resend if/when it has been runtime tested.

Sorry for that.
I'll resend when it has been runtime tested.

Thanks.

> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
