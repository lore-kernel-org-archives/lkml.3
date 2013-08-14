Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab3HNP57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:57:59 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47537 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760018Ab3HNP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:57:56 -0400
Date: Wed, 14 Aug 2013 17:57:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v3 0/3] qrwlock: Introducing a queue read/write lock
 implementation
Message-ID: <20130814155751.GA17821@gmail.com>
References: <1375315259-29392-1-git-send-email-Waiman.Long@hp.com>
 <520A811A.7080907@hp.com>
 <20130814102041.GG10849@gmail.com>
 <520BA109.1000501@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BA109.1000501@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> On 08/14/2013 06:20 AM, Ingo Molnar wrote:
> >* Waiman Long<waiman.long@hp.com>  wrote:
> >
> >>
> >>I would like to share with you a rwlock related system crash that I
> >>encountered during my testing with hackbench on an 80-core DL980. The
> >>kernel crash because of a "watchdog detected hard lockup on cpu 79". The
> >>crashing CPU was running "write_lock_irq(&tasklist_lock)" in
> >>forget_original_parent() of the exit code path when I interrupted the
> >>hackbench which was spawning thousands of processes. Apparently, the
> >>remote CPU was not able to get the lock for a sufficient long time due
> >>to the unfairness of the rwlock which I think my version of queue rwlock
> >>will be able to alleviate this issue.
> >>
> >>So far, I was not able to reproduce the crash. I will try to see if I
> >>could more consistently reproduce it.
> >Was it an actual crash/lockup, or a longish hang followed by a lock
> >detector splat followed by the system eventually recovering back to
> >working order?
> >
> >Thanks,
> >
> >	Ingo
> 
> It was an actual crash initiated by the NMI handler. I think the
> system was in a halt state after that.

Could be a CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1 kernel?

Thanks,

	Ingo
