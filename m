Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab3EXHwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:52:18 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60895 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956Ab3EXHwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130524075640.0a5b80ff@amdc308.digital.local>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
	<20130522122700.104ca5cd@amdc308.digital.local>
	<CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
	<20130522164453.29cd3a7d@amdc308.digital.local>
	<20130524075640.0a5b80ff@amdc308.digital.local>
Date: Fri, 24 May 2013 13:22:15 +0530
Message-ID: <CAKohpoksymD76rDvg_+PwU7r3JXp1oydHBbJE4-y6TBHOomZHg@mail.gmail.com>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2013 11:26, Lukasz Majewski <l.majewski@samsung.com> wrote:
>> > On 22 May 2013 15:57, Lukasz Majewski <l.majewski@samsung.com>
> As you wished, I've provided relevant data for overclocking.
>
> Would you be so kind and comment on them?

I was about to reply ... was busy with some other backlog :)

>> Test HW Exynos4412 (4 Cores):
>> Kernel 3.8.3
>>
>> Ondemand max freq: 1.4 GHz
>> Overclock max freq: 1.5 GHz
>>
>>
>> Ondemand improvement with and without overclocking (called by us
>> TurboBoost - TB):
>>
>> Dhrystone has been built according to:
>> http://zenit.senecac.on.ca/wiki/index.php/Dhrystone_howto
>> It's Makefile is also attached.
>> ------------------------------------------------
>>
>> Dhrystone     # of Threads
>>               1       2       3       4
>> ondemand      2054794 2061855 2097902 2090592
>> ondemand + TB 2290076 2205882 2281368 2290076
>>
>> Improvement:  10%     7%      8%      9%
>> -------------------------------------------------
>>
>> Electric charge [C]
>> (Avg) [A] * [second]  # of Threads
>>               1       2       3       4
>> ondemand      1,334   1,837   2,296   3,096
>> ondemand + TB 1,401   2,2025  2,907   4,34976
>>
>> Power cost:   5%      17%     21%     29%
>> -------------------------------------------------
>>
>> Execution time [second]       # of Threads
>>               1       2       3       4
>> ondemand      2,827   2,8     2,787   2,872
>> ondemand + TB 2,622   2,694   2,667   2,76
>>
>>
>> Speedup:      -7%     -4%     -4%     -4%
>>
>> -------------------------------------------------
>>
>> "Real life" example:
>> time tar -czf linux-3.9.1.tar.gz linux-3.9.1/
>>
>>               Avg current[mA]         Time[s]
>> Ondemand:     460                     153
>> Ondemand + TB:        512                     144
>>
>> Result:               +10%                    -6%
>>
>> Conclusion:
>>
>> The main use case for TB is to speed up execution of tasks packed to
>> one core. Other cores are then in IDLE state.
>>
>> For a single core we can safely overclock, since we will not exceed
>> its power consumption and thermal limits.

Hmm... So its ultraclear that higher clock rates have given us better
performance numbers, obviously at the cost of power.

Now, why don't we simply add this high end frequency in the available
frequencies list? And then ondemand can set it whenever the load is
high? Why do we need additional core support for it?
