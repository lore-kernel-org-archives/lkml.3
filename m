Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3CAWeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 17:34:23 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:50685 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3CAWeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 17:34:22 -0500
Date: Fri, 1 Mar 2013 14:33:38 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Simon Jeons <simon.jeons@gmail.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] add extra free kbytes tunable
In-Reply-To: <51307583.2020006@gmail.com>
Message-ID: <alpine.LNX.2.00.1303011431290.9961@eggly.anvils>
References: <alpine.DEB.2.02.1302111734090.13090@dflat> <A5ED84D3BB3A384992CBB9C77DEDA4D414A98EBF@USINDEM103.corp.hds.com> <511EB5CB.2060602@redhat.com> <alpine.DEB.2.02.1302171546120.10836@dflat> <20130219152936.f079c971.akpm@linux-foundation.org>
 <alpine.DEB.2.02.1302192100100.23162@dflat> <20130222175634.GA4824@cmpxchg.org> <51307354.5000401@gmail.com> <51307583.2020006@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013, Simon Jeons wrote:
> On 03/01/2013 05:22 PM, Simon Jeons wrote:
> > On 02/23/2013 01:56 AM, Johannes Weiner wrote:
> > > Mapped file pages have to get scanned twice before they are reclaimed
> > > because we don't have enough usage information after the first scan.
> > 
> > It seems that just VM_EXEC mapped file pages are protected.
> > Issue in page reclaim subsystem:
> > static inline int page_is_file_cache(struct page *page)
> > {
> >     return !PageSwapBacked(page);
> > }
> > AFAIK, PG_swapbacked is set if anonymous page added to swap cache, and be
> > cleaned if removed from swap cache. So anonymous pages which are reclaimed
> > and add to swap cache won't have this flag, then they will be treated as
> 
> s/are/aren't

PG_swapbacked != PG_swapcache
