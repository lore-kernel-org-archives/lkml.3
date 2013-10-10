Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab3JJTFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:05:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab3JJTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:05:42 -0400
Message-ID: <5256FA26.8010105@redhat.com>
Date: Thu, 10 Oct 2013 15:04:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, aarcange@redhat.com, srikar@linux.vnet.ibm.com,
        mgorman@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/numa: Introduce migrate_swap()
References: <1381141781-10992-39-git-send-email-mgorman@suse.de> <tip-ac66f5477239ebd3c4e2cbf2f591ef387aa09884@git.kernel.org> <20131010181722.GO13848@laptop.programming.kicks-ass.net>
In-Reply-To: <20131010181722.GO13848@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 02:17 PM, Peter Zijlstra wrote:
> On Wed, Oct 09, 2013 at 10:30:13AM -0700, tip-bot for Peter Zijlstra wrote:
>> sched/numa: Introduce migrate_swap()
>
> Thanks to Rik for writing the Changelog!
>
> ---
> From: Peter Zijlstra <peterz@infradead.org>
> Subject: sched: Fix race in migrate_swap_stop
>
> There is a subtle race in migrate_swap, when task P, on CPU A, decides to swap
> places with task T, on CPU B.
>
> Task P:
>    - call migrate_swap
> Task T:
>    - go to sleep, removing itself from the runqueue
> Task P:
>    - double lock the runqueues on CPU A & B
> Task T:
>    - get woken up, place itself on the runqueue of CPU C
> Task P:
>    - see that task T is on a runqueue, and pretend to remove it
>      from the runqueue on CPU B
>
> Now CPUs B & C both have corrupted scheduler data structures.
>
> This patch fixes it, by holding the pi_lock for both of the tasks
> involved in the migrate swap. This prevents task T from waking up,
> and placing itself onto another runqueue, until after migrate_swap
> has released all locks.
>
> This means that, when migrate_swap checks, task T will be either
> on the runqueue where it was originally seen, or not on any
> runqueue at all. Migrate_swap deals correctly with of those cases.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Tested-by: Joe Mario <jmario@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

