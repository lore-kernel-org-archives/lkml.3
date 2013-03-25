Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab3CYPsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:48:20 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48681 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200Ab3CYPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:48:18 -0400
Message-ID: <515071BE.4070007@gmail.com>
Date: Mon, 25 Mar 2013 08:48:14 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [REGRESSION] [CPUFREQ] 3.9.0-rcX
References: <CAG9S4UjMeRZECAiigZVLTU4av2ZJNBukyUAoCmiYRjtkdThhFw@mail.gmail.com> <CAKohpokBySA5uaTTAwF5tmUr-_+W04Ki_f6cWTLu7n1C3Tcqog@mail.gmail.com> <1965505.vyQ4xZcodg@vostro.rjw.lan>
In-Reply-To: <1965505.vyQ4xZcodg@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2013 07:53 AM, Rafael J. Wysocki wrote:
> On Sunday, March 24, 2013 07:59:35 PM Viresh Kumar wrote:
>> On 24 March 2013 19:41, Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
>>> (long e-mail, sorry ;-))
>>
>> Don't be, it was useful :)
>>
>>> Last known good: 3.8.0
>>>
>>> Short description:
>>> 1. On -rc3, after s2ram cpufreq does not set CPU on max frequency on high
>>> load (on battery).
>>
>> Try attached patch for this.
>>
>>> 2. On -rc4 (this is not real regression because I change config between -rc3
>>> and rc4), "ondemand" does not work. Current frequency is 'strange' (792
>>> MHz).
>>> ===============================================================================
>>> Kernel 3.9.0-rc4
>>>
>>> CASE 7
>>> (normal boot)
>>> cpu0/cpufreq//affected_cpus:0
>>> cpu0/cpufreq//related_cpus:0
>>
>> This must be related to your different driver.
>
> Yes, intel_pstate is not really a cpufreq driver.  It just overtakes the
> whole subsystem.
>
> Dirk, can you please check if this is as intended?

This is working as intended.  The intel_pstate driver has the governor
integrated into the scaling driver and does not use external governors.

The reason the frequency is strange is because intel_pstate returns a
measured value of the effective frequency that the core ran at during
the last time it was sampled.

--Dirk
