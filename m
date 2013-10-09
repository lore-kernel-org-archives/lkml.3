Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3JIWK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:10:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41157 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3JIWK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:10:26 -0400
Message-ID: <1381356624.4971.26.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH v2 tip/core/rcu 07/13] ipv6/ip6_tunnel: Apply
 rcu_access_pointer() to avoid sparse false positive
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
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
Date: Wed, 09 Oct 2013 15:10:24 -0700
In-Reply-To: <20131009215747.GA5790@linux.vnet.ibm.com>
References: <20131009212920.GA15413@linux.vnet.ibm.com>
	 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1381354186-16285-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1381354949.4971.20.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131009215747.GA5790@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 14:57 -0700, Paul E. McKenney wrote:

> Hmmm...  I could use RCU_INIT_POINTER().  Something like the following?
> 
> 	RCU_INIT_POINTER(ACCESS_ONCE(*tp), t->next);
> 
> The ACCESS_ONCE() to prevent the compiler from doing anything stupid.
> Presumably the value of t->next cannot change, so a normal load suffices.
> 
> Or did you have something else in mind?

Well, *tp and t->next are both of the same type, with __rcu attribute.

struct ip6_tnl __rcu **tp;

So I meant :

ACCESS_ONCE(*tp) = t->next;

If really we can have a really stupid compiler.


