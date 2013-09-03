Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345Ab3ICWhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:37:55 -0400
Received: from one.firstfloor.org ([193.170.194.197]:47502 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761165Ab3ICWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:37:54 -0400
Date: Wed, 4 Sep 2013 00:37:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] perf, x86: Support Haswell v4 LBR format v2
Message-ID: <20130903223751.GN19750@two.firstfloor.org>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <1366484783-15613-6-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1309031519440.12014@pianoman.cluster.toy>
 <20130903202844.GK16724@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1309031711001.25732@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309031711001.25732@pianoman.cluster.toy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 05:14:51PM -0400, Vince Weaver wrote:
> On Tue, 3 Sep 2013, Andi Kleen wrote:
> 
> > > > +	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
> > > > +	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
> > > > +	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
> > > 
> > > so if you specify these flags in branch_sample_type, what information
> > > appears in the branch record?  
> > 
> > This is just a filter, so when set branches that do not satisfy
> > the filter are not reported.
> 
> Is the implementation a direct mapping to the LBR documentation or has it 
> been generic so non-Intel architectures can use it?

It's not a direct mapping (no_tx doesn't exist in the hardware)
If other architectures have similar capabilities they can likely use it.

> 
> > The patches to export the new fields haven't been merged yet.
> 
> What does this mean?  The above values are exported as part of 
>   include/uapi/linux/perf_event.h
> Do they not work yet?

You can filter on the fields, but you can't see them outside
the kernel driver yet.  The patch to see them is still pending.
> 
> > >  What happens if you set both in transaction and not in?
> > 
> > Then you get all branches.
> 
> so what happens if you set neither "PERF_SAMPLE_BRANCH_IN_TX" nor
> "PERF_SAMPLE_BRANCH_NO_TX"?  Logically you'd get no branches at all,
> but that can't be true as all code prior to 3.11 didn't set those values.

Then you get all branches too

(that's how all the other filters work too)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
