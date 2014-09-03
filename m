Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaICCMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:12:03 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48566 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaICCMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:12:00 -0400
Date: Tue, 2 Sep 2014 19:11:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
Message-ID: <20140903021152.GA14069@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.11.1409021513490.26284@gentwo.org>
 <20140902203743.GL5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021545370.32690@gentwo.org>
 <20140902211517.GO5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021819500.5437@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409021819500.5437@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090302-1344-0000-0000-000003E66BA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 06:22:52PM -0500, Christoph Lameter wrote:
> On Tue, 2 Sep 2014, Paul E. McKenney wrote:
> 
> > Yep, these two have been on my "when I am feeling insanely gutsy" list
> > for quite some time.
> >
> > But I have to ask...  On x86, is a pair of mfence instructions really
> > cheaper than an atomic increment?
> 
> Not sure why you would need an mfence instruction?

Because otherwise RCU can break.  As soon as the grace-period machinery
sees that the value of this variable is even, it assumes a quiescent
state.  If there are no memory barriers, the non-quiescent code might
not have completed executing, and your kernel's actuarial statistics
become sub-optimal.

							Thanx, Paul

> > > If the first patch I send gets merged then a lot of other this_cpu related
> > > optimizations become possible regardless of the ones in the RFC.
> >
> > Yep, I am queuing that one.
> 
> Great.
> 
> > But could you please do future patches against the rcu/dev branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git?
> > I had to hand-apply due to conflicts.  Please see below for my version,
> > and please check to make sure that I didn't mess something up in the
> > translation.
> 
> Looks ok. Will use the correct tree next time.
> 
> 

