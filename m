Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbaJXNc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:32:58 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39009 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbaJXNc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:32:56 -0400
Message-ID: <544A5504.2090706@linaro.org>
Date: Fri, 24 Oct 2014 15:32:52 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rjw@rjwysocki.net, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/5] cpuidle: idle: menu: Don't reflect when a state selection
 failed
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org> <1413822343-1972-3-git-send-email-daniel.lezcano@linaro.org> <20141024132428.GJ12706@worktop.programming.kicks-ass.net>
In-Reply-To: <20141024132428.GJ12706@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 03:24 PM, Peter Zijlstra wrote:
> On Mon, Oct 20, 2014 at 06:25:41PM +0200, Daniel Lezcano wrote:
>> -	if (index > 0)
>> -	if (index >= 0)
>
> That's not the same condition.

Yes and it is wrong. That is the result of the 
CPUIDLE_DRIVER_STATE_START dance.

The ladder governor is avoiding to use the POLL state as it was running 
on x86. But on, eg. ARM, we will never reflect the state 0 because 
CPUIDLE_DRIVER_STATE_START is equal to zero for all non-x86 platform.

If I am not wrong the ladder select function will never choose the state 
0 for x86, so it will never reflect the state 0 (after applying the 
patch 1/5). For the other arch it will reflect the state 0 as it should.

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

