Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaBEAOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:14:12 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63424 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaBEAOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:14:09 -0500
Date: Tue, 4 Feb 2014 16:14:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Holger Kiehl <Holger.Kiehl@dwd.de>, Christoph Lameter <cl@linux.com>,
        Rafael Aquini <aquini@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, page_alloc: make first_page visible before
 PageTail
In-Reply-To: <20140204160641.8f5d369eeb2d0318618d6d5f@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1402041613450.14962@chino.kir.corp.google.com>
References: <alpine.LRH.2.02.1401312037340.6630@diagnostix.dwd.de> <20140203122052.GC2495@dhcp22.suse.cz> <alpine.LRH.2.02.1402031426510.13382@diagnostix.dwd.de> <20140203162036.GJ2495@dhcp22.suse.cz> <52EFC93D.3030106@suse.cz>
 <alpine.DEB.2.02.1402031602060.10778@chino.kir.corp.google.com> <alpine.LRH.2.02.1402040713220.13901@diagnostix.dwd.de> <alpine.DEB.2.02.1402041557380.10140@chino.kir.corp.google.com> <20140204160641.8f5d369eeb2d0318618d6d5f@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Andrew Morton wrote:

> > Commit bf6bddf1924e ("mm: introduce compaction and migration for ballooned 
> > pages") introduces page_count(page) into memory compaction which 
> > dereferences page->first_page if PageTail(page).
> > 
> > Introduce a store memory barrier to ensure page->first_page is properly 
> > initialized so that code that does page_count(page) on pages off the lru 
> > always have a valid p->first_page.
> 
> Could we have a code comment please?  Even checkpatch knows this rule!
> 

Ok.

> > Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
> 
> What did Holger report?
> 

A once-in-five-years NULL pointer dereference on the aforementioned 
page_count(page).
