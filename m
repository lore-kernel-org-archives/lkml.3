Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaFFHil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:38:41 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51218 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaFFHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:38:40 -0400
Message-ID: <53916FAA.3030008@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2014 13:07:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: akpm@linux-foundation.org, fweisbec@gmail.com, tglx@linutronix.de,
        hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smp, ipi: Speed up IPI handling by invoking the callbacks
 in reverse order
References: <20140604193934.21321.19185.stgit@srivatsabhat.in.ibm.com> <20140604194731.GO13930@laptop.programming.kicks-ass.net> <538F7C7D.9040606@linux.vnet.ibm.com> <20140605072637.GF3213@twins.programming.kicks-ass.net>
In-Reply-To: <20140605072637.GF3213@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060607-6102-0000-0000-000005B93B36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 12:56 PM, Peter Zijlstra wrote:
> On Thu, Jun 05, 2014 at 01:37:25AM +0530, Srivatsa S. Bhat wrote:
>> On 06/05/2014 01:17 AM, Peter Zijlstra wrote:
>>> On Thu, Jun 05, 2014 at 01:09:35AM +0530, Srivatsa S. Bhat wrote:
>>>> The current implementation of lockless list (llist) has a drawback: if we
>>>> want to traverse the list in FIFO order (oldest to newest), we need to
>>>> reverse the list first (and this can be expensive if the list is large,
>>>> since this is an O(n) operation).
>>>
>>> Have you actually looked at the queue depth of this thing? Large queues
>>> are a problem for interrupt latency.
>>>
>>
>> Actually, I wrote this patch just by looking at the code and realizing
>> that we don't need to reverse the list. In practice, I haven't actually
>> seen any noticeable interrupt latencies or large queues so far. So I think
>> this patch is just a very tiny optimization, that's all.
> 
> So conceptually it makes sense to service in FIFO because the first
> entry is waiting longest, by servicing them in LIFO order you get far
> more variance in latency.
> 
> And if the list is small, the cost isn't high.
> 
> Then again, we don't have any good numbers one way or the other.
> 

Hmm, right. I thought hard to see if there is a clever way to maintain
the llist in the FIFO order itself, while still preserving the atomicity
guarantees, but I couldn't think of anything sane :-(

Regards,
Srivatsa S. Bhat

