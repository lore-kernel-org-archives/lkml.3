Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaFDU2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:28:40 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:36213 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaFDU2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:28:39 -0400
Message-ID: <1401913714.13877.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH 3/3] locking/mutex: Optimize mutex trylock slowpath
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, tim.c.chen@linux.intel.com,
        peter@hurleysoftware.com, riel@redhat.com, hpa@zytor.com,
        walken@google.com, Waiman.Long@hp.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Date: Wed, 04 Jun 2014 13:28:34 -0700
In-Reply-To: <1401908911-8947-4-git-send-email-jason.low2@hp.com>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
	 <1401908911-8947-4-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 12:08 -0700, Jason Low wrote:
> In __mutex_trylock_slowpath(), we acquire the wait_lock spinlock,
> xchg() lock->count with -1, then set lock->count back to 0 if there
> are no waiters, and return true if the prev lock count was 1.
> 
> However, if we the mutex is already locked, then there may not be
             ^^ leave that out.

> much point in attempting the above operations. 

Isn't this redundant? I mean, if we enter the slowpath its because
__mutex_fastpath_trylock() already failed so we already know that the
lock is taken.

What kind of testing has this change been put through? Any advantages?
(ie: how many cycles are we saving here?), the trylock mechanism is
already pretty darn fast.

Thanks,
Davidlohr

