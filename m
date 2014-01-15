Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaAOGqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:46:13 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46805 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaAOGqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:46:10 -0500
Message-ID: <52D62E96.6030301@linaro.org>
Date: Wed, 15 Jan 2014 14:45:42 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org> <52D61DA0.8050206@linux.vnet.ibm.com>
In-Reply-To: <52D61DA0.8050206@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 01:33 PM, Michael wang wrote:
> On 01/15/2014 12:07 PM, Alex Shi wrote:
>> > Currently we just try to find least load cpu. If some cpus idled,
>> > we just pick the first cpu in cpu mask.
>> > 
>> > In fact we can get the interrupted idle cpu or the latest idled cpu,
>> > then we may get the benefit from both latency and power.
>> > The selected cpu maybe not the best, since other cpu may be interrupted
>> > during our selecting. But be captious costs too much.
> So the idea here is we want to choose the latest idle cpu if we have
> multiple idle cpu for choosing, correct?

yes.
> 
> And I guess that was in order to avoid choosing tickless cpu while there
> are un-tickless idle one, is that right?

no, current logical choice least load cpu no matter if it is idle.
> 
> What confused me is, what about those cpu who just going to recover from
> tickless as you mentioned, which means latest idle doesn't mean the best
> choice, or even could be the worst (if just two choice, and the longer
> tickless one is just going to recover while the latest is going to
> tickless).

yes, to save your scenario, we need to know the next timer for idle cpu,
but that is not enough, interrupt is totally unpredictable. So, I'd
rather bear the coarse method now.
> 
> So what about just check 'ts->tick_stopped' and record one ticking idle
> cpu? the cost could be lower than time comparison, we could reduce the
> risk may be...(well, not so risky since the logical only works when
> system is relaxing with several cpu idle)

first, nohz full also stop tick. second, tick_stopped can not reflect
the interrupt. when the idle cpu was interrupted, it's waken, then be a
good candidate for task running.

-- 
Thanks
    Alex
