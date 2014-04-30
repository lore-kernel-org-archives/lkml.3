Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbaD3JwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:52:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:34992 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbaD3JwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:52:08 -0400
Date: Wed, 30 Apr 2014 11:52:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/spinlock_debug: Tweak the loop time to fit different
 _delay()
Message-ID: <20140430095205.GF30445@twins.programming.kicks-ass.net>
References: <1398897638.21870.8.camel@wxm-ubuntu>
 <20140430085508.GE30445@twins.programming.kicks-ass.net>
 <27240C0AC20F114CBF8149A2696CBE4A01D053BC@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01D053BC@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 09:30:55AM +0000, Liu, Chuansheng wrote:
> > From: Peter Zijlstra [mailto:peterz@infradead.org]
> > Sent: Wednesday, April 30, 2014 4:55 PM
> > To: Wang, Xiaoming
> > Cc: mingo@redhat.com; linux-kernel@vger.kernel.org; Liu, Chuansheng
> > Subject: Re: [PATCH] lib/spinlock_debug: Tweak the loop time to fit different
> > _delay()
> > 
> > On Wed, Apr 30, 2014 at 06:40:38PM -0400, Wang, Xiaoming wrote:
> > > loops_per_jiffy*Hz  is not always 1 second exactly
> > > it depends on the realization of _delay() .
> > > delay_tsc is used as _delay() in arch/x86/lib/delay.c
> > 
> > This just states delay() is broken. The primary response should be to
> > try and fix that, no?
> 
> 
> delay(1s_count) is accurate, but delay(1) is not accurate indeed, since executing
> some instruction, then the 1 cycle delay maybe be used already.

OK, so there's (finally) a problem statement, so is there anything sane
we can do about that?

But yes, a trylock is a cmpxchg, and a cmpxchg on a contended cacheline
can be _much_ longer than one loop.

Now the real problem is coming up with something that'll work for all
architectures.
