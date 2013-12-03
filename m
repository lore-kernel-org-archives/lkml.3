Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3LCCAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:00:54 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49678 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3LCCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:00:51 -0500
X-AuditID: 9c93017e-b7c62ae0000049d9-ab-529d3b51d384
Date: Tue, 3 Dec 2013 11:03:16 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/9] mm/rmap: make rmap_walk to get the rmap_walk_control
 argument
Message-ID: <20131203020316.GB31168@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1385624926-28883-5-git-send-email-iamjoonsoo.kim@lge.com>
 <1386014973-h0zadm1f-mutt-n-horiguchi@ah.jp.nec.com>
 <20131202145105.c8027647503eece9a099462f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202145105.c8027647503eece9a099462f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 02:51:05PM -0800, Andrew Morton wrote:
> On Mon, 02 Dec 2013 15:09:33 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > > --- a/include/linux/rmap.h
> > > +++ b/include/linux/rmap.h
> > > @@ -235,11 +235,16 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page);
> > >  void page_unlock_anon_vma_read(struct anon_vma *anon_vma);
> > >  int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
> > >  
> > > +struct rmap_walk_control {
> > > +	int (*main)(struct page *, struct vm_area_struct *,
> > > +					unsigned long, void *);
> > 
> > Maybe you can add parameters' names to make this prototype more readable.
> > 
> 
> Yes, I find it quite maddening when the names are left out.  They're really
> very useful for understanding what's going on.

Okay. Will do.

> 
> The name "main" seems odd as well.  What does "main" mean?  "rmap_one"
> was better, but "rmap_one_page" or "rmap_one_pte" or whatever would
> be better.

Okay. I will think better name.

Thanks.
