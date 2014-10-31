Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161508AbaJaAol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:44:41 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:45421 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161353AbaJaAoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:44:38 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zhengsq@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <5c24485211df79d54b065fe536312398>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5452DB69.8030208@rock-chips.com>
Date: Fri, 31 Oct 2014 08:44:25 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: rui.zhang@intel.com, edubezval@gmail.com, zyf@rock-chips.com,
        dianders@chromium.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, cf@rock-chips.com,
        dmitry.torokhov@gmail.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v16 2/5] dt-bindings: document Rockchip thermal
References: <1414549959-13699-1-git-send-email-caesar.wang@rock-chips.com> <1414549959-13699-3-git-send-email-caesar.wang@rock-chips.com> <1823150.6k52MgLRcZ@phil>
In-Reply-To: <1823150.6k52MgLRcZ@phil>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

在 2014年10月31日 04:17, Heiko Stübner 写道:
> Am Mittwoch, 29. Oktober 2014, 10:32:36 schrieb Caesar Wang:
>> This add the necessary binding documentation for the thermal
>> found on Rockchip SoCs
>>
>> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> ---
>>   .../bindings/thermal/rockchip-thermal.txt          | 62
>> ++++++++++++++++++++++ 1 file changed, 62 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt new file
>> mode 100644
>> index 0000000..3061982
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> @@ -0,0 +1,62 @@
>> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
>> +
>> +Required properties:
>> +- compatible : "rockchip,rk3288-tsadc"
>> +- reg : physical base address of the controller and length of memory mapped
>> +	region.
>> +- interrupts : The interrupt number to the cpu. The interrupt specifier
>> format +	       depends on the interrupt controller.
>> +- clocks : Must contain an entry for each entry in clock-names.
>> +- clock-names : Shall be "tsadc" for the converter-clock, and "apb_pclk"
>> for +		the peripheral clock.
>> +- #thermal-sensor-cells : Should be 1. See ./thermal.txt for a description.
>> +- hw-shut-temp : The hardware-controlled shutdown temperature value. +-
>> tsadc-tshut-mode : The hardware-controlled shutdown mode 0:CRU 1:GPIO. +-
>> tsadc-tshut-polarity : The hardware-controlled active polarity 0:LOW
>> 1:HIGH. +
>> +Exiample:
>> +tsadc: tsadc@ff280000 {
>> +	compatible = "rockchip,rk3288-tsadc";
>> +	reg = <0xff280000 0x100>;
>> +	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
>> +	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
>> +	clock-names = "tsadc", "apb_pclk";
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <&otp_out>;
>> +	#thermal-sensor-cells = <1>;
>> +	hw-shut-temp = <125000>;
>> +	tsadc-tshut-mode = <0>;
>> +	tsadc-tshut-polarity = <0>;
> these last 3 seem to be specific to this tsadc so should probably have a
> "rockchip,"-prefix

Fixed.

e.g  sync to driver

rockchip,hw-shut-temp = <125000>;
rockchip,tsadc-tshut-mode = <0>;
rockchip,tsadc-tshut-polarity = <0>;



I will sent next patch  v17 in 1-2 days if this series patchs haven't 
any problems.

Thanks.

>
>
>
>

-- 
Best regards,
Caesar


