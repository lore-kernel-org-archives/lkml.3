Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281AbaH0Qhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:37:32 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35233 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934868AbaH0Qha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:37:30 -0400
Date: Wed, 27 Aug 2014 18:37:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Remove incorrect model number from
 Haswell perf
Message-ID: <20140827163728.GQ4120@two.firstfloor.org>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
 <1409006611-30741-2-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.10.1408262325200.3323@nanos>
 <20140826212934.GP4120@two.firstfloor.org>
 <alpine.DEB.2.10.1408270020020.3323@nanos>
 <alpine.DEB.2.10.1408271144580.3323@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1408271144580.3323@nanos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:53:57AM +0200, Thomas Gleixner wrote:
> On Wed, 27 Aug 2014, Thomas Gleixner wrote:
> 
> > On Tue, 26 Aug 2014, Andi Kleen wrote:
> > 
> > > > So what's the point of making the obvious onliner patch
> > > > 
> > > > -	case 71:
> > > > 
> > > > into something which reorders the sorted case numbers?
> > >  
> > > This was a merging mistake. I'll fix it to be a one liner.
> > > 
> > > > And of course, this patch is missing any explanation WHY 71 is
> > > > incorrect and how it got there in the first place.
> > > 
> > > 71 is a Broadwell, as you would know if you had read the next patch.
> > 
> > And why on earth do I need to read the next patch to figure out what
> > the heck this patch is doing?
> > 
> > Just because it's written by someone who gives a shit?
> > 
> > Your unwillingness to cooperate and your advisory resistance are
> > slowly approaching the Krause level...
> 
> And after reading the next patch I still can't see that 71 is a
> broadwell, because the next patch merily adds haswell names to the
> numbers. Neither of the following patches has the magic 71
> incorporated. The only model number related to broadwell is 61 in
> patch 3/5.

Ok fair enough.

It was true for v1, but not for v2.


> Try again when you figured yourself out what number means what and why
> 71 is bogus.

71 is definitely not a Haswell, but a Broadwell.

However it was removed from the Broadwell patch based on Peter's
feedback.

So technically the patch is not needed right now because there 
would be no duplicates (unless 71 was readded), so the compiler
would not complain.

However it's still incorrect for Haswell, so I maintain removing
it is the right thing to do.

-Andi
