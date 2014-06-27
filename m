Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaF0HrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:47:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbaF0HrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:47:00 -0400
Date: Fri, 27 Jun 2014 09:46:58 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Race when writing and swapping cpu buffer
 in parallel
Message-ID: <20140627074658.GA23205@pathway.suse.cz>
References: <1403788958-6751-1-git-send-email-pmladek@suse.cz>
 <20140626095831.667f834f@gandalf.local.home>
 <20140626205500.3f8e111c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626205500.3f8e111c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-26 20:55:00, Steven Rostedt wrote:
> On Thu, 26 Jun 2014 09:58:31 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > What we can do is force ring_buffer_swap_cpu() to only work for the CPU
> > that it is on. As we have snapshot in per_cpu buffers, to make that
> > work, we will need to change the per_cpu version of snapshot to do a
> > smp_call_function_single() to the CPU that it wants to take a snapshot
> > of, and run the swap there.
> > 
> > To force this, we can remove the cpu parameter from the
> > ring_buffer_swap_cpu(). By doing this, we may be able to remove some of
> > the CONFIG_RING_BUFFER_ALLOW_SWAP hacks too!
> > 
> > I'm not going to sacrifice the general performance of the ring buffer
> > for a feature that is seldom (if ever) used.

Fair enough. I see the point.

> Did you want to do the above, or do you want me to write something up?

I could look at it the following week.

When I think about it, the race is not that critical. In the worst
case, it slightly modifies the swapped buffer but there should not
be danger of any data corruption. Anyway, I will try to get rid of
it the way you suggested. It might be more important when the
ringbuffer has more users.

Best Regards,
Petr
