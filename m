Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaATQI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:08:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60672 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaATQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:08:52 -0500
Date: Mon, 20 Jan 2014 17:08:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v9 2/5] qrwlock x86: Enable x86 to use queue read/write
 lock
Message-ID: <20140120160806.GI30183@twins.programming.kicks-ass.net>
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
 <1389761047-47566-3-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389761047-47566-3-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:44:04PM -0500, Waiman Long wrote:
> This patch makes the necessary changes at the x86 architecture specific
> layer to enable the presence of the CONFIG_QUEUE_RWLOCK kernel option
> to replace the read/write lock by the queue read/write lock.
> 
> It also enables the CONFIG_QUEUE_RWLOCK option by default for x86 which
> will force the use of queue read/write lock. That will greatly improve
> the fairness of read/write lock and eliminate live-lock situation
> where one task may not get the lock for an indefinite period of time.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  arch/x86/Kconfig                      |    1 +
>  arch/x86/include/asm/spinlock.h       |    2 ++
>  arch/x86/include/asm/spinlock_types.h |    4 ++++
>  3 files changed, 7 insertions(+), 0 deletions(-)

This patch doesn't have nearly enough -, you should rip out all traces
of the old rwlock. There's no point in having it configurable, either
qrwlock is good or not.
