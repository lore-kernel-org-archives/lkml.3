Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbaCDHb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:31:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:52966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbaCDHbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:31:25 -0500
Message-ID: <1393918280.5419.19.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] clocksource: avoid unnecessary overflow in
 cyclecounter_cyc2ns()
From: Mike Galbraith <bitbucket@online.de>
To: Henrik Austad <henrik@austad.us>
Cc: John Stultz <johnstul@us.ibm.com>, Salman Qazi <sqazi@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 04 Mar 2014 08:31:20 +0100
In-Reply-To: <20140304072020.GA18178@austad.us>
References: <1393910409.6415.9.camel@marge.simpson.net>
	 <20140304072020.GA18178@austad.us>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:nRiarcN7Aby8pfINYOqyPYo3XHC48BrSQckcKL0832+
 tZvNSpJvdeYg+4kCHqBsuPEVl5dQhhJo5QIWffYR5dHElW4Ar/
 +iTYA/OTu6rKjX5ESJXXVRtxjkkzxhP1EtutMh0GDzNezzqYAt
 OuJ7Qgn0L8UB0LUAR9/LTPAYTpLr//ZnzBiQN4tRBCS4gQuvQV
 ia/CfMWUYcNsd1hDqUt+kKkbD4z7dLJgi9pai6TTkzP+Kz/zJB
 h8lZcavf4/9giFaJ2CdFVgPwP0RkvyNjuRWd/3L+mqxDfAD8iV
 /w4IKiZVxjD7b5A1dhOqgHgk56vJGITuSGzi2G5yitEfuo8ecD
 tt69woxavRStzYIzipaLZRJYBngQpSRDHzzaIsXIa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 08:20 +0100, Henrik Austad wrote: 
> On Tue, Mar 04, 2014 at 06:20:09AM +0100, Mike Galbraith wrote:
> > Greetings,
> > 
> > While rummaging around looking for HTH a gaggle of weird a$$ machines
> > can manage to timewarp back and forth by exactly 208 days, I stumbled
> > across $subject which looks like it may want to borrow Salman's fix.
> > 
> > clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
> > 
> > As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
> > cycles * mult >> shift is overflow prone. so give it the same treatment.
> > 
> > Cc: Salman Qazi <sqazi@google.com>
> > Cc: John Stultz <johnstul@us.ibm.com>
> > Signed-off-by: Mike Galbraith <bitbucket@online.de>
> > ---
> >  include/linux/clocksource.h |   11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > --- a/include/linux/clocksource.h
> > +++ b/include/linux/clocksource.h
> > @@ -77,13 +77,18 @@ struct timecounter {
> >   *
> >   * XXX - This could use some mult_lxl_ll() asm optimization. Same code
> >   * as in cyc2ns, but with unsigned result.
> > + *
> > + * Because it is the same as x86 __cycles_2_ns, give it the same treatment as
> > + * commit 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock"
> > + * to avoid a potential cycles * mult overflow.
> 
> Do we normally reference a particular commit in a comment? Why not just 
> grab the same comment and add a "this is grabbed from arch/x86/... ?

Fewer '+' signs?  History doesn't go away, so seems fine to me.

-Mike

