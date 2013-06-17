Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab3FQM3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:29:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:35119 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3FQM3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:29:01 -0400
Date: Mon, 17 Jun 2013 14:28:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        roland@kernel.org, mingo@kernel.org, kosaki.motohiro@gmail.com,
        penberg@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [PATCH] mm: Revert pinned_vm braindamage
In-Reply-To: <20130613140632.15982af2ebc443b24bfff86a@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1306171417450.4234@ionos.tec.linutronix.de>
References: <20130606124351.GZ27176@twins.programming.kicks-ass.net> <20130613140632.15982af2ebc443b24bfff86a@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013, Andrew Morton wrote:
> Let's try to get this wrapped up?
> 
> On Thu, 6 Jun 2013 14:43:51 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > 
> > Patch bc3e53f682 ("mm: distinguish between mlocked and pinned pages")
> > broke RLIMIT_MEMLOCK.
> 
> I rather like what bc3e53f682 did, actually.  RLIMIT_MEMLOCK limits the
> amount of memory you can mlock().  Nice and simple.
> 
> This pinning thing which infiniband/perf are doing is conceptually
> different and if we care at all, perhaps we should be looking at adding
> RLIMIT_PINNED.

Actually PINNED is just a stronger version of MEMLOCK. PINNED and
MEMLOCK are both preventing the page from being paged out. PINNED adds
the constraint of preventing minor faults as well.

So I think the really important tuning knob is the limitation of pages
which cannot be paged out. And this is what RLIMIT_MEMLOCK is about.

Now if you want to add RLIMIT_PINNED as well, then it only limits the
number of pages which cannot create minor faults, but that does not
affect the limitation of total pages which cannot be paged out.

Thanks,

	tglx
