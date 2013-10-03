Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3JCTkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:40:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab3JCTkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:40:20 -0400
Date: Thu, 3 Oct 2013 21:33:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131003193319.GB17796@redhat.com>
References: <20131002145655.361606532@infradead.org> <20131002150518.675931976@infradead.org> <20131003164117.GD5790@linux.vnet.ibm.com> <20131003184001.GM28601@twins.programming.kicks-ass.net> <20131003184719.GA11996@redhat.com> <20131003192135.GR5790@linux.vnet.ibm.com> <20131003193206.GA17796@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003193206.GA17796@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Oleg Nesterov wrote:
>
> Because I believe this needs another patch ;) see below, didn't test
> it yet.
> ...
>  struct rcu_sync_ops {
>  	void (*sync)(void);
>  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> +#ifdef CONFIG_PROVE_RCU
> +	bool (*held)(void);
        ^^^^
OK, it has to return "int".

Oleg.

