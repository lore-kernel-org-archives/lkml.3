Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3DVMwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:52:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3DVMwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:52:45 -0400
Message-ID: <51753289.70406@redhat.com>
Date: Mon, 22 Apr 2013 08:52:25 -0400
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
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>  <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>
In-Reply-To: <1366631460.4443.3.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 07:51 AM, Peter Zijlstra wrote:
> On Sun, 2013-04-21 at 17:12 -0400, Rik van Riel wrote:
>>
>> If we always incremented the ticket number by 2 (instead of 1), then
>> we could use the lower bit of the ticket number as the spinlock.
>
> ISTR that paravirt ticket locks already do that and use the lsb to
> indicate the unlock needs to perform wakeups.
>
> Also, since all of this is virt nonsense, shouldn't it live in the
> paravirt ticket lock code and leave the native code as is?

Sure, but that is still no reason not to have the virt
implementation be as fast as possible, and share the same
data type as the non-virt implementation.

Also, is it guaranteed that the native spin_lock code has
not been called yet before we switch over to the paravirt
functions?

If the native spin_lock code has been called already at
that time, the native code would still need to be modified
to increment the ticket number by 2, so we end up with a
compatible value in each spin lock's .tickets field, and
prevent a deadlock after we switch over to the paravirt
variant.

-- 
All rights reversed
