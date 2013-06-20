Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965438Ab3FTLei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:34:38 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57369 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965366Ab3FTLeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:34:36 -0400
Date: Thu, 20 Jun 2013 13:34:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        roland@kernel.org, kosaki.motohiro@gmail.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [PATCH] mm: Revert pinned_vm braindamage
Message-ID: <20130620113431.GA12125@gmail.com>
References: <20130606124351.GZ27176@twins.programming.kicks-ass.net>
 <20130613140632.15982af2ebc443b24bfff86a@linux-foundation.org>
 <alpine.DEB.2.02.1306171417450.4234@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306171417450.4234@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 13 Jun 2013, Andrew Morton wrote:
> > Let's try to get this wrapped up?
> > 
> > On Thu, 6 Jun 2013 14:43:51 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > 
> > > Patch bc3e53f682 ("mm: distinguish between mlocked and pinned pages")
> > > broke RLIMIT_MEMLOCK.
> > 
> > I rather like what bc3e53f682 did, actually.  RLIMIT_MEMLOCK limits the
> > amount of memory you can mlock().  Nice and simple.
> > 
> > This pinning thing which infiniband/perf are doing is conceptually
> > different and if we care at all, perhaps we should be looking at adding
> > RLIMIT_PINNED.
> 
> Actually PINNED is just a stronger version of MEMLOCK. PINNED and 
> MEMLOCK are both preventing the page from being paged out. PINNED adds 
> the constraint of preventing minor faults as well.
> 
> So I think the really important tuning knob is the limitation of pages 
> which cannot be paged out. And this is what RLIMIT_MEMLOCK is about.
> 
> Now if you want to add RLIMIT_PINNED as well, then it only limits the 
> number of pages which cannot create minor faults, but that does not 
> affect the limitation of total pages which cannot be paged out.

Agreed.

( Furthermore, the RLIMIT_MEMLOCK semantics change actively broke code so
  this is not academic and it would be nice to progress with it. )

Thanks,

	Ingo
