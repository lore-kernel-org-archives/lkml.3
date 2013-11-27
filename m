Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab3K0WGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:06:43 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59822 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab3K0WGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:06:40 -0500
Date: Wed, 27 Nov 2013 09:19:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: tony.luck@intel.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Does Itanium permit speculative stores?
Message-ID: <20131127171909.GO4137@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131111171307.GA27002@linux.vnet.ibm.com>
 <52957B5E.60701@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52957B5E.60701@jonmasters.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112722-8236-0000-0000-00000443ECAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:55:58PM -0500, Jon Masters wrote:
> On 11/11/2013 12:13 PM, Paul E. McKenney wrote:
> > Hello, Tony,
> > 
> > Does Itanium permit speculative stores?  For example, on Itanium what are
> > the permitted outcomes of the following litmus test, where both x and y
> > are initially zero?
> > 
> > 	CPU 0				CPU 1
> > 
> > 	r1 = ACCESS_ONCE(x);		r2 = ACCESS_ONCE(y);
> > 	if (r1)				if (r2)
> > 		ACCESS_ONCE(y) = 1;		ACCESS_ONCE(x) = 1;
> > 
> > In particular, is the outcome (r1 == 1 && r2 == 1) possible on Itanium
> > given this litmus test?
> > 
> > 							Thanx, Paul
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Btw, I was reading through some UEFI docs and noticed a reference to "A
> Formal Specification of Intel Itanium Processor Family Memory Ordering",
> then remembered this thread. In case it's of use:
> 
> http://www.intel.com/design/itanium/downloads/251429.htm

I have seen this, but there have been too many times when I have fooled
myself about what the words mean (with DEC Alpha back in the late 90s
being the most impressive example).  So while I do learn what I can from
them, they are unfortunately not a substitute for asking.  ;-)

Besides, some of the Itanium locking code uses instructions that the
above manual is silent about.

							Thanx, Paul

