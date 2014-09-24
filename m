Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaIXNN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:13:59 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:49853 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIXNN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:13:57 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <4562d574d5581b35c2380ac7125d8591>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5422C387.9050005@rock-chips.com>
Date: Wed, 24 Sep 2014 21:13:43 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Wang Caesar <caesar.wang@rock-chips.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: dts: add rk3288 power-domain node
References: <1411440916-6830-1-git-send-email-jinkun.hong@rock-chips.com> <1411440916-6830-4-git-send-email-jinkun.hong@rock-chips.com> <2840362.2VhRfgMh5I@phil>
In-Reply-To: <2840362.2VhRfgMh5I@phil>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On 09/24/2014 01:52 AM, Heiko Stübner wrote:
> Am Montag, 22. September 2014, 19:55:16 schrieb jinkun.hong:
>> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>>
>> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
>> Signed-off-by: Wang Caesar <caesar.wang@rock-chips.com>
>> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
>>
>> ---
>>
>>   arch/arm/boot/dts/rk3288.dtsi |   45
>> +++++++++++++++++++++++++++++++++++++++++ 1 file changed, 45 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
>> index 3bb5230..714b9d9 100644
>> --- a/arch/arm/boot/dts/rk3288.dtsi
>> +++ b/arch/arm/boot/dts/rk3288.dtsi
>> @@ -15,6 +15,7 @@
>>   #include <dt-bindings/interrupt-controller/arm-gic.h>
>>   #include <dt-bindings/pinctrl/rockchip.h>
>>   #include <dt-bindings/clock/rk3288-cru.h>
>> +#include <dt-bindings/power-domain/rk3288.h>
>>   #include "skeleton.dtsi"
>>
>>   / {
>> @@ -467,6 +468,50 @@
>>   		compatible = "rockchip,rk3288-pmu", "syscon";
>>   		reg = <0xff730000 0x100>;
>>   	};
> missing blank line here
>
> Also please mind the ordering. We have the nodes without registers (like the
> pinctrl) at the bottom, so maybe add the power-controller alphabetically after
> the pinctrl node.
>
>> +	power: power-controller {
>> +		compatible = "rockchip,rk3288-power-controller";
>> +		#power-domain-cells = <1>;
>> +		rockchip,pmu = <&pmu>;
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		pd_gpu {
>> +			reg = <RK3288_PD_GPU>;
>> +			clocks = <&cru ACLK_GPU>;
>> +		};
>> +
>> +		pd_vio {
>> +			reg = <RK3288_PD_VIO>;
>> +			clocks = <&cru HCLK_RGA>, <&cru HCLK_VOP0>,
>> +				<&cru HCLK_VOP1>, <&cru HCLK_VIO_AHB_ARBI>,
>> +				<&cru HCLK_VIO_NIU>, <&cru HCLK_VIP>,
>> +				<&cru HCLK_IEP>, <&cru HCLK_ISP>,
>> +				<&cru HCLK_VIO2_H2P>, <&cru PCLK_MIPI_DSI0>,
>> +				<&cru PCLK_MIPI_DSI1>, <&cru PCLK_MIPI_CSI>,
>> +				<&cru PCLK_LVDS_PHY>, <&cru PCLK_EDP_CTRL>,
>> +				<&cru PCLK_HDMI_CTRL>, <&cru PCLK_VIO2_H2P>,
>> +				<&cru ACLK_VOP0>, <&cru ACLK_IEP>,
>> +				<&cru ACLK_VIO0_NIU>, <&cru ACLK_VIP>,
>> +				<&cru ACLK_VOP1>, <&cru ACLK_ISP>,
>> +				<&cru ACLK_VIO1_NIU>, <&cru ACLK_RGA>,
>> +				<&cru ACLK_RGA_NIU>,<&cru SCLK_RGA>,
>> +				<&cru DCLK_VOP0>, <&cru DCLK_VOP1>,
>> +				<&cru SCLK_EDP_24M>, <&cru SCLK_EDP>,
>> +				<&cru SCLK_ISP>, <&cru SCLK_ISP_JPE>,
>> +				<&cru SCLK_HDMI_HDCP>, <&cru SCLK_HDMI_CEC>;
>> +		};
>> +
>> +		pd_video {
>> +			reg = <RK3288_PD_VIDEO>;
>> +			/* FIXME: add clocks */
> what is missing for these clocks? If it's just more clock ids, please
> corrdinate with Kever
The clock tree in PD_VIDEO is not complete, maybe because the
MUX which should be set from GRF_SOC_CON0[7].

I will handle this in my patch.

BR
-Kever

