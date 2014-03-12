Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaCLGPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:15:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47298 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaCLGPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:15:32 -0400
Date: Wed, 12 Mar 2014 07:15:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Waiman Long <waiman.long@hp.com>, arnd@arndb.de,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
Message-ID: <20140312061503.GH30956@twins.programming.kicks-ass.net>
References: <20140310154236.038181843@infradead.org>
 <20140312023153.GW13647@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312023153.GW13647@dastard>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:31:53PM +1100, Dave Chinner wrote:
> With the queuing spinlock, I expected to see somewhat better
> results, but I didn't at first. Turns out if you have any sort of
> lock debugging turned on, then the code doesn't ever go into the
> lock slow path and hence does not ever enter the "lock failed" slow
> path where all the contention fixes are supposed to be.

Yeah; its a 'feature' of the spinlock debugging to turn all spinlocks
into test-and-set thingies.

> Anyway, with all lock debugging turned off, the system hangs
> the instant I start the multithreaded bulkstat workload. Even the
> console is unrepsonsive. 

Oops, I only briefly tested this series in userspace and that seemed to
work. I'll go prod at it. Thanks for having a look though.

Is that bstat test any easier/faster to setup/run than the aim7 crap?
