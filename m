Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3DQKlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:41:19 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:44653 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754645Ab3DQKlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:41:18 -0400
In-Reply-To: <516D84D8.6090407@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH] futex: bugfix for robust futex deadlock when waking only
 one thread in handle_futex_death
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.4 March 27, 2005
Message-ID: <OFD68395F8.51EA74C8-ON48257B50.00324CEE-48257B50.003AB601@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Wed, 17 Apr 2013 18:40:41 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-17 18:40:34,
	Serialize complete at 2013-04-17 18:40:34
Content-Type: text/plain; charset="US-ASCII"
X-MAIL: mse01.zte.com.cn r3HAeois048129
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart <dvhart@linux.intel.com> wrote on 2013/04/17 01:05:28:


> 
> Performance isn't an issue here as this is an error path. The question
> is if the
> changed behavior will constitute a problem for existing applications. 
Rather
> than a serialized cascading wake, we have them all wake at once. If an
> application depended on the first waker after owner death to do some 
cleanup
> before the rest came along, I could imagine some potential for failure
> there.
> 

I don't find out there are any APIs can wake all waiters at once, so still 
use futex_wake.
When waiter return form futex_wait syscall, glibc check the futex's value 
and try to modify it by using atomic instructions, and let the waiter 
return only if successed.
The applications which not use the glibc's library should follow this.

> One possible alternative would be to wake waiters for a different
> process group
> when OWNER_DEAD is set, and leave it as a single wake.
> 

To wake one waiter of other process cannot slove this problem , because it 
can be exiting too.
