Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbaEMNhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:37:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399AbaEMNhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:37:00 -0400
Message-ID: <53721FD4.6060300@redhat.com>
Date: Tue, 13 May 2014 09:36:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Michael wang <wangyun@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <537192D3.5030907@linux.vnet.ibm.com> <20140513094737.GU30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140513094737.GU30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 05:47 AM, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 11:34:43AM +0800, Michael wang wrote:
>> During our testing, we found that the cpu.shares doesn't work as
>> expected, the testing is:
>>
> 
> /me zaps all the kvm nonsense as that's non reproducable and only serves
> to annoy.
> 
> Pro-tip: never use kvm to report cpu-cgroup issues.
> 
>> So is this results expected (I really do not think so...)?
>>
>> Or that imply the cpu-cgroup got some issue to be fixed?
> 
> So what I did (WSM-EP 2x6x2):
> 
> mount none /cgroup -t cgroup -o cpu
> mkdir -p /cgroup/a
> mkdir -p /cgroup/b
> mkdir -p /cgroup/c
> 
> echo $$ > /cgroup/a/tasks ; for ((i=0; i<12; i++)) ; do A.sh & done
> echo $$ > /cgroup/b/tasks ; for ((i=0; i<12; i++)) ; do B.sh & done
> echo $$ > /cgroup/c/tasks ; for ((i=0; i<12; i++)) ; do C.sh & done
> 
> echo 2048 > /cgroup/c/cpu.shares
> 
> Where [ABC].sh are spinners:

I suspect the "are spinners" is key.

Infinite loops can run all the time, while dbench spends a lot of
its time waiting for locks. That waiting may interfere with getting
as much CPU as it wants.

-- 
All rights reversed
