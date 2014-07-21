Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbaGUNfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:35:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41103 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbaGUNfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:35:00 -0400
Message-ID: <53CD219B.1060306@ti.com>
Date: Mon, 21 Jul 2014 17:20:11 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>, <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>
CC: <ivan.khoronzhuk@ti.com>, <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] gpio: keystone: add dsp gpio controller driver
References: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com> <53C64E78.4030506@gmail.com>
In-Reply-To: <53C64E78.4030506@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka Bhadram,

On 07/16/2014 01:05 PM, Varka Bhadram wrote:
> On 07/16/2014 04:13 PM, Grygorii Strashko wrote:
>> From: Murali Karicheri <m-karicheri2@ti.com>
>>
>> On Keystone SOCs, ARM host can send interrupts to DSP cores using the
>> DSP GPIO controller IP. Each DSP GPIO controller provides 28 IRQ
>> signals for
>> each DSP core. This is one of the component used by the IPC mechanism
>> used
>> on Keystone SOCs.
>>
>> Keystone 2 DSP GPIO controller has specific features:
>> - each GPIO can be configured only as output pin;
>> - setting GPIO value to 1 causes IRQ generation on target DSP core;
>> - reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>>    pending.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   .../devicetree/bindings/gpio/gpio-keystone.txt     |   43 ++++++
>>   drivers/gpio/Kconfig                               |    8 ++
>>   drivers/gpio/Makefile                              |    1 +
>>   drivers/gpio/gpio-keystone.c                       |  138
>> ++++++++++++++++++++
>>   4 files changed, 190 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/gpio/gpio-keystone.txt
>>   create mode 100644 drivers/gpio/gpio-keystone.c
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
>> b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
>> new file mode 100644
>> index 0000000..4f92af4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
>> @@ -0,0 +1,43 @@
>> +Keystone 2 DSP GPIO controller bindings
>> +
>> +HOST OS userland running on ARM can send interrupts to DSP cores using
>> +the DSP GPIO controller IP. It provides 28 IRQ signals per each DSP
>> core.
>> +This is one of the component used by the IPC mechanism used on
>> Keystone SOCs.
>> +
>> +For example TCI6638K2K SoC has 8 DSP GPIO controllers:
>> + - 8 for C66x CorePacx CPUs 0-7
>> +
>> +Keystone 2 DSP GPIO controller has specific features:
>> +- each GPIO can be configured only as output pin;
>> +- setting GPIO value to 1 causes IRQ generation on target DSP core;
>> +- reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>> +  pending.
>> +
>> +Required Properties:
>> +- compatible: should be "ti,keystone-dsp-gpio"
>> +
>> +- ti,syscon-dev:    phandle/offset pair. The phandle to syscon used to
>> +            access device state control registers and the offset
>> +            in order to use block of device's specific registers.
>> +
>> +- gpio-controller : Marks the device node as a gpio controller.
>> +
>> +- #gpio-cells : Should be one.
>> +                See gpio.txt in this directory for a of the cells format
>
> All the properties not properly aligned. It would be more readable if
>
> Required Properties:
> - compatible        : should be "ti,keystone-dsp-gpio"
> - ti,syscon-dev        : phandle/offset pair. The phandle to syscon used to
>                access device state control registers and the offset
>                in order to use block of device's specific registers.
> - gpio-controller    : Marks the device node as a gpio controller.
> - #gpio-cells        : Should be one.
>                See gpio.txt in this directory for a of the cells format

Unfortunately, the format of DT bindings description is not 
standardized, but i will try to beautify it :)

>
>> +
>> +Please refer to gpio.txt in this directory for details of the common
>> GPIO
>> +bindings used by client devices.
>> +
>
> (...)
>
>> +static struct platform_driver keystone_gpio_driver = {
>> +    .probe        = keystone_gpio_probe,
>> +    .remove        = keystone_gpio_remove,
>> +    .driver        = {
>> +        .name    = "keystone-dsp-gpio",
>> +        .owner    = THIS_MODULE,
>
> We can drop owner field...  :-)  .It will update by module_platform_driver
>
>

Thanks for your comments - I'll wait a bit and re-send.

Regards,
- grygorii

