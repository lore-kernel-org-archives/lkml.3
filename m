Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaBQVIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:08:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49880 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBQVIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:08:15 -0500
Message-ID: <53027A12.9090106@oracle.com>
Date: Mon, 17 Feb 2014 16:07:30 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
References: <52FFF7F8.2070801@oracle.com> <5301C41D.5000009@linux.vnet.ibm.com>
In-Reply-To: <5301C41D.5000009@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 03:11 AM, Michael wang wrote:
> Hi, Sasha
>
> On 02/16/2014 07:27 AM, Sasha Levin wrote:
>> Hi folks,
>>
>> While fuzzing with trinity inside a KVM tools guest running latest -next
>> kernel, I've
>> stumbled on the following:
>
> I've reproduced the same issue with tip/master, and below patch fixed the
> problem on my box along with some rcu stall info disappeared, would you
> like to have a try?
>
> BTW, I reproduced it by steps:
> 1. change current to RT
> 2. move to a different depth cpu-cgroup
> 3. change it back to FAIR
>
> Seems like it was caused by that RT has no task_move_group() implemented
> which could maintain depth, and that lead to a wrong depth after switched
> back to FAIR...

I *think* it works. There seems to be another sched issue that causes lockups,
so I can't say for certain that this one doesn't occur anymore.

I'm still working on collecting data for the other issue, I'll mail about it soon.


Thanks,
Sasha

