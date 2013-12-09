Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691Ab3LIWFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:05:30 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:55316 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3LIWF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:05:29 -0500
Date: Mon, 9 Dec 2013 14:05:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Xishi Qiu <qiuxishi@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add show num_poisoned_pages when oom
In-Reply-To: <1386625778-kutyp5f6-mutt-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.02.1312091405170.11026@chino.kir.corp.google.com>
References: <52A592DE.7010302@huawei.com> <1386625778-kutyp5f6-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Naoya Horiguchi wrote:

> > Show num_poisoned_pages when oom, it is helpful to find the reason.
> > 
> > Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> > ---
> >  lib/show_mem.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/lib/show_mem.c b/lib/show_mem.c
> > index 5847a49..1cbdcd8 100644
> > --- a/lib/show_mem.c
> > +++ b/lib/show_mem.c
> > @@ -46,4 +46,7 @@ void show_mem(unsigned int filter)
> >  	printk("%lu pages in pagetable cache\n",
> >  		quicklist_total_size());
> >  #endif
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +	printk("%lu pages poisoned\n", atomic_long_read(&num_poisoned_pages));
> > +#endif
> >  }
> 
> I think that just "poisoned" could be confusing because this word seems to
> be used also in other context (like slab and list_debug handling.)
> "hwpoisoned" or "hardware corrupted" (which is the same label in /proc/meminfo)
> looks better to me.
> 

Ah, good point.
