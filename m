Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3JIWqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:46:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45909 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3JIWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:46:33 -0400
Date: Wed, 9 Oct 2013 15:46:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
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
Message-ID: <20131009224624.GG5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131009212920.GA15413@linux.vnet.ibm.com>
 <20131009221805.GA11709@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009221805.GA11709@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100922-0928-0000-0000-000002696B54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 03:18:05PM -0700, Josh Triplett wrote:
> On Wed, Oct 09, 2013 at 02:29:20PM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This series features updates to allow sparse to do a better job of
> > statically analyzing RCU usage:
> > 
> > 1.	Apply ACCESS_ONCE() to rcu_assign_pointer()'s target to prevent
> > 	comiler mischief.  Also require that the source pointer be from
> > 	the kernel address space.  Sometimes it can be from the RCU address
> > 	space, which necessitates the remaining patches in this series.
> > 	Which, it must be admitted, apply to a very small fraction of
> > 	the rcu_assign_pointer() invocations in the kernel.  This commit
> > 	courtesy of Josh Triplett.
> > 
> > 2-13.	Apply rcu_access_pointer() to avoid a number of false positives.
> 
> I would suggest moving patch 1 to the end of the series, to avoid
> introducing and subsequently fixing warnings.

That would help with bisectability, will do!

							Thanx, Paul

