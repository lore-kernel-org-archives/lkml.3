Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3DVUFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:05:33 -0400
Received: from mb1i1mx.ns.pitt.edu ([136.142.11.141]:43143 "EHLO
	mb1i1.ns.pitt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754827Ab3DVUFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:05:31 -0400
Date: Mon, 22 Apr 2013 16:05:30 -0400
From: Jiannan Ouyang <ouyang@cs.pitt.edu>
Subject: Re: Preemptable Ticket Spinlock
In-reply-to: <517595FA.800@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
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
Message-id: <CAJocwcfmqOzB2q7Vugkyydq5WSjbYQ06z9xLxY4qdyznCnEJGg@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
 <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>
 <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>
 <517595FA.800@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 3:56 PM, Rik van Riel <riel@redhat.com> wrote:
> On 04/22/2013 03:49 PM, Peter Zijlstra wrote:
>>
>> On Mon, 2013-04-22 at 08:52 -0400, Rik van Riel wrote:
>
>
>>> If the native spin_lock code has been called already at
>>> that time, the native code would still need to be modified
>>> to increment the ticket number by 2, so we end up with a
>>> compatible value in each spin lock's .tickets field, and
>>> prevent a deadlock after we switch over to the paravirt
>>> variant.
>>
>>
>> I thought the stuff already made it upstream, but apparently not; the
>> lastest posting I'm aware of is here:
>>
>>    https://lkml.org/lkml/2012/5/2/105
>>
>> That stuff changes the normal ticket increment as well..
>
>
> Jiannan,
>
> It looks like the patch above could make a good patch
> 1 (or 2) in your patch series :)
>
> --
> All rights reversed

Yes.
I'm going to move my code, updated with Rik's suggestions, to paravirt
ops based on Jeremy's patch.
I'll post a new patch series soon.

Thanks to everyone for the great feedback!
--Jiannan
