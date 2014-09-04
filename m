Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaIDBCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:02:21 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:59301 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102AbaIDBCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:02:17 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zyf@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <af5551ea09172cf3df8c5bd9942bfd5b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5407BA10.2030402@rock-chips.com>
Date: Thu, 04 Sep 2014 09:02:08 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: rui.zhang@intel.com, edubezval@gmail.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com, dianders@chromium.org,
        dtor@chromium.org, zyw@rock-chips.com, addy.ke@rock-chips.com,
        dmitry.torokhov@gmail.com, zhaoyifeng <zyf@rock-chips.com>
Subject: Re: [PATCH v4 2/4] dt-bindings: document Rockchip thermal
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com> <1409710239-19941-3-git-send-email-caesar.wang@rock-chips.com> <11280986.L6lv82O8Qv@diego>
In-Reply-To: <11280986.L6lv82O8Qv@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014年09月03日 16:07, Heiko Stübner 写道:
> Am Mittwoch, 3. September 2014, 10:10:37 schrieb Caesar Wang:
>> This add the necessary binding documentation for the thermal
>> found on Rockchip SoCs
>>
>> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>   .../devicetree/bindings/thermal/rockchip-thermal.txt | 20
>> ++++++++++++++++++++ 1 file changed, 20 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt new file
>> mode 100644
>> index 0000000..1ed4d4c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> @@ -0,0 +1,20 @@
>> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
>> +
>> +Required properties:
>> +- compatible: "rockchip,rk3288-tsadc"
>> +- reg: physical base address of the controller and length of memory mapped
>> +       region.
>> +- interrupts: The interrupt number to the cpu. The interrupt specifier
>> format +	      depends on the interrupt controller.
>> +- clocks: Must contain an entry for each entry in clock-names.
>> +- clock-names: Shall be "tsadc" for the converter-clock, and "apb_pclk" for
>> +	       the peripheral clock.
> You're using the passive-temp, critical-temp and force-shut-temp properties in
> your driver without declaring them here.

frankly,the about are need be declared. but  there are 4 types[0] for 
trip in thermal framework,
there is no force-shut for me. So I want to change it three additional 
properties in [PATCH V4 4/4],


[0]
{
     THERMAL_TRIP_CRITICAL,
     THERMAL_TRIP_HOT,
     THERMAL_TRIP_PASSIVE,
     THERMAL_TRIP_ACTIVE,
}

> But more importantly, please use the generic trip-points for this. I guess it
> shouldn't be a problem to introduce a "forced-shutdown" trippoint [0] for the
> additional trip-point you have - thermal maintainers, please shout if I'm
> wrong :-)

It's a good option.
I can send a patch,but I don't know whether the thermal maintainers will 
accept it.

Maybe,they have a better way to suggest it.:-)


PS:I will sent a new patch If I still have no received their suggestions 
in two days.

>
> Heiko
>
>
> [0] in a separate patch, changing
> - thermal_trip_type enum in include/linux/thermal.h
> - trip_types mapping in drivers/thermal/of-thermal.c
> - Documentation/devicetree/bindings/thermal/thermal.txt
>
>> +
>> +Example:
>> +tsadc: tsadc@ff280000 {
>> +	compatible = "rockchip,rk3288-tsadc";
>> +	reg = <0xff280000 0x100>;
>> +	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
>> +	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
>> +	clock-names = "tsadc", "apb_pclk";
>> +};
>
>
>

-- 
Best regards,
Caesar


