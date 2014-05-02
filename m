Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaEBPLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:11:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaEBPLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:11:22 -0400
Date: Fri, 2 May 2014 17:11:20 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] memcg, mm: introduce lowlimit reclaim
Message-ID: <20140502151120.GN3446@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-2-git-send-email-mhocko@suse.cz>
 <20140430225550.GD26041@cmpxchg.org>
 <20140502093628.GC3446@dhcp22.suse.cz>
 <20140502120715.GI3446@dhcp22.suse.cz>
 <20140502130118.GK23420@cmpxchg.org>
 <20140502141515.GJ3446@dhcp22.suse.cz>
 <20140502150434.GM23420@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502150434.GM23420@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-05-14 11:04:34, Johannes Weiner wrote:
[...]
> > @@ -2236,12 +2246,9 @@ static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
> >  		do {
> >  			struct lruvec *lruvec;
> >  
> > -			/*
> > -			 * Memcg might be under its low limit so we have to
> > -			 * skip it during the first reclaim round
> > -			 */
> > -			if (follow_low_limit &&
> > -					!mem_cgroup_reclaim_eligible(memcg, root)) {
> > +			/* Memcg might be protected from the reclaim */
> > +			if (force_memcg_guarantee &&
> 
> respect_?  consider_?

enforce_ ?

-- 
Michal Hocko
SUSE Labs
