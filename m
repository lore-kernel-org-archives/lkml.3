Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbaE2Jqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:46:54 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51026 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbaE2Jqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:46:52 -0400
Message-ID: <5387031E.702@linux.vnet.ibm.com>
Date: Thu, 29 May 2014 15:21:26 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, pbonzini@redhat.com, gleb@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        waiman.long@hp.com, davej@redhat.com, oleg@redhat.com, x86@kernel.org,
        jeremy@goop.org, paul.gortmaker@windriver.com, ak@linux.intel.com,
        jasowang@redhat.com, fernando_b1@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, riel@redhat.com, mtosatti@redhat.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Implement Batched (group) ticket lock
References: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140529064606.GH19143@laptop.programming.kicks-ass.net>
In-Reply-To: <20140529064606.GH19143@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052909-8256-0000-0000-00000D69DB71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 12:16 PM, Peter Zijlstra wrote:
> On Wed, May 28, 2014 at 05:46:39PM +0530, Raghavendra K T wrote:
>> In virtualized environment there are mainly three problems
>> related to spinlocks that affect performance.
>> 1. LHP (lock holder preemption)
>> 2. Lock Waiter Preemption (LWP)
>> 3. Starvation/fairness
>>
>>   Though ticketlocks solve the fairness problem, it worsens LWP, LHP problems.
>> pv-ticketlocks tried to address this. But we can further improve at the
>> cost of relaxed fairness.
>
> So I really hate the idea of having different locks for paravirt and
> normal kernels.

Yes. I understand that queued lock for normal kernel and unfair version 
of queued spinlock for virtual guest would do better.

Since strict serialization of lockwaiters (in both ticketlock/queued 
spinlock) does not work well for virtualized guest, my idea was to
give an alternate idea which has bounded starvation and performs as good 
as unfair version to virtualized guest.

>
> And we're looking to move to that queued lock for normal kernels.

Agree. and I have tested that too.

