Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbbASGM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 01:12:28 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47357 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbbASGM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 01:12:27 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 19 Jan 2015 15:13:12 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/5] mm/compaction: enhance tracepoint output for
 compaction begin/end
Message-ID: <20150119061312.GA11473@js1304-P5Q-DELUXE>
References: <1421307673-24084-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1421307673-24084-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150115171627.91b51c2e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115171627.91b51c2e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 05:16:27PM -0800, Andrew Morton wrote:
> On Thu, 15 Jan 2015 16:41:10 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > We now have tracepoint for begin event of compaction and it prints
> > start position of both scanners, but, tracepoint for end event of
> > compaction doesn't print finish position of both scanners. It'd be
> > also useful to know finish position of both scanners so this patch
> > add it. It will help to find odd behavior or problem on compaction
> > internal logic.
> > 
> > And, mode is added to both begin/end tracepoint output, since
> > according to mode, compaction behavior is quite different.
> > 
> > And, lastly, status format is changed to string rather than
> > status number for readability.
> > 
> > ...
> >
> > +	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s status=%s",
> > +		__entry->zone_start,
> > +		__entry->migrate_pfn,
> > +		__entry->free_pfn,
> > +		__entry->zone_end,
> > +		__entry->sync ? "sync" : "async",
> > +		compaction_status_string[__entry->status])
> >  );
> >  
> >  #endif /* _TRACE_COMPACTION_H */
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index 546e571..2d86a20 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -19,6 +19,14 @@
> >  #include "internal.h"
> >  
> >  #ifdef CONFIG_COMPACTION
> > +char *compaction_status_string[] = {
> > +	"deferred",
> > +	"skipped",
> > +	"continue",
> > +	"partial",
> > +	"complete",
> > +};
> 
> compaction_status_string[] is unreferenced if tracing is disabled -
> more ifdeffery is needed?

Hello,

Yes, I sent fixed version patchset, v4, a while ago.
And, there is some build failure reports from kbuild test bot so please
take v4 rather than v3.

Thanks.
