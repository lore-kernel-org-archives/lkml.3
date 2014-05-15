Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaEOFE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:04:29 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39557 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaEOFE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:04:26 -0400
Message-ID: <1400130262.5175.93.camel@marge.simpson.net>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 15 May 2014 07:04:22 +0200
In-Reply-To: <20140515045011.GB3825@htj.dyndns.org>
References: <20140501142414.GA31611@htj.dyndns.org>
	 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
	 <20140501210242.GA28948@mtj.dyndns.org>
	 <20140501210943.GB28948@mtj.dyndns.org> <537384B9.5090907@suse.cz>
	 <20140514151501.GA24142@suse.cz> <20140514163238.GA15690@htj.dyndns.org>
	 <1400126037.5175.55.camel@marge.simpson.net>
	 <20140515040608.GA3825@htj.dyndns.org>
	 <1400129178.5175.82.camel@marge.simpson.net>
	 <20140515045011.GB3825@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 00:50 -0400, Tejun Heo wrote: 
> Hello, Mike.
> 
> On Thu, May 15, 2014 at 06:46:18AM +0200, Mike Galbraith wrote:
> > > I think it'd be healthier to identify the use cases and then provide
> > > proper interface for it.  Note that workqueue can now expose interface
> > > to modify concurrency, priority and cpumask to userland which
> > > writeback workers are already using.
> > 
> > You can't identify a specific thing, any/all of it can land on the
> > user's diner plate, so he should be able to make the decisions.  Power
> > to the user and all that, if he does something stupid, tuff titty.  User
> > getting to call the shots, and getting to keep the pieces when he fscks
> > it all up is wonderful stuff, lets kernel people off the hook :)
> 
> Do we know specific kthreads which need to be exposed with this way?

Soft/hard irq threads and anything having to do with IO mostly, which
including workqueues.  I had to give the user a rather fugly global
prioritization option to let users more or less safely do the evil deeds
they want to and WILL do whether I agree with their motivation to do so
or not.  I tell all users that realtime is real dangerous, but if they
want to do that, it's their box, so by definition perfectly fine.

> If there are good enough reasons for specific ones, sure, but I don't
> think "we can't change any of the kthreads because someone might be
> diddling with it" is something we can sustain in the long term.

I think the opposite.  Taking any control the user has is pure evil.

-Mike

