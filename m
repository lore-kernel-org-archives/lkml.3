Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3LTAE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:04:29 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52433 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3LTAE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:04:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	<1387478746-5436-5-git-send-email-davidlohr@hp.com>
	<CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	<1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
Date: Thu, 19 Dec 2013 16:04:27 -0800
X-Google-Sender-Auth: DvyicULLlST2Ny-C-HtA5wmw2ts
Message-ID: <CA+55aFyUd4Mhy8Rsbv=etahBCrQyWeZSLxW9sL0uCF0hCXkHfQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 3:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  - in queue_lock(), immediately before getting the spinlock (which
> will do the SAME ATOMIC INCREMENT, except it's just doing it on a
> different member of the structure, namely the spinlock head)

Ok, so there's the "q->lock_ptr = &hb->lock" assignment in between,
but if the ordering of that is critical, it should be documented in
the memory ordering rules, because it sure is subtle and not obviously
visible anywhere..

            Linus
