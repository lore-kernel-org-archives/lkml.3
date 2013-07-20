Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab3GTGOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 02:14:38 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:39451 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3GTGOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 02:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <51E98310.7020103@cogentembedded.com>
References: <1374226039-16943-1-git-send-email-oleksandr.kozaruk@ti.com>
	<1374226039-16943-2-git-send-email-oleksandr.kozaruk@ti.com>
	<51E94F97.40002@cogentembedded.com>
	<51E95DEB.7010702@ti.com>
	<51E98310.7020103@cogentembedded.com>
Date: Sat, 20 Jul 2013 01:14:34 -0500
X-Google-Sender-Auth: K54Pse_7vLO8tf1Vt39oVfaFOOw
Message-ID: <CAPb7_msk+dq9OK=UVU8A58k7iiPJwTYaViJjQ=qQHOCBN9u-7g@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] ARM: dts: twl: Add GPADC data to device tree
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>, tony@atomide.com,
        benoit.cousson@linaro.org, rnayak@ti.com, peter.ujfalusi@ti.com,
        kishon@ti.com, jic23@cam.ac.uk, grant.likely@linaro.org,
        rob.herring@calxeda.com, lars@metafoo.de, sameo@linux.intel.com,
        ch.naveen@samsung.com, poeschel@lemonage.de, milo.kim@ti.com,
        balajitk@ti.com, gg@slimlogic.co.uk, linux-iio@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Fri, Jul 19, 2013 at 1:18 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 07/19/2013 07:40 PM, Grygorii Strashko wrote:
>
>>>> GPADC is the general purpose ADC present on twl6030.
>>>> The dt data is interrupt used to trigger end of ADC
>>>> conversion.
>
>
>>>> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
>>>> ---
>>>>   arch/arm/boot/dts/twl6030.dtsi | 6 ++++++
>>>>   1 file changed, 6 insertions(+)
>
>
>>>> diff --git a/arch/arm/boot/dts/twl6030.dtsi
>>>> b/arch/arm/boot/dts/twl6030.dtsi
>>>> index 2e3bd31..d7d4c28 100644
>>>> --- a/arch/arm/boot/dts/twl6030.dtsi
>>>> +++ b/arch/arm/boot/dts/twl6030.dtsi
>>>> @@ -103,4 +103,10 @@
>>>>           compatible = "ti,twl6030-pwmled";
>>>>           #pwm-cells = <2>;
>>>>       };
>>>> +
>>>> +    adc: gpadc {
>
>
>>>     Read my lips: the node should be called just "adc", not "gpadc".
>>
>>        ^^^^^^^^^^^^ Are you sure?
>
>
>    I didn't know how to express my disappointment from Oleksandr's inability
> to understand what I wanted to convey to him from 2 attempts... first,
How would you comment the following code, v3.10-rc7:

arch/arm/boot/dts/dbx5x0.dtsi, line 375
375                                  ab8500-gpadc {
376                                          compatible =
"stericsson,ab8500-gpadc";
377                                          interrupts = <32
IRQ_TYPE_LEVEL_HIGH
arch/arm/boot/dts/dbx5x0.dtsi:                          ab8500-gpadc {
arch/arm/boot/dts/dbx5x0.dtsi:
compatible = "stericsson,ab8500-gpadc";
arch/arm/boot/dts/dbx5x0.dtsi:
vddadc-supply = <&ab8500_ldo_tvout_reg>;


arch/arm/boot/dts/sama5d3.dtsi:                 tsadcc: tsadcc@f8018000 {
arch/arm/boot/dts/sama5d3.dtsi:                         compatible =
"atmel,at91sam9x5-tsadcc";
arch/arm/boot/dts/sama5d3.dtsi:
atmel,tsadcc_clock = <300000>;

arch/arm/boot/dts/am33xx.dtsi:          tscadc: tscadc@44e0d000 {
arch/arm/boot/dts/am33xx.dtsi:                  compatible = "ti,am3359-tscadc";
arch/arm/boot/dts/am33xx.dtsi:                  ti,hwmods = "adc_tsc";
arch/arm/boot/dts/am33xx.dtsi:                  am335x_adc: adc {
arch/arm/boot/dts/am33xx.dtsi:                          compatible =
"ti,am3359-adc";

Regards,
Sasha.

> changed the label instead of the node name, then he only dropped "twl6030_"
> prefix from the name. I should probably have been even more specific before.
>
>
>> Why? The name was selected according to the documentation on device
>> "General
>> purpose analog-to-digital converter (GPADC)".
>
>
>    Sigh, we simply don't care whether this ADC is general-purpose or not.
> The main thing it is ADC.
>
>
>> PS. Following your logic - "GPIO" need to renamed to "IO" everywhere ;P
>
>
>    GPIO is well known and established abbreviation, contrasted to GPADC.
> Moreover, ePAPR spec lists "gpio" as a generic node name.
>
>
> WBR, Sergei
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
