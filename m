Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaAONpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:45:16 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52953 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAONpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:45:13 -0500
Message-ID: <52D690DE.8080507@linaro.org>
Date: Wed, 15 Jan 2014 14:45:02 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: raistlin@linux.it, juri.lelli@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <20140115120418.GD31570@twins.programming.kicks-ass.net> <20140115122452.GA18311@gmail.com>
In-Reply-To: <20140115122452.GA18311@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 01:24 PM, Ingo Molnar wrote:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Wed, Jan 15, 2014 at 09:27:34AM +0100, Daniel Lezcano wrote:
>>>
>>> Hi all,
>>>
>>> I use the tip/sched/core branch.
>>>
>>> After git pulling yesterday, my host is unresponsive after booting the OS.
>>>
>>>   * It boots normally
>>>   * It sends info to the console
>>>   * The graphics does not work
>>>   * The terminals show the prompt, I can enter the username but after
>>> pressing enter, it does not give the password prompt
>>>   * sysrq works more or less, I can't get the process stack but it receives
>>> the command
>>>
>>> It is like no new process can be created.
>>>
>>> I have a dual Xeon processor E5325 (2 x 4 cores).
>>>
>>> After git bisecting, the following patch seems to introduce the bug.
>>>
>>> commit d50dde5a10f305253cbc3855307f608f8a3c5f73
>>
>> OK, so my headless WSM-EP boots just fine. Obviously it cannot confirm
>> if graphics works, but I can ssh in and work on it without bother.
>>
>> I can even log in on the serial console without problems.
>>
>> I tried both tip/master and tip/sched/core.
>
> I too booted various sytems and have yet to notice similar oddity.

Ok, I was able to boot and use the system with init=/bin/bash and a 
busybox but the ubuntu distro ends up to block after booting. So I guess 
there a service triggering something in the kernel leading to this issue.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

