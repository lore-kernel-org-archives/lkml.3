Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaCKNJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:09:19 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15955 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaCKNJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:09:16 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-d4-531f0afaec89
Message-id: <531F0AEC.7010606@samsung.com>
Date: Tue, 11 Mar 2014 14:09:00 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk
Subject: Re: [PATCH 5/5] ARM: dts: exynos4412-trats2: Add ADC's dt data to get
 temperature of SoC/battery
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
 <1394524494-30641-6-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394524494-30641-6-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xa7q/uOSDDWb/5rW4/uU5q8X8I+dY
	Lc69Wslo0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsbl/mtVh6/SKTxYTpa1ksDq84wGTx
	6mAbiwOvx5p5axg9Wpp72DwWfL7C7rFy+Rc2j81L6j36tqxi9Pi8Sc5j49zQAI4oLpuU1JzM
	stQifbsEroyZP9cxFawQqrjR2czUwHiYr4uRg0NCwETi87W6LkZOIFNM4sK99WxdjFwcQgJL
	GSX+XrjOApIQEvjMKHGhgQvE5hXQknizr5EJxGYRUJX4dKCVHcRmE1CT+NzwiA3EFhWIkPg7
	bz0jRL2gxI/J98DmiAjYS+x5sIERZAGzwE4miT1Ld4INEhbIlrh58gvU5kZGiVk3z4J1cwq4
	SWyZ8BpsKrOAtcTKSdsYIWx5ic1r3jJPYBSYhWTJLCRls5CULWBkXsUomlqaXFCclJ5rqFec
	mFtcmpeul5yfu4kREjtfdjAuPmZ1iFGAg1GJh3eFv1ywEGtiWXFl7iFGCQ5mJRHei/eAQrwp
	iZVVqUX58UWlOanFhxiZODilGhgzZ+kJHzvzKmtqU9SOBQ6To+b+8moo2lq6evK05xkP83rF
	Jj4MqTTZ9rZLrnOefDc/2+kVZr1XFpn2zH5vov0qKKleyFvs4oHS7xc0zYIkH5zM//1vu1Nd
	4Yq6xDP2F0/+kZ8QEbxH59CGrNsJSiplZ/d6bA/Nf63VNnW2Tw1f8Dcr8eo7K18osRRnJBpq
	MRcVJwIABL8O9nsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 11.03.2014 08:54, Chanwoo Choi wrote:
> This patch use ADC to get the temperature of SoC/battery by using NTC thermistor
> driver in hwmon. NTC thermistor driver covnvert ADC's raw data to temperature
> by using following variables:
>
> - pullup-uv    : Voltage
> - pullup-ohm   : Pull-up resistance
> - pulldown-ohm : Pull-down resistance
> - io-channels  : It means ADC channel.
>

Those properties are well-defined in "ntc,ncp15wb473" DT bindings 
documentation. There is no need to repeat them here.

> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>   arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index 4f851cc..fc517c3 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> @@ -106,6 +106,27 @@
>   		};
>   	};
>
> +	adc: adc@126C0000 {
> +		vdd-supply = <&ldo3_reg>;
> +		status = "okay";
> +
> +		ncp15wb473@0 {

style: Nodes should have generic names, e.g. thermistor@0.

Also if node name is suffixed with @unit-address, then the node should 
have a reg property with its first entry corresponding to the 
unit-address. Now there is no physical unit-address definition for those 
thermistors, so they shouldn't use this naming pattern, but rather 
something like "thermistor-0" or "thermistor-ap".

> +			compatible = "ntc,ncp15wb473";
> +			pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
> +			pullup-ohm = <100000>;	 /* 100K */
> +			pulldown-ohm = <100000>; /* 100K */
> +			io-channels = <&adc 1>;  /* AP temperature */
> +		};
> +
> +		ncp15wb473@1 {
> +			compatible = "ntc,ncp15wb473";
> +			pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
> +			pullup-ohm = <100000>;	 /* 100K */
> +			pulldown-ohm = <100000>; /* 100K */
> +			io-channels = <&adc 2>;  /* Battery temperature */
> +		};

Anyway, I don't think it is correct to place IIO consumers under IIO 
provider node, because IIO is not a control bus, but rather a resource 
provider, like GPIO, clock, etc. So both thermistor nodes should be 
placed outside the adc node. (They might be grouped in a simple-bus 
subnode, though, to improve readability.)

Best regards,
Tomasz
