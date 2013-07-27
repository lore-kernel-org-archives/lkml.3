Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3G0HLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 03:11:16 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34507 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3G0HLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 03:11:14 -0400
Message-ID: <51F37290.5050101@linaro.org>
Date: Sat, 27 Jul 2013 09:11:12 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>, Jeremy Eder <jeder@redhat.com>,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        youquan.song@intel.com, paulmck@linux.vnet.ibm.com,
        len.brown@intel.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <51F2BC31.7000407@redhat.com> <51F2BF8C.7010308@linux.intel.com> <51F2C014.90102@redhat.com>
In-Reply-To: <51F2C014.90102@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 08:29 PM, Rik van Riel wrote:
> On 07/26/2013 02:27 PM, Arjan van de Ven wrote:
>> On 7/26/2013 11:13 AM, Rik van Riel wrote:
>>
>>>
>>> Could you try running the tests with just the repeat mode
>>> stuff from commit 69a37bea excluded, but leaving the common
>>> infrastructure and commit e11538?
>>>
>>
>> personally I think we should go the other way around.
>> revert the set entirely first, and now, and get our performance back
>> to what it should be
>>
>> and then see what we can add back without causing the regressions.
>> this may take longer, or be done in steps, and that's ok.
>>
>> the end point may well be the same... but we can then evaluate in the
>> right
>> direction.
> 
> Works for me. I have no objection to reverting both patches,
> if the people planning to fix the code prefer that :)

I am favor of reverting these patches also because they don't solve the
root problem of reducing the prediction failure.

The menu governor tries to deduce the next wakeup but based on events
per cpu. That means if a task with a specific behavior is migrated
across cpus, the statistics will be wrong. IMHO, the menu governor has
too much heuristic in there and may be we should consider the scheduler
to pass more informations to the governor and remove some of these
heuristics.

Beside that, on ARM the cpus could be coupled and the timer to detect
the prediction will wake up the entire cluster, making the power saving
less efficient and impacting the statistics of the other cpu.


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

