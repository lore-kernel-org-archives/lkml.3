Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab3DWSvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:51:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41416 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab3DWSvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:51:19 -0400
Message-ID: <5176D6B5.3070305@ti.com>
Date: Tue, 23 Apr 2013 21:45:09 +0300
From: Taras Kondratiuk <taras@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <rjw@sisk.pl>, <viresh.kumar@linaro.org>,
        <shawn.guo@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Philip Rakity <prakity@nvidia.com>, Eric Miao <eric.y.miao@gmail.com>,
        "grygorii.strashko" <grygorii.strashko@ti.com>,
        Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Subject: Re: [RFC PATCH 1/2] regulator: core: Add regulator_set_voltage_min()
References: <1366372554-20866-1-git-send-email-taras@ti.com> <1366372554-20866-2-git-send-email-taras@ti.com> <20130422131904.GL30351@opensource.wolfsonmicro.com> <51756A21.3020405@ti.com> <20130423084838.GB5019@opensource.wolfsonmicro.com> <5176743A.9070201@ti.com> <20130423134512.GL5019@opensource.wolfsonmicro.com>
In-Reply-To: <20130423134512.GL5019@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 04:45 PM, Mark Brown wrote:
> On Tue, Apr 23, 2013 at 02:44:58PM +0300, Taras Kondratiuk wrote:
>
>> GPU voltage is regulated by some devfreq driver.
>> CPU voltage is regulated by generic cpufreq-cpu0 driver.
>> Both drivers know only about their operational points.
>> They don't know anything about chip limits.
> Clearly at least the lower bound is known to the drivers...
Do you mean a voltage of the lowest operation point?

>
>> I see two options here:
>> 1. Pass somehow chip limits to drivers so they can limit their request.
>>     Pros: No need for regulator_set_voltage_min()
>>     Cons: a) Need to pass info about chip limits to driver. New API?
> Why on earth would this need a new API?
I think I'm missing something.
How can I pass chip limits to a driver in some generic way?
>
>>           b) CPU and GPU may have different limits,
>>              so after very first request voltage may violate
>>              CPU or GPU range.
> If the CPU and GPU drivers are trying to select incompatible
> configurations then we really ought to be detecting that, ignoring it
> seems like an obvious failure.  There's a bootstrapping problem but
> that's also an issue with specifying only the minimum voltage...
>
>> 2. Define chip limits in Reg X constraints.
>>     Pros: Limits will be applied to driver's request transparently.
>>           No need to pass info about limits to driver.
>>           Limits are set before the first request, so no violation.
>>     Cons: regulator_set_voltage_min() is needed.
>> IMHO option #2 is better.
>> Do you see other ways?
> Above you clearly say that this is all modelling operating points.  If
> you're doing that then I would expect the drivers to be talking
> operating points to an operating point abstraction.
I went through several SoC datasheets and found that min approach
won't work for some of them (like AM335x).
The only safe way is to send max OPP voltage as a max_uV.
So please skip this series.

-- 
BR
Taras Kondratiuk | GlobalLogic

