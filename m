Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaGAJrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:47:33 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49410 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaGAJrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:47:31 -0400
Message-ID: <53B282E9.6060806@linux.vnet.ibm.com>
Date: Tue, 01 Jul 2014 15:14:09 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, pbonzini@redhat.com, gleb@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        waiman.long@hp.com, riel@redhat.com, davej@redhat.com, oleg@redhat.com,
        x86@kernel.org, jeremy@goop.org, paul.gortmaker@windriver.com,
        ak@linux.intel.com, jasowang@redhat.com, fernando_b1@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, mtosatti@redhat.com,
        chegu_vinod@hp.com
Subject: Re: [RFC PATCH v2] Implement Batched (group) ticket lock
References: <1403947024-3193-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140701080537.GH6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140701080537.GH6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070109-0260-0000-0000-00000541C7D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 01:35 PM, Peter Zijlstra wrote:
> On Sat, Jun 28, 2014 at 02:47:04PM +0530, Raghavendra K T wrote:
>> In virtualized environment there are mainly three problems
>> related to spinlocks that affects performance.
>> 1. LHP (lock holder preemption)
>> 2. Lock Waiter Preemption (LWP)
>> 3. Starvation/fairness
>>
>> Though Ticketlocks solve fairness problem it worsens LWP, LHP problems. Though
>> pv-ticketlocks tried to address these problems we can further improve at the
>>   cost of relaxed fairness. The following patch tries to achieve that by grouping
>> (batched) ticketlocks.
>
> And here I stop reading and ignore this patch, right?
>
> Why should I look at this?
>

For baremetal we continue to have 'fully fair ticketlock' with this 
patch series.

Good thing about the patch is we do have upper bound on starvation and
at the same time we solve Lock Waiter Preemption horror of strict
serialization of ticketlocks in guest and combine definite advantages
of unfair locks for guest.

