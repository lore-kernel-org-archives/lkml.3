Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaFMUv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:51:29 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:25326 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaFMUv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:51:28 -0400
Message-ID: <1402692675.27369.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [patch V2 5/5] futex: Simplify futex_lock_pi_atomic() and make
 it more robust
From: Davidlohr Bueso <davidlohr@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <darren@dvhart.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Date: Fri, 13 Jun 2014 13:51:15 -0700
In-Reply-To: <alpine.DEB.2.10.1406131137020.5170@nanos>
References: <20140611202744.676528190@linutronix.de>
	  <20140611204237.361836310@linutronix.de>
	 <1402638363.22229.23.camel@fury.dvhart.com>
	 <alpine.DEB.2.10.1406131033440.5170@nanos>
	 <alpine.DEB.2.10.1406131136140.5170@nanos>
	 <alpine.DEB.2.10.1406131137020.5170@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 11:44 +0200, Thomas Gleixner wrote:
> Subject: futex: Simplify futex_lock_pi_atomic() and make it more robust
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 11 Jun 2014 20:45:41 -0000
> 
> futex_lock_pi_atomic() is a maze of retry hoops and loops.
> 
> Reduce it to simple and understandable states:
> 
> First step is to lookup existing waiters (state) in the kernel.
> 
> If there is an existing waiter, validate it and attach to it.
> 
> If there is no existing waiter, check the user space value
> 
> If the TID encoded in the user space value is 0, take over the futex
> preserving the owner died bit.
> 
> If the TID encoded in the user space value is != 0, lookup the owner
> task, validate it and attach to it.
> 
> Reduces text size by 128 bytes on x8664.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Darren Hart <darren@dvhart.com>
> Cc: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Kees Cook <kees@outflux.net>
> Cc: wad@chromium.org
> Link: http://lkml.kernel.org/r/20140611204237.361836310@linutronix.de
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> 
> V2: Fixed the brown paperbag bug of V1

I confirm this v2 fixes the issue. Passes 5 hr pounding on my 80-core
system. Unsurprisingly, I didn't see any performance regressions either.

Thanks,
Davidlohr

