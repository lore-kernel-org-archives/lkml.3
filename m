Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3DVXI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab3DVXI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:08:27 -0400
Message-ID: <5175C2D6.9020202@redhat.com>
Date: Mon, 22 Apr 2013 19:08:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiannan Ouyang <ouyang@cs.pitt.edu>, LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>  <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>  <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>  <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop>  <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com> <1366664138.8337.18.camel@laptop>
In-Reply-To: <1366664138.8337.18.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 04:55 PM, Peter Zijlstra wrote:
> On Mon, 2013-04-22 at 16:46 -0400, Jiannan Ouyang wrote:

>> - pv-preemptable-lock has much less performance variance compare to
>> pv_lock, because it adapts to preemption within  VM,
>>    other than using rescheduling that increase VM interference
>
> I would say it has a _much_ worse worst case (and thus worse variance)
> than the paravirt ticket implementation from Jeremy. While full
> paravirt ticket lock results in vcpu scheduling it does maintain
> fairness.
>
> If you drop strict fairness you can end up in unbounded starvation
> cases and those are very ugly indeed.

If needed, Jiannan's scheme could easily be bounded to prevent
infinite starvation. For example, we could allow only the first
8 CPUs in line to jump the queue.

However, given the way that virtual CPUs get scheduled in and
out all the time, I suspect starvation is not a worry, and we
will not need the additional complexity to deal with it.

You may want to play around with virtualization a bit, to get
a feel for how things work in virt land.

-- 
All rights reversed
