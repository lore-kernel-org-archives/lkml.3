Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaJJK1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:27:11 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43307 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaJJK1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:27:08 -0400
Message-ID: <5437B462.4050102@gmail.com>
Date: Fri, 10 Oct 2014 18:26:42 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill V Tkhai <tkhai@yandex.ru>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/deadline: do not try to push tasks if pinned task
 switches to dl
References: <1412908997-15396-1-git-send-email-wanpeng.li@linux.intel.com> <20141010101016.GJ10832@worktop.programming.kicks-ass.net>
In-Reply-To: <20141010101016.GJ10832@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 10/10/14, 6:10 PM, Peter Zijlstra 写道:
> On Fri, Oct 10, 2014 at 10:43:17AM +0800, Wanpeng Li wrote:
>> As Kirill mentioned(https://lkml.org/lkml/2013/1/29/118):
>> | If rq has already had 2 or more pushable tasks and we try to add a
>> | pinned task then call of push_rt_task will just waste a time.
>>
>> Just switched pinned task is not able to be pushed. If the rq had had
>> several dl tasks before they have already been considered as candidates
>> to be pushed (or pulled). This patch does the same behavior as rt class
>> which introduced by commit 104479 (sched/rt: Do not try to push tasks
>> if pinned task switches to RT).
> Checkpatch rightly complains:
>
> ERROR: Please use 12 or more chars for the git commit ID like: 'commit 10447917551e ("sched/rt: Do not try to push tasks if pinned task switches to RT")'
> #12:
> which introduced by commit 104479 (sched/rt: Do not try to push tasks

I also got this warning before send out the patch, however, I check 6 
chars is enough for this commit. Anyway, I will send a newer version later.

Regards,
Wanpeng Li

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

