Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916AbaENSwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:52:54 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44880 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaENSwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:52:53 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 14 May 2014 11:52:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Uma Sharma <uma.sharma523@gmail.com>
Subject: Re: [PATCH tip/core/rcu 1/1] rcu: Variable name changed in
 tree_plugin.h and used in tree.c
Message-ID: <20140514185239.GA4475@jtriplet-mobl1>
References: <1400027459-29427-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140514154150.GA1873@thin>
 <20140514155706.GG4570@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514155706.GG4570@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 08:57:06AM -0700, Paul E. McKenney wrote:
> On Wed, May 14, 2014 at 08:41:50AM -0700, Josh Triplett wrote:
> > On Tue, May 13, 2014 at 05:30:59PM -0700, Paul E. McKenney wrote:
> > > From: Uma Sharma <uma.sharma523@gmail.com>
> > > 
> > > The variable and struct both having the name "rcu_state" confuses
> > > sparse in some situations, so this commit changes the variable to
> > > "rcu_state_p" in order to avoid this confusion.  This also makes
> > > things easier for human readers.
> > 
> > Human readers aside, how does Sparse get confused?  Let's fix that.
> 
> OK.  The issue appears to be that we have a variable with the same
> name as a struct, as in:
> 
> struct rcu_state *rcu_state;

Which is completely legal C, and Sparse should have no issue with it.

> > Personally, I don't think the _p makes things particularly easier for
> > human readers, but it doesn't make things *harder* for anyone other than
> > those used to reading the existing code, so, *shrug*.
> 
> It does make it a bit easier for me when grepping through the source,
> given the large number of "struct rcu_state" strings in there.  And
> yes, I should be using some more modern tools than "grep" and "cscope"!
> But I am not the only throwback.  ;-)

Count me in as someone using "grep" as well (usually via "git grep").

- Josh Triplett
