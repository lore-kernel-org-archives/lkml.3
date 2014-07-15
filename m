Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaGOOcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:32:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39421 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaGOOcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:32:31 -0400
Date: Tue, 15 Jul 2014 07:32:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140715143225.GC8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140612135630.GA23606@htj.dyndns.org>
 <20140612153426.GV4581@linux.vnet.ibm.com>
 <20140612155227.GB23606@htj.dyndns.org>
 <20140617144151.GD4669@linux.vnet.ibm.com>
 <20140617152752.GC31819@htj.dyndns.org>
 <87lhs35p0v.fsf@rustcorp.com.au>
 <20140714113911.GM16041@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1407141014390.25436@gentwo.org>
 <20140715101150.GA8690@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1407150903570.10593@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407150903570.10593@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071514-1344-0000-0000-000002D71F4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 09:06:00AM -0500, Christoph Lameter wrote:
> On Tue, 15 Jul 2014, Paul E. McKenney wrote:
> 
> > If I understand your initialization procedure correctly, you need at least
> > an smp_wmb() on the update side and at least an smp_read_barrier_depends()
> > on the read side.
> 
> A barrier for data that is not in the cache of the read side? That has
> not been accessed yet (well there could have been a free_percpu before but
> if so then the cache line was evicted by the initialization code).

http://www.openvms.compaq.com/wizard/wiz_2637.html

Besides which, if you don't have barriers on the initialization side,
then both the CPU and the compiler are free to update the pointer before
completing the initialization, which can leave old stuff still in other
CPUs' caches for long enough to break you.

							Thanx, Paul

