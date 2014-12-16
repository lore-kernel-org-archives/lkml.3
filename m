Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaLPKIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:08:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:61547 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaLPKII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:08:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,585,1413270000"; 
   d="scan'208";a="648364610"
Date: Tue, 16 Dec 2014 10:09:48 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
Message-ID: <20141216020948.GA6399@intel.com>
References: <547E42F7.5070105@gmail.com>
 <20141213083012.GH32572@gmail.com>
 <20141215121227.GZ29390@twins.programming.kicks-ass.net>
 <548FBA62.5090603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548FBA62.5090603@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:51:46PM -0500, Sasha Levin wrote:
> On 12/15/2014 07:12 AM, Peter Zijlstra wrote:
> > 
> > Sorry for the long delay, I was out for a few weeks due to having become
> > a dad for the second time.
> 
> Congrats! May you be able to sleep at night sooner rather than later.
 
Congrats +1.

> 
> It's fairy reproducible, I've seen it happen quite a few times. What other
> information might be useful?
> 

Sasha, it might be helpful to see this_load is from:

this_load1: this_load = target_load(this_cpu, idx);

or

this_load2: this_load += effective_load(tg, this_cpu, -weight, -weight);

It really does not seem to be this_load1, while the calc of effective_load is a bit
complicated to see what the problem is.
