Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652Ab3EOQz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:55:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37672 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab3EOQzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:55:55 -0400
Date: Wed, 15 May 2013 18:55:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130515165542.GD13916@laptop.home>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515150652.GP23604@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:06:53AM -0400, Don Zickus wrote:
> Coming into the middle of the thread is always hard, but why/how does perf
> disable nohz_full?  I didn't think the hardware events of perf would cause
> problems as they are no different than an irq.  Curious.

Yah, right :-) So I think what happens is that when we enter kernel
space for whatever reason (say NMIs for a watchdog), we kill the magic
NO_HZ state that allows a single task that's stuck in userspace to
effectively have the tick disabled.

But yeah, the initial patch was a tad light on detail, so I'll have to
let Steve and Frederic expand / correct.
