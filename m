Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaFWK3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:29:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaFWK3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:29:02 -0400
Date: Mon, 23 Jun 2014 12:28:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Waiman Long <waiman.long@hp.com>, Romanov Arya <romanov.arya@gmail.com>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: simplify
 force_quiescent_state()
Message-ID: <20140623102850.GX19860@laptop.programming.kicks-ass.net>
References: <539FAE21.7070702@gmail.com>
 <20140617145419.GE4669@linux.vnet.ibm.com>
 <CAJKcOGdUDwdmdkpd0dw5xO9+TK=9W9fvF9Q+f5F_b4R8cEgdTA@mail.gmail.com>
 <53A07336.7030704@hp.com>
 <20140617171116.GH4669@linux.vnet.ibm.com>
 <20140617173717.GA28198@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617173717.GA28198@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:37:17AM -0700, Paul E. McKenney wrote:
> Oh, and to answer the implicit question...  A properly configured 4096-CPU
> system will have two funnel levels, with 64 nodes at the leaf level
> and a single node at the root level.  If the system is not properly
> configured, it will have three funnel levels.  The maximum number of
> funnel levels is four, which would handle more than four million CPUs
> (sixteen million if properly configured), so we should be good.  ;-)
> 
> The larger numbers of levels are intended strictly for testing.  I set
> CONFIG_RCU_FANOUT_LEAF=2 and CONFIG_RCU_FANOUT=2 on a 16-CPU system just
> to make sure that I am testing something uglier than what will be running
> in production.  A large system should have both of these set to 64,
> though this requires also booting with skew_tick=1 as well.

Right, and I think we talked about this before; the first thing one
should do is align the RCU fanout masks with the actual machine
topology. Because currently they can be all over the place.
