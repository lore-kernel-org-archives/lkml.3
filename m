Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbbAWIkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:40:39 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:36811 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbbAWIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:40:37 -0500
Message-ID: <54C208D9.6050006@st.com>
Date: Fri, 23 Jan 2015 09:39:53 +0100
From: David Paris <david.paris@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <rtc-linux@googlegroups.com>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux@roeck-us.net>
Subject: Re: [PATCH v2 4/9] ARM: STi: DT: STiH407: Add Device Tree node for
 the LPC
References: <1421927767-28889-1-git-send-email-lee.jones@linaro.org> <1421927767-28889-5-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1421927767-28889-5-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.83]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-23_02:2015-01-23,2015-01-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

     Just a minor remark/question,

     David

On 01/22/2015 12:56 PM, Lee Jones wrote:
> On current ST platforms the LPC controls a number of functions.  This
> patch enables support for the LPC Watchdog and LPC RTC devices on LPC1
> and LPC2 respectively.
>
> Signed-off-by: David Paris <david.paris@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/stih407-family.dtsi | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
> index 3e31d32..04448a7 100644
> --- a/arch/arm/boot/dts/stih407-family.dtsi
> +++ b/arch/arm/boot/dts/stih407-family.dtsi
> @@ -7,6 +7,7 @@
>    * publishhed by the Free Software Foundation.
>    */
>   #include "stih407-pinctrl.dtsi"
> +#include <dt-bindings/mfd/st-lpc.h>
>   #include <dt-bindings/reset-controller/stih407-resets.h>
>   / {
>   	#address-cells = <1>;
> @@ -274,5 +275,24 @@
>   
>   			status = "disabled";
>   		};
> +
> +		/* Watchdog and Real-Time Clock */
> +		lpc@8787000 {
> +			compatible = "st,stih407-lpc";
> +			reg = <0x8787000 0x1000>;
> +			interrupts = <GIC_SPI 129 IRQ_TYPE_EDGE_RISING>;
In case of Watchdog, "interrupt" property is not used. So I think we can 
remove it ?
> +			clocks = <&clk_s_d3_flexgen CLK_LPC_0>;
> +			timeout-sec = <120>;
> +			st,syscfg = <&syscfg_core>;
> +			st,lpc-mode = <ST_LPC_MODE_WDT>;
> +		};
> +
> +		lpc@8788000 {
> +			compatible = "st,stih407-lpc";
> +			reg = <0x8788000 0x1000>;
> +			interrupts = <GIC_SPI 130 IRQ_TYPE_EDGE_RISING>;
> +			clocks = <&clk_s_d3_flexgen CLK_LPC_1>;
> +			st,lpc-mode = <ST_LPC_MODE_RTC>;
> +		};
>   	};
>   };

