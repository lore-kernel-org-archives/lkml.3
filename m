Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833AbaCTSsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:48:52 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54791 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759570AbaCTSss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:48:48 -0400
Message-ID: <532B37D6.6070400@st.com>
Date: Thu, 20 Mar 2014 19:47:50 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <srinivas.kandagatla@st.com>,
        <patrice.chotard@st.com>
Subject: Re: [PATCH] ARM: STi: Add support for the FSM Serial Flash Controller
References: <1395330920-10559-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1395330920-10559-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.129.4.70]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-20_04:2014-03-20,2014-03-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/20/2014 04:55 PM, Lee Jones wrote:
> Here we add the necessary device nodes required for successful device
> probing and Pinctrl setup for the FSM.
>
> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Acked-by Angus Clark <angus.clark@st.com>
> Acked-by: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/stih416-pinctrl.dtsi | 13 +++++++++++++
>   arch/arm/boot/dts/stih416.dtsi         | 13 +++++++++++++
>   arch/arm/boot/dts/stih41x-b2020.dtsi   |  1 +
>   arch/arm/boot/dts/stih41x-b2020x.dtsi  | 28 ++++++++++++++++++++++++++++
Could you please split this patch in two ?
	1 - stih416-pinctrl.dtsi and stih416.dtsi
	2 - stih41x-b2020.dtsi and stih41x-b2020x.dtsi

Once these changes done, you can add

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime

>   4 files changed, 55 insertions(+)
>   create mode 100644 arch/arm/boot/dts/stih41x-b2020x.dtsi
>
> diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> index b29ff4b..81df8e7 100644
> --- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> @@ -210,6 +210,19 @@
>   					};
>   				};
>   			};
> +
> +			fsm {
> +				pinctrl_fsm: fsm {
> +					st,pins {
> +						spi-fsm-clk  = <&PIO12 2 ALT1 OUT>;
> +						spi-fsm-cs   = <&PIO12 3 ALT1 OUT>;
> +						spi-fsm-mosi = <&PIO12 4 ALT1 OUT>;
> +						spi-fsm-miso = <&PIO12 5 ALT1 IN>;
> +						spi-fsm-hol  = <&PIO12 6 ALT1 OUT>;
> +						spi-fsm-wp   = <&PIO12 7 ALT1 OUT>;
> +					};
> +				};
> +			};
>   		};
>
>   		pin-controller-rear {
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index b7ab47b..1e24b9e 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -145,5 +145,18 @@
>
>   			status		= "disabled";
>   		};
> +
> +		/* FSM */
> +		spifsm: spifsm@fe902000 {
> +			compatible	   = "st,spi-fsm";
> +			reg		   = <0xfe902000 0x1000>;
> +			pinctrl-0	   = <&pinctrl_fsm>;
> +
> +			st,syscfg	   = <&syscfg_rear>;
> +			st,boot-device-reg = <0x958>;
> +			st,boot-device-spi = <0x1a>;
> +
> +			status = "disabled";
> +		};
>   	};
>   };
> diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
> index 0ef0a69..01487e0 100644
> --- a/arch/arm/boot/dts/stih41x-b2020.dtsi
> +++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
> @@ -6,6 +6,7 @@
>    * it under the terms of the GNU General Public License version 2 as
>    * publishhed by the Free Software Foundation.
>    */
> +#include "stih41x-b2020x.dtsi"
>   / {
>   	memory{
>   		device_type = "memory";
> diff --git a/arch/arm/boot/dts/stih41x-b2020x.dtsi b/arch/arm/boot/dts/stih41x-b2020x.dtsi
> new file mode 100644
> index 0000000..df01c12
> --- /dev/null
> +++ b/arch/arm/boot/dts/stih41x-b2020x.dtsi
> @@ -0,0 +1,28 @@
> +/*
> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
> + * Author: Lee Jones <lee.jones@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * publishhed by the Free Software Foundation.
> + */
> +/ {
> +	soc {
> +		spifsm: spifsm@fe902000 {
> +			#address-cells = <1>;
> +			#size-cells    = <1>;
> +
> +			status = "okay";
> +
> +			partition@0 {
> +				label = "SerialFlash1";
> +				reg   = <0x00000000 0x00500000>;
> +			};
> +
> +			partition@500000 {
> +				label = "SerialFlash2";
> +				reg   = <0x00500000 0x00b00000>;
> +			};
> +		};
> +	};
> +};
>
