Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaFLAZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:25:03 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52653 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaFLAZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:25:01 -0400
Date: Wed, 11 Jun 2014 17:24:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 08/10] mm, compaction: pass gfp mask to compact_control
In-Reply-To: <539841A7.3040202@suse.cz>
Message-ID: <alpine.DEB.2.02.1406111724140.11536@chino.kir.corp.google.com>
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-8-git-send-email-vbabka@suse.cz> <20140611024855.GH15630@bbox> <539841A7.3040202@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Vlastimil Babka wrote:

> > > diff --git a/mm/compaction.c b/mm/compaction.c
> > > index c339ccd..d1e30ba 100644
> > > --- a/mm/compaction.c
> > > +++ b/mm/compaction.c
> > > @@ -965,8 +965,8 @@ static isolate_migrate_t isolate_migratepages(struct
> > > zone *zone,
> > >   	return ISOLATE_SUCCESS;
> > >   }
> > > 
> > > -static int compact_finished(struct zone *zone,
> > > -			    struct compact_control *cc)
> > > +static int compact_finished(struct zone *zone, struct compact_control
> > > *cc,
> > > +			    const int migratetype)
> > 
> > If we has gfp_mask, we could use gfpflags_to_migratetype from cc->gfp_mask.
> > What's is your intention?
> 
> Can't speak for David but I left it this way as it means
> gfpflags_to_migratetype is only called once per compact_zone. Now I realize my
> patch 10/10 repeats the call in isolate_migratepages_range so I'll probably
> update that as well.
> 

Yes, that was definitely the intention: call it once in compact_zone() and 
store it as const and then avoid calling it every time for 
compact_finished().
