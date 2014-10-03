Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaJCOvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:51:24 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34244 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaJCOvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <20141003143634.GL2849@worktop.programming.kicks-ass.net>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-4-git-send-email-vincent.guittot@linaro.org> <20141003143634.GL2849@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 3 Oct 2014 16:51:01 +0200
Message-ID: <CAKfTPtDvX=JFf6OBBzTVbo6C76p243za+9CkL-ofSOvHQS5-mQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] sched: add utilization_avg_contrib
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2014 16:36, Peter Zijlstra <peterz@infradead.org> wrote:
>
>> +      * utilization_load_avg is the sum of the average running time of the
>> +      * sched_entities on the rq.
>>        */
>
> So I think there was some talk about a blocked_utilization thingy, which
> would track the avg running time of the tasks currently asleep, right?
>

yes. Do you mean that we should anticipate and rename
utilization_load_avg into utilization_runnable_avg to make space for a
utilization_blocked_avg that could be added in future ?

>> +     unsigned long runnable_load_avg, blocked_load_avg, utilization_load_avg;
>>       atomic64_t decay_counter;
>>       u64 last_decay;
>>       atomic_long_t removed_load;
