Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab3HMNV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:21:26 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35459 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab3HMNVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:21:24 -0400
Message-ID: <520A32CF.1010701@baylibre.com>
Date: Tue, 13 Aug 2013 15:21:19 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: benoit.cousson@linaro.org, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] arm: omap5: dts: split SMPS10 dt node
References: <1376300221-15172-1-git-send-email-kishon@ti.com>
In-Reply-To: <1376300221-15172-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 12/08/2013 11:37, Kishon Vijay Abraham I wrote:
> SMPS10 has two outputs OUT1 and OUT2. Hence SMPS10 is modeled as
> two regulators. The dt node is split to reflect it.

Mmm, I'm curious. How is it supposed to work?

Do you have dedicated control on each output?

Otherwise, it should be seen as one output with two potential consumers.

Regards,
Benoit

>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/omap5-uevm.dts |   13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
> index 65d7b60..05b9b12 100644
> --- a/arch/arm/boot/dts/omap5-uevm.dts
> +++ b/arch/arm/boot/dts/omap5-uevm.dts
> @@ -334,9 +334,18 @@
>   					ti,smps-range = <0x80>;
>   				};
>
> -				smps10_reg: smps10 {
> +				smps10_out2_reg: smps10_out2 {
>   					/* VBUS_5V_OTG */
> -					regulator-name = "smps10";
> +					regulator-name = "smps10_out2";
> +					regulator-min-microvolt = <5000000>;
> +					regulator-max-microvolt = <5000000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				smps10_out1_reg: smps10_out1 {
> +					/* VBUS_5V_OTG */
> +					regulator-name = "smps10_out1";
>   					regulator-min-microvolt = <5000000>;
>   					regulator-max-microvolt = <5000000>;
>   					regulator-always-on;
>

