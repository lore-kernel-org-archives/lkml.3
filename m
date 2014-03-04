Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbaCDIYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:24:37 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59371 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbaCDIYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:24:35 -0500
Message-ID: <1393921471.5419.37.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] clocksource: avoid unnecessary overflow in
 cyclecounter_cyc2ns()
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: John Stultz <john.stultz@linaro.org>, Salman Qazi <sqazi@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 04 Mar 2014 09:24:31 +0100
In-Reply-To: <20140304080231.GB18178@austad.us>
References: <1393910409.6415.9.camel@marge.simpson.net>
	 <20140304072020.GA18178@austad.us>
	 <1393918280.5419.19.camel@marge.simpson.net>
	 <1393918588.5419.23.camel@marge.simpson.net>
	 <20140304080231.GB18178@austad.us>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 09:02 +0100, Henrik Austad wrote: 
> On Tue, Mar 04, 2014 at 08:36:28AM +0100, Mike Galbraith wrote:
> > (boing boing boing... hell with it, today doesn't exist;)
> 
> you lost me at boing.. :)

Mail bounces due to dead addresses.  Bad hair day in progress.  Now my
shiny new address, which is the result of _every damn address_ I tried
at gmail saying "sorry, taken, try again endlessly", has escaped.

> > On Tue, 2014-03-04 at 08:31 +0100, Mike Galbraith wrote: 
> > > On Tue, 2014-03-04 at 08:20 +0100, Henrik Austad wrote: 
> > > > On Tue, Mar 04, 2014 at 06:20:09AM +0100, Mike Galbraith wrote:
> > > > > Greetings,
> > > > > 
> > > > > While rummaging around looking for HTH a gaggle of weird a$$ machines
> > > > > can manage to timewarp back and forth by exactly 208 days, I stumbled
> > > > > across $subject which looks like it may want to borrow Salman's fix.
> > > > > 
> > > > > clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
> > > > > 
> > > > > As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
> > > > > cycles * mult >> shift is overflow prone. so give it the same treatment.
> > > > > 
> > > > > Cc: Salman Qazi <sqazi@google.com>
> > > > > Cc: John Stultz <johnstul@us.ibm.com>
> > > > > Signed-off-by: Mike Galbraith <bitbucket@online.de>
> > > > > ---
> > > > >  include/linux/clocksource.h |   11 ++++++++---
> > > > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > > > 
> > > > > --- a/include/linux/clocksource.h
> > > > > +++ b/include/linux/clocksource.h
> > > > > @@ -77,13 +77,18 @@ struct timecounter {
> > > > >   *
> > > > >   * XXX - This could use some mult_lxl_ll() asm optimization. Same code
> > > > >   * as in cyc2ns, but with unsigned result.
> > > > > + *
> > > > > + * Because it is the same as x86 __cycles_2_ns, give it the same treatment as
> > > > > + * commit 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock"
> > > > > + * to avoid a potential cycles * mult overflow.
> > > > 
> > > > Do we normally reference a particular commit in a comment? Why not just 
> > > > grab the same comment and add a "this is grabbed from arch/x86/... ?
> > > 
> > > Fewer '+' signs?  History doesn't go away, so seems fine to me.
> 
> I wasn't thinking about the number of +'s in the code, but rather 
> referencing other parts of the code from the code and particular commits in 
> the commit-msg itself. It was the code<->commitmsg interface I was 
> pondering.
> 
> Besides, it wasn't meant as "you shouldn't do that", but more "is it ok to 
> do that?" :)

It's perfectly fine until the maintainer says "NAK" :)  If he does, I'll
go generate '+' signs.. that he can then whack when he gets around to
what he said was likely to happen to that code.

-Mike

