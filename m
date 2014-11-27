Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbaK0Ps6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:48:58 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40817 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaK0Ps4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:48:56 -0500
Message-ID: <547747DF.9070402@arm.com>
Date: Thu, 27 Nov 2014 15:48:47 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: ARM: Fix the Generic Timers interrupt active level
 description
References: <1417099005-18638-1-git-send-email-Liviu.Dudau@arm.com> <5477389A.8010606@arm.com> <20141127153453.GR828@e106497-lin.cambridge.arm.com>
In-Reply-To: <20141127153453.GR828@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/14 15:34, Liviu Dudau wrote:
> On Thu, Nov 27, 2014 at 02:43:38PM +0000, Marc Zyngier wrote:
>> On 27/11/14 14:36, Liviu Dudau wrote:
>>> The Cortex-A5x TRM states in paragraph "9.2 Generic Timer functional
>>> description" that generic timers provide an active-LOW interrupt
>>> output. Fix the device trees to correctly describe this.
>>>
>>> While doing this update the CPU mask to match the number of described
>>> CPUs as well.
>>>
>>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>>> ---
>>>
>>> Arnd, Olof: This is on top of linux-next/master as it patches the Juno
>>> as well as all the other ARM DTs.
>>>
>>>  arch/arm64/boot/dts/arm/foundation-v8.dts  | 8 ++++----
>>>  arch/arm64/boot/dts/arm/juno.dts           | 8 ++++----
>>>  arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts | 8 ++++----
>>>  3 files changed, 12 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/arch/arm64/boot/dts/arm/foundation-v8.dts b/arch/arm64/boot/dts/arm/foundation-v8.dts
>>> index 4a06090..27f3296 100644
>>> --- a/arch/arm64/boot/dts/arm/foundation-v8.dts
>>> +++ b/arch/arm64/boot/dts/arm/foundation-v8.dts
>>> @@ -78,10 +78,10 @@
>>>  
>>>  	timer {
>>>  		compatible = "arm,armv8-timer";
>>> -		interrupts = <1 13 0xff01>,
>>> -			     <1 14 0xff01>,
>>> -			     <1 11 0xff01>,
>>> -			     <1 10 0xff01>;
>>> +		interrupts = <1 13 0xf08>,
>>> +			     <1 14 0xf08>,
>>> +			     <1 11 0xf08>,
>>> +			     <1 10 0xf08>;
>>>  		clock-frequency = <100000000>;
>>>  	};
>>>  
>>> diff --git a/arch/arm64/boot/dts/arm/juno.dts b/arch/arm64/boot/dts/arm/juno.dts
>>> index 097ecc4..cb3073e 100644
>>> --- a/arch/arm64/boot/dts/arm/juno.dts
>>> +++ b/arch/arm64/boot/dts/arm/juno.dts
>>> @@ -98,10 +98,10 @@
>>>  
>>>  	timer {
>>>  		compatible = "arm,armv8-timer";
>>> -		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
>>> -			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
>>> -			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
>>> -			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>;
>>> +		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_LOW)>,
>>> +			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_LOW)>,
>>> +			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_LOW)>,
>>> +			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_LOW)>;
>>>  	};
>>>  
>>>  	pmu {
>>> diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts b/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
>>> index 572005e..efc59b3 100644
>>> --- a/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
>>> +++ b/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
>>> @@ -81,10 +81,10 @@
>>>  
>>>  	timer {
>>>  		compatible = "arm,armv8-timer";
>>> -		interrupts = <1 13 0xff01>,
>>> -			     <1 14 0xff01>,
>>> -			     <1 11 0xff01>,
>>> -			     <1 10 0xff01>;
>>> +		interrupts = <1 13 0xf08>,
>>> +			     <1 14 0xf08>,
>>> +			     <1 11 0xf08>,
>>> +			     <1 10 0xf08>;
>>>  		clock-frequency = <100000000>;
>>>  	};
>>>  
>>>
>>
>> Sorry, but that's wrong. Despite the *cores* having an level-low output,
>> the GIC only triggers on *level-high*. Yes, there is probably an
>> inverter in between.
> 
> BTW, should I also update the bindings example to get this right?

Definitely. I'm pretty sure I got it wrong too at some point...

	M.
-- 
Jazz is not dead. It just smells funny...
