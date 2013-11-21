Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3KUWcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:32:36 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:41406 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KUWcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:32:35 -0500
Date: Thu, 21 Nov 2013 14:32:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v2 RFC 1/3] documentation: Add needed ACCESS_ONCE() calls
 to memory-barriers.txt
Message-ID: <20131121223230.GI4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131121213055.GA6938@linux.vnet.ibm.com>
 <1385069489-7898-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131121215517.GA16796@laptop.programming.kicks-ass.net>
 <20131121220950.GG4138@linux.vnet.ibm.com>
 <20131121221821.GB16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121221821.GB16796@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112122-0928-0000-0000-000003EB2C8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:18:21PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 21, 2013 at 02:09:51PM -0800, Paul E. McKenney wrote:
> > On Thu, Nov 21, 2013 at 10:55:17PM +0100, Peter Zijlstra wrote:
> > > On Thu, Nov 21, 2013 at 01:31:27PM -0800, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > The Documentation/memory-barriers.txt file was written before the need
> > > > for ACCESS_ONCE() was fully appreciated.  It therefore contains no
> > > > ACCESS_ONCE() calls, which can be a problem when people lift examples
> > > > from it.  This commit therefore adds ACCESS_ONCE() calls.
> > > 
> > > So I find the repeated ACCESS_ONCE() significantly detracts from the
> > > readability of the text.
> > > 
> > > Can't we simply state that all accesses are assumed single-copy atomic
> > > and this can be achieved for naturally aligned words using ACCESS_ONCE()
> > > in C/C++ ?
> > 
> > We could, but at the moment I would prefer the decrease in readability
> > to the copy-and-paste bugs that omit needed ACCESS_ONCE() calls.
> > 
> > Is there some way to get both ACCESS_ONCE() and readability?  An
> > abbreviation such as AO()?  More easily distinguished variable names?
> > Something else?
> 
> Use a form that looks less like C and thus defeats copy/paste?

My concern with that approach is that there is likely to be a large
number of people who are likely to be willing and able to transcribe
from any reasonable non-C form to ACCESS_ONCE()-free C code.  :-/

But maybe you have something specific in mind?

							Thanx, Paul

