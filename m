Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaAOO24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:28:56 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50697 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAOO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:28:53 -0500
Message-ID: <52D69AFA.1060308@linaro.org>
Date: Wed, 15 Jan 2014 22:28:10 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org> <52D61DA0.8050206@linux.vnet.ibm.com> <52D62E96.6030301@linaro.org> <52D6412D.8050000@linux.vnet.ibm.com>
In-Reply-To: <52D6412D.8050000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 04:05 PM, Michael wang wrote:
> On 01/15/2014 02:45 PM, Alex Shi wrote:
> [snip]
>>
>> yes, to save your scenario, we need to know the next timer for idle cpu,
>> but that is not enough, interrupt is totally unpredictable. So, I'd
>> rather bear the coarse method now.
>>>
>>> So what about just check 'ts->tick_stopped' and record one ticking idle
>>> cpu? the cost could be lower than time comparison, we could reduce the
>>> risk may be...(well, not so risky since the logical only works when
>>> system is relaxing with several cpu idle)
>>
>> first, nohz full also stop tick. second, tick_stopped can not reflect
>> the interrupt. when the idle cpu was interrupted, it's waken, then be a
>> good candidate for task running.
> 
> IMHO, if we have to do gamble here, we better choose the cheaper bet,
> unless we could prove this 'coarse method' have more higher chance for
> BINGO than just check 'tick_stopped'...

Tick stopped on a nohz full CPU, but the cpu still had a task running...
> 
> BTW, may be the logical should be in the select_idle_sibling()?

both of functions need to be considered.
> 
> Regards,
> Michael Wang
> 
>>
> 


-- 
Thanks
    Alex
