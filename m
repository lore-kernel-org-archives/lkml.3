Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaBZRpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:45:31 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:55146 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaBZRp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:45:29 -0500
X-Greylist: delayed 78546 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2014 12:45:29 EST
Message-ID: <1393436725.11382.3.camel@j-VirtualBox>
Subject: Re: [PATCH 5/8] locking, mutex: Cancelable MCS lock for adaptive
 spinning
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Wed, 26 Feb 2014 09:45:25 -0800
In-Reply-To: <20140226092210.GH18404@twins.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
	 <20140210203659.671232531@infradead.org>
	 <1393358179.7727.34.camel@j-VirtualBox>
	 <20140226092210.GH18404@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 10:22 +0100, Peter Zijlstra wrote:
> On Tue, Feb 25, 2014 at 11:56:19AM -0800, Jason Low wrote:
> > On Mon, 2014-02-10 at 20:58 +0100, Peter Zijlstra wrote:
> > > +	for (;;) {
> > > +		if (prev->next == node &&
> > > +		    cmpxchg(&prev->next, node, NULL) == node)
> > > +			break;
> > > +
> > > +		/*
> > > +		 * We can only fail the cmpxchg() racing against an unlock(),
> > > +		 * in which case we should observe @node->locked becomming
> > > +		 * true.
> > > +		 */
> > > +		if (smp_load_acquire(&node->locked))
> > > +			return true;
> 
> I've stuck on in right about here. So that we don't unduly delay the
> cmpxchg() after the load of prev.

Ok.

Reviewed-by: Jason Low <jason.low2@hp.com>


