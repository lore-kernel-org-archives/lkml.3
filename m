Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3KUWTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:19:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60218 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3KUWSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:18:48 -0500
Date: Thu, 21 Nov 2013 23:18:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v2 RFC 1/3] documentation: Add needed ACCESS_ONCE() calls
 to memory-barriers.txt
Message-ID: <20131121221821.GB16796@laptop.programming.kicks-ass.net>
References: <20131121213055.GA6938@linux.vnet.ibm.com>
 <1385069489-7898-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131121215517.GA16796@laptop.programming.kicks-ass.net>
 <20131121220950.GG4138@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121220950.GG4138@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:09:51PM -0800, Paul E. McKenney wrote:
> On Thu, Nov 21, 2013 at 10:55:17PM +0100, Peter Zijlstra wrote:
> > On Thu, Nov 21, 2013 at 01:31:27PM -0800, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > The Documentation/memory-barriers.txt file was written before the need
> > > for ACCESS_ONCE() was fully appreciated.  It therefore contains no
> > > ACCESS_ONCE() calls, which can be a problem when people lift examples
> > > from it.  This commit therefore adds ACCESS_ONCE() calls.
> > 
> > So I find the repeated ACCESS_ONCE() significantly detracts from the
> > readability of the text.
> > 
> > Can't we simply state that all accesses are assumed single-copy atomic
> > and this can be achieved for naturally aligned words using ACCESS_ONCE()
> > in C/C++ ?
> 
> We could, but at the moment I would prefer the decrease in readability
> to the copy-and-paste bugs that omit needed ACCESS_ONCE() calls.
> 
> Is there some way to get both ACCESS_ONCE() and readability?  An
> abbreviation such as AO()?  More easily distinguished variable names?
> Something else?

Use a form that looks less like C and thus defeats copy/paste?
