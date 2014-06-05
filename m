Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaFETWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:22:14 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:49668 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaFETWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:22:13 -0400
Message-ID: <1401996117.6680.33.camel@j-VirtualBox>
Subject: Re: [RFC PATCH 1/3] locking/mutex: Try to acquire mutex only if it
 is unlocked
From: Jason Low <jason.low2@hp.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com, riel@redhat.com,
        hpa@zytor.com, walken@google.com, davidlohr@hp.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Date: Thu, 05 Jun 2014 12:21:57 -0700
In-Reply-To: <538FE2DE.8080800@hp.com>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
	  <1401908911-8947-2-git-send-email-jason.low2@hp.com>
	  <20140604194322.GN13930@laptop.programming.kicks-ass.net>
	 <1401917173.2232.14.camel@j-VirtualBox> <538FE2DE.8080800@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 23:24 -0400, Waiman Long wrote:
> On 06/04/2014 05:26 PM, Jason Low wrote:
> > On Wed, 2014-06-04 at 21:43 +0200, Peter Zijlstra wrote:
> >> Please make them inline functions, also can we rename the SHOW_NO_WAITER
> >> thing, because its not at all clear to me wtf it does; should it be
> >> called: mutex_no_waiters() or somesuch?
> > Okay, I can make them inline functions. I mainly added the macro to keep
> > it consistent with the MUTEX_SHOW_NO_WAITER() check, but we can surely
> > make this more clear. mutex_no_waiters() sounds fine, or perhaps
> > something like mutex_has_no_waiters()?
> >
> 
> You can remove the MUTEX_SHOW_NO_WAITER macro as all the call sites are 
> to be replaced.

Sure.

> I didn't check directly for unlocked count because of 
> fairness concern in my original patch, but I think checking directly for 
> unlocked count should be fine too.

Can you elaborate on the "fairness concern"? In the current code, we're
already directly checking for unlocked count in
atomic_read(&lock->count) == 1 if that's what you're referring to.

Thanks,
Jason

