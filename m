Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab3EWLbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:31:35 -0400
Received: from mail.us.es ([193.147.175.20]:59352 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688Ab3EWLb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:31:26 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.8/17262. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.7/7.5):. 
 Processed in 4.834373 secs); 23 May 2013 11:31:25 -0000
X-Envelope-From: pneira@us.es
Date: Thu, 23 May 2013 13:31:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, horms@verge.net.au, eric.dumazet@gmail.com,
        ja@ssi.bg, mingo@redhat.com, paulmck@linux.vnet.ibm.com,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dipankar@in.ibm.com
Subject: Re: [PATCH ipvs-next v3 0/2] sched: Add cond_resched_rcu_lock()
 helper
Message-ID: <20130523113117.GG22553@localhost>
References: <1369201832-17163-1-git-send-email-horms@verge.net.au>
 <20130522075438.GO26912@twins.programming.kicks-ass.net>
 <20130522.013108.58504645261021804.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522.013108.58504645261021804.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

I did so. Thanks David.
