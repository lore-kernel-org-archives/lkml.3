Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaG2JQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:16:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:7324 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaG2JQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:16:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,755,1400050800"; 
   d="scan'208";a="580532457"
Date: Tue, 29 Jul 2014 09:13:42 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: bsegall@google.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        pjt@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729011342.GC5203@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <20140728135122.GT6758@twins.programming.kicks-ass.net>
 <xm26lhrdv2s4.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140728171909.GW19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728171909.GW19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 07:19:09PM +0200, Peter Zijlstra wrote:
> > > And here we try and make good on that assumption. The thing I worry
> > > about is what happens if the machine is entirely idle...
> > >
> > > What guarantees an semi up-to-date cfs_rq->avg.last_update_time.
> > 
> > update_blocked_averages I think should do just as good a job as the old
> > code, which isn't perfect but is about as good as you can get worst case.
> 
> Right, that's called from rebalance_domains() which should more or less
> update this value on tick boundaries or thereabouts for most 'active'
> cpus.
> 
> But if the entire machine is idle, the first wakeup (if its a x-cpu one)
> might see a very stale timestamp.
> 
> If we can fix that, that would be good I suppose, but I'm not
> immediately seeing something pretty there, but you're right, it'd not be
> worse than the current situation.

It matters time is up-to-date before load_avg is actually used. So yes, we should
have already achieved that.
