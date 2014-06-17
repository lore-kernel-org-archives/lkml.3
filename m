Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbaFQUGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:06:48 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:48326 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:06:46 -0400
X-Greylist: delayed 88242 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2014 16:06:46 EDT
Message-ID: <53A09FD3.1050709@hp.com>
Date: Tue, 17 Jun 2014 16:06:43 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Romanov Arya <romanov.arya@gmail.com>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: simplify force_quiescent_state()
References: <539FAE21.7070702@gmail.com> <20140617145419.GE4669@linux.vnet.ibm.com> <CAJKcOGdUDwdmdkpd0dw5xO9+TK=9W9fvF9Q+f5F_b4R8cEgdTA@mail.gmail.com> <53A07336.7030704@hp.com> <20140617171116.GH4669@linux.vnet.ibm.com> <20140617173717.GA28198@linux.vnet.ibm.com>
In-Reply-To: <20140617173717.GA28198@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 01:37 PM, Paul E. McKenney wrote:
>
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
>
> 							Thanx, Paul

Thank for the clarification as I haven't looked deep into the code to 
see how many levels there are. I totally understand the impact cacheline 
contention can have on system performance. After all, this is what many 
of my patches are trying to address.

-Longman
