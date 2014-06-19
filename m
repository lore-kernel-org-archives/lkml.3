Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646AbaFSVEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:04:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55439 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934613AbaFSVD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:03:58 -0400
Date: Thu, 19 Jun 2014 13:53:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
Message-ID: <20140619205336.GM4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A2F406.4010109@oracle.com>
 <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
 <20140619165247.GA4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192127100.5170@nanos>
 <20140619202928.GG4904@linux.vnet.ibm.com>
 <53A34B23.1000401@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A34B23.1000401@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061920-9332-0000-0000-000001256D3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 04:42:11PM -0400, Sasha Levin wrote:
> On 06/19/2014 04:29 PM, Paul E. McKenney wrote:
> > rcu: Provide call_rcu_alloc() and call_rcu_sched_alloc() to avoid recursion
> > 
> > The sl*b allocators use call_rcu() to manage object lifetimes, but
> > call_rcu() can use debug-objects, which in turn invokes the sl*b
> > allocators.  These allocators are not prepared for this sort of
> > recursion, which can result in failures.
> > 
> > This commit therefore creates call_rcu_alloc() and call_rcu_sched_alloc(),
> > which act as their call_rcu() and call_rcu_sched() counterparts, but
> > which avoid invoking debug-objects.  These new API members are intended
> > only for use by the sl*b allocators, and this commit makes the sl*b
> > allocators use call_rcu_alloc().  Why call_rcu_sched_alloc()?  Because
> > in CONFIG_PREEMPT=n kernels, call_rcu() maps to call_rcu_sched(), so
> > therefore call_rcu_alloc() must map to call_rcu_sched_alloc().
> > 
> > Reported-by: Sasha Levin <sasha.levin@oracle.com>
> > Set-straight-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Paul, what is this patch based on? It won't apply cleanly on -next
> or Linus's tree.

On my -rcu tree, but I think that Thomas's approach is better.

							Thanx, Paul

