Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3DVF4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:56:35 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48276 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3DVF4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:56:34 -0400
Message-ID: <5174D1D4.1080704@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 11:29:48 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiannan Ouyang <ouyang@cs.pitt.edu>
CC: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com> <51745650.9050204@redhat.com> <CAJocwccDznaMGkBgWpZ9M5k3JUqf0pnvK2hDyRBR_JEseNrQ_g@mail.gmail.com>
In-Reply-To: <CAJocwccDznaMGkBgWpZ9M5k3JUqf0pnvK2hDyRBR_JEseNrQ_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042205-5564-0000-0000-000007997B6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 04:37 AM, Jiannan Ouyang wrote:
> On Sun, Apr 21, 2013 at 5:12 PM, Rik van Riel <riel@redhat.com> wrote:
>> Your algorithm is very clever, and very promising.
>>
>> However, it does increase the size of the struct spinlock, and adds
>> an additional atomic operation to spin_unlock, neither of which I
>> suspect are necessary.
>>
>> If we always incremented the ticket number by 2 (instead of 1), then
>> we could use the lower bit of the ticket number as the spinlock.
>>
>> If we do NOT run virtualized, we simply increment the ticket by 2
>> in spin_unlock, and the code can remain otherwise the same.
>>
>> If we do run virtualized, we take that spinlock after acquiring
>> the ticket (or timing out), just like in your code. In the
>> virtualized spin_unlock, we can then release the spinlock and
>> increment the ticket in one operation: by simply increasing the
>> ticket by 1.
>>
>> In other words, we should be able to keep the overhead of this
>> to an absolute minimum, and keep spin_unlock to be always the
>> same cost it is today.
>>
>> --
>> All rights reversed
>
> Hi Rik,
>
> Thanks for your feedback.
>
> Yes I agree with you
> - increase the size of struct spinlock is unnecessary
> - your idea of utilize the lower bit and save one atomic operation
> from unlock is cool!
>

Yes, +1. it is indeed a cool idea. Thanks to Jeremy.. and as Rik already 
mentioned it would also prevent the side effects of increasing
lock size. (It reminds my thought of encoding vcpuid in lock for pv 
spinlock)

> I can come up with a updated patch soon.
>
> --Jiannan
>
>

