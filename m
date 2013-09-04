Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763215Ab3IDRFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:05:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:10368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763198Ab3IDRFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:05:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1022,1367996400"; 
   d="scan'208";a="373470111"
Date: Wed, 4 Sep 2013 10:05:01 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] perf, x86: Support Haswell v4 LBR format v2
Message-ID: <20130904170501.GL16724@tassilo.jf.intel.com>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <1366484783-15613-6-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1309031519440.12014@pianoman.cluster.toy>
 <20130903202844.GK16724@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1309031711001.25732@pianoman.cluster.toy>
 <20130903223751.GN19750@two.firstfloor.org>
 <alpine.DEB.2.02.1309041015130.28706@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309041015130.28706@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 10:21:27AM -0400, Vince Weaver wrote:
> On Wed, 4 Sep 2013, Andi Kleen wrote:
> 
> > > What does this mean?  The above values are exported as part of 
> > >   include/uapi/linux/perf_event.h
> > > Do they not work yet?
> > 
> > You can filter on the fields, but you can't see them outside
> > the kernel driver yet.  The patch to see them is still pending.
> 
> so you can filter for aborts, but they'll never show up in the lbr[]
> sample buffer?

They will show up, you just don't know that they are aborts 
because the two new status bits are not exported.

> 
> > > > >  What happens if you set both in transaction and not in?
> > > > 
> > > > Then you get all branches.
> > > 
> > > so what happens if you set neither "PERF_SAMPLE_BRANCH_IN_TX" nor
> > > "PERF_SAMPLE_BRANCH_NO_TX"?  Logically you'd get no branches at all,
> > > but that can't be true as all code prior to 3.11 didn't set those values.
> > 
> > Then you get all branches too
> > 
> > (that's how all the other filters work too)
> 
> This is a really confusing API
> 
> so does setting "PERF_SAMPLE_BRANCH_ANY" also enable all of the TX types?
> 
> Is leaving branch_sample_type at 0 the same as setting it to all 1s?

I believe so.

It may be also that the catch all only works if everything is 0.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
