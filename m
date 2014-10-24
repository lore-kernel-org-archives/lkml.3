Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbaJXNoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:44:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39854 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbaJXNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:43:56 -0400
Message-ID: <544A5799.7020405@linaro.org>
Date: Fri, 24 Oct 2014 15:43:53 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rjw@rjwysocki.net, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/5] cpuidle: idle: menu: Don't reflect when a state selection
 failed
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org> <1413822343-1972-3-git-send-email-daniel.lezcano@linaro.org> <20141024133810.GK12706@worktop.programming.kicks-ass.net>
In-Reply-To: <20141024133810.GK12706@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 03:38 PM, Peter Zijlstra wrote:
> On Mon, Oct 20, 2014 at 06:25:41PM +0200, Daniel Lezcano wrote:
>> +++ b/kernel/sched/idle.c
>> @@ -162,7 +162,8 @@ use_default:
>>   	/*
>>   	 * Give the governor an opportunity to reflect on the outcome
>>   	 */
>> -	cpuidle_reflect(dev, entered_state);
>> +	if (entered_state >= 0)
>> +		cpuidle_reflect(dev, entered_state);
>>
>
> Given we'll do use_default: when next_state < 0, we actually never get
> here unless this is true.

There is the 'cpuidle_enter' call in between which may fail.



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

