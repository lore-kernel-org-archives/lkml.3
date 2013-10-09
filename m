Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3JIWhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:37:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37286 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab3JIWhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:37:00 -0400
Date: Wed, 9 Oct 2013 15:36:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 tip/core/rcu 07/13] ipv6/ip6_tunnel: Apply
 rcu_access_pointer() to avoid sparse false positive
Message-ID: <20131009223652.GC5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131009212920.GA15413@linux.vnet.ibm.com>
 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1381354186-16285-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <1381354949.4971.20.camel@edumazet-glaptop.roam.corp.google.com>
 <20131009215747.GA5790@linux.vnet.ibm.com>
 <1381356624.4971.26.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381356624.4971.26.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100922-8236-0000-0000-0000028DC220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 03:10:24PM -0700, Eric Dumazet wrote:
> On Wed, 2013-10-09 at 14:57 -0700, Paul E. McKenney wrote:
> 
> > Hmmm...  I could use RCU_INIT_POINTER().  Something like the following?
> > 
> > 	RCU_INIT_POINTER(ACCESS_ONCE(*tp), t->next);
> > 
> > The ACCESS_ONCE() to prevent the compiler from doing anything stupid.
> > Presumably the value of t->next cannot change, so a normal load suffices.
> > 
> > Or did you have something else in mind?
> 
> Well, *tp and t->next are both of the same type, with __rcu attribute.
> 
> struct ip6_tnl __rcu **tp;
> 
> So I meant :
> 
> ACCESS_ONCE(*tp) = t->next;
> 
> If really we can have a really stupid compiler.

That would work, though it would probably give sparse complaints.

Of course, it is not the stupid compilers that worry me, but rather the
smart ones...

							Thanx, Paul

