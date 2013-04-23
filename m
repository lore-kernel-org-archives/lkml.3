Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3DWF6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:58:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab3DWF6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:58:04 -0400
Date: Tue, 23 Apr 2013 08:57:44 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi.kivity@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Subject: Re: Preemptable Ticket Spinlock
Message-ID: <20130423055743.GB12401@redhat.com>
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
 <51745650.9050204@redhat.com>
 <1366631460.4443.3.camel@laptop>
 <51753289.70406@redhat.com>
 <1366660147.6454.6.camel@laptop>
 <517595FA.800@redhat.com>
 <1366661294.6454.18.camel@laptop>
 <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com>
 <1366664138.8337.18.camel@laptop>
 <5175C2D6.9020202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5175C2D6.9020202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 07:08:06PM -0400, Rik van Riel wrote:
> On 04/22/2013 04:55 PM, Peter Zijlstra wrote:
> >On Mon, 2013-04-22 at 16:46 -0400, Jiannan Ouyang wrote:
> 
> >>- pv-preemptable-lock has much less performance variance compare to
> >>pv_lock, because it adapts to preemption within  VM,
> >>   other than using rescheduling that increase VM interference
> >
> >I would say it has a _much_ worse worst case (and thus worse variance)
> >than the paravirt ticket implementation from Jeremy. While full
> >paravirt ticket lock results in vcpu scheduling it does maintain
> >fairness.
> >
> >If you drop strict fairness you can end up in unbounded starvation
> >cases and those are very ugly indeed.
> 
> If needed, Jiannan's scheme could easily be bounded to prevent
> infinite starvation. For example, we could allow only the first
> 8 CPUs in line to jump the queue.
> 
> However, given the way that virtual CPUs get scheduled in and
> out all the time, I suspect starvation is not a worry, and we
> will not need the additional complexity to deal with it.
> 
FWIW RHEL6 uses unfair spinlock when it runs as a guest. We never got
reports about problems due to this on any scale.

> You may want to play around with virtualization a bit, to get
> a feel for how things work in virt land.
> 
> -- 
> All rights reversed

--
			Gleb.
