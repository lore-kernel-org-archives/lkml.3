Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaEBPfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:35:08 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60179 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaEBPfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:35:06 -0400
Date: Fri, 2 May 2014 11:34:51 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] memcg, mm: introduce lowlimit reclaim
Message-ID: <20140502153451.GN23420@cmpxchg.org>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-2-git-send-email-mhocko@suse.cz>
 <20140430225550.GD26041@cmpxchg.org>
 <20140502093628.GC3446@dhcp22.suse.cz>
 <20140502120715.GI3446@dhcp22.suse.cz>
 <20140502130118.GK23420@cmpxchg.org>
 <20140502141515.GJ3446@dhcp22.suse.cz>
 <20140502150434.GM23420@cmpxchg.org>
 <20140502151120.GN3446@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502151120.GN3446@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 05:11:20PM +0200, Michal Hocko wrote:
> On Fri 02-05-14 11:04:34, Johannes Weiner wrote:
> [...]
> > > @@ -2236,12 +2246,9 @@ static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
> > >  		do {
> > >  			struct lruvec *lruvec;
> > >  
> > > -			/*
> > > -			 * Memcg might be under its low limit so we have to
> > > -			 * skip it during the first reclaim round
> > > -			 */
> > > -			if (follow_low_limit &&
> > > -					!mem_cgroup_reclaim_eligible(memcg, root)) {
> > > +			/* Memcg might be protected from the reclaim */
> > > +			if (force_memcg_guarantee &&
> > 
> > respect_?  consider_?
> 
> enforce_ ?

A native speaker might be better at this, but to me it seems weird to
enforce a promise.  honor_memcg_guarantee?
