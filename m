Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab3GPNvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:51:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17280 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3GPNvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:51:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 16 Jul 2013 06:50:26 -0700
Message-ID: <51E54FD1.1010404@nvidia.com>
Date: Tue, 16 Jul 2013 16:51:13 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: tegra: enable palmas device for dalmore
References: <1373441852-27176-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1373441852-27176-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 10:37 AM, Laxman Dewangan wrote:
> Make the entry of Dalmore Power Management Unit device TPS65913
> in dalmore DTS file. The Palma driver support this device.
>
> Enable following submodule of the TPS65913:
> - GPIO driver
> - RTC driver.
> - Power regulator driver.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - renames nodes from palams_* to simple as gpio, rtc, pmic etc.
> - Added line gap properly.
> - Remove comment for palams-gpio reference as the entry itself explain.
> - Remove unit address for tps65913.
>
>   arch/arm/boot/dts/tegra114-dalmore.dts |  184 +++++++++++++++++++++++++++++++-
>   1 files changed, 183 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
> index a42bfa4..7bdad77 100644
> --- a/arch/arm/boot/dts/tegra114-dalmore.dts
> +++ b/arch/arm/boot/dts/tegra114-dalmore.dts
> @@ -791,7 +791,7 @@
>   					regulator-boot-on;
>   				};
>
> -				dcdc3 {
> +				tps65090_dcdc3_reg: dcdc3 {
>   					regulator-name = "vdd-ao";
>   					regulator-always-on;
>   					regulator-boot-on;
> @@ -836,6 +836,178 @@
>   				};
>   			};
>   		};
> +
> +		palmas: tps65913 {
> +			compatible = "ti,palmas";
> +			reg = <0x58>;
> +			interrupts = <0 86 0x4>;
> +
> +			#interrupt-cells = <2>;
> +			interrupt-controller;
> +
> +			palmas_gpio: gpio {
> +				compatible = "ti,palmas-gpio";
> +				gpio-controller;
> +				#gpio-cells = <2>;
> +			};

I don't think the palmas-gpio driver ever gets probed since it doesn't
have device tree compability strings?

> ...
