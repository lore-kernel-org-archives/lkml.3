Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaJ1Acy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:32:54 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:59440 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaJ1Acx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:32:53 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zhengsq@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <b95dbb24873099e7968aae459daca742>
X-DNS-TYPE: 0
Message-ID: <544EE42D.3030208@rock-chips.com>
Date: Tue, 28 Oct 2014 08:32:45 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v14 2/5] dt-bindings: document Rockchip thermal
References: <1414377588-2237-1-git-send-email-caesar.wang@rock-chips.com> <1414377588-2237-3-git-send-email-caesar.wang@rock-chips.com> <20141028002915.GJ7594@dtor-ws>
In-Reply-To: <20141028002915.GJ7594@dtor-ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

在 2014年10月28日 08:29, Dmitry Torokhov 写道:
> On Mon, Oct 27, 2014 at 10:39:45AM +0800, Caesar Wang wrote:
>> This add the necessary binding documentation for the thermal
>> found on Rockchip SoCs
>>
>> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>   .../bindings/thermal/rockchip-thermal.txt          | 53 ++++++++++++++++++++++
>>   1 file changed, 53 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> new file mode 100644
>> index 0000000..d5b1401
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> @@ -0,0 +1,53 @@
>> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
>> +
>> +Required properties:
>> +- compatible : "rockchip,rk3288-tsadc"
>> +- reg : physical base address of the controller and length of memory mapped
>> +	region.
>> +- interrupts : The interrupt number to the cpu. The interrupt specifier format
>> +	       depends on the interrupt controller.
>> +- clocks : Must contain an entry for each entry in clock-names.
>> +- clock-names : Shall be "tsadc" for the converter-clock, and "apb_pclk" for
>> +		the peripheral clock.
>> +- #thermal-sensor-cells : Should be 1. See ./thermal.txt for a description.
> I think you are missing description of hw-shut-temp, tsadc-tshut-mode
> and tsadc-tshut-mode
>   and optional pinctrl settings.

If it's really need,we just have hw-shut-temp,tsadc-tshut-mode
and tsadc-tshut-mode,no need  pinctrl setting,I think.

>> +
>> +Exiample:
>> +tsadc: tsadc@ff280000 {
>> +	compatible = "rockchip,rk3288-tsadc";
>> +	reg = <0xff280000 0x100>;
>> +	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
>> +	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
>> +	clock-names = "tsadc", "apb_pclk";
>> +};
>> +
>> +Example: referring to thermal sensors:
>> +thermal-zones {
>> +	cpu_thermal: cpu_thermal {
>> +		polling-delay-passive = <1000>; /* milliseconds */
>> +		polling-delay = <5000>; /* milliseconds */
>> +
>> +		/* sensor	ID */
>> +		thermal-sensors = <&tsadc	1>;
>> +
>> +		trips {
>> +			cpu_alert0: cpu_alert {
>> +				temperature = <80000>; /* millicelsius */
>> +				hysteresis = <2000>; /* millicelsius */
>> +				type = "passive";
>> +			};
>> +			cpu_crit: cpu_crit {
>> +				temperature = <120000>; /* millicelsius */
>> +				hysteresis = <2000>; /* millicelsius */
>> +				type = "critical";
>> +			};
>> +		};
>> +
>> +		cooling-maps {
>> +			map0 {
>> +				trip = <&cpu_alert0>;
>> +				cooling-device =
>> +					<&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
>> +			};
>> +		};
>> +	};
>> +};
>> -- 
>> 1.9.1
>>
>>

-- 
Best regards,
Caesar


