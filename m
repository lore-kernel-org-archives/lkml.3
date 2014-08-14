Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaHNH3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:29:39 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:36600 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbaHNH3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:29:36 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <53EC6631.3020203@smartplayin.com>
Date: Thu, 14 Aug 2014 13:03:05 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/6] ARM: dts: qcom: Add PM8941 and PM8841 pinctrl
 nodes
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com> <1407771634-14946-6-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1407771634-14946-6-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,
This patch fail to apply on linux-next Tree. Probably because this is
based on Stanimir's older patch series "Support for Qualcomm QPNP
PMIC's". He has posted v4 of them on which it fails to apply. Am I correct?

Thanks
Pramod

On Monday 11 August 2014 09:10 PM, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Add nodes for PM8941 and PM8841 GPIO and MPP PMIC subfunctions.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  arch/arm/boot/dts/qcom-msm8974.dtsi | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
> index c7ae7ba..3967797 100644
> --- a/arch/arm/boot/dts/qcom-msm8974.dtsi
> +++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
> @@ -267,6 +267,31 @@
>  					reg-names = "rtc", "alarm";
>  					interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
>  				};
> +
> +				pm8941_gpios: gpios@c000 {
> +					compatible = "qcom,pm8941-gpio";
> +					reg = <0xc000>;
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					interrupts = <0 0xc0 0 0>, <0 0xc1 0 0>, <0 0xc2 0 0>, <0 0xc3 0 0>,
> +						     <0 0xc4 0 0>, <0 0xc5 0 0>, <0 0xc6 0 0>, <0 0xc7 0 0>,
> +						     <0 0xc8 0 0>, <0 0xc9 0 0>, <0 0xca 0 0>, <0 0xcb 0 0>,
> +						     <0 0xcc 0 0>, <0 0xcd 0 0>, <0 0xce 0 0>, <0 0xcf 0 0>,
> +						     <0 0xd0 0 0>, <0 0xd1 0 0>, <0 0xd2 0 0>, <0 0xd3 0 0>,
> +						     <0 0xd4 0 0>, <0 0xd5 0 0>, <0 0xd6 0 0>, <0 0xd7 0 0>,
> +						     <0 0xd8 0 0>, <0 0xd9 0 0>, <0 0xda 0 0>, <0 0xdb 0 0>,
> +						     <0 0xdc 0 0>, <0 0xdd 0 0>, <0 0xde 0 0>, <0 0xdf 0 0>,
> +						     <0 0xe0 0 0>, <0 0xe1 0 0>, <0 0xe2 0 0>, <0 0xe3 0 0>;
> +				};
> +
> +				pm8941_mpps: mpps@a000 {
> +					compatible = "qcom,pm8941-mpp";
> +					reg = <0xa000>;
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					interrupts = <0 0xa0 0 0>, <0 0xa1 0 0>, <0 0xa2 0 0>, <0 0xa3 0 0>,
> +						     <0 0xa4 0 0>, <0 0xa5 0 0>, <0 0xa6 0 0>, <0 0xa7 0 0>;
> +				};
>  			};
>  
>  			usid1: pm8941@1 {
> @@ -281,6 +306,14 @@
>  				reg = <0x4 SPMI_USID>;
>  				#address-cells = <1>;
>  				#size-cells = <0>;
> +
> +				pm8841_mpps: mpps@a000 {
> +					compatible = "qcom,pm8841-mpp";
> +					reg = <0xa000>;
> +					gpio-controller;
> +					#gpio-cells = <2>;
> +					interrupts = <4 0xa0 0 0>, <4 0xa1 0 0>, <4 0xa2 0 0>, <4 0xa3 0 0>;
> +				};
>  			};
>  
>  			usid5: pm8841@5 {
> 
