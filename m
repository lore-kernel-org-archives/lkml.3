Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3B0WNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:13:41 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:53131 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3B0WNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:13:40 -0500
Date: Wed, 27 Feb 2013 14:13:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, show_mem: suppress page counts in non-blockable
 contexts
In-Reply-To: <512E2B91.6000506@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1302271410230.7155@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1302261642520.11109@chino.kir.corp.google.com> <512E2B91.6000506@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013, Dave Hansen wrote:

> On 02/26/2013 04:46 PM, David Rientjes wrote:
> > diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > --- a/arch/arm/mm/init.c
> > +++ b/arch/arm/mm/init.c
> > @@ -99,6 +99,9 @@ void show_mem(unsigned int filter)
> >  	printk("Mem-info:\n");
> >  	show_free_areas(filter);
> > 
> > +	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
> > +		return;
> > +
> 
> Won't this just look like a funky truncated warning to the end user?
> 

No, because of the uninhibited call to show_free_areas() above.  This 
still dumps the pcp state, global and per-node page type breakdown, and 
free pages at given order.  The only things suppresses are the total 
pages, pages reserved, pages shared, and pages non-shared counts that are 
quite expensive to determine because it walks all memory while irqs are 
disabled and increases with the amount of RAM a system has.
