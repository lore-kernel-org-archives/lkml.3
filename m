Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab3GWTOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:14:16 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52122 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933733Ab3GWTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:14:14 -0400
Date: Tue, 23 Jul 2013 21:14:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        eranian@google.com
Subject: Re: [PATCH] perf, x86: Enable PEBS mode automatically for
 mem-{loads,stores} v3
Message-ID: <20130723191413.GS6123@two.firstfloor.org>
References: <1374188619-19220-1-git-send-email-andi@firstfloor.org>
 <20130723083834.GS27075@twins.programming.kicks-ass.net>
 <20130723161334.GQ6123@two.firstfloor.org>
 <20130723165739.GD27075@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723165739.GD27075@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 06:57:39PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 23, 2013 at 06:13:34PM +0200, Andi Kleen wrote:
> > On Tue, Jul 23, 2013 at 10:38:34AM +0200, Peter Zijlstra wrote:
> > > On Thu, Jul 18, 2013 at 04:03:39PM -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > [The patch to enable this in the user tools has been sent separately]
> > > > 
> > > > With the earlier patches to automatically try cpu// and add
> > > > a precise sys attribute, we can now enable PEBS for the mem-loads,
> > > > mem-stores events everywhere.
> > > > 
> > > > This allows to use
> > > > 
> > > > perf record -e mem-loads ...
> > > > 
> > > > instead of
> > > > 
> > > > perf record -e cpu/mem-loads/p ...
> > > > 
> > > > Always use precise=2 even though it is costly pre-Haswell
> > > 
> > > This Changelog fails to give a reason _why_ we'd want to do this.
> > 
> > The first is much nicer to type and understand? Just in the spirit of
> > making perf easier to use.
> 
> And here I was thinking that maybe these events don't make sense without
> pebs or so. But no, rather than giving an actual useful reason you'd
> have me look things up myself. *sigh*

You can use them without PEBS, but they're much more useful with PEBS
(e.g. due to skid or if you want the address or data source, although
you can also use perf mem for the later)

I think PEBS on is a better default here.

BTW I should add i have some other events (for HSW TSX) that would
really like a PEBS default. That was the original motivation,
but then I realized it makes other things nicer too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
