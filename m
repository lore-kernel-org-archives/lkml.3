Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3LBWvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:51:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3LBWvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:51:06 -0500
Date: Mon, 2 Dec 2013 14:51:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 4/9] mm/rmap: make rmap_walk to get the
 rmap_walk_control argument
Message-Id: <20131202145105.c8027647503eece9a099462f@linux-foundation.org>
In-Reply-To: <1386014973-h0zadm1f-mutt-n-horiguchi@ah.jp.nec.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1385624926-28883-5-git-send-email-iamjoonsoo.kim@lge.com>
	<1386014973-h0zadm1f-mutt-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Dec 2013 15:09:33 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -235,11 +235,16 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page);
> >  void page_unlock_anon_vma_read(struct anon_vma *anon_vma);
> >  int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
> >  
> > +struct rmap_walk_control {
> > +	int (*main)(struct page *, struct vm_area_struct *,
> > +					unsigned long, void *);
> 
> Maybe you can add parameters' names to make this prototype more readable.
> 

Yes, I find it quite maddening when the names are left out.  They're really
very useful for understanding what's going on.

The name "main" seems odd as well.  What does "main" mean?  "rmap_one"
was better, but "rmap_one_page" or "rmap_one_pte" or whatever would
be better.
