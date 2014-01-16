Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaAPCg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:36:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52995 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaAPCg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:36:56 -0500
Date: Wed, 15 Jan 2014 18:36:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH v2 tip/core/timers] Crude timer-wheel latency hacks
Message-ID: <20140116023649.GT10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1401152316500.4207@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401152316500.4207@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011602-8236-0000-0000-0000061F805A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 11:22:41PM +0100, Thomas Gleixner wrote:
> Paul,
> 
> On Tue, 14 Jan 2014, Paul E. McKenney wrote:
> > The following three patches provide some crude timer-wheel latency
> > patches.  I understand that a more comprehensive solution is in progress,
> > but in the meantime, these patches work well in cases where a given
> > CPU has either zero or one timers pending, which is a common case for
> > NO_HZ_FULL kernels.  So, on the off-chance that this is helpful to
> > someone, the individual patches are as follows:
> 
> so far that makes sense, though I'd rather like to redesign the whole
> timer wheel mess than adding more duct tape to it.

This is supposed to be in addition you your redesign, absolutely not
instead of your redesign.  For one thing, hopefully your redesign
will avoid jiffy-scanning in the case where the CPU has a pair of
timers separated by many jiffies.  My patches won't help in that case.

My patches are instead intended for testing in the meantime, and they
do help a bit in some common NO_HZ_FULL situations.

>                                                    I can't dig into
> the details right now as I'm dead tired and about to leave for a
> funeral. i'll have a detailed look at this at the weekend.

My sympathies!

And I will be sending out an updated series shortly anyway.

							Thanx, Paul

