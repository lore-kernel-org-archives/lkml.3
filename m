Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285Ab3E2JGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:06:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48582 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3E2JGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:06:32 -0400
Message-ID: <51A5C4F1.3010809@ti.com>
Date: Wed, 29 May 2013 11:05:53 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <florian.vaussard@epfl.ch>
CC: Afzal Mohammed <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Ankur Kishore <a-kishore@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>
Subject: Re: [PATCH v2 14/14] ARM: dts: AM43x: initial support
References: <cover.1369658705.git.afzal@ti.com> <3790fa57fc4c69da12224fbcec17cd07c59771a0.1369658705.git.afzal@ti.com> <51A5C1F3.2070605@ti.com> <51A5C2EE.4060607@epfl.ch>
In-Reply-To: <51A5C2EE.4060607@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 10:57 AM, Florian Vaussard wrote:
> Hello,
> 
> On 05/29/2013 10:53 AM, Benoit Cousson wrote:
>> + Florian
>>
>> Hi Afzal,
>>
>> On 05/27/2013 04:37 PM, Afzal Mohammed wrote:
>>> DT source (minimal) for AM4372 SoC to represent AM43x SoC's. Those
>>> represented here are the minimal DT nodes necessary to get kernel
>>> booting.
>>>
>>> In DT nodes, "ti,hwmod" property has not been added, this would be
>>> added along with PRCM support for AM43x.
>>>
>>> Signed-off-by: Ankur Kishore <a-kishore@ti.com>
>>> Signed-off-by: Afzal Mohammed <afzal@ti.com>
>>> ---
>>>
>>> v2: Add gptimer 1ms, timer2, synctimer and remove twd local timer
>>>
>>>   arch/arm/boot/dts/am4372.dtsi | 66
>>> +++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 66 insertions(+)
>>>   create mode 100644 arch/arm/boot/dts/am4372.dtsi
>>>
>>> diff --git a/arch/arm/boot/dts/am4372.dtsi
>>> b/arch/arm/boot/dts/am4372.dtsi
>>> new file mode 100644
>>> index 0000000..1d58298
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/am4372.dtsi
>>> @@ -0,0 +1,66 @@
>>> +/*
>>> + * Device Tree Source for AM4372 SoC
>>> + *
>>> + * Copyright (C) 2013 Texas Instruments Incorporated -
>>> http://www.ti.com/
>>> + *
>>> + * This file is licensed under the terms of the GNU General Public
>>> License
>>> + * version 2.  This program is licensed "as is" without any warranty
>>> of any
>>> + * kind, whether express or implied.
>>> + */
>>> +
>>> +/include/ "skeleton.dtsi"
>>
>> You can now use the C preprocessor statement instead of this one.
>> Florian already started doing the change [1].
>>
>> Beside that detail, that patch looks good to me.
>> I'll pull it separately of the series.
>>
> 
> If you pull the patch in your branch, I can take care of the changes
> when I rebase
> my series. This will allow me to clean the 'interrupts' statements below
> as well.

Ooops, thanks, I missed that one.

Thanks,
Benoit

> 
> Regards,
> 
> Florian
> 
>> Regards,
>> Benoit
>>
>> [1] http://thread.gmane.org/gmane.linux.ports.arm.omap/98320
>>
>>> +
>>> +/ {
>>> +    compatible = "ti,am4372", "ti,am43";
>>> +    interrupt-parent = <&gic>;
>>> +
>>> +
>>> +    aliases {
>>> +        serial0 = &uart1;
>>> +    };
>>> +
>>> +    cpus {
>>> +        cpu@0 {
>>> +            compatible = "arm,cortex-a9";
>>> +        };
>>> +    };
>>> +
>>> +    gic: interrupt-controller@48241000 {
>>> +        compatible = "arm,cortex-a9-gic";
>>> +        interrupt-controller;
>>> +        #interrupt-cells = <3>;
>>> +        reg = <0x48241000 0x1000>,
>>> +              <0x48240100 0x0100>;
>>> +    };
>>> +
>>> +    ocp {
>>> +        compatible = "simple-bus";
>>> +        #address-cells = <1>;
>>> +        #size-cells = <1>;
>>> +        ranges;
>>> +
>>> +        uart1: serial@44e09000 {
>>> +            compatible = "ti,am4372-uart","ti,omap2-uart";
>>> +            reg = <0x44e09000 0x2000>;
>>> +            interrupts = <0 72 0x4>;
>>> +        };
>>> +
>>> +        timer1: timer@44e31000 {
>>> +            compatible = "ti,am4372-timer-1ms","ti,am335x-timer-1ms";
>>> +            reg = <0x44e31000 0x400>;
>>> +            interrupts = <0 67 0x4>;
>>> +            ti,timer-alwon;
>>> +        };
>>> +
>>> +        timer2: timer@48040000  {
>>> +            compatible = "ti,am4372-timer","ti,am335x-timer";
>>> +            reg = <0x48040000  0x400>;
>>> +            interrupts = <0 68 0x4>;
>>> +        };
>>> +
>>> +        counter32k: counter@44e86000 {
>>> +            compatible = "ti,am4372-counter32k","ti,omap-counter32k";
>>> +            reg = <0x44e86000 0x40>;
>>> +        };
>>> +    };
>>> +};
>>>
>>

