Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3LRU4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:56:04 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43045 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3LRU4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:56:01 -0500
Date: Wed, 18 Dec 2013 12:55:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, torvalds@linux-foundation.org,
        VICTORK@il.ibm.com, oleg@redhat.com, anton@samba.org,
        benh@kernel.crashing.org, fweisbec@gmail.com,
        mathieu.desnoyers@polymtl.ca, michael@ellerman.id.au,
        mikey@neuling.org, linux@arm.linux.org.uk, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, tony.luck@intel.com
Subject: Re: [PATCH 0/4] arch: Introduce smp_load_acquire() and
 smp_store_release()
Message-ID: <20131218205556.GT19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131218190806.370008594@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218190806.370008594@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121820-1542-0000-0000-00000463FC12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 08:08:06PM +0100, Peter Zijlstra wrote:
> 
> This should hopefully be the last posting of this series -- people felt it
> needed one more mostly because last time I typoed the linux-kernel email
> address.
> 
> If there are no further comments, Ingo will merge these patches in the next few
> days.

They still look good to me!

							Thanx, Paul

> ---
> 
> These patches introduce 2 new barrier primitives:
> 
>   smp_load_acquire(p)
>   smp_store_release(p, v)
> 
> See the first patch, which changes Documentation/memory-barriers.txt, to find
> the exact definitions of what an ACQUIRE/RELEASE barrier is -- previously known
> as LOCK/UNLOCK barriers.
> 
> The second patch moves the smp_mb__{before,after}_atomic_{dec,inc}() barriers
> to asm/atomic.h for arc and hexagon -- they were already there for all other archs.
> 
> This cleans up asm/barrier.h, and the third patch makes more agressive use of
> asm-generic/barrier.h to implement the simple cases.
> 
> Then the fourth patch adds the new primitives.
> 
> Previous versions were widely build tested -- this version is not, but it also
> not significantly different.
> 
> These patches apply to:
> 
>   tip/master
> 
> 
> ---
> Changes since the last version -- lkml.kernel.org/r/20131213145657.265414969@infradead.org
> 
>  - fixed linux-kernel email address
>  - updated the Documentation patch
> 

