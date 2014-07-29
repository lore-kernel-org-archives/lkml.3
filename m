Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaG2I7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:59:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:30556 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaG2I7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,755,1400050800"; 
   d="scan'208";a="568814738"
Date: Tue, 29 Jul 2014 08:56:41 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729005640.GA5203@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <20140728104837.GQ6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728104837.GQ6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 12:48:37PM +0200, Peter Zijlstra wrote:
> > +static __always_inline u64 decay_load(u64 val, u64 n)
> > +{
> > +	if (likely(val <= UINT_MAX))
> > +		val = decay_load32(val, n);
> > +	else {
> > +		val *= (u32)decay_load32(1 << 15, n);
> > +		val >>= 15;
> > +	}
> > +
> > +	return val;
> > +}
> 
> Please just use mul_u64_u32_shr().
> 
> /me continues reading the rest of it..

Good. Since 128bit is considered in mul_u64_u32_shr, load_sum can
afford more tasks :)
