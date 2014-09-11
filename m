Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbaIKPhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:37:32 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54253 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaIKPh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:37:29 -0400
Message-ID: <5411C1B6.5090104@gmail.com>
Date: Thu, 11 Sep 2014 08:37:26 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: dirk.brandewie@gmail.com, Anup Chenthamarakshan <anupc@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
References: <1410221424-20590-1-git-send-email-anupc@chromium.org> <1610826.tK4V65ABJD@vostro.rjw.lan> <20140910233905.GA2439@google.com> <7546673.Ir6ttItgPU@vostro.rjw.lan> <CANMivWa_kowDefkvLHpY=JoB9JejiJWBZL7fNqeuwQfcMu+hhQ@mail.gmail.com>
In-Reply-To: <CANMivWa_kowDefkvLHpY=JoB9JejiJWBZL7fNqeuwQfcMu+hhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 06:04 PM, Sameer Nanda wrote:
> On Wed, Sep 10, 2014 at 5:04 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Wednesday, September 10, 2014 04:39:05 PM Anup Chenthamarakshan wrote:
>>> On Thu, Sep 11, 2014 at 12:49:48AM +0200, Rafael J. Wysocki wrote:
>>>> On Wednesday, September 10, 2014 03:15:08 PM Anup Chenthamarakshan wrote:
>>>>>
>>>>> Tools like powertop and turbostat are not present by default on all systems,
>>>>> so it is not always possible to use them :(
>>>>
>>>> Which systems are you referring to in particular?
>>>
>>> We're testing on Chrome OS devices (Chromebooks).
>>
>> How big of a deal is it to install the tools mentioned above on such a system?
>>
>> At least turbostat is shipped with the kernel source.
>
> Given the web browser based front end of Chrome OS, installing these
> tools will only get us so far -- if the system is in developer mode,
> the tools are accessible but when the system is in normal (verified
> boot mode) these tools cannot be launched directly.
>
> We are in the process of switching Chrome OS x86 kernels from ondemand
> governor to intel_pstate.  When debugging power consumption issues,
> losing the ability to easily get CPU frequency related information as
> a side-effect of this switch is less than ideal.
>
> We are happy to spin this patch to expose aperf/mperf based CPU
> frequency information if you think that is the better route to take
> longer term.

You can get the frequency as measured by intel_pstate from /proc/cpuinfo
or /sys/devices/system/cpu/cpu[n]/cpufreq/cpuinfo_cur_freq but his is only
for the most recent sample on cpu[n]

reading MSR 0x199 and some reasonable rate will let you graph what request
is being made on each core.

>
>>
>> --
>> I speak only for myself.
>> Rafael J. Wysocki, Intel Open Source Technology Center.
>
>
>

