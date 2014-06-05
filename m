Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaFELUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:20:42 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:53528 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFELUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:20:40 -0400
Date: Thu, 5 Jun 2014 13:20:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605112035.GA27384@gmail.com>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <20140605081742.GC4926@gmail.com>
 <20140605111110.GA26771@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140605111110.GA26771@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Not unexpected the breakage comes from:
> 
>  5627b9d439cc4dfaab738b8c21eef10fb40733f8 is the first bad commit
>  commit 5627b9d439cc4dfaab738b8c21eef10fb40733f8
>  Author: Waiman Long <Waiman.Long@hp.com>
>  Date:   Mon Feb 3 13:18:57 2014 +0100
> 
>     x86, locking: Switch x86 to qrwlock-style rwlocks and optimize it
>     
>     Make x86 use the fair rwlock_t.
> 
> Please also split the feature-enabling and the optimization into two 
> separate patches.

So a bit of an update: I've done the first part of the splitup: the 
simple enablement of qrwlock-style rwlocks on x86.

But even that leaves build errors:

  include/asm-generic/qrwlock_types.h:14:3: error: conflicting types for ‘arch_rwlock_t’

Which means the base patch is broken:

  78e077b0c5ec locking/qrwlock: Introduce qrwlock

I've picked up the other patches (rwsem optimistic spinning and 
fallout), and can apply the qwrlock patches once they are fixed and 
properly split up.

Thanks,

	Ingo
