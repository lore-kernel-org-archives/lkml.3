Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab3LGFUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 00:20:33 -0500
Received: from one.firstfloor.org ([193.170.194.197]:56338 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3LGFUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 00:20:32 -0500
Date: Sat, 7 Dec 2013 06:20:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>, lenb@kernel.org,
        tglx@linutronix.de, peterz@infradead.org
Subject: Re: [PATCH] Trace idle entry and exit times
Message-ID: <20131207052029.GC21717@two.firstfloor.org>
References: <1386377164-2223-1-git-send-email-andi@firstfloor.org>
 <1386392252.5673.31.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386392252.5673.31.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 05:57:32AM +0100, Mike Galbraith wrote:
> On Fri, 2013-12-06 at 16:46 -0800, Andi Kleen wrote: 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > This patch creates 4 new trace points: one at the beginning of idle,
> > one before entering mwait, one after exiting mwait, and one after
> > finishing the idle code. This is useful to trace down any
> > additional latencies caused by the ever-growing idle code.
> > 
> > Idle latencies are a common source of performance problems, so it's
> > important to be able to measure them.
> 
> You mean stuff like.. oh, say 60 cores doing zero work every 12ms
> munching ~20% cpu?

Well that one is obvious. I mean more the subtle problems.

BTW the timer problem is fixed on Westmere and later (always running APIC
timer), but yes it's a problem before that. I looked at it some time ago,
but eventually gave up after only fixing low hanging fruit. There are likely 
some more tricks that could be done here (see the old patches from back then)

-Andi
