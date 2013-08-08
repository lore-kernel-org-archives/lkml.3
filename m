Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966445Ab3HHUgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:36:19 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:38777 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966345Ab3HHUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:36:17 -0400
Message-ID: <52040146.7060703@cogentembedded.com>
Date: Fri, 09 Aug 2013 00:36:22 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        MLongnecker@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/3] ARM: dt: t114 dalmore: add dt entry for nct1008
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-3-git-send-email-wni@nvidia.com>
In-Reply-To: <1375944991-29182-3-git-send-email-wni@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/08/2013 10:56 AM, Wei Ni wrote:

> Enable thermal sensor nct1008 for t114 dalmore.

> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>   arch/arm/boot/dts/tegra114-dalmore.dts |   10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
> index b5a42f0..9d4d2b2 100644
> --- a/arch/arm/boot/dts/tegra114-dalmore.dts
> +++ b/arch/arm/boot/dts/tegra114-dalmore.dts
> @@ -738,6 +738,14 @@
>   			realtek,ldo1-en-gpios =
>   				<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
>   		};
> +
> +		nct1008 {

    ePAPR [1] says: "the name of a node should be somewhat generic, reflecting 
the function of the device and not its precise programming model". So I 
suggest "thermal"

> +			compatible = "onnn,nct1008";
> +			reg = <0x4c>;
> +			vdd-supply = <&palmas_ldo6_reg>;
> +			interrupt-parent = <&gpio>;
> +			interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
> +		};
>   	};

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei


