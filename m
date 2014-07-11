Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaGKRVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:21:34 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3288 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaGKRVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:21:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jul 2014 10:14:23 -0700
Message-ID: <53C01D17.2050906@nvidia.com>
Date: Fri, 11 Jul 2014 20:21:27 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 01/13] clk: tegra: Add binding for the Tegra124 DFLL clocksource
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>	<1405028569-14253-2-git-send-email-ttynkkynen@nvidia.com>	<CAL1qeaFF0ZpUFovxTuLXrBPRg2Lbf-754Z=ztD5HFZPbfnDsAw@mail.gmail.com>	<53C01558.3090607@nvidia.com> <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com>
In-Reply-To: <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/14 20:08, Andrew Bresticker wrote:
> On Fri, Jul 11, 2014 at 9:48 AM, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
>>
>>
>> On 11/07/14 19:28, Andrew Bresticker wrote:
>>>
>>> On Thu, Jul 10, 2014 at 2:42 PM, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>>> wrote:
>>>>
>>>> The DFLL is the main clocksource for the fast CPU cluster on Tegra124
>>>> and also provides automatic CPU rail voltage scaling as well. The DFLL
>>>> is a separate IP block from the usual Tegra124 clock-and-reset
>>>> controller, so it gets its own node in the device tree.
>>>
>>>
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
>>>> b/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
>>>
>>>
>>>> +- nvidia,pmic-voltage-table: Array of 2-tuples.  Each entry should have
>>>> the
>>>> +  form <register-value voltage-in-uV>, indicating the register value
>>>> that
>>>> +  needs to be programmed to the PMIC for changing the VDD_CPU voltage to
>>>> +  the specified voltage. The table must be in ascending order by the
>>>> voltage.
>>>
>>>
>>> Instead of listing the register values for each voltage in the DT,
>>> can't you use regulator_list_voltage() to create this map?
>>>
>>
>> I don't see a way to get the register values that way, unless we assume that
>> the mapping is linear and doesn't have holes.
>
> Hmm... I guess if you don't assume it's linear and continuous you'd
> have to iterate over all 256 selectors.
>

I don't think we can assume that each selector maps to a concrete 
register value, though I'm not sure. include/linux/regulator/driver.h 
documents for @list_voltage "Selectors range from zero to one less 
regulator_desc.n_voltages." but maybe the consumer API could take 
different values.

-- 
nvpublic
