Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3LTA0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:26:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:52706 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab3LTA0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:26:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,516,1384329600"; 
   d="scan'208";a="427524622"
Message-ID: <1387499182.3510.43.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 19 Dec 2013 16:26:22 -0800
In-Reply-To: <CA+55aFyUd4Mhy8Rsbv=etahBCrQyWeZSLxW9sL0uCF0hCXkHfQ@mail.gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	 <1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
	 <CA+55aFyUd4Mhy8Rsbv=etahBCrQyWeZSLxW9sL0uCF0hCXkHfQ@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 16:04 -0800, Linus Torvalds wrote:
> On Thu, Dec 19, 2013 at 3:53 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >  - in queue_lock(), immediately before getting the spinlock (which
> > will do the SAME ATOMIC INCREMENT, except it's just doing it on a
> > different member of the structure, namely the spinlock head)
> 
> Ok, so there's the "q->lock_ptr = &hb->lock" assignment in between,
> but if the ordering of that is critical, it should be documented in
> the memory ordering rules, because it sure is subtle and not obviously
> visible anywhere..

I'm trying to look into this to confirm, but it will require some time
for me to page that all in. There are some issues with respect to the
lock_ptr that are documented in the other functions (like unqueue_me),
but I *think* they are mostly on the other end of the operation and may
not be an issue here... 

q->lock_ptr == 0 also indicates "woken" state.

I will spend some time on this to try and get a definitive answer.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


