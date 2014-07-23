Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaGWM6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:58:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbaGWM6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:58:24 -0400
Date: Wed, 23 Jul 2014 13:58:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: Avoid full RCU lookup of memcg for statistics
 updates
Message-ID: <20140723125818.GT10819@suse.de>
References: <1406114656-16350-1-git-send-email-mgorman@suse.de>
 <1406114656-16350-2-git-send-email-mgorman@suse.de>
 <20140723114449.GE1725@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140723114449.GE1725@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 07:44:49AM -0400, Johannes Weiner wrote:
> On Wed, Jul 23, 2014 at 12:24:15PM +0100, Mel Gorman wrote:
> > When updating memcg VM statistics like PGFAULT we take the rcu read
> > lock and lookup the memcg. For statistic updates this is overkill
> > when the process may not belong to a memcg. This patch adds a light
> > check to check if a memcg potentially exists. It's race-prone in that
> > some VM stats may be missed when a process first joins a memcg but
> > that is not serious enough to justify a constant performance penalty.
> 
> Tasks always belong to a memcg, the root group per default.  There
> isn't really any accounting that could be omitted.
> 

Crap, ok, I had not taken that into account. The lookup of that cannot
really be avoided. It's a pity because the stats on the root memcg are
not likely to be that interesting. Thanks for reviewing.

-- 
Mel Gorman
SUSE Labs
