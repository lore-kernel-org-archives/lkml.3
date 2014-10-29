Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaJ2DC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:02:57 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:45523 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaJ2DCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:02:55 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zhengsq@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <a6bdba8e39a49fe295d09ad62502d48c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <545058D7.8020302@rock-chips.com>
Date: Wed, 29 Oct 2014 11:02:47 +0800
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
Subject: Re: [PATCH v15 2/5] dt-bindings: document Rockchip thermal
References: <1414486287-25498-1-git-send-email-caesar.wang@rock-chips.com> <1414486287-25498-3-git-send-email-caesar.wang@rock-chips.com> <20141028234624.GD19675@dtor-ws>
In-Reply-To: <20141028234624.GD19675@dtor-ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014年10月29日 07:46, Dmitry Torokhov 写道:
> On Tue, Oct 28, 2014 at 04:51:24PM +0800, Caesar Wang wrote:
>> This add the necessary binding documentation for the thermal
>> found on Rockchip SoCs
>>
>> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Added.

Thank you!
>
>> ---
>>   .../bindings/thermal/rockchip-thermal.txt          | 62 ++++++++++++++++++++++
>>   1 file changed, 62 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> new file mode 100644
>> index 0000000..fc30e1b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
>> @@ -0,0 +1,62 @@
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
>> +- hw-shut-temp : The hardware-controlled shutdown temperature value.
>> +- tsadc-tshut-mode : The hardware-controlled shutdown mode 0:CRU 1:GPIO.
>> +- tsadc-tshut-polarity : The hardware-controlled active polarity 0:LOW 1:HIGH.
>> +
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


