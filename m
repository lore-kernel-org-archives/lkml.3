Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3JXQYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:24:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:23408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab3JXQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="424214323"
Subject: Re: [PATCH v4 1/3] qrwlock: A queue read/write lock implementation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, walken@google.com,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
In-Reply-To: <52692AE7.3060701@hp.com>
References: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
	 <1380722946-30468-2-git-send-email-Waiman.Long@hp.com>
	 <20131023120004.GD2862@localhost> <52680022.1020200@hp.com>
	 <alpine.DEB.2.02.1310241207500.4983@ionos.tec.linutronix.de>
	 <52692AE7.3060701@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Oct 2013 09:24:49 -0700
Message-ID: <1382631889.11046.208.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 10:12 -0400, Waiman Long wrote:
> On 10/24/2013 06:14 AM, Thomas Gleixner wrote:
> > On Wed, 23 Oct 2013, Waiman Long wrote:
> >> On 10/23/2013 08:00 AM, walken@google.com wrote:
> >>>> +	/*
> >>>> +	 * Wait until the next one in queue set up the next field
> >>>> +	 */
> >>>> +	while (likely(!(next = ACCESS_ONCE(node->next))))
> >>>> +		cpu_relax();
> >>>> +	/*
> >>>> +	 * The next one in queue is now at the head
> >>>> +	 */
> >>>> +notify_next:
> >>>> +	barrier();
> >>>> +	ACCESS_ONCE(next->wait) = false;
> >>>> +	smp_wmb();
> >>>> +}
> >>> I believe this could be unified with mspin_lock() / mspin_unlock() in
> >>> kernel/mutex.c ? (there is already talk of extending these functions
> >>> to be used by rwsem for adaptive spinning as well...)
> >> It probably can, but the unification can wait until the code are in.
> > The unification has to be done as a part of this series. Cleanups are
> > part of the development process of new code and not an optional
> > feature.
> >
> > Thanks,
> >
> > 	tglx
> >
> 
> There is an outstanding rwsem patch series that is doing the 
> unification. I am waiting for that patch series to be at least in a tip 
> or linux-next branch before doing the unification. Otherwise, it will 
> cause merge conflict.

We can merge the 3 MCS patches of the rwsem patch series first
while we continue to work on other rwsem patches. These 3 
patches are independent of the other rwsem patches.
They separate out the MCS locking into its own file and clean up
the code.

MCS Lock: Restructure the MCS lock defines and locking
https://lkml.org/lkml/2013/10/2/647
MCS Lock: optimizations and extra comments
https://lkml.org/lkml/2013/10/2/644
MCS Lock: Barrier corrections
https://lkml.org/lkml/2013/10/2/650

Thanks.

Tim



