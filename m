Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3ICU2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:28:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:52923 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929Ab3ICU2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:28:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1016,1367996400"; 
   d="scan'208";a="290404333"
Date: Tue, 3 Sep 2013 13:28:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] perf, x86: Support Haswell v4 LBR format v2
Message-ID: <20130903202844.GK16724@tassilo.jf.intel.com>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <1366484783-15613-6-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1309031519440.12014@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309031519440.12014@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
> > +	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
> > +	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
> 
> so if you specify these flags in branch_sample_type, what information
> appears in the branch record?  

This is just a filter, so when set branches that do not satisfy
the filter are not reported.

The patches to export the new fields haven't been merged yet.

> 
> If you get an abort, what address appears in the record?

Abort is a jump from the abort point to the abort handler or
the HLE XACQUIRE lock instruction.

> What does it mean in regards to a branch entry to be or not be in a 
> transaction?  

When the branch is executed the CPU is in the transactional execution
state.

> 
> If you set "in transaction" does that then only record branches that are 
> in transactions? 

Yes, like all the other branch filter flags.

>  What happens if you set both in transaction and not in?

Then you get all branches.

> 
> Is there some sort of document from intel you can link to that describes 
> all of this?

http://download.intel.com/products/processor/manual/253669.pdf
Chapter 17.8

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
