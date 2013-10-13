Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3JMLR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 07:17:29 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37982 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab3JMLR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 07:17:27 -0400
Date: Sun, 13 Oct 2013 04:17:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>, peterz@infradead.org,
        fweisbec@gmail.com, dhowells@redhat.com, edumazet@google.com,
        gaofeng@cn.fujitsu.com, mingo@kernel.org,
        bridge@lists.linux-foundation.org, jmorris@namei.org,
        dipankar@in.ibm.com, darren@dvhart.com, rostedt@goodmis.org,
        niv@us.ibm.com, mathieu.desnoyers@efficios.com, kuznet@ms2.inr.ac.ru,
        tglx@linutronix.de, johannes@sipsolutions.net, laijs@cn.fujitsu.com,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kaber@trash.net, stephen@networkplumber.org, sbw@mit.edu,
        tgraf@suug.ch, akpm@linux-foundation.org, fengguang.wu@intel.com,
        davem@davemloft.net
Subject: Re: [Bridge] [PATCH v3 tip/core/rcu 0/14] Sparse-related updates for
 3.13
Message-ID: <20131013111716.GG5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131011231659.GA28062@linux.vnet.ibm.com>
 <20131012065326.GG15339@leaf>
 <20131012171345.GB5790@linux.vnet.ibm.com>
 <20131012173930.GD20321@order.stressinduktion.org>
 <20131012174354.GE20321@order.stressinduktion.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131012174354.GE20321@order.stressinduktion.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101311-8236-0000-0000-000002AD11EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 07:43:54PM +0200, Hannes Frederic Sowa wrote:
> On Sat, Oct 12, 2013 at 07:39:30PM +0200, Hannes Frederic Sowa wrote:
> > On Sat, Oct 12, 2013 at 10:13:45AM -0700, Paul E. McKenney wrote:
> > > On Fri, Oct 11, 2013 at 11:53:27PM -0700, Josh Triplett wrote:
> > > > On Fri, Oct 11, 2013 at 04:16:59PM -0700, Paul E. McKenney wrote:
> > > > > Changes from v2:
> > > > > 
> > > > > o	Switch from rcu_assign_pointer() to ACCESS_ONCE() given that
> > > > > 	the pointers are all --rcu and already visible to readers,
> > > > > 	as suggested by Eric Dumazet and Josh Triplett.
> > > > 
> > > > Hang on a moment.  Do *none* of these cases need write memory barriers?
> > > 
> > > Sigh.  Some afternoons it doesn't pay to touch the keyboard.
> > > 
> > > Thank you for catching this.  I will fix, but at this point, I am thinking
> > > in terms of 3.14 rather than 3.13 for this series.
> > 
> > Some of them looked safe. You could also replace --rcu with __rcu in the
> > comments while at it.
> 
> Most of them deal with management, maybe a rtnl_assign_pointer with lockdep
> check for rtnl lock could help to not clean up the wrong bits.
> 
> I don't know if rtnl_assign_pointer is that a could name as it does not really
> explain why the barrier is not needed there. :/

Beyond a certain point, I need to let people who know more about Linux's
networking implementation handle this sort of thing.

							Thanx, Paul

