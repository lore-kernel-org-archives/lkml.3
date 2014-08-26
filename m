Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbaHZAuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:50:19 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:54655 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHZAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:50:17 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zyf@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <907b52cce341b8782a0ffdb2efa8b1d4>
X-DNS-TYPE: 0
Message-ID: <53FBD9C4.3010309@rock-chips.com>
Date: Tue, 26 Aug 2014 08:50:12 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: rui.zhang@intel.com, rdunlap@infradead.org, cf@rock-chips.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, zyw@rock-chips.com, huangtao@rock-chips.com,
        xjq@rock-chips.com, addy.ke@rock-chips.com, dianders@chromium.org,
        zhaoyifeng <zyf@rock-chips.com>
Subject: Re: [PATCH 1/2] dt-bindings: document Rockchip thermal
References: <1408752934-18318-1-git-send-email-caesar.wang@rock-chips.com> <1408752934-18318-2-git-send-email-caesar.wang@rock-chips.com> <1504889.nDzfjZj9xp@diego>
In-Reply-To: <1504889.nDzfjZj9xp@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

在 2014年08月24日 07:03, Heiko Stübner 写道:
> Hi Caesar,
>
> Am Samstag, 23. August 2014, 08:15:33 schrieb Caesar Wang:
>> This add the necessary binding documentation for the thermal
>> found on Rockchip SoCs
>>
>> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>   .../bindings/thermal/rockchip-thermal.txt          |   33
>> ++++++++++++++++++++ 1 file changed, 33 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt new file
>> mode 100644
>> index 0000000..b556eae
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> @@ -0,0 +1,33 @@
>> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
>> +
>> +Required properties:
>> +- compatible : "rockchip,rk3288-tsadc"
>> +- reg : physical base address of the controller and length of memory mapped
>> +  region.
>> +- interrupts : The interrupt number to the cpu. The interrupt specifier
>> format +  depends on the interrupt controller.
>> +- clocks : Must contain an entry for each entry in clock-names.
>> +- clock-names : Shall be "tsadc_clk" for the transfer-clock, and
>> "tsadc_pclk" for +    the peripheral clock.
>> +Optional properties:
>> +- clock-frequency : Thermal sensor's clock frequency.
> see comment in patch2, this should probably use assigned-rate if at all
> necessary (and the assigned-rate is not necessary to document here)
>

yeah, it's necessary.

ok,I will fix it.
>> +- pinctrl-names : Should contain only one value - "default".
>> +- pinctrl-0 : Should contain only one value - &tsadc_int.
> in general pinctrl settings are just board-specific settings and do not
> need to be part of the binding documentation.
> And in this case, are you sure that the tsadc uses some pin as interrupt?
> Because in the TRM the TS-ADC interrupt is number 69 of the GIC itself
> and not some pin accessible via pinctrl.
>
>
>> +- passive-temp : Temperature of trip 0.
>> +- critical-temp : Temperature of trip 1.
>> +- force-shut-temp : Temperature of force shut down.
> please use the generic trip-points described in
> Documentation/devicetree/bindings/thermal/thermal.txt
> for this, instead of defining new properties
>
>
> Heiko
Ditto,
>
>> +Example:
>> +
>> +tsadc: tsadc@ff280000 {
>> +	compatible = "rockchip,rk3288-tsadc";
>> +	reg = <0xff280000 0x100>;
>> +	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
>> +	clock-frequency = <10000>;
>> +	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
>> +	clock-names = "tsadc_clk", "tsadc_pclk";
>> +	pinctrl-names = "default";
>> +	pinctrl-1 = <&tsadc_int>;
>> +	passive-temp = <80>;
>> +	critical-temp = <100>;
>> +	force-shut-temp = <120>;
>> +};
>
>
>

-- 
Best regards,
Caesar


