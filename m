Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbaCOMlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 08:41:50 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40656 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaCOMlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 08:41:47 -0400
Message-ID: <53244A88.9070806@gmail.com>
Date: Sat, 15 Mar 2014 13:41:44 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>, Tomasz Figa <t.figa@samsung.com>
CC: Chanwoo Choi <cw00.choi@samsung.com>, Mark Rutland <mark.rutland@arm.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "nm@ti.com" <nm@ti.com>,
        "b.zolnierkie@samsaung.com" <b.zolnierkie@samsaung.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCHv2 8/8] devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>	<1394698649-20996-9-git-send-email-cw00.choi@samsung.com>	<20140313175308.GE25870@e106331-lin.cambridge.arm.com>	<5322AC5D.9070200@samsung.com>	<20140314103552.GK25870@e106331-lin.cambridge.arm.com>	<5322E04D.2060801@samsung.com>	<53233DE7.2030902@samsung.com> <CAH9JG2WV-y+9wMyu0_6WSRXMWZmCWmxHnWot9APKUo6eFkZS5A@mail.gmail.com>
In-Reply-To: <CAH9JG2WV-y+9wMyu0_6WSRXMWZmCWmxHnWot9APKUo6eFkZS5A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.03.2014 12:36, Kyungmin Park wrote:
> On Sat, Mar 15, 2014 at 2:35 AM, Tomasz Figa <t.figa@samsung.com> wrote:
>> Hi Chanwoo, Mark,
>>
>>
>> On 14.03.2014 11:56, Chanwoo Choi wrote:
>>>
>>> Hi Mark,
>>>
>>> On 03/14/2014 07:35 PM, Mark Rutland wrote:
>>>>
>>>> On Fri, Mar 14, 2014 at 07:14:37AM +0000, Chanwoo Choi wrote:
>>>>>
>>>>> Hi Mark,
>>>>>
>>>>> On 03/14/2014 02:53 AM, Mark Rutland wrote:
>>>>>>
>>>>>> On Thu, Mar 13, 2014 at 08:17:29AM +0000, Chanwoo Choi wrote:
>>>>>>>
>>>>>>> This patch add busfreq driver for Exynos4210/Exynos4x12 memory
>>>>>>> interface
>>>>>>> and bus to support DVFS(Dynamic Voltage Frequency Scaling) according
>>>>>>> to PPMU
>>>>>>> counters. PPMU (Performance Profiling Monitorings Units) of Exynos4
>>>>>>> SoC provides
>>>>>>> PPMU counters for DMC(Dynamic Memory Controller) to check memory bus
>>>>>>> utilization
>>>>>>> and then busfreq driver adjusts dynamically the operating
>>>>>>> frequency/voltage
>>>>>>> by using DEVFREQ Subsystem.
>>>>>>>
>>>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>>>> ---
>>>>>>>    .../devicetree/bindings/devfreq/exynos4_bus.txt    | 49
>>>>>>> ++++++++++++++++++++++
>>>>>>>    1 file changed, 49 insertions(+)
>>>>>>>    create mode 100644
>>>>>>> Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>>>>>
>>>>>>> diff --git a/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>>>>> b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>>>>> new file mode 100644
>>>>>>> index 0000000..2a83fcc
>>>>>>> --- /dev/null
>>>>>>> +++ b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>>>>> @@ -0,0 +1,49 @@
>>>>>>> +
>>>>>>> +Exynos4210/4x12 busfreq driver
>>>>>>> +-----------------------------
>>>>>>> +
>>>>>>> +Exynos4210/4x12 Soc busfreq driver with devfreq for Memory bus
>>>>>>> frequency/voltage
>>>>>>> +scaling according to PPMU counters of memory controllers
>>>>>>> +
>>>>>>> +Required properties:
>>>>>>> +- compatible   : should contain Exynos4 SoC type as follwoing:
>>>>>>> +                 - "samsung,exynos4x12-busfreq" for Exynos4x12
>>>>>>> +                 - "samsung,exynos4210-busfreq" for Exynos4210
>>>>>>
>>>>>>
>>>>>> Is there a device called "busfreq"? What device does this binding
>>>>>> describe?
>>>>>
>>>>>
>>>>> I'll add detailed description of busfreq as following:
>>>>>
>>>>> "busfreq(bus frequendcy)" driver means that busfreq driver control
>>>>> dynamically
>>>>> memory bus frequency/voltage by checking memory bus utilization to
>>>>> optimize
>>>>> power-consumption. When checking memeory bus utilization,
>>>>> exynos4_busfreq driver
>>>>> would use PPMU(Performance Profiling Monitoring Units).
>>>>
>>>>
>>>> This still sounds like a description of the _driver_, not the _device_.
>>>> The binding should describe the hardware, now the high level abstraction
>>>> that software is going to build atop of it.
>>>>
>>>> It sounds like this is a binding for the DMC PPMU?
>>>>
>>>> Is the PPMU a component of the DMC, or is it bolted on the side?
>>>
>>>
>>> PPMU(Performance Profiling Monitoring Unit) is to profile performance
>>> event of
>>> various IP on Exynos4. Each PPMU provide perforamnce event for each IP.
>>> We can check various PPMU as following:
>>>
>>> PPMU_3D
>>> PPMU_ACP
>>> PPMU_CAMIF
>>> PPMU_CPU
>>> PPMU_DMC0
>>> PPMU_DMC1
>>> PPMU_FSYS
>>> PPMU_IMAGE
>>> PPMU_LCD0
>>> PPMU_LCD1
>>> PPMU_MFC_L
>>> PPMU_MFC_R
>>> PPMU_TV
>>> PPMU_LEFT_BUS
>>> PPMU_RIGHT_BUS
>>>
>>> DMC (Dynamic Memory Controller) control the operation of DRAM in Exynos4
>>> SoC.
>>> If we need to get memory bust utilization of DMC, we can get memory bus
>>> utilization
>>> from PPMU_DMC0/PPMU_DMC1.
>>>
>>> So, Exynos4's busfreq used two(PPMU_DMC0/PPMU_DMC1) among upper various
>>> PPMU list.
>>
>>
>> Well, PPMUs and DMCs are separate hardware blocks found inside Exynos SoCs.
>> Busfreq/devfreq is just a Linux-specific abstraction responsible for
>> collecting data using PPMUs and controlling frequencies and voltages of
>> appropriate power planes, vdd_int responsible for powering DMC0 and DMC1
>> blocks in this case.
>>
>> I'm afraid that the binding you're proposing is unfortunately incorrect,
>> because it represents the software abstraction, not the real hardware.
>>
>> Instead, this should be separated into several independent bindings:
>>
>>   - PPMU bindings to list all the PPMU instances present in the SoC and
>> resources they need,
>>
>>   - power plane bindings, which define a power plane in which multiple IP
>> blocks might reside, can be monitored by one or more PPMU units and
>> frequency and voltage of which can be configured according to determined
>> performance level. Needed resources will be clocks and regulators to scale
>> and probably also operating points.
>>
>> Then, exynos-busfreq driver should bind to such power planes, parse
>> necessary data from DT (list of PPMUs and IP blocks, clocks, regulators and
>> operating points) and register a devfreq entity.
>
> How about to use component DT like DRM?

Well, basically this is what I proposed. Each "power plane" would be a 
"subsystem" built from components - PPMUs, IP blocks, clocks, 
regulators, etc, specified in DT by existing means, e.g.

ppmu_disp: ppmu@12340000 {
	/* Resources of PPMU */
}

fimd: fimd@23450000 {
	/* Resources of FIMD */
};

power-plane-display {
	compatible = "samsung,power-plane";
	samsung,ppmus = <&ppmu_disp>, ...;
	samsung,devices = <&fimd>, ...;
	clock-names = "aclk_xxx", "sclk_xxx", ...;
	clocks = ...;
	vdd_xxx-supply = ...;
};

However I'm still wondering whether there shouldn't be a relation 
between power planes and power domains and simply existing power domain 
nodes shouldn't be extended with the data I put above in 
power-plane-display node. I need to check this in the documentation back 
at work on Monday.

Best regards,
Tomasz
