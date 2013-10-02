Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3JBPUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:20:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48938 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3JBPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:20:15 -0400
Date: Wed, 2 Oct 2013 17:19:37 +0200
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
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v4 0/3] qrwlock: Introducing a queue read/write lock
 implementation
Message-ID: <20131002151937.GU3081@twins.programming.kicks-ass.net>
References: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 10:09:03AM -0400, Waiman Long wrote:
> v3->v4:
>  - Optimize the fast path with better cold cache behavior and
>    performance.
>  - Removing some testing code.
>  - Make x86 use queue rwlock with no user configuration.

>  arch/x86/Kconfig                      |    1 +
>  arch/x86/include/asm/spinlock.h       |    2 +
>  arch/x86/include/asm/spinlock_types.h |    4 +
>  include/asm-generic/qrwlock.h         |  256 +++++++++++++++++++++++++++++++++
>  include/linux/rwlock.h                |   15 ++
>  include/linux/rwlock_types.h          |   13 ++
>  kernel/Kconfig.locks                  |    7 +
>  lib/Makefile                          |    1 +
>  lib/qrwlock.c                         |  247 +++++++++++++++++++++++++++++++
>  lib/spinlock_debug.c                  |   19 +++
>  10 files changed, 565 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-generic/qrwlock.h
>  create mode 100644 lib/qrwlock.c


Where's the ---- for removing the old rwlock from x86?
