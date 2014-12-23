Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaLWEwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:52:12 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:39218 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbaLWEwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:52:11 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 23 Dec 2014 13:56:44 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] mm/debug-pagealloc: prepare boottime configurable
 on/off
Message-ID: <20141223045644.GA9176@js1304-P5Q-DELUXE>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1416816926-7756-3-git-send-email-iamjoonsoo.kim@lge.com>
 <1417091739.29407.95.camel@x220>
 <20141128073524.GC11802@js1304-P5Q-DELUXE>
 <1419239442.30945.5.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419239442.30945.5.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 10:10:42AM +0100, Paul Bolle wrote:
> Hi Joonsoo,
> 
> On Fri, 2014-11-28 at 16:35 +0900, Joonsoo Kim wrote:
> > Hello, Paul.
> > 
> > Thanks for spotting this.
> > I attach the patch. :)
> > 
> > Andrew,
> > Could you kindly fold this into the patch in your tree?
> > 
> > Thanks.
> > 
> > ------------------->8---------------
> > From a33c480160904cc93333807a448960151ac4c534 Mon Sep 17 00:00:00 2001
> > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Date: Fri, 28 Nov 2014 16:05:32 +0900
> > Subject: [PATCH] mm/debug_pagealloc: remove obsolete Kconfig options
> > 
> > These are obsolete since commit "mm/debug-pagealloc: prepare boottime
> > configurable" is merged. So, remove it.
> > 
> > [pebolle@tiscali.nl: find obsolete Kconfig options]
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> >  mm/Kconfig.debug |    9 ---------
> >  1 file changed, 9 deletions(-)
> > 
> > diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> > index 56badfc..957d3da 100644
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -14,7 +14,6 @@ config DEBUG_PAGEALLOC
> >  	depends on !KMEMCHECK
> >  	select PAGE_EXTENSION
> >  	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
> > -	select PAGE_GUARD if ARCH_SUPPORTS_DEBUG_PAGEALLOC
> >  	---help---
> >  	  Unmap pages from the kernel linear mapping after free_pages().
> >  	  This results in a large slowdown, but helps to find certain types
> > @@ -27,13 +26,5 @@ config DEBUG_PAGEALLOC
> >  	  that would result in incorrect warnings of memory corruption after
> >  	  a resume because free pages are not saved to the suspend image.
> >  
> > -config WANT_PAGE_DEBUG_FLAGS
> > -	bool
> > -
> >  config PAGE_POISONING
> >  	bool
> > -	select WANT_PAGE_DEBUG_FLAGS
> > -
> > -config PAGE_GUARD
> > -	bool
> > -	select WANT_PAGE_DEBUG_FLAGS
> 
> This patch didn't make it into v3.19-rc1. And I think it never entered
> linux-next. Did this fall through the cracks or was there some other
> issue with this patch?

Hello,

I guess that it is just missed.
I re-sent the patch to Andrew a while ago.

Thank you for reporting.

Thanks.
