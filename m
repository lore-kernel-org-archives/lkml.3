Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3CEM1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 07:27:46 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54010 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3CEM1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:27:44 -0500
Message-ID: <5135E3E9.3020608@linux.vnet.ibm.com>
Date: Tue, 05 Mar 2013 17:54:09 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 0/2] kvm: Better yield_to candidate using preemption
 notifiers
References: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com> <20130305095307.GA11728@hawk.usersys.redhat.com>
In-Reply-To: <20130305095307.GA11728@hawk.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030512-8256-0000-0000-00000679B9BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 03:23 PM, Andrew Jones wrote:
> On Mon, Mar 04, 2013 at 11:31:46PM +0530, Raghavendra K T wrote:
>>   This patch series further filters better vcpu candidate to yield to
>> in PLE handler. The main idea is to record the preempted vcpus using
>> preempt notifiers and iterate only those preempted vcpus in the
>> handler. Note that the vcpus which were in spinloop during pause loop
>> exit are already filtered.
>
> The %improvement and patch series look good.
>

Thank you for the review.

>>
>> Thanks Jiannan, Avi for bringing the idea and Gleb, PeterZ for
>> precious suggestions during the discussion.
>> Thanks Srikar for suggesting to avoid rcu lock while checking task state
>> that has improved overcommit cases.
>>
>> There are basically two approches for the implementation.
>>
>> Method 1: Uses per vcpu preempt flag (this series).
>>
>> Method 2: We keep a bitmap of preempted vcpus. using this we can easily
>> iterate over preempted vcpus.
>>
>> Note that method 2 needs an extra index variable to identify/map bitmap to
>> vcpu and it also needs static vcpu allocation.
>
> We definitely don't want something that requires static vcpu allocation.
> I think it'd be better to add another counter for the vcpu bit assignment.
>

So do you mean some thing parallel to online_vcpus?

>>
>> I am also posting Method 2 approach for reference in case it interests.
>
> I guess the interest in Method2 would come from perf numbers. Did you try
> comparing Method1 vs. Method2?
>

Yes I did. Performance wise method2 is almost equal to method1. But I
believe if there is any difference it may show when we have large vcpu
guest. (Currently I have only 32 core host).

