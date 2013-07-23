Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3GWMF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:05:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39858 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3GWMF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:05:28 -0400
Date: Tue, 23 Jul 2013 14:05:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
Message-ID: <20130723120501.GY27075@twins.programming.kicks-ass.net>
References: <1374220211.5447.9.camel@j-VirtualBox>
 <20130722070144.GC5138@linux.vnet.ibm.com>
 <1374519467.7608.87.camel@j-VirtualBox>
 <20130723110646.GA27005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723110646.GA27005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 04:36:46PM +0530, Srikar Dronamraju wrote:

> May be the current max value is a limiting factor, but I think there
> should be a limit to the maximum value. Peter and Ingo may help us
> understand why they limited to the 1ms. But I dont think we should
> introduce a new variable just for this.

/me blames it all on Mike.. I tried to remember why he did that, but
alas.

> If idle balance did succeed, then it means that the system was indeed
> imbalanced. So idle balance was the right thing to do. May be we chose
> the wrong task to pull. May be after numa balancing enhancements go in,
> we pick a better task to pull atleast across nodes. And there could be
> other opportunities/strategies to select a right task to pull.
> 
> Again, schedstats during the application run should give us hints here.

Not necessarily so, IIRC the newidle idx is 0 which means that its very
aggressive at pulling load, there might not actually be an imbalance
with higher idx averages.

> I was saying it the other way. 
> your suggestion is to run idle balance once in n runs .. where n is 10
> to 20. 
> My thinking was to not run idle balance once in n unsuccessful runs. 

I think you're talking past each other. Each having a different N :-)

