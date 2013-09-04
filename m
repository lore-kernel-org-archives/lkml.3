Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878Ab3IDQcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:32:00 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43330 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935163Ab3IDQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:31:58 -0400
Message-ID: <52276079.5020101@baylibre.com>
Date: Wed, 04 Sep 2013 18:31:53 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: joelf@ti.com
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, tony@atomide.com,
        santosh.shilimkar@ti.com, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: add AM33XX EDMA support
References: <1377505784-9820-1-git-send-email-bigeasy@linutronix.de> <521B1380.3030908@baylibre.com> <522144AB.9010802@ti.com>
In-Reply-To: <522144AB.9010802@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

On 31/08/2013 03:19, Joel Fernandes wrote:
> Hi Benoit,
>
> On 08/26/2013 03:36 AM, Benoit Cousson wrote:
>> - minus all the TI emails which are not working anymore :-(
>>
>> I've just sent my previous email too soon...
>>
>> Now the patch is different :-) I'll take that one.
>
> Unfortunately this patch is still missing from your latest pull request:

Indeed, it was supposed to be applied on 3.13 only. It just came too 
late for 3.12.

Regards,
Benoit

> Subject "[GIT PULL] ARM: OMAP: Device Tree for 3.12 take #2"
>    git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
> tags/for_3.12/dts_signed  (commit 4843be165c10f9886c87eeb20acf19a3ddec6653)
>
> Below is a scissor patch that cleanly applies on above branch.
>
> Thanks,
>
> -Joel
>
> --->8----
> From: Matt Porter <mporter@ti.com>
> Subject: [PATCH] ARM: dts: add AM33XX EDMA support
>
> Adds AM33XX EDMA support to the am33xx.dtsi as documented in
> Documentation/devicetree/bindings/dma/ti-edma.txt
>
> v2 changes:
> Drop DT entries that are non-hardware-description Joel Fernandes <joelf@ti.com>
> Discussion in [1].
>
> v3 changes: Changed node name from "edma: edma@" to "edma: dma-controller@"
> by Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> [1] https://patchwork.kernel.org/patch/2226761/
>
> Signed-off-by: Matt Porter <mporter@ti.com>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> ---
>   arch/arm/boot/dts/am33xx.dtsi | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 5996d63..f5869ed 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -101,6 +101,18 @@
>   			reg = <0x48200000 0x1000>;
>   		};
>
> +		edma: dma-controller@49000000 {
> +			compatible = "ti,edma3";
> +			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
> +			reg =	<0x49000000 0x10000>,
> +				<0x44e10f90 0x10>;
> +			interrupts = <12 13 14>;
> +			#dma-cells = <1>;
> +			dma-channels = <64>;
> +			ti,edma-regions = <4>;
> +			ti,edma-slots = <256>;
> +		};
> +
>   		gpio0: gpio@44e07000 {
>   			compatible = "ti,omap4-gpio";
>   			ti,hwmods = "gpio1";
>

