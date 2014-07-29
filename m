Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaG2NUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:20:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaG2NUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:20:02 -0400
Date: Tue, 29 Jul 2014 15:19:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729131957.GE3935@laptop>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <20140728113939.GR6758@twins.programming.kicks-ass.net>
 <20140729010945.GB5203@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729010945.GB5203@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:09:45AM +0800, Yuyang Du wrote:
> > > +#define subtract_until_zero(minuend, subtrahend)	\
> > > +	(subtrahend < minuend ? minuend - subtrahend : 0)
> > 
> > WTH is a minuend or subtrahend? Are you a wordsmith in your spare time
> > and like to make up your own words?
> > 
> > Also, isn't writing: x = max(0, x-y), far more readable to begin with?
> > 
> 
> Ok. IIUC, max() does not handle minus number super good, and we don't need the type
> overhead in max(), so still use my macro, but won't be wordsmith again, :)

The 'type' muck is compile time, it doesn't generate any code.

And max() deals just fine with negative numbers assuming you use signed
types, which you could force with max_t().
