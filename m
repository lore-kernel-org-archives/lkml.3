Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIJShd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:37:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaIJShb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:37:31 -0400
Date: Wed, 10 Sep 2014 11:34:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/26] locking: Add non-fatal spin lock assert
Message-ID: <20140910183452.GA15250@kroah.com>
References: <1409693975-1028-14-git-send-email-peter@hurleysoftware.com>
 <20140903092723.GA4783@worktop.ger.corp.intel.com>
 <5406F964.6060900@hurleysoftware.com>
 <20140903144029.GA7083@twins.programming.kicks-ass.net>
 <54072A99.1080306@hurleysoftware.com>
 <20140903150729.GA7436@twins.programming.kicks-ass.net>
 <20140904051411.GA27350@gmail.com>
 <54102FB2.1020808@hurleysoftware.com>
 <20140910130832.GY4783@worktop.ger.corp.intel.com>
 <5410640D.8010903@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5410640D.8010903@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:45:33AM -0400, Peter Hurley wrote:
> On 09/10/2014 09:08 AM, Peter Zijlstra wrote:
> > On Wed, Sep 10, 2014 at 07:02:10AM -0400, Peter Hurley wrote:
> >> On 09/04/2014 01:14 AM, Ingo Molnar wrote:
> >>>
> >>> * Peter Zijlstra <peterz@infradead.org> wrote:
> >>>
> >>>> On Wed, Sep 03, 2014 at 10:50:01AM -0400, Peter Hurley wrote:
> >>>>> So a lockdep-only assert is unlikely to draw attention to existing bugs,
> >>>>> especially in established drivers.
> >>>>
> >>>> By the same logic lockdep will not find locking errors in established
> >>>> drivers.
> >>>
> >>> Indeed, this patch is ill-advised in several ways:
> >>>
> >>>   - it extends an API variant that we want to phase
> >>>
> >>>   - emits a warning even if say lockdep has already emitted a
> >>>     warning and locking state is not guaranteed to be consistent. 
> >>>
> >>>   - makes the kernel more expensive once fully debugged, in that
> >>>     non-fatal checks are unconditional.
> >>
> >> Ok.
> >>
> >> One thing: I'm not seeing how lockdep_assert_held() switches off once
> >> the warning has been emitted? Is the caller expected to construct their
> >> own _ONCE tags?
> > 
> > Indeed, it does not do that. I suppose you can add
> > lockdep_assert_held_once() or somesuch if you think the once thing is
> > important.
> 
> Ok, will do.
> 
> On 09/04/2014 01:14 AM, Ingo Molnar wrote:
> > Also please submit locking related patches as standalone series 
> > to the locking subsystem, not embedded in an unrelated series.
> 
> Ok, but how will Greg know when to take the series that depends on
> this change, if the locking change is submitted separately?

 Cc: me on those changes, and I can track what happens with the tip tree
 where these would show up.

Or wait a release cycle, that also is an easy way.

thanks,

greg k-h
