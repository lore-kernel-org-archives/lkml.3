Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3EVJBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:01:32 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55220
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324Ab3EVJB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:01:29 -0400
Date: Wed, 22 May 2013 11:00:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: horms@verge.net.au, eric.dumazet@gmail.com, ja@ssi.bg, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, pablo@netfilter.org, dipankar@in.ibm.com
Subject: Re: [PATCH ipvs-next v3 0/2] sched: Add cond_resched_rcu_lock()
 helper
Message-ID: <20130522090051.GA18810@twins.programming.kicks-ass.net>
References: <1369201832-17163-1-git-send-email-horms@verge.net.au>
 <20130522075438.GO26912@twins.programming.kicks-ass.net>
 <20130522.013108.58504645261021804.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522.013108.58504645261021804.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:31:08AM -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 22 May 2013 09:54:38 +0200
> 
> > On Wed, May 22, 2013 at 02:50:30PM +0900, Simon Horman wrote:
> >> Add a helper that for use in loops which read data protected by RCU and
> >> may have a large number of iterations.  Such an example is dumping the list
> >> of connections known to IPVS: ip_vs_conn_array() and ip_vs_conn_seq_next().
> >> 
> >> This series also updates IPVS to use the helper.
> >> 
> >> Simon Horman (2):
> >>   sched: add cond_resched_rcu() helper
> >>   ipvs: use cond_resched_rcu() helper when walking connections
> >> 
> >>  include/linux/sched.h           |  9 +++++++++
> >>  net/netfilter/ipvs/ip_vs_conn.c | 23 ++++++++---------------
> >>  2 files changed, 17 insertions(+), 15 deletions(-)
> > 
> > Acked-by: Peter Zijlstra <peterz@infradead.org>
> > 
> > How do you want to go about merging this? Do you want to route it
> > through the net tree or through -tip?
> 
> I think we can have Pablo merge it into his netfilter tree.

Works for me. Thanks!
