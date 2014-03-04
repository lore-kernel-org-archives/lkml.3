Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbaCDHvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:51:51 -0500
Received: from mail-ee0-f68.google.com ([74.125.83.68]:53146 "EHLO
	mail-ee0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbaCDHvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:51:49 -0500
Message-ID: <1393918588.5419.23.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] clocksource: avoid unnecessary overflow in
 cyclecounter_cyc2ns()
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: John Stultz <john.stultz@linaro.org>, Salman Qazi <sqazi@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 04 Mar 2014 08:36:28 +0100
In-Reply-To: <1393918280.5419.19.camel@marge.simpson.net>
References: <1393910409.6415.9.camel@marge.simpson.net>
	 <20140304072020.GA18178@austad.us>
	 <1393918280.5419.19.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(boing boing boing... hell with it, today doesn't exist;)

On Tue, 2014-03-04 at 08:31 +0100, Mike Galbraith wrote: 
> On Tue, 2014-03-04 at 08:20 +0100, Henrik Austad wrote: 
> > On Tue, Mar 04, 2014 at 06:20:09AM +0100, Mike Galbraith wrote:
> > > Greetings,
> > > 
> > > While rummaging around looking for HTH a gaggle of weird a$$ machines
> > > can manage to timewarp back and forth by exactly 208 days, I stumbled
> > > across $subject which looks like it may want to borrow Salman's fix.
> > > 
> > > clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
> > > 
> > > As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
> > > cycles * mult >> shift is overflow prone. so give it the same treatment.
> > > 
> > > Cc: Salman Qazi <sqazi@google.com>
> > > Cc: John Stultz <johnstul@us.ibm.com>
> > > Signed-off-by: Mike Galbraith <bitbucket@online.de>
> > > ---
> > >  include/linux/clocksource.h |   11 ++++++++---
> > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > 
> > > --- a/include/linux/clocksource.h
> > > +++ b/include/linux/clocksource.h
> > > @@ -77,13 +77,18 @@ struct timecounter {
> > >   *
> > >   * XXX - This could use some mult_lxl_ll() asm optimization. Same code
> > >   * as in cyc2ns, but with unsigned result.
> > > + *
> > > + * Because it is the same as x86 __cycles_2_ns, give it the same treatment as
> > > + * commit 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock"
> > > + * to avoid a potential cycles * mult overflow.
> > 
> > Do we normally reference a particular commit in a comment? Why not just 
> > grab the same comment and add a "this is grabbed from arch/x86/... ?
> 
> Fewer '+' signs?  History doesn't go away, so seems fine to me.
> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


