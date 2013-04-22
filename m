Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3DVUqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:46:24 -0400
Received: from mb1i1mx.ns.pitt.edu ([136.142.11.141]:42468 "EHLO
	mb1i1.ns.pitt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755250Ab3DVUqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:46:22 -0400
Date: Mon, 22 Apr 2013 16:46:19 -0400
From: Jiannan Ouyang <ouyang@cs.pitt.edu>
Subject: Re: Preemptable Ticket Spinlock
In-reply-to: <1366661294.6454.18.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Message-id: <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
 <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>
 <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>
 <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 4:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:

>
> I much prefer the entire series from Jeremy since it maintains the
> ticket semantics and doesn't degrade the lock to unfair under
> contention.
>
> Now I suppose there's a reason its not been merged yet and I suspect
> its !paravirt hotpath impact which wasn't rightly justified or somesuch
> so maybe someone can work on that or so.. dunno.
>
>

In my paper, I comparable preemptable-lock and pv_lock on KVM from
Raghu and Jeremy.
Results show that:
- preemptable-lock improves performance significantly without paravirt support
- preemptable-lock can also be paravirtualized, which outperforms
pv_lock, especially when overcommited by 3 or more
- pv-preemptable-lock has much less performance variance compare to
pv_lock, because it adapts to preemption within  VM,
  other than using rescheduling that increase VM interference

It would still be very interesting to conduct more experiments to
compare these two, to see if the fairness enforced by pv_lock is
mandatory, and if preemptable-lock outperforms pv_lock in most cases,
and how do they work with PLE.

--Jiannan
