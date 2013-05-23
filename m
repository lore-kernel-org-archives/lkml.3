Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab3EWLaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:30:55 -0400
Received: from mail.us.es ([193.147.175.20]:59204 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651Ab3EWLaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:30:52 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.8/17262. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.7/7.5):. 
 Processed in 1.826833 secs); 23 May 2013 11:30:50 -0000
X-Envelope-From: pneira@us.es
Date: Thu, 23 May 2013 13:30:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@verge.net.au>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH ipvs-next v3 2/2] ipvs: use cond_resched_rcu() helper
 when walking connections
Message-ID: <20130523113046.GF22553@localhost>
References: <1369201832-17163-1-git-send-email-horms@verge.net.au>
 <1369201832-17163-3-git-send-email-horms@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369201832-17163-3-git-send-email-horms@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:50:32PM +0900, Simon Horman wrote:
> This avoids the situation where walking of a large number of connections
> may prevent scheduling for a long time while also avoiding excessive
> calls to rcu_read_unlock() and rcu_read_lock().
> 
> Note that in the case of !CONFIG_PREEMPT_RCU this will
> add a call to cond_resched().

Applied, thanks.
