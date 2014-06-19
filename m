Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbaFSUmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:42:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43227 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975AbaFSUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:42:35 -0400
Message-ID: <53A34B23.1000401@oracle.com>
Date: Thu, 19 Jun 2014 16:42:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>
CC: Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
References: <53A2F406.4010109@oracle.com> <alpine.DEB.2.11.1406191001090.2785@gentwo.org> <20140619165247.GA4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192127100.5170@nanos> <20140619202928.GG4904@linux.vnet.ibm.com>
In-Reply-To: <20140619202928.GG4904@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 04:29 PM, Paul E. McKenney wrote:
> rcu: Provide call_rcu_alloc() and call_rcu_sched_alloc() to avoid recursion
> 
> The sl*b allocators use call_rcu() to manage object lifetimes, but
> call_rcu() can use debug-objects, which in turn invokes the sl*b
> allocators.  These allocators are not prepared for this sort of
> recursion, which can result in failures.
> 
> This commit therefore creates call_rcu_alloc() and call_rcu_sched_alloc(),
> which act as their call_rcu() and call_rcu_sched() counterparts, but
> which avoid invoking debug-objects.  These new API members are intended
> only for use by the sl*b allocators, and this commit makes the sl*b
> allocators use call_rcu_alloc().  Why call_rcu_sched_alloc()?  Because
> in CONFIG_PREEMPT=n kernels, call_rcu() maps to call_rcu_sched(), so
> therefore call_rcu_alloc() must map to call_rcu_sched_alloc().
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Set-straight-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Paul, what is this patch based on? It won't apply cleanly on -next
or Linus's tree.


Thanks,
Sasha
