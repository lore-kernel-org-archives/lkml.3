Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3FHHPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 03:15:17 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:57453 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FHHPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 03:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon3Tc+dSycv-QeLg9vwjXijaZrtjzw0-tHVAqX6moBUjA@mail.gmail.com>
References: <68ae523282b494da0e8f67536af1df874c326675.1370422554.git.viresh.kumar@linaro.org>
	<1855098.3p2j9hWHoD@vostro.rjw.lan>
	<CAKohpon3Tc+dSycv-QeLg9vwjXijaZrtjzw0-tHVAqX6moBUjA@mail.gmail.com>
Date: Sat, 8 Jun 2013 15:15:12 +0800
Message-ID: <CAFgnuDfTW1w-uC9S8OO_hniReBTtNu7Eo=orwngV4ZURRf6yiQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: userspace: Simplify governor
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/5 Viresh Kumar <viresh.kumar@linaro.org>:
> On 5 June 2013 18:07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Wednesday, June 05, 2013 02:34:33 PM Viresh Kumar wrote:
>>> Userspace governor has got more code than what it needs for its functioning.
>>> Lets simplify it.
>>
>> OK
>>
>> Why exactly is the code you're removing unnecessary?
>>
>>> Over that it will fix issues in cpufreq_governor_userspace(), which isn't doing
>>> right things in START/STOP.
>>
>> What exactly is the problem?
>
> I sent a reply now to the problem reported by Xiaoguang as I don't feel
> now there is a problem :(
>
Yes, I think the problem will disappear since the related code is
deleted. the original code path will not be executed.

>>> It is working per-cpu currently whereas it just
>>> required to manage policy->cpu.
>>>
>>> Reported-by: Xiaoguang Chen <chenxg.marvell@gmail.com>
>>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>> ---
>>> @Rafael:
>>>
>>> I don't know why this code was initially added. Please let me know if I am doing
>>> something stupid.
>>>
>>> Also, please apply it as a fix for 3.10 as it is broken recently in 3.9.
>>
>> I'd love to, but I need answers to the above questions before I do that.
>
> To be honest with the amount of experience I have now, my log was
> poor :(
>
> I have used following log in the attached patch:
>
> Subject: [PATCH] cpufreq: userspace: Simplify governor
>
> Userspace governor has got more code than what it needs for its functioning.
> Lets simplify it. Portions of code removed are:
> - Extra header files which aren't required anymore (rearranged them as well)
> - cpu_{max|min|cur|set}_freq, as they are always same as policy->{max|min|cur}
> - userspace_cpufreq_notifier_block as we don't need to set cpu_cur_freq anymore
> - cpus_using_userspace_governor as it was for notifier code
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
