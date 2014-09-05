Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaIEKUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:20:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbaIEKUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:20:47 -0400
Date: Fri, 5 Sep 2014 11:20:44 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: clean up zone flags
Message-ID: <20140905102044.GG17501@suse.de>
References: <1409668074-16875-1-git-send-email-hannes@cmpxchg.org>
 <alpine.DEB.2.02.1409021437160.28054@chino.kir.corp.google.com>
 <20140902222653.GA20186@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140902222653.GA20186@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 06:26:53PM -0400, Johannes Weiner wrote:
> From 2420ad16df0634e073ad327f0f72472d9b03762b Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Tue, 2 Sep 2014 10:14:36 -0400
> Subject: [patch] mm: clean up zone flags
> 
> Page reclaim tests zone_is_reclaim_dirty(), but the site that actually
> sets this state does zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY), sending
> the reader through layers indirection just to track down a simple bit.
> 
> Remove all zone flag wrappers and just use bitops against zone->flags
> directly.  It's just as readable and the lines are barely any longer.
> 
> Also rename ZONE_TAIL_LRU_DIRTY to ZONE_DIRTY to match ZONE_WRITEBACK,
> and remove the zone_flags_t typedef.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: David Rientjes <rientjes@google.com>

I would have gone with making them ZONE_TAIL_DIRTY and ZONE_TAIL_WRITEBACK
because to me it's clearer what the flag means.  ZONE_DIRTY can be
interpreted as "the zone has dirty pages" which is not what reclaim
cares about, it cares about dirty pages at the tail of the LRU.  However,
I don't feel strongly enough to make a big deal about it so

Acked-by: Mel Gorman <mgorman@suse.de>

Thanks.

-- 
Mel Gorman
SUSE Labs
