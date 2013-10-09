Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3JIWa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:30:58 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58172 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3JIWa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:30:56 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 9 Oct 2013 15:30:37 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, fengguang.wu@intel.com, stephen@networkplumber.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, tgraf@suug.ch, gaofeng@cn.fujitsu.com,
        linux-decnet-user@lists.sourceforge.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH v2 tip/core/rcu 0/13] Sparse-related updates for 3.13
Message-ID: <20131009223036.GE11709@jtriplet-mobl1>
References: <20131009212920.GA15413@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009212920.GA15413@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 02:29:20PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series features updates to allow sparse to do a better job of
> statically analyzing RCU usage:
> 
> 1.	Apply ACCESS_ONCE() to rcu_assign_pointer()'s target to prevent
> 	comiler mischief.  Also require that the source pointer be from
> 	the kernel address space.  Sometimes it can be from the RCU address
> 	space, which necessitates the remaining patches in this series.
> 	Which, it must be admitted, apply to a very small fraction of
> 	the rcu_assign_pointer() invocations in the kernel.  This commit
> 	courtesy of Josh Triplett.
> 
> 2-13.	Apply rcu_access_pointer() to avoid a number of false positives.

I posted one minor nit in response to one of these patches, but in any
case, for 2-13:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I'm obviously OK with patch 1 as well, but it should move to the end of
the series, and you need a new patch 1 that adds a comment constraining
rcu_assign_pointer to evaluate its argument exactly once.

- Josh Triplett
