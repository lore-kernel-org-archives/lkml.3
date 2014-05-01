Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaEAVCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:02:05 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50232 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaEAVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:02:03 -0400
Date: Thu, 1 May 2014 14:02:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, vbabka@suse.cz, iamjoonsoo.kim@lge.com,
        gthelen@google.com, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 2/2] mm, compaction: return failed migration target pages
 back to freelist
In-Reply-To: <5361dae9.4781e00a.74f8.ffff8c8eSMTPIN_ADDED_BROKEN@mx.google.com>
Message-ID: <alpine.DEB.2.02.1405011401040.32268@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1404301744400.8415@chino.kir.corp.google.com> <5361dae9.4781e00a.74f8.ffff8c8eSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Naoya Horiguchi wrote:

> > diff --git a/mm/compaction.c b/mm/compaction.c
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -797,6 +797,19 @@ static struct page *compaction_alloc(struct page *migratepage,
> >  }
> >  
> >  /*
> > + * This is a migrate-callback that "frees" freepages back to the isolated
> > + * freelist.  All pages on the freelist are from the same zone, so there is no
> > + * special handling needed for NUMA.
> > + */
> > +static void compaction_free(struct page *page, unsigned long data)
> > +{
> > +	struct compact_control *cc = (struct compact_control *)data;
> > +
> > +	list_add(&page->lru, &cc->freepages);
> > +	cc->nr_freepages++;
> 
> With this change, migration_page() handles cc->nr_freepages consistently, so
> we don't have to run over freelist to update this count in update_nr_listpages()?
> 

Good optimization, I'll add it!
