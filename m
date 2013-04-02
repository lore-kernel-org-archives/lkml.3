Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3DBHfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:35:05 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34700 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760957Ab3DBHfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:35:01 -0400
Message-ID: <515A8A21.6070509@linaro.org>
Date: Tue, 02 Apr 2013 09:34:57 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: jonghwa3.lee@samsung.com
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [RFC PATCH 1/2] cpuidle: Add idle enter/exit time stamp for notifying
 current idle state.
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com> <1364804657-16590-2-git-send-email-jonghwa3.lee@samsung.com> <515A65DB.8070803@linaro.org> <515A77FC.70008@samsung.com>
In-Reply-To: <515A77FC.70008@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 08:17 AM, jonghwa3.lee@samsung.com wrote:
> On 2013년 04월 02일 14:00, Daniel Lezcano wrote:
> 
>> On 04/01/2013 10:24 AM, Jonghwa Lee wrote:
>>> This patch adds idle state time stamp to cpuidle device structure to
>>> notify its current idle state. If last enter time is newer than last
>>> exit time, then it means that the core is in idle now.
>>>
>>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> ---
>>
>> The patch description does not explain what problem you want to solve,
>> how to solve it and the patch itself shows nothing.
>>
>> Could you elaborate ?
> 
> 
> I'm sorry for lacking description. I supplement more.
> 
> This patch does add time-stamp for idle enter/exit only nothing more.
> The reason why I needed them is that I wanted to know current cpu idle
> state. It is hard to know whether cpu is in idle or not now.

Did you looked at:

include/linux/sched.h:extern int idle_cpu(int cpu);

?

> When I check the cpuidle state usage, sometimes the information is wrong.
> Because it is updated only when the cpu exits the idle state. So while the
> cpu is idling, the cpuidle state usage holds past one. Therefore I put
> the time-stamp for cpuidle enter/exit for checking current idling and
> calculating idle state usage correctly.
> 
> I just make this patch temporary for my cpufreq governor work. So, it just
> use time-stamp for all idle state together. After RFC working, I have a plan
> to update this patch to use timestamp for each idle state.

I suggest you look at the enter_idle / exit_idle function and make your
governor to subscribe to the IDLE_START/EXIT notifiers.

arch/x86/kernel/process.c

These are defined for the x86 architecture, maybe worth to add it to
another architecture.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

