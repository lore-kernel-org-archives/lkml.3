Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbbA0RKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:10:32 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbA0RK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:10:28 -0500
Date: Tue, 27 Jan 2015 18:10:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 3/6] locking/rwsem: Set lock ownership ASAP
Message-ID: <20150127171021.GJ21418@twins.programming.kicks-ass.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
 <1422257769-14083-4-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422257769-14083-4-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 11:36:06PM -0800, Davidlohr Bueso wrote:
> In order to optimize the spinning step, we need to set the lock
> owner as soon as the lock is acquired; after a successful counter
> cmpxchg operation, that is. This is particularly useful as rwsems
> need to set the owner to nil for readers, so there is a greater
> chance of falling out of the spinning. Currently we only set the
> owner much later in the game, in the more generic level -- latency
> can be specially bad when waiting for a node->next pointer when
> releasing the osq in up_write calls.
> 
> As such, update the owner inside rwsem_try_write_lock (when the
> lock is obtained after blocking) and rwsem_try_write_lock_unqueued
> (when the lock is obtained while spinning). This requires creating
> a new internal rwsem.h header to share the owner related calls.
> 
> Also cleanup some headers for mutex and rwsem.

This is the thing I suggested
lkml.kernel.org/r/20150108103708.GE29390@twins.programming.kicks-ass.net
there right?

Do you have numbers for how much this gained?
