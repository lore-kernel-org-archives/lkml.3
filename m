Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3JIW6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:58:51 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:48847 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3JIW6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <1381354186-16285-5-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131009212920.GA15413@linux.vnet.ibm.com>
	<1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1381354186-16285-5-git-send-email-paulmck@linux.vnet.ibm.com>
Date: Wed, 9 Oct 2013 18:58:47 -0400
Message-ID: <CAPhKKr8kLDNd7CdksHriyMzsqcj0oSf7mAfLceviMjobYGy7oA@mail.gmail.com>
Subject: Re: [PATCH v2 tip/core/rcu 05/13] decnet: Apply rcu_access_pointer()
 to avoid sparse false positive
From: Dhaval Giani <dhaval.giani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org,
        laijs@cn.fujitsu.com, Dipankar <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        josh@joshtriplett.org, Nivedita Singhvi <niv@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        Darren Hart <darren@dvhart.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, sbw@mit.edu,
        "David S. Miller" <davem@davemloft.net>, Thomas Graf <tgraf@suug.ch>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 5:29 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>
> The sparse checking for rcu_assign_pointer() was recently upgraded
> to reject non-__kernel address spaces.  This also rejects __rcu,
> which is almost always the right thing to do.  However, the use in
> dn_insert_route() is legitimate: It is assigning a pointer to an element
> from an RCU-protected list, and all elements of this list are already
> visible to caller.
>
> This commit therefore silences this false positive by laundering the
> pointer using rcu_access_pointer() as suggested by Josh Triplett.
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>


I did not realize that we were allowed to rename people :-)

Thanks!
Dhaval
