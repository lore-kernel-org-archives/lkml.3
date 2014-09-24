Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaIXTCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:02:03 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:57079 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbaIXTCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:02:00 -0400
Message-ID: <54231523.9050502@kapsi.fi>
Date: Wed, 24 Sep 2014 22:01:55 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        juha-matti.tilli@iki.fi
Subject: Re: [PATCH v5 3/4] ARM: tegra: Add thermal trip points for Jetson
 TK1
References: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com> <1408616242-21009-4-git-send-email-mperttunen@nvidia.com> <20140924183204.GE27076@developer> <54230EA8.7080604@kapsi.fi> <20140924184157.GB7593@developer> <542310EB.7050802@kapsi.fi> <20140924184843.GA15798@developer>
In-Reply-To: <20140924184843.GA15798@developer>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 09:48 PM, Eduardo Valentin wrote:
> Hello Mikko,
>
> On Wed, Sep 24, 2014 at 09:43:55PM +0300, Mikko Perttunen wrote:
>> On 09/24/2014 09:41 PM, Eduardo Valentin wrote:
>>> On Wed, Sep 24, 2014 at 09:34:16PM +0300, Mikko Perttunen wrote:
>>>> On 09/24/2014 09:32 PM, Eduardo Valentin wrote:
>>>>> Hello Mikko,
>>>>>
>>>>> On Thu, Aug 21, 2014 at 01:17:21PM +0300, Mikko Perttunen wrote:
>>>>>> This adds critical trip points to the Jetson TK1 device tree.
>>>>>> The device will do a controlled shutdown when either the CPU, GPU
>>>>>> or MEM thermal zone reaches 101 degrees Celsius.
>>>>>>
>>>>>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>>>>>> ---
>>>>>> v5: added cooling-maps nodes
>>>>>>
>>>>>
>>>>> OK. But no cooling map entry in it. What was the reason again you don't
>>>>> need/want to add the maps?
>>>>
>>>> There is currently no cooling device to map to.
>>>
>>> Not even cpufreq cooling? Is CPUfreq operational in Tegra?
>>
>> Indeed, it is not currently operational (except on Tegra20). There is a
>> series for Tegra124 but it needs more work. Not going in during this cycle.
>>
>
> OK. Now I understand. In this case, can you please explain the situation
> with a TODO comment inside the cooling-maps?
>
> The way it is now, looks awkwards.

OK, I will add a comment.

>
>>>
>>>>
>>>> Mikko
>>>>
>>>>>
>>>>>>     arch/arm/boot/dts/tegra124-jetson-tk1.dts | 41 +++++++++++++++++++++++++++++++
>>>>>>     1 file changed, 41 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>>>>>> index 0cdb5cf..bcdab7f 100644
>>>>>> --- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>>>>>> +++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
>>>>>> @@ -1876,4 +1876,45 @@
>>>>>>     			 <&tegra_car TEGRA124_CLK_EXTERN1>;
>>>>>>     		clock-names = "pll_a", "pll_a_out0", "mclk";
>>>>>>     	};
>>>>>> +
>>>>>> +	thermal-zones {
>>>>>> +		cpu {
>>>>>> +			trips {
>>>>>> +				trip@0 {
>>>>>> +					temperature = <101000>;
>>>>>> +					hysteresis = <0>;
>>>>>> +					type = "critical";
>>>>>> +				};
>>>>>> +			};
>>>>>> +
>>>>>> +			cooling-maps {
>>>>>> +			};
>>>>>> +		};
>>>>>> +
>>>>>> +		mem {
>>>>>> +			trips {
>>>>>> +				trip@0 {
>>>>>> +					temperature = <101000>;
>>>>>> +					hysteresis = <0>;
>>>>>> +					type = "critical";
>>>>>> +				};
>>>>>> +			};
>>>>>> +
>>>>>> +			cooling-maps {
>>>>>> +			};
>>>>>> +		};
>>>>>> +
>>>>>> +		gpu {
>>>>>> +			trips {
>>>>>> +				trip@0 {
>>>>>> +					temperature = <101000>;
>>>>>> +					hysteresis = <0>;
>>>>>> +					type = "critical";
>>>>>> +				};
>>>>>> +			};
>>>>>> +
>>>>>> +			cooling-maps {
>>>>>> +			};
>>>>>> +		};
>>>>>> +	};
>>>>>>     };
>>>>>> --
>>>>>> 1.8.1.5
>>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>

