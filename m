Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaFLSZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:25:54 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:29438 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaFLSZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:25:53 -0400
Message-ID: <1402597547.2627.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 4/4] mutex: Optimize mutex trylock slowpath
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        tim.c.chen@linux.intel.com, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, Waiman.Long@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Thu, 12 Jun 2014 11:25:47 -0700
In-Reply-To: <1402511843-4721-5-git-send-email-jason.low2@hp.com>
References: <1402511843-4721-1-git-send-email-jason.low2@hp.com>
	 <1402511843-4721-5-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 11:37 -0700, Jason Low wrote:
> The mutex_trylock() function calls into __mutex_trylock_fastpath() when
> trying to obtain the mutex. On 32 bit x86, in the !__HAVE_ARCH_CMPXCHG
> case, __mutex_trylock_fastpath() calls directly into __mutex_trylock_slowpath()
> regardless of whether or not the mutex is locked.
> 
> In __mutex_trylock_slowpath(), we then acquire the wait_lock spinlock, xchg()
> lock->count with -1, then set lock->count back to 0 if there are no waiters,
> and return true if the prev lock count was 1.
> 
> However, if the mutex is already locked, then there isn't much point
> in attempting all of the above expensive operations. In this patch, we only
> attempt the above trylock operations if the mutex is unlocked.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>

This is significantly cleaner than the v1 patch.

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

