Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaIJCtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:49:19 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:53060 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaIJCtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:49:15 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: dmitry.torokhov@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <da66630ac747c7f5f649ed5837c737a4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <540FBC21.2090504@rock-chips.com>
Date: Wed, 10 Sep 2014 10:49:05 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: rui.zhang@intel.com, edubezval@gmail.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com, dianders@chromium.org,
        dtor@chromium.org, zyw@rock-chips.com, addy.ke@rock-chips.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH v4 3/4] ARM: dts: add main Thermal info to rk3288
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com> <1409710239-19941-4-git-send-email-caesar.wang@rock-chips.com> <3426113.Zcq8V2S7cg@diego>
In-Reply-To: <3426113.Zcq8V2S7cg@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

在 2014年09月09日 19:37, Heiko Stübner 写道:
> Am Mittwoch, 3. September 2014, 10:10:38 schrieb Caesar Wang:
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>   arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
>> index 36be7bb..3d672e3 100644
>> --- a/arch/arm/boot/dts/rk3288.dtsi
>> +++ b/arch/arm/boot/dts/rk3288.dtsi
>> @@ -224,6 +224,17 @@
>>   		status = "disabled";
>>   	};
>>
>> +	tsadc: tsadc@ff280000 {
> please keep the list of nodes sorted by register address. So when looking at
> my v3.18-next/dts branch, it should be after uart4: serial@ff1c0000 and before
> usb_host0_ehci: usb@ff500000 .
>

oh...,I will fix it.
>> +		compatible = "rockchip,rk3288-tsadc";
>> +		reg = <0xff280000 0x100>;
>> +		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
>> +		clock-names = "tsadc", "apb_pclk";
>> +		pinctrl-names = "default";
>> +		pinctrl-1 = <&tsadc_int>;
>> +		status = "disabled";
>> +	};
>> +
>>   	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
>>
>>   	usb_hsic: usb@ff5c0000 {
>> @@ -611,5 +622,12 @@
>>   				rockchip,pins = <5 15 3 &pcfg_pull_none>;
>>   			};
>>   		};
>> +
>> +		tsadc {
>> +			tsadc_int: tsadc-int {
>> +				rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_up>;
>> +			};
>> +		};
> After looking this up in the schematics I see that this is the
> overtemperature-protection output pin ... labeled OTP_OUT.
> So I'd think the pinconfig should reflect this pin-name, especially as tsadc-int
> suggests, that this would be an interrupt leading into the tsadc, while in
> fact it is an output to a separate circuit.
>
Maybe,I guess  your mean as the follows .
Please correct it and  Laugh out if I got it wrong.

tsadc {
             otp_out: otp-out {
                 rockchip,pins = <0 10 RK_FUNC_GPIO &pcfg_pull_none>;
             };

             tsadc_int: tsadc-int {
                 rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_none>;
             };
         };
Then,I deal with the otp_out in thermal driver.
I believe The "otp_out" will restart board if it's a high active.

tsadc_int: tsadc-int {
+				rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_up>;
+			};

But,I think the about will be implemented in thermal driver.
> Heiko
>
>
>

-- 
Best regards,
Caesar


