Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369AbaDJOdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:33:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:16414 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934856AbaDJOc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:32:57 -0400
Date: Thu, 10 Apr 2014 10:32:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140410103255.2eba08c6@gandalf.local.home>
In-Reply-To: <1397140123.5137.99.camel@marge.simpson.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
	<1397139510.5137.92.camel@marge.simpson.net>
	<1397140123.5137.99.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 16:28:43 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> On Thu, 2014-04-10 at 16:18 +0200, Mike Galbraith wrote: 
> > On Wed, 2014-04-09 at 15:19 -0400, Steven Rostedt wrote:
> > 
> > > If you have any benchmark on large machines I would be very happy if
> > > you could test this patch against the unpatched version of -rt.
> > 
> > Too bad I don't have (and know how to use) specjbb.
> > 
> > I dug up old vmark, thinking I'd be able to get some halfway useful
> > relative numbers from it, but that was a waste of a day.  The thing
> > performs so badly on 40 core box that rt _beats_ nopreempt, and after 2
> > nodes, you're going backward.  40 Westmere EX cores does a whopping ~2.5
> > * dinky old Q6600 box throughput.
> 
> P.S.  What I didn't see was any sign of a delta patched/unpatched..
> which may mean nothing at all :-/

Actually that at least means it didn't cause any regressions for you.

-- Steve
