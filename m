Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3LBNMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:12:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3LBNMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:12:41 -0500
Date: Mon, 2 Dec 2013 14:12:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, azurit@pobox.sk,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [merged]
 mm-memcg-handle-non-error-oom-situations-more-gracefully.patch removed from
 -mm tree
Message-ID: <20131202131238.GB18838@dhcp22.suse.cz>
References: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org>
 <alpine.DEB.2.02.1311271453270.13682@chino.kir.corp.google.com>
 <20131127233353.GH3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271622330.10617@chino.kir.corp.google.com>
 <20131128021809.GI3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271826001.5120@chino.kir.corp.google.com>
 <20131128031313.GK3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271914460.5120@chino.kir.corp.google.com>
 <20131128100213.GE2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311291600290.22413@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311291600290.22413@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 29-11-13 16:05:04, David Rientjes wrote:
> On Thu, 28 Nov 2013, Michal Hocko wrote:
> 
> > > None that I am currently aware of,
> > 
> > Are you saing that scenarios described in 3812c8c8f395 (mm: memcg: do not
> > trap chargers with full callstack on OOM) are not real or that _you_
> > haven't seen an issue like that?
> > 
> > The later doesn't seem to be so relevant as we had at least one user who
> > has seen those in the real life.
> > 
> 
> I said I'm not currently aware of any additional problems with the 
> patchset,

I have obviously misread your reply. Sorry about that.

> but since Johannes said the entire series wasn't meant for that 
> merge window, I asked if it was still being worked on.
> 
> > > You don't think something like this is helpful after scanning a memcg will 
> > > a large number of processes?
> > 
> > It looks as a one-shot workaround for short lived processes to me.
> 
> It has nothing to do with how long a process has been running, both racing 
> processes could have been running for years.  It's obvious that even this 
> patch before calling oom_kill_process() does not catch a racing process 
> that has already freed its memory and is exiting but it makes the 
> liklihood significantly less in testing at scale. 

I guess we need to know how much is significantly less.
oom_scan_process_thread already aborts on exiting tasks so we do not
kill anything and then the charge (whole page fault actually) is retried
when we check for the OOM again so my intuition would say that we gave
the exiting task quite a lot of time.

> It's simply better to avoid unnecessary oom killing at anytime
> possible and this is not a hotpath.

-- 
Michal Hocko
SUSE Labs
