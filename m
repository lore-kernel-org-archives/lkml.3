Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbaDCASb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:18:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38632 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591AbaDCAS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:18:29 -0400
Date: Thu, 3 Apr 2014 02:18:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 0/2] nohz: Move nohz kick out of scheduler IPI v2
Message-ID: <20140403001825.GC23338@localhost.localdomain>
References: <1396483767-28607-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396483767-28607-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I got Jens address wrong once again :-(

On Thu, Apr 03, 2014 at 02:09:25AM +0200, Frederic Weisbecker wrote:
> Hi Paul,
> 
> Here's an updated version of the patches with your review addressed.
> I ripped the function parameter and let it be setup on queued IPI object
> initialization time so that people don't get confused and always use the
> same function for a given queued object.
> 
> Please tell me if you find other issues.
> 
> Thanks.
> 
> Frederic Weisbecker (2):
>   smp: Non busy-waiting IPI queue
>   nohz: Move full nohz kick to its own IPI
> 
>  include/linux/smp.h      | 11 +++++++++++
>  include/linux/tick.h     |  2 ++
>  kernel/sched/core.c      |  5 +----
>  kernel/sched/sched.h     |  2 +-
>  kernel/smp.c             | 42 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/time/tick-sched.c | 21 +++++++++++++++++++++
>  6 files changed, 78 insertions(+), 5 deletions(-)
> 
> -- 
> 1.8.3.1
> 
