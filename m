Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3HGSvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:51:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50892 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab3HGSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:51:03 -0400
Message-ID: <52029713.5070808@wwwdotorg.org>
Date: Wed, 07 Aug 2013 12:50:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] clk: Tegra: Add CPU0 clock driver
References: <cover.1375886595.git.viresh.kumar@linaro.org> <8d192a13cb7e088943da40689d62bc6353bd8604.1375886595.git.viresh.kumar@linaro.org> <52028620.6000608@wwwdotorg.org> <CAKohpokVgcMfmKmjkxc9Dr3z6mBKad23uUdB4ydN_xzGHdfedQ@mail.gmail.com> <52028859.20008@wwwdotorg.org> <CAKohpokK7F7tYJnisVjF=NCRb9zUjQNzrFdXs+QsPSb4oqyytA@mail.gmail.com>
In-Reply-To: <CAKohpokK7F7tYJnisVjF=NCRb9zUjQNzrFdXs+QsPSb4oqyytA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 11:54 AM, Viresh Kumar wrote:
> On 7 August 2013 23:18, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/07/2013 11:45 AM, Viresh Kumar wrote:
>>> On 7 August 2013 23:08, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> On 08/07/2013 08:46 AM, Viresh Kumar wrote:
>>>>> This patch adds CPU0's clk driver for Tegra. It will be used by the generic
>>>>> cpufreq-cpu0 driver to get/set cpu clk.
>>>>>
>>>>> Most of the platform specific bits are picked from tegra-cpufreq.c.
>>>>
>>>> Hmmm. I'm not sure if it makes sense to represent this as a clock
>>>> object; isn't this more of a virtual construct that manages the rate of
>>>> the clock, rather than an actual clock? The actual clock already exists
>>>> as "cpu".
>>>
>>> I see it as this: There is a clock in system for cpu, call it "cpu". Now we
>>> must be able to provide get/set routines for it. A set should set the
>>> frequency to whatever is asked for and should really worry about how
>>> that is being set. This part is internal to "cpu" clk.
>>
>> Sure.
>>
>>> This is what cpufreq-cpu0 driver should expect and does. Current "cpu"
>>> clock implemented doesn't provide this facility ? And so this wrapper
>>> made sense to me.
>>
>> But the additional management logic on top of the raw clock is exactly
>> what the cpufreq driver is for. This patch series is basically moving
>> the cpufreq driver code inside the clock code instead.
> 
> Above "sure" didn't go very well with what you wrote here :)
> 
> The additional management that we are required to do isn't cpufreq
> driver specific but cpu or platform specific.

Right, and that's *exactly* what having a cpufreq driver is for; to
implement the details of CPU clock management.
