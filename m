Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaEBI7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:59:12 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42104 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaEBI7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:59:09 -0400
Message-ID: <53635E5F.8070100@linaro.org>
Date: Fri, 02 May 2014 10:59:11 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: peterz@infradead.org, mingo@elte.hu, amit.kucheria@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH V2 1/2] sched: idle: Encapsulate the code to compile it
 out
References: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org> <2783362.8r7SvVhudq@vostro.rjw.lan> <2735426.75qSjG3M6Y@vostro.rjw.lan>
In-Reply-To: <2735426.75qSjG3M6Y@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 12:56 AM, Rafael J. Wysocki wrote:
> On Thursday, May 01, 2014 12:47:25 AM Rafael J. Wysocki wrote:
>> On Wednesday, April 30, 2014 02:01:02 PM Daniel Lezcano wrote:
>>> Encapsulate the large portion of cpuidle_idle_call inside another
>>> function so when CONFIG_CPU_IDLE=n, the code will be compiled out.
>>> Also that is benefitial for the clarity of the code as it removes
>>> a nested indentation level.
>>>
>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>> Well, this conflicts with
>>
>> https://patchwork.kernel.org/patch/4071541/
>>
>> which you haven't commented on and I still want cpuidle_select() to be able to
>> return negative values because of
>>
>> https://patchwork.kernel.org/patch/4089631/
>>
>> (and I have one more patch on top of these two that requires this).
>
> Moreover (along the lines of Nico said) after https://patchwork.kernel.org/patch/4071541/
> we actually don't need the #ifdef CONFIG_CPU_IDLE in your patch, because cpuidle_select()
> for CONFIG_CPU_IDLE unset is a static inline returning a negative number and the compiler
> should optimize out the blocks that depend on it being non-negative.

Thanks for the head up.

Actually that was to solve a compilation issue with the next patch when 
adding the cpuidle state in the struct rq.

When the option CPU_IDLE is not set, the code assinging the cpu idle 
state in the rq is still there while in the struct rq the field is 
compiled out with the ifdef macro. If I rely on the compiler 
optimization, the compilation error will happen.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

