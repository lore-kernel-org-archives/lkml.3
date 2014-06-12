Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaFLThN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:37:13 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:53460 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaFLThM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:37:12 -0400
Message-ID: <1402601825.2627.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 3/4] mutex: Try to acquire mutex only if it is
 unlocked
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        tim.c.chen@linux.intel.com, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, Waiman.Long@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Thu, 12 Jun 2014 12:37:05 -0700
In-Reply-To: <1402511843-4721-4-git-send-email-jason.low2@hp.com>
References: <1402511843-4721-1-git-send-email-jason.low2@hp.com>
	 <1402511843-4721-4-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 11:37 -0700, Jason Low wrote:
> Upon entering the slowpath in __mutex_lock_common(), we try once more to
> acquire the mutex. We only try to acquire if (lock->count >= 0). However,
> what we actually want here is to try to acquire if the mutex is unlocked
> (lock->count == 1). 
>   
> This patch changes it so that we only try-acquire the mutex upon entering
> the slowpath if it is unlocked, rather than if the lock count is non-negative.
> This helps further reduce unnecessary atomic xchg() operations.
> 
> Furthermore, this patch uses !mutex_is_locked(lock) to do the initial
> checks for if the lock is free rather than directly calling atomic_read()
> on the lock->count, in order to improve readability.

I think this patch can be merged in 2/4, like you had in v1. Otherwise
looks good.

