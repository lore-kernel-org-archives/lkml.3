Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3KLVaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:30:17 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:57162 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3KLVaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:30:10 -0500
Date: Tue, 12 Nov 2013 13:29:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Does Itanium permit speculative stores?
Message-ID: <20131112212904.GR4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131111171307.GA27002@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31D5DB28@ORSMSX106.amr.corp.intel.com>
 <20131112182617.GG21461@twins.programming.kicks-ass.net>
 <3908561D78D1C84285E8C5FCA982C28F31D5DF47@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D5DF47@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111221-9332-0000-0000-00000220CEE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 06:46:20PM +0000, Luck, Tony wrote:
> > So the point we're having a discussion on is if any architecture has
> > visible speculative STORES and if there's an architecture that doesn't
> > have control dependencies.
> >
> > On the visible speculative STORES; can, if in the above example we have
> > regular loads/stores:
> >
> >  LOAD r1, x			LOAD r2, y
> >  IF (r1)			IF (r2)
> >	STORE y, 1			STORE x, 1
> >
> > we observe: r1==1 && r2==1
> >
> > In order for that to be true; we must be able to observe the stores
> > before the loads are complete -- and therefore before the branches are a
> > certainty.
> 
> Even without the ".acq" and ".rel" this code is still safe.
> 
> Quoting ia64 SDM vol 1, Section 4.4.7 Memory Access Ordering"
> "In addition, memory writes and flushes must observe control dependencies"
> 
> which I take to mean that the STORE can't be visible until we are certain of
> the outcome of the conditional.

Even better!

							Thanx, Paul

