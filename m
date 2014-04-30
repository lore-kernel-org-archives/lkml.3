Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946118AbaD3V2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:28:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:11581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbaD3V2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:28:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,960,1389772800"; 
   d="scan'208";a="532698907"
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1398891992.10827.2.camel@buesod1.americas.hpqcorp.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140430082715.GA11096@twins.programming.kicks-ass.net>
	 <1398880209.2970.100.camel@schen9-DESK>
	 <20140430180441.GF17778@laptop.programming.kicks-ass.net>
	 <1398881337.2970.103.camel@schen9-DESK>
	 <1398891699.2970.110.camel@schen9-DESK>
	 <1398891992.10827.2.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 14:28:05 -0700
Message-ID: <1398893285.2970.111.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 14:06 -0700, Davidlohr Bueso wrote:

> > > > > 
> > > > > 		  if (count == RWSEM_WAITING_BIAS)
> > > > > 			old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_BIAS);
> > > > > 		  else
> > > > > 			old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);
> > > > 
> > > > I think I simply mis-typed it; shouldn't both cases be
> > > > RWSEM_ACTIVE_WRITE_BIAS ?
> > > 
> > > Yeah,  we should just write it as
> > > 			  old = cmpxchg(&sem->count, count, RWSEM_ACTIVE_WRITE_BIAS);
> > 
> > Oops, I mean
> > 			    old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);
> > 
> > for count == 0, we need sem->count to be RWSEM_ACTIVE_WRITE_BIAS, 
> > for count == RWSEM_WAITING_BIAS, we need sem->count to be  RWSEM_WAITING_BIAS + RWSEM_ACTIVE_WRITE_BIAS
> 
> Yep, I had just noticed this. Peter's original suggestion was correct,
> just needed to change RWSEM_ACTIVE_BIAS for RWSEM_ACTIVE_WRITE_BIAS.
> 

Yes, I think we are all on the same page now.

Tim

